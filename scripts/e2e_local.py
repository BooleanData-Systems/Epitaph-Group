"""End-to-end run of the production SQL on a local DuckDB copy: Bronze -> Silver -> Gold -> Semantic -> KPIs.

Every file in snowflake/deploy_order.txt is transpiled from Snowflake to DuckDB with sqlglot and run in order.
Statements that only make sense inside Snowflake (roles, grants, tasks, alerts, procedures, integrations, policies)
are skipped and counted. A TapClicks Data Table export is loaded into BRONZE as history, and the numbers are traced
through every layer and compared with the file. Prints totals and pass/fail only.

    python scripts/e2e_local.py --tapclicks /secure/Data_Table_Export.csv      (engineer only: real export)
"""
import argparse
import csv
import re
import sys
from pathlib import Path

import duckdb
import sqlglot

ROOT = Path(__file__).resolve().parents[1]
SKIP = re.compile(r"^\s*(use |grant |revoke |alter (warehouse|account|task|alert|user|dynamic table|view)|call |create (or replace )?"
                  r"(procedure|task|alert|network rule|secret|external access|notification|resource monitor|warehouse|role|user|"
                  r"row access policy|masking policy|stage|function|database|schema)|create (row access|masking) policy|show )", re.I)
RESULTS = []


def check(name, ok, detail=""):
    RESULTS.append((name, ok, detail))
    print(f"  {'PASS' if ok else 'FAIL'}  {name}{('  ' + detail) if detail else ''}")


def statements(text):
    text = re.sub(r"\$\$.*?\$\$", "$$BODY$$", text, flags=re.S)
    for s in re.split(r";[ \t]*(?:--[^\n]*)?(?:\n|$)", text):
        body = "\n".join(l for l in s.splitlines() if not l.strip().startswith("--")).strip()
        if body:
            yield body


def to_duckdb(stmt):
    stmt = re.sub(r"(?is)to_number\(to_char\(((?:[^()]|\([^()]*\))*?),\s*'YYYYMMDD'\)\)", r"cast(strftime(\1, '%Y%m%d') as integer)", stmt)
    stmt = re.sub(r"(?is)dateadd\(day,\s*seq4\(\),\s*'2020-01-01'::date\)", "(cast('2020-01-01' as date) + cast(seq as integer))", stmt)
    stmt = re.sub(r"(?is)\s+with row access policy \S+ on \(\w+\)", "", stmt)
    stmt = re.sub(r"(?is)target_lag\s*=\s*(downstream|'[^']*')|refresh_mode\s*=\s*\w+|warehouse\s*=\s*\w+|change_tracking\s*=\s*true", "", stmt)
    stmt = re.sub(r"(?is)\bcluster by \([^)]*\)", "", stmt)
    stmt = re.sub(r"(?is)create or replace dynamic table", "create or replace table", stmt)
    stmt = re.sub(r"(?is)\bcomment\s*=\s*'(?:[^']|'')*'", "", stmt)
    stmt = re.sub(r"(?is)table\(generator\(rowcount\s*=>\s*(\d+)\)\)", r"range(\1) g(seq)", stmt).replace("seq4()", "seq")
    out = sqlglot.transpile(stmt, read="snowflake", write="duckdb")
    return out[0] if out else ""


