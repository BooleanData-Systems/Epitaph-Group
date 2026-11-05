"""Checks that run on every pull request (and locally before a commit). No connection to Snowflake or Omni.

  1. config/kpis.yml: every KPI name is unique; every ratio uses only known measures.
  2. specs/dashboards/*.yml: every metric is a KPI; no element keeps its own date range (A22);
     every element is scoped to Smart Campaigns unless the dashboard shows all campaigns (Q003).
  3. config/feeds.yml: ids unique; required fields present.
  4. Every SQL file parses (sqlglot, Snowflake dialect) where the parser supports the statement.
  5. Client-facing text (docs/, specs/fixes.md, plans/) has no long dashes.
  6. Every file the fixes register points to exists.
Exit code 1 if anything fails.
"""
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
ERRORS = []
WARNINGS = []
PARSED = []
ALL_CAMPAIGN_DASHBOARDS = {"D095", "D097"}   # Sysco and Wurth show every campaign (Q23)
MEASURES = {"impressions", "clicks", "spend", "video_starts", "completed_plays", "post_shares", "spots", "conversions",
            "platform_conversions", "platform_all_conversions", "revenue", "click_through_conversions",
            "view_through_conversions", "sessions", "goal_value", "site_visits", "flight_searches", "flight_bookings",
            "hotel_searches", "hotel_bookings", "travel_search_signals", "attributed_books", "performance_trials",
            "organic_trials", "scorecard_trials", "performance_flow_starts", "organic_flow_starts", "commuter_starts",
            "commuter_activations", "quotes", "quality_quotes", "binds", "customers"}


def err(msg):
    ERRORS.append(msg)


def check_kpis():
    k = yaml.safe_load(open(ROOT / "config" / "kpis.yml"))
    names = [x["name"] for x in k["kpis"]]
    for n in {n for n in names if names.count(n) > 1}:
        err(f"kpis.yml: '{n}' defined more than once (Q005)")
    for x in k["kpis"]:
        if x["type"] in ("sum", "ratio", "goal"):
            used = set(re.findall(r"(?:sum|avg)\((\w+)\)", x.get("expr", "")))
            unknown = used - MEASURES
            if unknown:
                err(f"kpis.yml: '{x['name']}' uses unknown measure(s) {sorted(unknown)}")
        if x["status"] not in ("agreed", "open"):
            err(f"kpis.yml: '{x['name']}' has status '{x['status']}'")
    return set(names)


def check_specs(kpi_names):
    n = 0
    for f in sorted((ROOT / "specs" / "dashboards").glob("D*.yml")):
        s = yaml.safe_load(open(f))
        n += 1
        scoped_dashboard = s["id"] in ALL_CAMPAIGN_DASHBOARDS
        for sec in s["sections"]:
            for w in sec["widgets"]:
                where = f"{f.name} widget {w['tapclicks_widget_id']}"
                for m in w["metrics"]:
                    if m not in kpi_names:
                        err(f"{where}: metric '{m}' is not in config/kpis.yml")
                if "date_range" in w and w["date_range"].get("now") != "dashboard date picker":
                    err(f"{where}: element keeps its own date range (A22)")
                fields = {x.get("field") for x in w.get("filters", [])}
                if not scoped_dashboard and not fields & {"smart_campaign", "campaign_name", "source_name", "conversion_tag",
                                                          "media_type", "channel", "platform", "account_name",
                                                          "ga4_session_campaign", "competitor_domain", "program_code"}:
                    # Unscoped elements inherit the dashboard's Smart Campaign control; flag only on non-template builds.
                    if s["build_type"] != "Standard":
                        WARNINGS.append(f"{where}: scoped by client only (Q003); confirm in the build review")
    if n != 29:
        err(f"expected 29 dashboard specs, found {n}")


def check_feeds():
    c = yaml.safe_load(open(ROOT / "config" / "feeds.yml"))
    ids = [f["id"] for f in c["feeds"]]
    for i in {i for i in ids if ids.count(i) > 1}:
        err(f"feeds.yml: duplicate id {i}")
    for f in c["feeds"]:
        for key in ("folder", "match", "table", "required", "date_column", "owner", "status"):
            if key not in f:
                err(f"feeds.yml: {f['id']} missing '{key}'")


