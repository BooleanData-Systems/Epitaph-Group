import datetime as dt
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import fx_loader  # noqa: E402

SAMPLE = {"observations": [
    {"d": "2026-10-01", "FXUSDCAD": {"v": "1.3712"}},
    {"d": "2026-10-02", "FXUSDCAD": {"v": "1.3740"}},
    {"d": "2026-10-05", "FXUSDCAD": {}},          # missing value is skipped
]}


def test_parse_observations():
    rows = fx_loader.parse_observations(SAMPLE, "FXUSDCAD")
    assert rows == [("FXUSDCAD", dt.date(2026, 10, 1), 1.3712), ("FXUSDCAD", dt.date(2026, 10, 2), 1.374)]


def test_fetch_builds_request():
    seen = {}

    def fake_get(url, params):
        seen["url"], seen["params"] = url, params
        return SAMPLE

    rows = fx_loader.fetch("FXUSDCAD", dt.date(2026, 9, 21), get=fake_get)
    assert seen["url"].endswith("/valet/observations/FXUSDCAD/json")
    assert seen["params"] == {"start_date": "2026-09-21"}
    assert len(rows) == 2