def setup(con):
    for db in ("BRONZE", "SILVER", "GOLD"):
        con.execute(f"attach ':memory:' as {db}")
    for s in ("BRONZE.SHAREPOINT", "BRONZE.LOADER", "BRONZE.TAPCLICKS", "BRONZE.REFERENCE", "SILVER.STG", "GOLD.MARTS",
              "GOLD.SEMANTIC", "GOLD.CONTROL", "GOLD.CHECKS", "GOLD.ADMIN", "GOLD.ARCHIVE"):
        con.execute(f"create schema if not exists {s}")
    # Snowflake SQL helpers used by the SQL files
    con.execute("create or replace macro try_to_number(x) as try_cast(x as double)")
    con.execute("create or replace macro try_to_decimal(x, p, s) as try_cast(x as double)")
    # record:col on a JSON column gives the JSON text ("2026-10-01" with quotes); Snowflake's variant cast gives the
    # bare value. sv strips the quotes so the macros see what Snowflake sees.
    sv = "trim(cast(v as varchar), '\"')"
    con.execute(f"""create or replace macro SILVER.STG.NUM(v) as try_cast(nullif(trim(replace(replace(replace({sv}, ',', ''), '$', ''), '%', '')), 'null') as double)""")
    con.execute(f"""create or replace macro SILVER.STG.DAY(v) as case
                   when regexp_full_match(trim({sv}), '[0-9]{{1,2}}/[0-9]{{1,2}}/[0-9]{{2}}')
                     then cast(try_strptime(trim({sv}), '%m/%d/%y') as date)
                   else coalesce(try_cast({sv} as date), try_cast(left({sv}, 10) as date),
                     cast(try_strptime({sv}, ['%m/%d/%Y', '%Y/%m/%d', '%b %d %Y', '%b %d, %Y', '%B %d, %Y', '%b %Y']) as date)) end""")
    con.execute(f"""create or replace macro SILVER.STG.TXT(v) as nullif(nullif(nullif(trim({sv}), ''), 'null'), '-')""")
    for t in ("SONNET_RAW_DATA", "SONNET_QUOTE_QUALITY", "SONNET_GROUP_BREAKDOWN", "SONNET_MULTILINE", "DIRECT_BUY_SPEND",
              "SONNET_DV360_CREATIVE", "SONNET_AUCTION_PRESSURE", "SONNET_VISIBILITY", "SONNET_VS_COMPETITION", "AMAZON_DSP_REACH",
              "SXM_ADOBE", "SXM_SCORECARD", "SILVERPUSH", "HIVESTACK", "NETFLIX_PAUSE_ADS", "JOLT_MEDIA", "ADARA", "SPOTIFY_FILES",
              "GOALS", "WILDBRAIN"):
        con.execute(f"""create table BRONZE.SHAREPOINT.{t} (item_id varchar, etag varchar, file_name varchar, feed_id varchar,
                        report varchar, grain varchar, row_number integer, record json, run_id varchar, loaded_at timestamp)""")


def run_sql(con):
    order = [l.strip() for l in (ROOT / "snowflake" / "deploy_order.txt").read_text().splitlines()
             if l.strip() and not l.startswith("#")]
    ran = skipped = 0
    failures = []
    for rel in order:
        path = ROOT / "snowflake" / rel
        req = re.search(r"^-- requires: (\S+)", path.read_text(), re.M)
        if req:                                   # connector not synced here: use its stub, as the deploy script does
            path = path.parent / "stubs" / path.name
        for stmt in statements(path.read_text()):
            m = re.match(r"(?i)^\s*use schema (\S+)", stmt)
            if m:
                con.execute(f"use {m.group(1)}")
                continue
            if re.match(r"(?i)^\s*(end|begin)\b", stmt) or "V_KPI_DEFINITIONS" in stmt:
                skipped += 1                       # task bodies; the KPI definitions view (VALUES naming differs)
                continue
            if SKIP.match(stmt) or "$$BODY$$" in stmt or "set masking policy" in stmt.lower():
                skipped += 1
                continue
            if "ADMIN.V_" in stmt or "INFORMATION_SCHEMA" in stmt.upper() or "SNOWFLAKE.ACCOUNT_USAGE" in stmt.upper():
                skipped += 1                       # account monitoring: Snowflake-only system views
                continue
            try:
                con.execute(to_duckdb(stmt))
                ran += 1
            except Exception as e:  # noqa: BLE001
                failures.append((rel, stmt.split("\n")[0][:90], str(e).split("\n")[0][:160]))
    con.execute("use memory")
    return ran, skipped, failures