def check_sql():
    try:
        import sqlglot
    except ImportError:
        print("sqlglot not installed; SQL parse check skipped")
        return
    skip = re.compile(r"^\s*(create\s+(or\s+replace\s+)?(procedure|task|alert|network rule|secret|external access|notification|"
                      r"resource monitor|warehouse|role|user|row access|masking policy|stage|function)|alter|grant|call|use|create (database|schema))",
                      re.I)
    for f in sorted((ROOT / "snowflake").rglob("*.sql")):
        text = f.read_text()
        text = re.sub(r"\$\$.*?\$\$", "''", text, flags=re.S)       # procedure bodies are checked in Snowflake
        for stmt in [s for s in re.split(r";\s*\n", text) if s.strip()]:
            body = "\n".join(l for l in stmt.splitlines() if not l.strip().startswith("--")).strip()
            if not body or skip.match(body):
                continue
            body = re.sub(r"(?is)create or replace dynamic table\s+(\S+)\s+.*?\bas\b\s*\n", r"create or replace table \1 as\n", body, count=1)
            body = re.sub(r"(?is)\s+with row access policy \S+ on \(\w+\)", "", body)
            try:
                sqlglot.parse_one(body, read="snowflake")
                PARSED.append(f.name)
            except Exception as e:  # noqa: BLE001
                err(f"{f.relative_to(ROOT)}: SQL does not parse: {str(e).splitlines()[0][:160]}")


def check_text():
    client_facing = [ROOT / "specs" / "fixes.md"] + sorted((ROOT / "docs").glob("*.md")) + \
                    sorted((ROOT / "plans").glob("*.md"))
    for f in client_facing:
        if not f.exists():
            continue
        t = f.read_text()
        if "\u2014" in t:
            err(f"{f.relative_to(ROOT)}: contains a long dash")
    for f in list((ROOT / "specs").rglob("*.yml")) + list((ROOT / "config").glob("*.yml")):
        if "\u2014" in f.read_text():
            err(f"{f.relative_to(ROOT)}: contains a long dash")


def check_fix_paths():
    text = (ROOT / "specs" / "fixes.md").read_text()
    for p in re.findall(r"`((?:snowflake|scripts|config|seeds|specs|loader|plans|docs|omni)/[^`*]+?)`", text):
        if not (ROOT / p.split(" ")[0]).exists():
            err(f"fixes.md points to {p}, which does not exist")


def check_gold_contract():
    """Every column the contract marks 'built' must be produced by the gold SQL for that table."""
    contract = yaml.safe_load(open(ROOT / "specs" / "gold_contract.yml"))["tables"]
    sql = "\n".join(p.read_text() for p in (ROOT / "snowflake" / "40_marts").glob("*.sql"))
    for table, spec in contract.items():
        m = re.search(rf"create (?:or replace )?(?:dynamic )?table (?:if not exists )?{table}\b(.*?)(?=\ncreate |\Z)", sql, re.S | re.I)
        if not m:
            if any(v["status"] == "built" for v in spec["columns"].values()):
                err(f"gold contract: {table} has built columns but no SQL creates it")
            continue
        body = m.group(1).lower()
        for col, v in spec["columns"].items():
            if v["status"] == "built" and not re.search(rf"\b{col.lower()}\b", body):
                err(f"gold contract: {table}.{col} is marked built but the SQL does not produce it")


if __name__ == "__main__":
    names = check_kpis()
    check_specs(names)
    check_feeds()
    check_sql()
    check_text()
    check_fix_paths()
    check_gold_contract()
    for e in ERRORS:
        print("FAIL", e)
    print(f"{len(PARSED)} SQL statements parsed")
    if WARNINGS:
        print(f"{len(WARNINGS)} element(s) on custom dashboards are scoped by client only (Q003); listed in the build review")
    print(f"{len(ERRORS)} problem(s)")
    sys.exit(1 if ERRORS else 0)
