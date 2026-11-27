"""deploy_snowflake.sh --plan: lists what a deploy would run and stops before any call to Snowflake.

The plan is computed by the same helpers as the real deploy, so these checks cover the changed-only rules. The
connection name is set to one that does not exist, so even a mistake here cannot reach Snowflake.
"""
import os
import shutil
import subprocess
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "deploy_snowflake.sh"
BASH = shutil.which("bash")
pytestmark = pytest.mark.skipif(BASH is None, reason="bash not available")


def plan(*args):
    env = dict(os.environ, SNOW_CONNECTION="__no_such_connection__")
    r = subprocess.run([BASH, str(SCRIPT), "--plan", *args], cwd=ROOT, env=env, capture_output=True, text=True)
    return r.returncode, r.stdout


def deploy_order():
    lines = (ROOT / "snowflake" / "deploy_order.txt").read_text().splitlines()
    return [l.strip() for l in lines if l.strip() and not l.startswith("#")]


def test_full_plan_lists_every_file_in_order_and_all_seeds():
    code, out = plan()
    assert code == 0
    listed = [l.strip() for l in out.splitlines() if l.startswith("   ") and l.strip().endswith(".sql")]
    assert listed == deploy_order()
    assert "Seeds: all" in out
    for f in ("loader/sharepoint_loader.py", "loader/fx_loader.py", "config/feeds.yml"):
        assert f in out


def test_unknown_commit_falls_back_to_full():
    code, out = plan("--changed-since", "0" * 40)
    assert code == 0
    assert "deploying everything" in out and "Seeds: all" in out


def test_no_change_plans_nothing():
    code, out = plan("--changed-since", "HEAD", "--to", "HEAD")
    assert code == 0
    assert not [l for l in out.splitlines() if l.startswith("   ")]
    assert "Seeds: none" in out
