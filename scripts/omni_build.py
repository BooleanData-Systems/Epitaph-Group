"""Build the Omni model and the dashboard build sheets from the KPI file, the semantic view and the column groups.

What it writes (all generated, never edited by hand; CI fails if a regenerated file differs from the commit):
  omni/model/model.yaml                          access grants (one per column group) and the default client filter
  omni/model/media_performance_daily.view.yaml   every column of GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY and every KPI
  omni/model/media_performance.topic.yaml        the topic dashboards are built on, filtered to the viewer's client
  omni/model/data_checks.view.yaml / .topic.yaml the morning check results (Epitaph staff only)
  omni/dashboards/build/<ID>_build_sheet.md      element-by-element checklist for each of the 29 dashboards

How the KPIs become Omni measures (config/kpis.yml stays the one source):
  sum(x)                       -> measure, aggregate_type sum
  sum(x) filter (cond)         -> measure, aggregate_type sum, with measure filters
  ratio of the above           -> measure whose sql divides other measures (NULLIF on the divisor)
  as_reported                  -> no measure: shown at the platform and period it was reported for
Each KPI requires the access grants of every column group it reads, so hiding spend from a client also hides CPM,
CPC and CPA for that client.

Filters on delivery-only columns: outcome rows (conversions, quotes, trials, sessions) have no media type, tactic or
creative. Each such column gets a hidden filter field, filter_<column>, that reads "All outcomes" on outcome rows.
A tile filter is then written as filter_media_type in [CTV, All outcomes], which keeps the outcome rows in.

    python scripts/omni_build.py                 # everything
    python scripts/omni_build.py --only D053     # one build sheet (the model is always rebuilt)
"""
import argparse
import csv
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
OMNI = ROOT / "omni"
MODEL = OMNI / "model"
sys.path.insert(0, str(ROOT / "scripts"))
from gen_semantic_view import BLOCKS, DIMS, MEASURES  # noqa: E402

VIEW = "media_performance_daily"
TOPIC = "media_performance"
OUTCOMES = "All outcomes"
DIM_NAMES = [d for d, _ in DIMS]
# Dimensions only delivery rows carry (every other row type leaves them null).
DELIVERY_ONLY = sorted((set(BLOCKS[0]["cols"]) - {c for b in BLOCKS[1:] for c in b["cols"]}) & set(DIM_NAMES))
FORMATS = {"integer": "number_0", "decimal": "number_2", "currency": "currency_2", "percent": "percent_2"}
CHECK_COLUMNS = [("run_id", "string"), ("check_name", "string"), ("rule_id", "string"), ("client_part", "string"),
                 ("source_name", "string"), ("period_start", "date"), ("period_grain", "string"), ("measure", "string"),
                 ("status", "string")]
CHECK_MEASURES = ["snowflake_value", "tapclicks_value", "diff"]


class Dumper(yaml.SafeDumper):
    pass


Dumper.add_representer(str, lambda d, s: d.represent_scalar("tag:yaml.org,2002:str", s,
                                                            style="'" if s.startswith("$") or ":" in s else None))


def dump(obj):
    return yaml.dump(obj, Dumper=Dumper, sort_keys=False, width=140, allow_unicode=True)


def slug(name):
    s = re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")
    return s if not s[:1].isdigit() else "k_" + s


def col_sql(col):
    return f'"{col.upper()}"'


def column_groups():
    """column -> group, from seeds/column_groups.csv. A seed entry matches a column exactly or as its last part
    (trials matches performance_trials). Measures no group names are client file data; other dimensions are identity."""
    groups = list(csv.DictReader(open(ROOT / "seeds" / "column_groups.csv")))
    out = {}
    for col in DIM_NAMES + MEASURES:
        for g in groups:
            names = [c.strip() for c in g["columns"].split(",") if c.strip()]
            if col in names or any(col.endswith("_" + n) for n in names):
                out[col] = g["column_group"]
                break
        else:
            out[col] = "client_files" if col in MEASURES else "identity"
    return out, [g["column_group"] for g in groups]


def grants_for(cols, groups_of):
    return sorted({f"cg_{groups_of[c]}" for c in cols if groups_of[c] != "identity"})


TERM = re.compile(r"sum\((\w+)\)(?:\s*filter\s*\(([^()]*)\))?")
AVG = re.compile(r"avg\((\w+)\)(?:\s*filter\s*\(([^()]*)\))?")
MONEY = "currency"
PLATFORM_COUNT = "platforms_in_view"   # K07: rates marked per_platform_only are blank when a tile blends platforms


def parse_filter(cond):
    cond = cond.strip()
    m = re.fullmatch(r"(\w+)\s*=\s*'([^']*)'", cond)
    if m:
        return {m.group(1): {"is": m.group(2)}}
    if re.fullmatch(r"\w+", cond):
        return {cond: {"is": True}}
    raise ValueError(f"unsupported KPI filter: {cond}")