def load_seeds(con):
    import yaml  # noqa: F401
    for f in sorted((ROOT / "seeds").glob("*.csv")):
        table = {"mci_client": "MCI_CLIENT", "mci_client_identifier": "MCI_CLIENT_IDENTIFIER", "map_client_account": "MAP_CLIENT_ACCOUNT", "map_client_alias": "MAP_CLIENT_ALIAS", "map_media_type": "MAP_MEDIA_TYPE", "ctl_cutover": "CTL_CUTOVER",
                 "ctl_source_precedence": "CTL_SOURCE_PRECEDENCE", "dq_tolerances": "DQ_TOLERANCES",
                 "map_smart_campaign_rule": "MAP_SMART_CAMPAIGN_RULE", "map_smart_campaign_override": "MAP_SMART_CAMPAIGN_OVERRIDE",
                 "map_conversion_tag": "MAP_CONVERSION_TAG", "map_platform_account": "MAP_PLATFORM_ACCOUNT",
                 "dashboard_smart_campaigns": "DASHBOARD_SMART_CAMPAIGNS", "filter_rules": "FILTER_RULES",
                 "mon_schedule": "MON_SCHEDULE", "column_groups": "COLUMN_GROUPS",
                 "client_column_access": "CLIENT_COLUMN_ACCESS",
                 "ctl_archive_requests": "CTL_ARCHIVE_REQUESTS"}.get(f.stem)
        if not table:
            continue
        rows = list(csv.DictReader(open(f, newline="", encoding="utf-8")))
        if not rows:
            continue
        cols = list(rows[0].keys())
        con.executemany(f"insert into GOLD.CONTROL.{table} ({', '.join(cols)}) values ({', '.join('?' * len(cols))})",
                        [[r[c] if r[c] != "" else None for c in cols] for r in rows])


def load_history(con, path):
    rows = []
    with open(path, encoding="utf-8-sig", newline="") as fh:
        rd = csv.reader(fh)
        next(rd)
        for i, r in enumerate(rd, start=2):
            rows.append(r[:12] + ["history_" + Path(path).name, i])
    con.executemany("""insert into BRONZE.TAPCLICKS.TAPCLICKS_HISTORY (activity_date_text, data_source_name, campaign_name,
        media_buy_name, creative_name, conversion_tag_name, impressions, clicks, spend, starts, completed_plays,
        total_conversions, file_name, file_row_number) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""", rows)
    return rows


def refresh(con):
    """Dynamic tables are snapshots here: rebuild the chain after data or seeds change."""
    return run_sql(con)


def archive_steps():
    """The '-- step:' statements inside GOLD.ARCHIVE.RUN_ARCHIVE, exactly as deployed."""
    body = (ROOT / "snowflake" / "45_archive" / "archive.sql").read_text()
    return dict(re.findall(r"-- step: (\w+)\n(.*?);\n", body, re.S))


def run_step(con, sql, **v):
    for k, val in v.items():
        sql = re.sub(rf":{k}\b", f"'{val}'" if not isinstance(val, (int, float)) else str(val), sql)
    con.execute(to_duckdb(sql))


