"""Every seed CSV loads as written: each row has as many fields as the header (an unquoted comma in a note adds a
field and makes scripts/load_seeds.py fail on insert)."""
import csv
from pathlib import Path

import pytest

SEEDS = sorted((Path(__file__).resolve().parents[1] / "seeds").glob("*.csv"))


@pytest.mark.parametrize("path", SEEDS, ids=lambda p: p.name)
def test_rows_match_header(path):
    rows = list(csv.reader(open(path, encoding="utf-8", newline="")))
    width = len(rows[0])
    bad = [n for n, r in enumerate(rows[1:], start=2) if r and len(r) != width]
    assert not bad, f"{path.name}: lines {bad} do not have {width} fields"
