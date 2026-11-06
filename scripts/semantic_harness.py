"""Gold-first build: run the semantic layer and every KPI locally, before any source is connected.

The gold tables are created in DuckDB from specs/gold_contract.yml, the semantic view is taken from the real
Snowflake file (snowflake/50_semantic/v_media_performance_daily.sql) with only Snowflake-only clauses removed, and
each KPI is computed from its expression in config/kpis.yml. So the semantic layer, the KPI definitions and the
Omni measures can be built and tested now; silver is then built to fill the same contract.

  python scripts/semantic_harness.py --tapclicks /secure/Data_Table_Export.csv     # real export, engineer only
  (tests use synthetic rows: tests/test_semantic_layer.py)

Output with --tapclicks: KPI totals per client and source, and a check of CPM, CTR and CPC against the values
TapClicks printed in the same file. Totals only; no rows are printed.
"""
import argparse
import csv
import hashlib
import re
from pathlib import Path

import duckdb
import yaml

ROOT = Path(__file__).resolve().parents[1]
TYPES = {"number": "DOUBLE", "varchar": "VARCHAR", "boolean": "BOOLEAN", "date": "DATE"}


def connect():
    con = duckdb.connect(":memory:")
    contract = yaml.safe_load(open(ROOT / "specs" / "gold_contract.yml"))
    for table, spec in contract["tables"].items():
        cols = ", ".join(f"{c} {TYPES[v['type']]}" for c, v in spec["columns"].items())
        con.execute(f"create table {table} ({cols})")
    # small dimensions the view joins that the contract leaves to the platform
    con.execute("create table DIM_DATE (date_key DOUBLE, date_day DATE, week_start DATE, month_start DATE)")
    con.execute("""insert into DIM_DATE select cast(strftime(d, '%Y%m%d') as double), d, date_trunc('week', d), date_trunc('month', d)
                   from range(date '2024-01-01', date '2027-12-31', interval 1 day) t(d)""")
    con.execute("create table DIM_SOURCE (source_key VARCHAR, source_name VARCHAR)")
    # DIM_CLIENT is in the contract: fill it from the Master Client Index seed
    con.executemany("insert into DIM_CLIENT (client_code, client_name) values (?, ?)", sorted({(r["client_code"], r["client_name"]) for r in
                    csv.DictReader(open(ROOT / "seeds" / "mci_client.csv"))}))
    con.execute(semantic_sql())
    return con


def semantic_sql():
    """The production view, with Snowflake-only parts removed (role, row access policy, database prefixes)."""
    text = (ROOT / "snowflake" / "50_semantic" / "v_media_performance_daily.sql").read_text()
    stmt = text[text.index("create or replace view GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY"):]
    stmt = stmt[:stmt.index(";")]
    stmt = stmt.replace("GOLD.SEMANTIC.", "").replace("GOLD.MARTS.", "")
    stmt = re.sub(r"\s+with row access policy \S+ on \(\w+\)", "", stmt)
    return stmt


def kpi_sql(expr):
    """config/kpis.yml uses `sum(x) filter (cond)`; standard SQL spells it `filter (where cond)`."""
    return re.sub(r"filter\s*\((?!\s*where)", "filter (where ", expr)


def kpis():
    return yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]


def view_columns(con):
    return {r[0].lower() for r in con.execute("describe V_MEDIA_PERFORMANCE_DAILY").fetchall()}


def evaluate(con, where="true", group_by=None):
    """Every KPI whose measures are in the semantic view, over the rows matching `where`."""
    cols = view_columns(con)
    out = {}
    for k in kpis():
        if "expr" not in k:
            continue
        measures = set(re.findall(r"(?:sum|avg)\((\w+)\)", k["expr"])) | set(re.findall(r"\b(kpi_group|counts_toward_kpi|campaign_type)\b", k["expr"]))
        if not measures <= cols:
            continue
        sel = kpi_sql(k["expr"])
        if group_by:
            rows = con.execute(f"select {group_by}, {sel} from V_MEDIA_PERFORMANCE_DAILY where {where} group by 1 order by 1").fetchall()
            out[k["name"]] = dict(rows)
        else:
            out[k["name"]] = con.execute(f"select {sel} from V_MEDIA_PERFORMANCE_DAILY where {where}").fetchone()[0]
    return out


def coverage(con):
    """Which KPIs the semantic view can compute today, and which wait for another fact."""
    cols = view_columns(con)
    ready, other = [], []
    for k in kpis():
        ms = set(re.findall(r"(?:sum|avg)\((\w+)\)", k.get("expr", "")))
        (ready if ms and ms <= cols else other).append(k["name"])
    return ready, other


# ---------------------------------------------------------------- load a TapClicks Data Table export into gold
def key(*parts):
    return hashlib.sha256("|".join(p or "(none)" for p in parts).encode()).hexdigest()


def num(v):
    v = (v or "").replace(",", "").replace("$", "").replace("%", "").strip()
    try:
        return float(v)
    except ValueError:
        return 0.0


