"""Per-client column access: a client override beats the default, identity is always shown, internal never."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import omni_access as sa  # noqa: E402

RULES = {("*", "spend"): "show", ("*", "internal"): "hide", ("C08", "spend"): "hide"}


def test_client_override_beats_default():
    assert sa.access(RULES, "C08", "spend") == "hide"
    assert sa.access(RULES, "C01", "spend") == "show"


def test_identity_always_shown_and_unknown_hidden():
    assert sa.access(RULES, "C01", "identity") == "show"
    assert sa.access(RULES, "C01", "something_new") == "hide"


def test_seeded_defaults_hide_internal_from_every_client():
    clients, groups, rules = sa.load()
    assert "internal" in groups
    assert all(sa.access(rules, code, "internal") == "hide" for code in clients)


def test_attributes_follow_the_seed_and_staff_see_everything():
    rules = {("*", "spend"): "show", ("*", "internal"): "hide", ("C08", "spend"): "hide"}
    groups = ["identity", "spend", "internal"]
    assert sa.attributes(rules, groups, "C08") == {"client_code": "C08", "cg_spend": "no", "cg_internal": "no"}
    assert sa.attributes(rules, groups, "C01")["cg_spend"] == "yes"
    assert sa.attributes(rules, groups, "ALL") == {"client_code": "ALL", "cg_spend": "yes", "cg_internal": "yes"}