def test_archive(con, file_tot):
    """Archive one client, check the copy and that it left every live layer, then restore and check it is back."""
    steps = archive_steps()
    check("archive procedure has its five tested steps",
          set(steps) == {"copy_delivery", "copy_conversions", "compare_and_log", "mark_archived", "mark_restored"}, ", ".join(steps))
    pick = con.execute("""select m.client_code, any_value(m.client_name), count(*) n, sum(d.spend), max(d.activity_date)
                          from SILVER.STG.INT_AD_DELIVERY d
                          join GOLD.CONTROL.MAP_CLIENT_ACCOUNT m on lower(m.client_name) = lower(d.client_part)
                          group by 1 order by n desc limit 1""").fetchone()
    if not pick:
        check("a client to archive", False, "no client in the data matches the client list")
        return
    code, name, n_rows, c_spend, last_day = pick[0], pick[1], pick[2], float(pick[3] or 0), pick[4]
    before = str(last_day + __import__("datetime").timedelta(days=1))   # test: every row of the client is "old"
    bronze_before = con.execute("select count(*) from BRONZE.TAPCLICKS.TAPCLICKS_HISTORY").fetchone()[0]
    print(f"  client {code}: {n_rows} delivery rows, spend {c_spend:,.2f}, archived before {before}")

    # the 24-month guard: a request for today moves nothing newer than 24 months ago
    con.execute(f"""insert into GOLD.CONTROL.CTL_ARCHIVE_REQUESTS values ('{code}', 'archive', current_date, 'test', 'Mike DeOliveira', current_date, 'e2e')""")
    due = con.execute("""select cast(archive_before as date), cast(archive_before as date) <= cast(date_trunc('month', current_date)
                         - interval 24 month as date) from GOLD.ARCHIVE.V_ARCHIVE_DUE""").fetchone()
    check("a move never reaches data newer than 24 months", bool(due and due[1]), f"requested today, moves before {due[0] if due else '-'}")
    con.execute("update GOLD.CONTROL.CTL_ARCHIVE_REQUESTS set approved_by = null")
    check("no approval, no move", con.execute("select count(*) from GOLD.ARCHIVE.V_ARCHIVE_DUE").fetchone()[0] == 0)

    v = dict(v_batch="b-test-1", v_client=code, v_name=name, v_before=before)
    for s in ("copy_delivery", "copy_conversions", "compare_and_log"):
        run_step(con, steps[s], **v)
    log = con.execute("""select verified, source_rows, archived_rows, archived_spend from GOLD.ARCHIVE.ARCHIVE_LOG
                         where batch_id = 'b-test-1'""").fetchone()
    check("archived copy matches the source (rows, spend, impressions, conversions)", bool(log and log[0]),
          f"{log[1]} rows, spend {float(log[3]):,.2f}" if log else "no log row")
    # a copy that does not match must stop the move
    bad = dict(v, v_batch="b-test-bad")
    run_step(con, steps["copy_delivery"], **bad)
    run_step(con, steps["copy_conversions"], **bad)
    con.execute("delete from GOLD.ARCHIVE.AD_DELIVERY where batch_id = 'b-test-bad' and rowid = (select min(rowid) from GOLD.ARCHIVE.AD_DELIVERY where batch_id = 'b-test-bad')")
    run_step(con, steps["compare_and_log"], **bad)
    stopped = con.execute("select verified from GOLD.ARCHIVE.ARCHIVE_LOG where batch_id = 'b-test-bad'").fetchone()
    check("a copy missing one row is caught and the move stops", stopped is not None and stopped[0] is False)
    con.execute("delete from GOLD.ARCHIVE.AD_DELIVERY where batch_id = 'b-test-bad'")      # the procedure rolls back here
    con.execute("delete from GOLD.ARCHIVE.CONVERSIONS where batch_id = 'b-test-bad'")
    con.execute("delete from GOLD.ARCHIVE.ARCHIVE_LOG where batch_id = 'b-test-bad'")

    run_step(con, steps["mark_archived"], **v)
    refresh(con)
    sem = float(con.execute("select coalesce(sum(spend), 0) from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY").fetchone()[0])
    arc = float(con.execute("select coalesce(sum(spend), 0) from GOLD.ARCHIVE.AD_DELIVERY").fetchone()[0])
    check("archived client left Silver, Gold and the semantic view", abs(sem - (file_tot["spend"] - c_spend)) < 0.01,
          f"live {sem:,.2f} + archive {arc:,.2f} = file {file_tot['spend']:,.2f}")
    check("live plus archive still equals the file", abs(sem + arc - file_tot["spend"]) < 0.01)
    check("BRONZE untouched", con.execute("select count(*) from BRONZE.TAPCLICKS.TAPCLICKS_HISTORY").fetchone()[0] == bronze_before)
    check("archive check is clean while archived", con.execute("select count(*) from GOLD.CHECKS.DQ_ARCHIVE").fetchone()[0] == 0)

    run_step(con, steps["mark_restored"], **v)
    refresh(con)
    sem2 = float(con.execute("select coalesce(sum(spend), 0) from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY").fetchone()[0])
    check("restore brings the client back in full", abs(sem2 - file_tot["spend"]) < 0.01, f"{sem2:,.2f}")
    check("archive check is clean after the restore", con.execute("select count(*) from GOLD.CHECKS.DQ_ARCHIVE").fetchone()[0] == 0)
    check("archived copy kept after the restore", con.execute("select count(*) from GOLD.ARCHIVE.AD_DELIVERY").fetchone()[0] == n_rows)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tapclicks", required=True)
    a = ap.parse_args()
    con = duckdb.connect(":memory:")
    setup(con)
    print("1. Deploy the SQL (empty)")
    ran, skipped, fails = run_sql(con)
    print(f"  {ran} statements ran, {skipped} Snowflake-only skipped, {len(fails)} failed")
    for f in fails:
        print("   ", f)
    check("every portable statement runs", not fails)

    print("2. Load seeds and the TapClicks export into BRONZE, rebuild")
    load_seeds(con)
    raw = load_history(con, a.tapclicks)
    ran, skipped, fails2 = refresh(con)
    check("rebuild with data runs", not fails2, f"{len(fails2)} failures" if fails2 else "")
    for f in fails2[:10]:
        print("   ", f)

    def n(x):
        x = (x or "").replace(",", "").replace("$", "").replace("%", "").strip()
        try:
            return float(x)
        except ValueError:
            return 0.0
    file_tot = {"impressions": sum(n(r[6]) for r in raw if not r[5]), "clicks": sum(n(r[7]) for r in raw if not r[5]),
                "spend": sum(n(r[8]) for r in raw if not r[5]), "conversions": sum(n(r[11]) for r in raw if r[5]),
                "rows": len(raw)}
    print(f"3. Trace totals through every layer (file: {file_tot['rows']} rows)")
    layers = {
        "BRONZE": "select sum(try_cast(replace(impressions, ',', '') as double)), sum(try_cast(replace(clicks, ',', '') as double)), "
                  "sum(try_cast(replace(spend, ',', '') as double)) from BRONZE.TAPCLICKS.TAPCLICKS_HISTORY where coalesce(conversion_tag_name, '') = ''",
        "SILVER history": "select sum(impressions), sum(clicks), sum(spend) from SILVER.STG.STG_TAPCLICKS_HISTORY where conversion_tag_name is null",
        "SILVER combined": "select sum(impressions), sum(clicks), sum(spend) from SILVER.STG.INT_AD_DELIVERY",
        "GOLD fact": "select sum(impressions), sum(clicks), sum(spend) from GOLD.MARTS.FCT_AD_DELIVERY_DAILY",
        "SEMANTIC": "select sum(impressions), sum(clicks), sum(spend) from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY",
    }
    for name, q in layers.items():
        i, c, s = (float(v or 0) for v in con.execute(q).fetchone())
        ok = abs((i or 0) - file_tot["impressions"]) < 0.5 and abs((c or 0) - file_tot["clicks"]) < 0.5 and abs((s or 0) - file_tot["spend"]) < 0.01
        check(f"{name}: impressions, clicks, spend equal the file", ok, f"{i:,.0f} / {c:,.0f} / {s:,.2f}")
    conv = float(con.execute("select sum(platform_conversions) from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY").fetchone()[0] or 0)
    check("conversions equal the file", abs(conv - file_tot["conversions"]) < 0.01, f"{conv:,.2f} vs {file_tot['conversions']:,.2f}")

    print("4. Grain and keys")
    dup = con.execute("""select count(*) from (select date_key, source_key, campaign_key, media_buy_key, creative_key, count(*) n
                         from GOLD.MARTS.FCT_AD_DELIVERY_DAILY group by all having n > 1)""").fetchone()[0]
    check("delivery fact has one row per grain", dup == 0, f"{dup} duplicate keys")
    orphan = con.execute("""select count(*) from GOLD.MARTS.FCT_AD_DELIVERY_DAILY f
                            left join GOLD.MARTS.DIM_CAMPAIGN c using (campaign_key) where c.campaign_key is null""").fetchone()[0]
    check("every fact row has a campaign", orphan == 0, f"{orphan} orphans")
    dk = con.execute("""select count(*) from GOLD.MARTS.FCT_AD_DELIVERY_DAILY f left join GOLD.MARTS.DIM_DATE d using (date_key)
                        where d.date_key is null""").fetchone()[0]
    check("every fact row has a date", dk == 0)

    print("4b. Master Client Index")
    check("no identifier points to two clients", con.execute("select count(*) from GOLD.CHECKS.DQ_MCI_CONFLICTS").fetchone()[0] == 0)
    unres_fact = float(con.execute("select coalesce(sum(spend), 0) from GOLD.MARTS.FCT_AD_DELIVERY_DAILY where client_code is null").fetchone()[0])
    unres_dq = float(con.execute("select coalesce(sum(spend), 0) from GOLD.CHECKS.DQ_UNRESOLVED_CLIENTS").fetchone()[0])
    check("every row without a client is listed on the Data Checks page", abs(unres_fact - unres_dq) < 0.01,
          f"spend without a client {unres_fact:,.2f}")
    mism = con.execute("""select count(*) from GOLD.MARTS.FCT_AD_DELIVERY_DAILY f join GOLD.MARTS.DIM_CAMPAIGN c using (campaign_key)
                          where f.client_code is not null and c.client_code is not null and f.client_code <> c.client_code""").fetchone()[0]
    check("fact client and campaign client agree", mism == 0, f"{mism} rows differ")
    keyed = con.execute("""select count(*) from GOLD.MARTS.FCT_AD_DELIVERY_DAILY f left join GOLD.MARTS.DIM_CLIENT c using (client_key)
                           where f.client_key is not null and c.client_key is null""").fetchone()[0]
    check("every client_key on a fact exists in DIM_CLIENT", keyed == 0)
    for row in con.execute("""select matched_by, count(*) from SILVER.STG.MCI_CLIENT_RESOLUTION group by 1 order by 2 desc""").fetchall():
        print(f"  {row[1]:>6}  source/campaign keys resolved by {row[0]}")

    print("5. Per source: semantic layer vs file")
    by_src_file = {}
    for r in raw:
        if not r[5]:
            by_src_file[r[1]] = by_src_file.get(r[1], 0) + n(r[8])
    by_src = dict((k, float(v or 0)) for k, v in con.execute("""select source_name, sum(spend) from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY
                                 where row_type = 'delivery' group by 1""").fetchall())
    bad = [s for s in by_src_file if abs(by_src.get(s, 0) - by_src_file[s]) > 0.01]
    check(f"spend matches for each of {len(by_src_file)} sources", not bad, ", ".join(bad))

    print("6. Mapping and quality views")
    for q, label in (("select count(*) from GOLD.MARTS.DIM_CAMPAIGN", "campaigns"),
                     ("select count(*) from GOLD.MARTS.DIM_CAMPAIGN where smart_campaign = 'Unmapped'", "campaigns without a Smart Campaign (rules not yet approved)"),
                     ("select count(*) from GOLD.MARTS.DIM_CAMPAIGN where not campaign_name_valid", "campaign names off the convention"),
                     ("select count(*) from GOLD.MARTS.DIM_CAMPAIGN where client_code is null", "campaigns with no client"),
                     ("select count(*) from GOLD.MARTS.DIM_MEDIA_BUY where media_type = 'Unclassified'", "media buys with unknown media type"),
                     ("select count(*) from GOLD.CHECKS.DQ_SOURCE_OVERLAP", "source overlaps after precedence"),
                     ("select count(*) from GOLD.CHECKS.DQ_IMPOSSIBLE_VALUES", "impossible values"),
                     ("select count(*) from GOLD.CHECKS.DQ_VCR", "VCR over 100%")):
        try:
            print(f"  {con.execute(q).fetchone()[0]:>6}  {label}")
        except Exception as e:  # noqa: BLE001
            check(label, False, str(e)[:120])

    print("7. KPIs from the semantic layer (production formulas)")
    sys.path.insert(0, str(ROOT / "scripts"))
    import semantic_harness as h
    import yaml
    k_ok = k_fail = 0
    for k in yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]:
        if "expr" not in k:
            continue
        try:
            con.execute(f"select {h.kpi_sql(k['expr'])} from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY").fetchone()
            k_ok += 1
        except Exception as e:  # noqa: BLE001
            k_fail += 1
            print("   ", k["name"], str(e).split("\n")[0][:120])
    check("every KPI formula runs on the deployed semantic view", k_fail == 0, f"{k_ok} ran")
    tot = [float(v) for v in con.execute("""select sum(spend) / nullif(sum(impressions), 0) * 1000, sum(clicks) / nullif(sum(impressions), 0)
                         from GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY""").fetchone()]
    exp = (file_tot["spend"] / file_tot["impressions"] * 1000, file_tot["clicks"] / file_tot["impressions"])
    check("CPM and CTR equal the file's totals", abs(tot[0] - exp[0]) < 1e-6 and abs(tot[1] - exp[1]) < 1e-9,
          f"CPM {tot[0]:.4f}, CTR {tot[1]:.5f}")

    print("8. Archive and restore a former client (A12)")
    test_archive(con, file_tot)

    failed = [r for r in RESULTS if not r[1]]
    print(f"\n{len(RESULTS) - len(failed)} of {len(RESULTS)} checks passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
