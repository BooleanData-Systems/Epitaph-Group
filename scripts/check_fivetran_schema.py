"""Compare the tables and columns the staging SQL expects with what Fivetran actually created.

Reads INFORMATION_SCHEMA only (table and column names, no rows), so it can run with the structure-only role.
Prints missing tables and columns per connector; exit code 1 if any are missing.

    python scripts/check_fivetran_schema.py
"""
import os
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]


def connector_schemas():
    """Fivetran destination schemas, from config/connectors.yml (they have no common prefix)."""
    return {c["schema"].upper() for c in yaml.safe_load(open(ROOT / "config" / "connectors.yml"))["connectors"]}


def expected_columns():
    """Columns referenced as alias.column for each table in a connector schema, from the staging SQL."""
    schemas = connector_schemas()
    out = {}
    for f in (ROOT / "snowflake" / "30_staging").glob("*.sql"):
        for sql in f.read_text().split(";"):            # one statement at a time, so aliases do not mix
            for m in re.finditer(r"BRONZE\.(\w+)\.(\w+)\s+(?:as\s+)?(\w+)", sql, re.I):
                schema, table, alias = m.group(1).upper(), m.group(2).upper(), m.group(3)
                if schema not in schemas or alias.lower() in ("qualify", "where", "on", "group", "join", "left"):
                    continue
                cols = {c.upper() for c in re.findall(rf"\b{alias}\.(\w+)", sql)}
                out.setdefault((schema, table), set()).update(cols)
    return out


def main():
    want = expected_columns()
    import snowflake.connector
    con = snowflake.connector.connect(account=os.environ["SNOWFLAKE_ACCOUNT"], user=os.environ["SNOWFLAKE_USER"],
                                      authenticator="SNOWFLAKE_JWT", private_key_file=os.environ["SNOWFLAKE_PRIVATE_KEY_PATH"],
                                      role="EPITAPH_STRUCTURE", warehouse="WH_TRANSFORMATION")
    cur = con.cursor()
    schemas = sorted(connector_schemas())
    cur.execute("select table_schema, table_name, column_name from BRONZE.INFORMATION_SCHEMA.COLUMNS "
                f"where table_schema in ({', '.join(['%s'] * len(schemas))})", schemas)
    have = {}
    for s, t, c in cur.fetchall():
        have.setdefault((s, t), set()).add(c)
    problems = 0
    for (s, t), cols in sorted(want.items()):
        if (s, t) not in have:
            print(f"{s}.{t}: table missing")
            problems += 1
            continue
        missing = sorted(cols - have[(s, t)])
        if missing:
            print(f"{s}.{t}: missing columns {', '.join(missing)}")
            problems += 1
    planned = yaml.safe_load(open(ROOT / "config" / "connectors.yml"))["connectors"]
    for c in planned:
        if not any(s == c["schema"] for s, _ in have):
            print(f"{c['schema']}: connector not synced yet ({c['status']})")
    print(f"{problems} problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
