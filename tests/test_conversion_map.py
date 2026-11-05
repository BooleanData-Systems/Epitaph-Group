"""The conversion mapping holds Nathan's T01 to T11 answers (2 Nov 2026)."""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROWS = list(csv.DictReader(open(ROOT / "seeds" / "map_conversion_tag.csv", newline="", encoding="utf-8")))
CLIENTS = {r["client_code"] for r in csv.DictReader(open(ROOT / "seeds" / "map_client_account.csv"))}


def test_every_row_is_valid():
    for r in ROWS:
        assert r["client_code"] in CLIENTS, r
        assert r["counts_toward_kpi"] in ("true", "false"), r
        assert r["tag_name"].strip() and r["platform"].strip() and r["approved_by"].strip(), r


def test_no_duplicate_keys():
    keys = [(r["client_code"], r["platform"], r["tag_name"].lower(), r["valid_from"]) for r in ROWS]
    assert len(keys) == len(set(keys))


def test_answers_applied():
    def counted(client, group):
        return {r["counts_toward_kpi"] for r in ROWS if r["client_code"] == client and r["kpi_group"] == group}
    assert counted("C08", "find_a_retailer") == {"true"} and counted("C08", "shop_now") == {"false"}   # T06
    assert counted("C07", "apple_app_store") == {"false"}                                               # T05
    assert counted("C13", "lead") == {"false"} and counted("C13", "order") == {"true"}                  # T10
    assert counted("C06", "order") == {"true"} and counted("C06", "cart_start") == {"false"}            # T04
    assert counted("C05", "amazon_application") == {"true"}                                             # T03
    assert not [r for r in ROWS if r["client_code"] in ("C01", "C02")]                                  # T11: none needed