def term_name(col, cond):
    if not cond:
        return f"total_{col}"
    f = parse_filter(cond)
    (field, rule), = f.items()
    val = rule["is"]
    return f"total_{col}_{field}" if val is True else f"total_{col}_{slug(str(val))}"


def build_measures(groups_of):
    kpis = yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]
    helpers, measures, names = {}, {}, {}
    if any(k.get("per_platform_only") for k in kpis):
        helpers[PLATFORM_COUNT] = {"sql": 'COALESCE("PLATFORM", "SOURCE_NAME")', "aggregate_type": "count_distinct",
                                   "hidden": True, "filters": {"row_type": {"is": "delivery"}},
                                   "description": "K07: platforms in the current tile; per-platform rates show only when it is 1."}
    for k in kpis:
        if "expr" not in k:
            continue
        avg = AVG.fullmatch(k["expr"].strip())
        terms = TERM.findall(k["expr"]) or ([avg.groups()] if avg else [])
        for col, cond in terms:
            if col not in MEASURES:
                raise ValueError(f"{k['name']}: {col} is not a column of the semantic view")
            n = term_name(col, cond)
            if n not in helpers:
                h = {"sql": col_sql(col), "aggregate_type": "sum", "hidden": True}
                if cond:
                    h["filters"] = parse_filter(cond)
                h["required_access_grants"] = grants_for([col], groups_of)
                if not h["required_access_grants"]:
                    del h["required_access_grants"]
                helpers[n] = h
        name = slug(k["name"])
        while name in measures or name in DIM_NAMES:
            name += "_kpi"
        names[k["name"]] = name
        used = [c for c, _ in terms]   # filter fields (counts_toward_kpi) select rows; they do not decide who sees the KPI
        m = {"label": k["name"], "description": f"{k.get('decision', '')} {k.get('notes', '')}".strip()}
        if TERM.fullmatch(k["expr"].strip()) or avg:
            col, cond = terms[0]
            m.update({"sql": col_sql(col), "aggregate_type": "average" if avg else "sum"})
            if cond:
                m["filters"] = parse_filter(cond)
        else:
            e = TERM.sub(lambda mt: "${" + f"{VIEW}.{term_name(mt.group(1), mt.group(2))}" + "}", k["expr"])
            m["sql"] = re.sub(r"\bnullif\(", "NULLIF(", e)
            if k.get("per_platform_only"):
                m["sql"] = f"CASE WHEN ${{{VIEW}.{PLATFORM_COUNT}}} = 1 THEN {m['sql']} END"
        m["format"] = FORMATS[k["format"]]
        g = grants_for(used, groups_of)
        if g:
            m["required_access_grants"] = g
        measures[name] = m
    return helpers, measures, names


def build_view(groups_of):
    dims = {}
    types = dict(DIMS)
    for d in DIM_NAMES:
        x = {"sql": col_sql(d), "label": d.replace("_", " ").capitalize()}
        if types[d] == "date":
            x["type"] = "date"
        elif types[d] == "boolean":
            x["type"] = "boolean"
        if groups_of[d] != "identity":
            x["required_access_grants"] = [f"cg_{groups_of[d]}"]
        dims[d] = x
    for d in DELIVERY_ONLY:
        dims[f"filter_{d}"] = {
            "sql": f"CASE WHEN {col_sql('row_type')} = 'delivery' THEN {col_sql(d)} ELSE '{OUTCOMES}' END",
            "label": f"{d.replace('_', ' ').capitalize()} (filter)", "hidden": True,
            "description": f"Use this, not {d}, in tile filters: outcome rows read '{OUTCOMES}' so they stay in."}
    helpers, measures, names = build_measures(groups_of)
    view = {"schema": "SEMANTIC", "table_name": "V_MEDIA_PERFORMANCE_DAILY",
            "label": "Media performance (daily)",
            "description": "GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY. Generated by scripts/omni_build.py from config/kpis.yml.",
            "dimensions": dims, "measures": {**helpers, **measures}}
    return view, names


def build_model(all_groups):
    grants = {f"cg_{g}": {"user_attribute": f"cg_{g}", "allowed_values": ["yes"]} for g in all_groups if g != "identity"}
    return {"access_grants": grants,
            "default_topic_access_filters": [{"field": f"{VIEW}.client_code", "user_attribute": "client_code",
                                              "values_for_unfiltered": ["ALL"]}]}


def build_topic():
    return {"base_view": VIEW, "label": "Media performance",
            "description": "Every client dashboard is built on this topic. Rows are filtered to the viewer's client_code.",
            "access_filters": [{"field": f"{VIEW}.client_code", "user_attribute": "client_code",
                                "values_for_unfiltered": ["ALL"]}]}


