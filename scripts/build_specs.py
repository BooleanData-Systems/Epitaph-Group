"""Build one dashboard spec per live TapClicks dashboard from the profiling workbook.

Run locally by an engineer (never by the automated code tools), because the profiling workbook holds
Epitaph's real client and campaign names:

    python scripts/build_specs.py --profiling /path/to/Epitaph_Profiling.xlsx --out specs/dashboards

What it does
- Reads the Dashboards and Widgets sheets for the 29 live dashboards.
- Groups widgets by section and translates each one into the new model:
  metric names mapped to the agreed KPI names, filters parsed into fields and values,
  "metric eq [x]" filters turned into minimum thresholds, every widget on the dashboard date picker.
- Applies the fixes Epitaph agreed (sections and widgets not rebuilt, KPI renames, merges).
- Writes specs/dashboards/<ID>_<slug>.yml plus specs/dashboards/_index.yml and specs/required_columns.yml.
"""
import argparse
import html
import re
from collections import Counter
OrderedDict = dict  # plain dicts keep insertion order and dump cleanly
from pathlib import Path

import openpyxl
import yaml

LIVE = OrderedDict([
    # id: (client, priority, type, group, moves)
    ("D053", ("Nulo", "High", "Standard", "1", "2026-12-11")),
    ("D091", ("SiriusXM", "High", "Custom", "1", "2026-12-11")),
    ("D092", ("SiriusXM", "High", "Custom", "1", "2026-12-11")),
    ("D093", ("Sonnet Insurance", "High", "Custom", "1", "2026-12-11")),
    ("D056", ("Nulo", "Medium", "Standard", "1", "2026-12-11")),
    ("D014", ("Conexus", "Medium", "Standard", "1", "2026-12-11")),
    ("D017", ("Conexus", "Medium", "Standard", "1", "2026-12-11")),
    ("D023", ("Embark", "Medium", "Standard", "2", "2026-12-18")),
    ("D059", ("Ottawa Tourism", "Medium", "Standard", "3", "2027-01-22")),
    ("D061", ("Ottawa Tourism", "Medium", "Standard", "3", "2027-01-22")),
    ("D074", ("Ottawa Tourism", "Medium", "Standard", "3", "2027-01-29")),
    ("D026", ("Kicking Horse Coffee", "Medium", "Standard", "2", "2026-12-18")),
    ("D035", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D038", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D039", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D041", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D043", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D044", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D046", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D049", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D051", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D052", ("Kids Help Phone", "Medium", "Standard", "2", "2026-12-18")),
    ("D005", ("Cobs Bread", "Medium", "Standard", "3", "2027-01-15")),
    ("D095", ("Sysco", "Medium", "Standard", "2", "2026-12-18")),
    ("D094", ("Sonnet Insurance", "Medium", "Custom", "3", "2027-01-15")),
    ("D001", ("Aquamar", "Medium", "Hand-built", "3", "2027-01-22")),
    ("D002", ("BDO", "Medium", "Hand-built", "3", "2027-01-22")),
    ("D097", ("Wurth Canada", "Medium", "Hand-built", "3", "2027-01-29")),
    ("D032", ("Kicking Horse Coffee", "Medium", "Hand-built", "3", "2027-01-29")),
])

# TapClicks metric name -> agreed KPI name (config/kpis.yml). None = not rebuilt.
METRIC_MAP = {
    "Impression": "Impressions",                     # K03 merged
    "Video Fully Played": "Completed Plays",          # K08 merged
    "Adobe CPT": "CPT",                               # K14 duplicates removed
    "Adobe Performance CPT": "Performance CPT",
    "CPT - SC": "Scorecard CPT",
    "Trials - SC x 100": None,                        # K16 dropped
    "Spend - Goloot": None,                           # K15 GoLoot not rebuilt
    "Spend - Facebook+Instagram": "Spend",            # K15 spend with a filter
    "Spend - Search": "Spend",
    "Spend - StndDisplay": "Spend",
    "-": "Search Impr. share (Auction Insights)",   # K17: real name; label hidden in Omni
    "Conversions - Conexus": "Total Conversions",     # Conexus tags via dim_conversion_tag
    "Conexus CPA": "CPA",
    "Competition 1": None, "Competition 2": None,     # K19 Google Trends, not rebuilt
    "Competition 3": None, "Competition 4": None,
    "Sonnet": None,
    "*Conversions - PerfMax": "Conversions - PerfMax",
}
SPEND_FILTERS = {
    "Spend - Facebook+Instagram": ("media_type", ["Facebook+Instagram"]),
    "Spend - Search": ("media_type", ["Search"]),
    "Spend - StndDisplay": ("media_type", ["StndDisplay"]),
}

# TapClicks filter field -> model column
FIELD_MAP = {
    "Smart Campaign": "smart_campaign", "Media Type": "media_type", "Campaign": "campaign_name",
    "Campaign Name": "campaign_name", "Conversion Tag Name": "conversion_tag", "Data Source Name": "source_name",
    "Channels": "channel", "Platform": "platform", "Province": "province", "Account Name": "account_name",
    "Url": "competitor_domain", "Site Key": "site_key", "Tactic": "tactic", "Program Code": "program_code",
    "Audience": "audience", "Media Buy Name": "media_buy_name", "Session campaign": "ga4_session_campaign",
    "Session source": "ga4_session_source", "Language": "language", "Format": "creative_format",
    "Creative Name": "creative_name", "Call to Action": "call_to_action", "Creative": "creative_name",
    "Product": "product", "Search Keywords": "keyword", "Date": "date", "Session medium": "ga4_session_medium",
    "Session Manual Ad Content": "ga4_manual_ad_content", "Site": "site", "Campaign Filter": "campaign_filter",
    "Order Name": "order_name", "Attribution Group": "attribution_group", "Segment": "segment", "Pvm": "quality_band",
    "URL": "competitor_domain", "Conversion Action Name": "conversion_tag",
}

WIDGET_TYPE = {
    "bignumber": "kpi", "combinationchart": "combo-chart", "barchart": "bar-chart", "linechart": "line-chart",
    "piechart": "pie-chart", "datagrid": "table", "gaugechart": "kpi-with-target",
}

# Sources that stopped more than 90 days ago (A23): their sections and widgets are not rebuilt.
DEAD_SOURCE_RULES = [
    ("D091", "GoLoot"), ("D091", "Goloot"), ("D038", "55 Rush"), ("D043", "Billups"), ("D023", "Netflix"),
]


def slug(s):
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")[:48]


def clean_title(t):
    t = html.unescape(re.sub(r"<[^>]+>", "", str(t or ""))).strip()
    return t or "Untitled"


def parse_filters(text, metrics_known):
    """'Media Type in [CTV ; Display] AND Spend eq [0.01]' -> list of filter dicts."""
    out = []
    if not text or text.startswith("("):
        return out
    for part in re.split(r"\s+AND\s+", text):
        m = re.match(r"^(.+?)\s+(in|nin|eq|gt|lt|ne)\s+\[(.*)\]$", part.strip())
        if not m:
            out.append({"raw": part.strip(), "note": "not parsed, check by hand"})
            continue
        field, op, vals = m.group(1).strip(), m.group(2), [v.strip() for v in m.group(3).split(";") if v.strip()]
        if field in metrics_known or field not in FIELD_MAP:
            if op == "eq":
                # Q010: "Spend eq [0.01]" was used as a minimum threshold, not equality.
                try:
                    out.append({"metric_at_least": {"metric": METRIC_MAP.get(field) or field, "value": float(vals[0])}})
                    continue
                except ValueError:
                    pass
        col = FIELD_MAP.get(field, slug(field).replace("-", "_"))
        f = {"field": col, "op": {"in": "in", "nin": "not in"}.get(op, op), "values": vals}
        if any("*" in v for v in vals):
            # Q009: wildcard Smart Campaign or name filters become exact lists from the mapping table.
            f["wildcard"] = True
            f["note"] = "wildcard (Q009): resolved to an exact list or a pattern rule in seeds/filter_rules.csv"
        out.append(f)
    return out


def date_rule(dr):
    if not dr or dr == "Dashboard date":
        return None
    # A22: every widget follows the dashboard date picker; keep the old setting for reference.
    return {"was": dr, "now": "dashboard date picker"}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--profiling", required=True)
    ap.add_argument("--out", default="specs/dashboards")
    a = ap.parse_args()
    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)

    wb = openpyxl.load_workbook(a.profiling, read_only=True)
    ws = wb["Dashboards"]
    hdr = list(next(ws.iter_rows(max_row=1, values_only=True)))
    dash = {}
    for r in ws.iter_rows(min_row=2, values_only=True):
        d = dict(zip(hdr, r))
        if d["Dash ID"] in LIVE:
            dash[d["Dash ID"]] = d

    kpis = yaml.safe_load(open(Path(__file__).resolve().parents[1] / "config" / "kpis.yml"))
    kpi_names = {k["name"] for k in kpis["kpis"]}
    metrics_known = set(kpi_names) | set(METRIC_MAP) | {"Search Impr. share (Auction Insights)"}
    ws = wb["KPI Catalogue"]
    for r in ws.iter_rows(min_row=2, values_only=True):
        if r[1]:
            metrics_known.add(r[1])

    widgets = {k: [] for k in LIVE}
    ws = wb["Widgets"]
    for r in ws.iter_rows(min_row=2, values_only=True):
        if r[0] in widgets:
            widgets[r[0]].append(r)

    index, columns_needed, unknown_metrics, totals = [], Counter(), Counter(), Counter()
    for did, (client, prio, typ, group, moves) in LIVE.items():
        d = dash[did]
        sections = OrderedDict()
        dropped = Counter()
        for (_, tcid, section, wid, wtype, title, mapping, metrics, dims, flt, dr) in widgets[did]:
            blob = " ".join(str(x) for x in (section, mapping, metrics, flt, title))
            reason = None
            for dd, key in DEAD_SOURCE_RULES:
                if did == dd and key in blob:
                    reason = f"source {key} stopped over 90 days ago (A23)"
            if "DNU" in str(title):
                reason = "marked do-not-use in TapClicks"
            new_metrics, extra, labels = [], [], {}
            for m in [x.strip() for x in str(metrics or "").split(",") if x.strip()]:
                if m in METRIC_MAP:
                    nm = METRIC_MAP[m]
                    if nm is None:
                        continue
                    if m in SPEND_FILTERS:
                        col, vals = SPEND_FILTERS[m]
                        extra.append({"field": col, "op": "in", "values": vals})
                    new_metrics.append(nm)
                    if nm != m:
                        labels[nm] = m
                else:
                    new_metrics.append(m)
            if not new_metrics and not reason:
                reason = "all metrics retired (K16, K19)"
            sec = sections.setdefault(section, {"name": section, "rebuild": True, "widgets": []})
            if reason:
                dropped[reason] += 1
                totals["dropped"] += 1
                continue
            for m in new_metrics:
                if m not in kpi_names:
                    unknown_metrics[m] += 1
            filters = parse_filters(flt, metrics_known) + extra
            for f in filters:
                if "field" in f:
                    columns_needed[f["field"]] += 1
            group_by = [FIELD_MAP.get(x.strip(), slug(x.strip()).replace("-", "_")) for x in str(dims or "").split(",") if x.strip() and x.strip() != "None"]
            for g in group_by:
                columns_needed[g] += 1
            w = OrderedDict()
            w["tapclicks_widget_id"] = wid
            w["element"] = WIDGET_TYPE.get(wtype, wtype)
            w["title"] = clean_title(title)
            w["metrics"] = list(dict.fromkeys(new_metrics))
            if "Search Impr. share (Auction Insights)" in w["metrics"] and str(metrics).strip() == "-":
                w["hide_metric_label"] = True     # K17
            tb = re.match(r"^(Top|Bottom)\s+(\d+)\b.*?\bby\s+(.+)$", w["title"], re.I)
            if tb:
                w["sort"] = {"by": tb.group(3).strip(), "order": "desc" if tb.group(1).lower() == "top" else "asc",
                             "limit": int(tb.group(2))}
            if w.get("hide_metric_label"):    # K17: the "-" label was a TapClicks workaround; Omni hides it
                labels = {k: v for k, v in labels.items() if str(v).strip() != "-"} if labels else labels
            if labels:
                w["labels"] = labels      # show the TapClicks label in Omni (K14, K15)
            if group_by:
                tl = w["title"].lower()
                grain = "week" if "week" in tl else "month" if "month" in tl else "day" if ("day" in tl or "daily" in tl) else None
                w["group_by"] = [f"date:{grain}" if (g == "date" and grain) else g for g in group_by]
            if filters:
                w["filters"] = filters
            dchg = date_rule(dr)
            if dchg:
                w["date_range"] = dchg
            w["source_mapping_in_tapclicks"] = mapping
            sec["widgets"].append(w)
            totals["kept"] += 1
        for s in sections.values():
            if not s["widgets"]:
                s["rebuild"] = False
                s["note"] = "every widget in this section is retired; data stays available by date range"
        spec = OrderedDict()
        spec["id"] = did
        spec["title"] = d["TapClicks Title"]
        spec["client"] = client
        spec["priority"] = prio
        spec["build_type"] = typ
        spec["move_group"] = group
        spec["target_live_date"] = moves
        spec["template"] = "master" if typ == "Standard" else ("master-base-plus-custom" if typ == "Custom" else "hand-built-layout")
        spec["tapclicks"] = {"dashboard_id": d["TapClicks Dash ID"], "client_account": d["TapClicks Client Account"],
                             "built_from": d["Built From"], "data_widgets": d["# Data Widgets"]}
        spec["scope"] = {"smart_campaign_filter_values": d["Smart Campaign Filter Values"],
                         "how_widgets_are_scoped": d["How Widgets Are Scoped"]}
        notes = []
        if did == "D005":
            notes.append("Merge Cobs Bread Evergreen and Evergreen USA into this one dashboard (A16).")
        if did in ("D059", "D061", "D074"):
            notes.append("Likely merged into one Ottawa Tourism dashboard once Epitaph approves the template.")
        if did in ("D095", "D097"):
            notes.append("Shows every campaign for the client, as Epitaph confirmed (Q23).")
        if did in ("D039", "D052"):
            notes.append("Google Ads Grants spend is USD and shows in CAD via dim_fx_rate (Q20).")
        if did == "D053":
            notes.append("Reported in USD, the ad account's currency (Q19).")
        if did in ("D093", "D094"):
            notes.append("GA4 Test source excluded (Q22). Quotes come from Sonnet Raw Data (K22).")
        if dropped:
            notes.append("Not rebuilt: " + "; ".join(f"{v} widget{'s' if v > 1 else ''}, {k}" for k, v in dropped.items()))
        spec["notes"] = notes
        spec["sections"] = list(sections.values())
        fname = f"{did}_{slug(d['TapClicks Title'])}.yml"
        with open(out / fname, "w") as fh:
            yaml.safe_dump(spec, fh, sort_keys=False, allow_unicode=True, width=120)
        index.append({"id": did, "file": fname, "title": d["TapClicks Title"], "client": client, "priority": prio,
                      "build_type": typ, "move_group": group, "target_live_date": moves,
                      "sections_rebuilt": sum(1 for s in sections.values() if s["rebuild"]),
                      "widgets_rebuilt": sum(len(s["widgets"]) for s in sections.values()),
                      "widgets_retired": sum(dropped.values())})
    with open(out / "_index.yml", "w") as fh:
        yaml.safe_dump({"dashboards": index, "totals": dict(totals)}, fh, sort_keys=False)
    with open(out.parent / "required_columns.yml", "w") as fh:
        yaml.safe_dump({"columns_used_by_filters_and_group_by": dict(columns_needed.most_common()),
                        "metrics_not_yet_in_kpis_yml": dict(unknown_metrics.most_common())}, fh, sort_keys=False)
    # Client seed: one row per TapClicks client account on a live dashboard.
    import csv
    clients = {}
    for did, (client, *_r) in LIVE.items():
        acct = dash[did]["TapClicks Client Account"]
        clients.setdefault((client, acct), []).append(did)
    seeds = out.parent.parent / "seeds"
    seeds.mkdir(exist_ok=True)
    with open(seeds / "map_client_account.csv", "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["client_code", "client_name", "tapclicks_client_account", "dashboards", "reporting_currency"])
        for (client, acct), ids in sorted(clients.items()):
            code = "C" + str(sorted({c for c, _ in clients}).index(client) + 1).zfill(2)
            cur = "USD" if client == "Nulo" else "CAD"
            w.writerow([code, client, acct, " ".join(ids), cur])
    print(f"{len(index)} specs; widgets kept {totals['kept']}, retired {totals['dropped']}; unknown metrics {len(unknown_metrics)}")


if __name__ == "__main__":
    main()
