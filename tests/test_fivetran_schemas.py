"""Fivetran schema names live in one place, config/connectors.yml. Everything that names a connector schema must agree.

Fivetran sets a connector's destination schema when the connector is created and it cannot be renamed later, so the
code follows Fivetran. If a real schema differs, change it in connectors.yml and these tests list what else to change.
"""
import csv
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import check_fivetran_schema  # noqa: E402

CONNECTORS = yaml.safe_load(open(ROOT / "config" / "connectors.yml"))["connectors"]
SCHEMAS = {c["schema"] for c in CONNECTORS}
# BRONZE schemas created by this repo (loaders), never by Fivetran
OWN_SCHEMAS = {"LOADER", "SHAREPOINT", "REFERENCE", "TAPCLICKS", "PUBLIC", "INFORMATION_SCHEMA"}
STAGING = ROOT / "snowflake" / "30_staging"


def test_schema_names_are_unique_upper_case_and_not_ours():
    assert len(SCHEMAS) == len(CONNECTORS)
    for s in SCHEMAS:
        assert re.fullmatch(r"[A-Z][A-Z0-9_]*", s), s
    assert not SCHEMAS & OWN_SCHEMAS


def test_staging_views_read_only_connector_schemas():
    for f in STAGING.glob("*.sql"):
        for schema in re.findall(r"\bBRONZE\.(\w+)\.\w+", f.read_text(), re.I):
            assert schema.upper() in SCHEMAS | OWN_SCHEMAS, f"{f.name} reads BRONZE.{schema}, not in connectors.yml"


def test_requires_header_names_a_connector_schema_and_has_a_stub():
    seen = set()
    for f in STAGING.glob("*.sql"):
        m = re.search(r"^-- requires: BRONZE\.(\w+)\s*$", f.read_text(), re.M)
        if not m:
            continue
        assert m.group(1) in SCHEMAS, f"{f.name}: requires BRONZE.{m.group(1)}, not in connectors.yml"
        assert (STAGING / "stubs" / f.name).exists(), f"{f.name} has no stub"
        seen.add(m.group(1))
    staged = {c["schema"] for c in CONNECTORS if str(c.get("staging", "")).startswith("STG_")}
    assert staged <= seen, f"connectors with a staging view but no requires header: {sorted(staged - seen)}"


def test_staging_view_named_in_connectors_exists():
    for c in CONNECTORS:
        if str(c.get("staging", "")).startswith("STG_"):
            assert (STAGING / f"{c['staging'].lower()}.sql").exists(), c["staging"]


def test_mon_schedule_watches_every_connector_schema():
    rows = list(csv.DictReader(open(ROOT / "seeds" / "mon_schedule.csv", encoding="utf-8")))
    watched = {r["job_name"] for r in rows if r["kind"] == "fivetran"}
    assert watched == SCHEMAS


def test_no_fivetran_prefix_left():
    # _fivetran_synced is a column Fivetran adds, not a schema
    pattern = re.compile(r"BRONZE\.FIVETRAN_", re.I)
    for f in list(STAGING.rglob("*.sql")) + [ROOT / "scripts" / "build_data_mapping.py", ROOT / "specs" / "data_mapping.csv"]:
        assert not pattern.search(f.read_text(encoding="utf-8")), f"{f.relative_to(ROOT)} still names a FIVETRAN_ schema"


def test_schema_checker_finds_staging_tables():
    want = check_fivetran_schema.expected_columns()
    assert {s for s, _ in want} <= SCHEMAS
    assert ("GOOGLE_ADS", "AD_STATS") in want
    assert ("TIKTOK_ADS", "AD_REPORT_DAILY") in want