def build_checks():
    view = {"schema": "CHECKS", "table_name": "RECON_RESULTS", "label": "Data checks",
            "description": "GOLD.CHECKS.RECON_RESULTS: Snowflake vs TapClicks, every morning.",
            "dimensions": {c: ({"sql": col_sql(c), "type": "date"} if t == "date" else {"sql": col_sql(c)})
                           for c, t in CHECK_COLUMNS},
            "measures": {**{m: {"sql": col_sql(m), "aggregate_type": "sum"} for m in CHECK_MEASURES},
                         "failed_checks": {"sql": col_sql("run_id"), "aggregate_type": "count",
                                           "filters": {"status": {"is": "FAIL"}}}}}
    topic = {"base_view": "data_checks", "label": "Data checks", "required_access_grants": ["cg_internal"],
             "access_filters": []}
    return view, topic


def build_sheet(spec, kpi_names):
    money = {k["name"]: k.get("format") == MONEY for k in yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]}
    lines = [f"# Build sheet: {spec['id']} {spec['title']}", "",
             f"Client: {spec['client']}. Type: {spec['build_type']}. Target live date: {spec['target_live_date']}.",
             f"Omni topic: {TOPIC}. Fields are the measure names in omni/model/{VIEW}.view.yaml.", ""]
    for n in spec.get("notes", []):
        lines.append(f"- {n}")
    if spec.get("split_money_by"):
        lines.append(f"- Every money tile (spend, CPM, CPC, CPA and other cost KPIs) is split by {spec['split_money_by']}: "
                     "accounts in different currencies are never added together.")
    lines.append("")
    for sec in spec["sections"]:
        lines.append(f"## {sec['name']}" + ("" if sec["rebuild"] else " (not rebuilt)"))
        lines.append("")
        if not sec["rebuild"]:
            lines.append(sec.get("note", ""))
            lines.append("")
            continue
        lines.append("| Done | Element | Title | Metrics (Omni field) | Group by | Filters |")
        lines.append("|---|---|---|---|---|---|")
        for w in sec["widgets"]:
            fl = []
            for f in w.get("filters", []):
                if "metric_at_least" in f:
                    fl.append(f"{f['metric_at_least']['metric']} >= {f['metric_at_least']['value']}")
                elif "field" in f:
                    vals = list(f["values"][:6]) + (["..."] if len(f["values"]) > 6 else [])
                    field = f["field"]
                    if field in DELIVERY_ONLY:
                        field, vals = f"filter_{field}", vals + [OUTCOMES]
                    fl.append(f"{field} {f['op']} [{', '.join(vals)}]")
            mets = ", ".join(f"{m} ({kpi_names[m]})" if m in kpi_names else m for m in w["metrics"])
            if w.get("labels"):
                mets += " (labels: " + ", ".join(f"{k} as {v}" for k, v in w["labels"].items()) + ")"
            if w.get("hide_metric_label"):
                mets += " (metric label hidden on the chart)"
            group = list(w.get("group_by", []))
            split = spec.get("split_money_by")
            if split and split not in group and any(money.get(m) for m in w["metrics"]):
                group.append(split)
            lines.append(f"| [ ] | {w['element']} | {w['title']} | {mets} | {', '.join(group)} | {'; '.join(fl)} |")
        lines.append("")
    kpis = {k["name"] for k in yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]}
    missing = sorted({m for s in spec["sections"] for w in s["widgets"] for m in w["metrics"] if m not in kpis})
    if missing:
        lines.append("Metrics not in config/kpis.yml: " + ", ".join(missing))
    return "\n".join(lines) + "\n"


def write_model():
    groups_of, all_groups = column_groups()
    view, names = build_view(groups_of)
    cview, ctopic = build_checks()
    MODEL.mkdir(parents=True, exist_ok=True)
    head = "# Generated by scripts/omni_build.py. Do not edit by hand: change config/kpis.yml or the seeds.\n"
    files = {"model.yaml": build_model(all_groups), f"{VIEW}.view.yaml": view, f"{TOPIC}.topic.yaml": build_topic(),
             "data_checks.view.yaml": cview, "data_checks.topic.yaml": ctopic}
    for fn, obj in files.items():
        (MODEL / fn).write_text(head + dump(obj))
    return view, names


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only")
    a = ap.parse_args()
    view, names = write_model()
    out = OMNI / "dashboards" / "build"
    out.mkdir(parents=True, exist_ok=True)
    sheets = 0
    for f in sorted((ROOT / "specs" / "dashboards").glob("D*.yml")):
        spec = yaml.safe_load(open(f))
        if a.only and spec["id"] != a.only:
            continue
        (out / f"{spec['id']}_build_sheet.md").write_text(build_sheet(spec, names))
        sheets += 1
    kpi_measures = sum(1 for m in view["measures"].values() if not m.get("hidden"))
    print(f"model: {len(view['dimensions'])} dimensions, {kpi_measures} KPI measures; build sheets: {sheets}")


if __name__ == "__main__":
    main()
