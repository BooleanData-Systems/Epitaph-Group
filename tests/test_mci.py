"""Master Client Index seeds: one golden record per client, and every identifier points to exactly one of them."""
import csv
import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
ID_TYPES = {"campaign_prefix", "campaign_token", "sharepoint_feed", "ga4_property", "platform_account"}


def rows(name):
    return list(csv.DictReader(open(ROOT / "seeds" / name, newline="", encoding="utf-8")))


def norm(v):
    return re.sub(r"[^a-z0-9]+", " ", v.lower()).strip()


CLIENTS = rows("mci_client.csv")
IDS = rows("mci_client_identifier.csv")
CODES = {c["client_code"] for c in CLIENTS}


def test_one_record_per_client():
    codes = [c["client_code"] for c in CLIENTS]
    names = [c["client_name"].lower() for c in CLIENTS]
    assert len(codes) == len(set(codes)), "client_code repeated"
    assert len(names) == len(set(names)), "client_name repeated"
    for c in CLIENTS:
        assert re.fullmatch(r"C\d{2}", c["client_code"]), c
        assert c["reporting_currency"] in ("CAD", "USD"), c
        assert c["status"] in ("active", "paused", "former"), c
        assert c["effective_from"] <= c["effective_to"], c
        assert c["steward"] == "Nathan Sennema", "Nathan is the single point of contact and steward"


def test_mci_agrees_with_the_tapclicks_account_list():
    accounts = rows("map_client_account.csv")
    by_code = {c["client_code"]: c for c in CLIENTS}
    for a in accounts:
        c = by_code.get(a["client_code"])
        assert c, f"{a['client_code']} in map_client_account.csv but not in the MCI"
        assert c["client_name"] == a["client_name"], a
        assert c["reporting_currency"] == a["reporting_currency"], a
    assert CODES == {a["client_code"] for a in accounts}, "every MCI client has at least one TapClicks account"


def test_aliases_name_an_mci_client():
    names = {c["client_name"] for c in CLIENTS}
    for a in rows("map_client_alias.csv"):
        assert a["client_name"] in names, a


def test_identifiers_are_valid():
    feeds = {f["id"] for f in yaml.safe_load(open(ROOT / "config" / "feeds.yml"))["feeds"]}
    for i in IDS:
        assert i["client_code"] in CODES, i
        assert i["id_type"] in ID_TYPES, i
        assert i["status"] in ("approved", "proposed"), i
        assert i["valid_from"] <= i["valid_to"], i
        if i["status"] == "approved":
            assert i["approved_by"], f"approved identifier without an approver: {i}"
        if i["id_type"] == "sharepoint_feed":
            assert i["id_value"] in feeds, f"feed {i['id_value']} not in config/feeds.yml"


def test_no_identifier_points_to_two_clients():
    seen = {}
    every = [(i["id_type"], i["system"], norm(i["id_value"]), i["client_code"]) for i in IDS if i["status"] == "approved"]
    every += [("alias", "*", norm(a["alias"]), next(c["client_code"] for c in CLIENTS if c["client_name"] == a["client_name"]))
              for a in rows("map_client_alias.csv")]
    every += [("alias", "*", norm(c["client_name"]), c["client_code"]) for c in CLIENTS]
    every += [("campaign_prefix", "*", norm(c["client_name"]), c["client_code"]) for c in CLIENTS]
    for t, s, v, code in every:
        assert seen.setdefault((t, s, v), code) == code, f"{t} '{v}' points to {seen[(t, s, v)]} and {code}"


def test_single_client_feeds_are_in_the_index():
    """The Sonnet, SiriusXM and Adara files carry no client column: the MCI must name their client."""
    feed_ids = {i["id_value"] for i in IDS if i["id_type"] == "sharepoint_feed" and i["status"] == "approved"}
    for f in ("F01a", "F01b", "F01c", "F01d", "F02", "F03", "F05a", "F05f", "F06", "F07a", "F07e", "F08", "F14", "F15"):
        assert f in feed_ids, f


def test_no_client_named_in_sql():
    """Clients come from the MCI; a client code or name written into a view would bypass it."""
    sql = "\n".join(p.read_text() for p in (ROOT / "snowflake").rglob("*.sql") if "00_setup" not in p.parts)
    assert not re.search(r"'C\d{2}'\s+as\s+client_code", sql, re.I)
    assert "where client_name = '" not in sql
    for name in ("Cobs Bread", "Sonnet Insurance"):
        assert f"'{name}'," not in sql, f"'{name}' written into SQL"
