"""Static checks that the setup scripts meet the Boolean Snowflake Kickstart Checklist v1.0.
These read the SQL only; the live check after deploy is GOLD.ADMIN.CHECK_WAREHOUSE_STANDARD()."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ACCOUNT = (ROOT / "snowflake" / "00_setup" / "01_account.sql").read_text().lower()
GRANTS = (ROOT / "snowflake" / "00_setup" / "03_grants.sql").read_text().lower()
MONITOR = (ROOT / "snowflake" / "00_setup" / "04_monitoring.sql").read_text().lower()
PIPE = (ROOT / "snowflake" / "70_tasks" / "pipeline_monitoring.sql").read_text().lower()
ALL_SQL = "\n".join(p.read_text().lower() for p in (ROOT / "snowflake").rglob("*.sql"))

WAREHOUSES = {"wh_load": "xsmall", "wh_transformation": "small", "wh_adhoc": "xsmall", "wh_reporting": "xsmall", "wh_history": "small"}


def wh_create(name):
    m = re.search(rf"create warehouse if not exists {name}\b(.*?);", ACCOUNT, re.S)
    assert m, f"{name} not created"
    return m.group(1)


def test_checklist_warehouses_sizes_and_settings():
    for name, size in WAREHOUSES.items():
        body = wh_create(name)
        assert f"warehouse_size = {size}" in body, name
        assert "auto_suspend = 60" in body and "auto_resume = true" in body, name
        timeout = "3600" if name == "wh_history" else "300"
        assert f"statement_timeout_in_seconds = {timeout}" in body, name


def test_medallion_databases():
    for db in ("bronze", "silver", "gold"):
        assert f"create database if not exists {db}" in ACCOUNT


def test_roles_and_service_accounts():
    for role in ("epitaph_developer", "epitaph_reader", "epitaph_loader", "epitaph_transformer", "epitaph_reporter"):
        assert f"create role if not exists {role}" in ACCOUNT
    for user, wh in (("svc_loader", "wh_load"), ("svc_transformer", "wh_transformation"), ("svc_reporter", "wh_reporting")):
        m = re.search(rf"create user if not exists {user} (.*?);", ACCOUNT, re.S)
        assert m and "type = service" in m.group(1) and f"default_warehouse = {wh}" in m.group(1), user


def test_reader_is_gold_only_and_future_grants_exist():
    reader = [l for l in GRANTS.splitlines() if "to role epitaph_reader" in l and l.startswith("grant")]
    assert reader and all(("gold" in l) or ("warehouse" in l) for l in reader)
    assert "future tables in database bronze" in GRANTS and "future tables in database gold" in GRANTS


def test_resource_monitors_alert_80_suspend_100():
    for rm in ("rm_epitaph_account", "rm_wh_load", "rm_wh_transformation", "rm_wh_adhoc"):
        m = re.search(rf"create or replace resource monitor {rm} (.*?);", MONITOR, re.S)
        assert m, rm
        assert "on 80 percent do notify" in m.group(1) and "on 100 percent do suspend" in m.group(1), rm
        assert "notify_users = (dl_epitaph_data_alerts)" in m.group(1), rm
    assert "alter account set resource_monitor = rm_epitaph_account" in MONITOR


def test_monitoring_views():
    for v in ("v_login_history", "v_query_history_top", "v_credits_daily"):
        assert f"create or replace view gold.admin.{v}" in MONITOR


def test_one_alert_per_stage_and_freshness():
    for a in ("a_source_to_bronze", "a_bronze_to_silver", "a_silver_to_gold", "a_gold_to_downstream", "a_data_freshness"):
        assert f"create or replace alert gold.admin.{a}" in PIPE
        assert f"alter alert gold.admin.{a} resume" in PIPE


def test_every_warehouse_used_has_a_monitor():
    used = set(re.findall(r"warehouse = (wh_\w+)", ALL_SQL))
    for wh in used:
        assert re.search(rf"alter warehouse {wh}\s+set resource_monitor", MONITOR), wh


def test_reporter_reads_semantic_views_not_marts():
    """Omni must not bypass the row access policy on the semantic views by reading the marts."""
    sql = (ROOT / "snowflake" / "00_setup" / "03_grants.sql").read_text().lower()
    assert "schema gold.marts to role epitaph_reporter" not in sql
    assert "in schema gold.marts to role epitaph_reporter" not in sql


def test_archive_is_admin_only_and_never_deletes():
    grants = (ROOT / "snowflake" / "00_setup" / "03_grants.sql").read_text()
    assert "revoke usage on schema GOLD.ARCHIVE from role EPITAPH_READER" in grants
    assert "grant select on future tables in schema GOLD.ARCHIVE to role EPITAPH_ADMIN" in grants
    assert "GOLD.ARCHIVE to role EPITAPH_REPORTER" not in grants
    sql = (ROOT / "snowflake" / "45_archive" / "archive.sql").read_text().lower()
    assert "delete from" not in sql and "truncate" not in sql and "drop table" not in sql
    assert "bronze." not in sql.split("$$")[1]          # the move never touches BRONZE
    assert "if (v_ok) then" in sql and "rollback;" in sql   # nothing is hidden unless the copy matched
    assert "dateadd(month, -24" in sql                  # never newer than 24 months
    assert "45_archive/archive.sql" in (ROOT / "snowflake" / "deploy_order.txt").read_text()
