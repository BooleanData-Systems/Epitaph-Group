"""DIM_CAMPAIGN matches Smart Campaign overrides on the name with whitespace collapsed.

TapClicks exports Instagram boosted-post names with Windows line breaks (CR LF); Facebook sends LF only. With an exact
match those campaigns stayed Unmapped, so D053 showed posts that belong to 'Nulo: Non Epitaph Data'."""
import re
import sys
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from e2e_local import to_duckdb  # noqa: E402

DIMS = (ROOT / "snowflake" / "40_marts" / "dims.sql").read_text(encoding="utf-8")
KEY = "regexp_replace(trim({}), '[[:space:]]+', ' ')"


def test_override_join_uses_collapsed_names():
    assert "left join overrides o on o.name_key = " + KEY.format("c.campaign_name") in DIMS
    assert KEY.format("campaign_name") + " as name_key" in DIMS
    assert not re.search(r"MAP_SMART_CAMPAIGN_OVERRIDE o on o\.campaign_name = c\.campaign_name", DIMS)


def test_line_breaks_and_double_spaces_match():
    tapclicks = "Instagram post: Game faces on!\r\n\r\nPaisley, Sookie..."
    facebook = "Instagram post: Game faces on!\n\nPaisley,  Sookie...  "
    con = duckdb.connect()
    sql = to_duckdb(f"select {KEY.format('a')} = {KEY.format('b')} as same, {KEY.format('a')} as k from (select ? as a, ? as b)")
    same, key = con.execute(sql, [tapclicks, facebook]).fetchone()
    assert same and key == "Instagram post: Game faces on! Paisley, Sookie..."