def load_tapclicks(con, path, media_types=None):
    media_types = media_types or {r["raw_value"]: r for r in csv.DictReader(open(ROOT / "seeds" / "map_media_type.csv"))}
    clients = {r["client_name"].lower(): r["client_code"] for r in csv.DictReader(open(ROOT / "seeds" / "mci_client.csv"))}
    deliv, conv, camps, mbs, crs, srcs, printed = {}, {}, {}, {}, {}, set(), []
    import datetime as dt
    for r in csv.DictReader(open(path, encoding="utf-8-sig")):
        d = dt.datetime.strptime(r["Date"].strip(), "%b %d %Y").date()
        dk = float(d.strftime("%Y%m%d"))
        src, cn, mb, cr, tag = (r.get(x, "").strip() for x in ("Data Source Name", "Campaign Name", "Media Buy Name", "Creative Name", "Conversion Tag Name"))
        sk, ck, mk, rk = key(src), key(cn), key(mb, cn), key(cr)
        srcs.add((sk, src))
        p = cn.split("_")
        camps[ck] = (ck, cn, clients.get(p[0].lower()), None, p[2] if len(p) > 2 else None, p[3] if len(p) > 3 else None,
                     p[4] if len(p) > 4 else None, bool(re.match(r"^[^_]+_[^_]+_\d{4}-\d+_[A-Za-z]{2}_[A-Za-z]{2}$", cn)))
        mp = mb.split("_")
        mt = media_types.get(mp[3] if len(mp) > 3 else "", {})
        mbs[mk] = (mk, mb, mt.get("media_type", "Unclassified"), (mp[4].split("-")[0] if len(mp) > 4 else None),
                   (mp[7].strip() if len(mp) > 7 else None), None, None)
        cp = cr.split("_")
        crs[rk] = (rk, cr, cp[6] if len(cp) > 6 else None, cp[8] if len(cp) > 8 else None)
        if tag:
            c = conv.setdefault((dk, sk, ck, tag), [0.0])
            c[0] += num(r.get("Total Conversions"))
        else:
            v = deliv.setdefault((dk, sk, ck, mk, rk), [mt.get("media_type", "Unclassified"), mt.get("channel", "Unclassified"), 0, 0, 0, 0, 0])
            for i, col in enumerate(("Impressions", "Clicks", "Spend", "Starts", "Completed Plays"), start=2):
                v[i] += num(r.get(col))
            printed.append((num(r.get("Impressions")), num(r.get("Clicks")), num(r.get("Spend")), r.get("CPM"), r.get("CTR"), r.get("CPC")))
    con.executemany("insert into DIM_SOURCE values (?, ?)", list(srcs))
    con.executemany("""insert into DIM_CAMPAIGN (campaign_key, campaign_name, client_code, smart_campaign, job_number, language,
                       country, campaign_name_valid) values (?, ?, ?, ?, ?, ?, ?, ?)""", list(camps.values()))
    con.executemany("insert into DIM_MEDIA_BUY values (?, ?, ?, ?, ?, ?, ?)", list(mbs.values()))
    con.executemany("insert into DIM_CREATIVE values (?, ?, ?, ?)", list(crs.values()))
    con.executemany("""insert into FCT_AD_DELIVERY_DAILY (date_key, source_key, campaign_key, media_buy_key, creative_key, media_type,
                       channel, impressions, clicks, spend, video_starts, completed_plays, spend_account_currency, post_shares, spots,
                       loaded_from) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 'tapclicks_history')""",
                    [(*k, *v, v[4]) for k, v in deliv.items()])
    con.executemany("""insert into FCT_CONVERSIONS_DAILY (date_key, source_key, campaign_key, conversion_tag_name, conversions,
                       platform_conversions, counts_toward_kpi, loaded_from) values (?, ?, ?, ?, ?, ?, true, 'tapclicks_history')""",
                    [(*k, v[0], v[0]) for k, v in conv.items()])
    return printed


def check_printed_rates(printed):
    """Recompute CPM, CTR and CPC per row and compare with what TapClicks printed. The export prints spend rounded to
    cents while TapClicks computed rates on unrounded spend, so the allowed gap includes half a cent of spend."""
    bad = {"CPM": 0, "CTR": 0, "CPC": 0}
    n = 0
    for imp, clk, sp, cpm, ctr, cpc in printed:
        n += 1
        if imp and cpm and abs(sp / imp * 1000 - num(cpm)) > 0.006 + 0.005 / imp * 1000:
            bad["CPM"] += 1
        if imp and ctr and abs(clk / imp * 100 - num(ctr)) > 0.006:
            bad["CTR"] += 1
        if clk and cpc and abs(sp / clk - num(cpc)) > 0.006 + 0.005 / clk:
            bad["CPC"] += 1
    return n, bad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tapclicks", required=True)
    a = ap.parse_args()
    con = connect()
    printed = load_tapclicks(con, a.tapclicks)
    ready, other = coverage(con)
    print(f"semantic view computes {len(ready)} of {len(kpis())} KPIs; {len(other)} read their own fact or are as reported")
    n, bad = check_printed_rates(printed)
    print(f"rates recomputed on {n} delivery rows; differences from TapClicks: {bad}")
    tot = evaluate(con)
    for k in ("Impressions", "Clicks", "Spend", "CPM", "CTR", "CPC", "Total Conversions", "CPA", "VCR", "CPCV"):
        v = tot.get(k)
        print(f"  {k:<18} {v:,.4f}" if isinstance(v, float) else f"  {k:<18} {v}")
    avg_cpm = con.execute("""select avg(spend / nullif(impressions, 0) * 1000) from V_MEDIA_PERFORMANCE_DAILY
                             where row_type = 'delivery' and impressions > 0""").fetchone()[0]
    print(f"  CPM averaged from rows (the TapClicks mistake K02 fixes): {avg_cpm:,.2f} vs from totals {tot['CPM']:,.2f}")


if __name__ == "__main__":
    main()
