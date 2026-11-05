"""Load the seed CSVs into GOLD.CONTROL. The CSVs in /seeds are the source of truth: a change is a pull request,
reviewed like code, and this script replaces the table contents on deploy. Prints table names and row counts only.

Runs in CI with the deploy key (env SNOWFLAKE_ACCOUNT, SNOWFLAKE_USER, SNOWFLAKE_PRIVATE_KEY_PATH).
    python scripts/load_seeds.py            # all seeds
    python scripts/load_seeds.py --dry-run  # check files and columns, no connection
"""
import argparse
import csv
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SEEDS = {   # file -> table
    "map_client_account.csv": "GOLD.CONTROL.MAP_CLIENT_ACCOUNT",
    "map_client_alias.csv": "GOLD.CONTROL.MAP_CLIENT_ALIAS",
    "map_media_type.csv": "GOLD.CONTROL.MAP_MEDIA_TYPE",
    "dashboard_smart_campaigns.csv": "GOLD.CONTROL.DASHBOARD_SMART_CAMPAIGNS",
    "filter_rules.csv": "GOLD.CONTROL.FILTER_RULES",
    "ctl_source_precedence.csv": "GOLD.CONTROL.CTL_SOURCE_PRECEDENCE",
    "ctl_cutover.csv": "GOLD.CONTROL.CTL_CUTOVER",
    "dq_tolerances.csv": "GOLD.CONTROL.DQ_TOLERANCES",
    "map_smart_campaign_rule.csv": "GOLD.CONTROL.MAP_SMART_CAMPAIGN_RULE",
    "map_smart_campaign_override.csv": "GOLD.CONTROL.MAP_SMART_CAMPAIGN_OVERRIDE",
    "map_conversion_tag.csv": "GOLD.CONTROL.MAP_CONVERSION_TAG",
    "map_platform_account.csv": "GOLD.CONTROL.MAP_PLATFORM_ACCOUNT",
    "column_groups.csv": "GOLD.CONTROL.COLUMN_GROUPS",
    "client_column_access.csv": "GOLD.CONTROL.CLIENT_COLUMN_ACCESS",
    "mon_schedule.csv": "GOLD.CONTROL.MON_SCHEDULE",
    "ctl_archive_requests.csv": "GOLD.CONTROL.CTL_ARCHIVE_REQUESTS",
}


def read(path):
    with open(path, newline="", encoding="utf-8") as fh:
        rows = list(csv.reader(fh))
    return (rows[0], rows[1:]) if rows else ([], [])


def connect():
    import snowflake.connector
    from cryptography.hazmat.primitives import serialization
    with open(os.environ["SNOWFLAKE_PRIVATE_KEY_PATH"], "rb") as fh:
        key = serialization.load_pem_private_key(fh.read(), password=None)
    der = key.private_bytes(serialization.Encoding.DER, serialization.PrivateFormat.PKCS8, serialization.NoEncryption())
    return snowflake.connector.connect(account=os.environ["SNOWFLAKE_ACCOUNT"], user=os.environ["SNOWFLAKE_USER"],
                                       private_key=der, role="EPITAPH_DEPLOYER", warehouse="WH_TRANSFORMATION")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    con = None if a.dry_run else connect()
    for fname, table in SEEDS.items():
        path = ROOT / "seeds" / fname
        if not path.exists():
            print(f"{table}: no seed file yet, left as is")
            continue
        header, rows = read(path)
        if a.dry_run:
            print(f"{table}: {len(rows)} rows, columns {', '.join(header)}")
            continue
        cur = con.cursor()
        cols = ", ".join(header)
        marks = ", ".join(["%s"] * len(header))
        cur.execute("begin")
        cur.execute(f"truncate table {table}")
        if rows:
            cur.executemany(f"insert into {table} ({cols}) values ({marks})", [[v if v != "" else None for v in r] for r in rows])
        cur.execute("commit")
        print(f"{table}: {len(rows)} rows")
    return 0


if __name__ == "__main__":
    sys.exit(main())
