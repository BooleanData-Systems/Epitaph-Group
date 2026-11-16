"""specs/data_mapping.csv must match the SQL: every field it names in Bronze, Silver and Gold exists in the code."""
import csv
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROWS = list(csv.DictReader(open(ROOT / "specs" / "data_mapping.csv", newline="", encoding="utf-8")))
SQL = {p.name: p.read_text().lower() for p in (ROOT / "snowflake").rglob("*.sql")}
STAGING = "\n".join(v for k, v in SQL.items() if k.startswith("stg_") or k.startswith("mci_"))
GOLD = SQL["facts.sql"] + SQL["dims.sql"]
SIMPLE = re.compile(r"^[a-z_0-9]+$")


def test_csv_is_current():
    before = (ROOT / "specs" / "data_mapping.csv").read_text()
    subprocess.run([sys.executable, str(ROOT / "scripts" / "build_data_mapping.py")], check=True, capture_output=True)
    assert (ROOT / "specs" / "data_mapping.csv").read_text() == before, "run scripts/build_data_mapping.py"


def test_ids_unique_and_fields_present():
    assert len({r["map_id"] for r in ROWS}) == len(ROWS)
    for r in ROWS:
        assert r["source"] and r["source_field"] and r["rule"], r["map_id"]
        assert r["status"] in ("built", "planned"), r["map_id"]


def test_sharepoint_fields_are_read_by_staging():
    for r in ROWS:
        f = r["bronze_field"].lower()
        if f.startswith("record:") and SIMPLE.match(f[7:]):
            assert f in STAGING, f"{r['map_id']}: {f} not read by any staging view"


def test_silver_fields_exist():
    for r in ROWS:
        f = r["silver_field"].lower()
        if r["silver_object"] and SIMPLE.match(f):
            assert re.search(rf"\b{f}\b", STAGING + SQL["dims.sql"]), f"{r['map_id']}: Silver field {f} not in the SQL"


def test_gold_fields_exist():
    for r in ROWS:
        f = r["gold_field"].lower()
        if r["gold_object"] and SIMPLE.match(f):
            body = GOLD[GOLD.index(r["gold_object"].lower()):]
            assert re.search(rf"\b{f}\b", body), f"{r['map_id']}: {r['gold_object']}.{f} not in the Gold SQL"
