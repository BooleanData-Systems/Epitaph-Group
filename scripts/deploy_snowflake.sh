#!/usr/bin/env bash
# Deploy Snowflake objects in order with the Snowflake CLI. Used by CI; can be run by an engineer with the deploy key.
# Needs: snow CLI, connection "epitaph" configured from environment variables (see .github/workflows/deploy.yml).
# Prints statement status only; queries in these files create objects and never return client rows.
set -euo pipefail
cd "$(dirname "$0")/.."

CONN="${SNOW_CONNECTION:-epitaph}"

echo "1. Upload loader code to @BRONZE.LOADER.CODE"
for f in loader/sharepoint_loader.py loader/fx_loader.py config/feeds.yml; do
  snow stage copy "$f" @BRONZE.LOADER.CODE --overwrite -c "$CONN" --role EPITAPH_LOADER >/dev/null
  echo "   $f"
done

echo "2. Generate KPI definitions from config/kpis.yml"
python scripts/gen_semantic.py

echo "3. Run SQL in order"
schema_exists() {   # $1 = DATABASE.SCHEMA ; prints yes or no
  local db="${1%%.*}" sch="${1#*.}"
  snow sql -q "select count(*) from ${db}.INFORMATION_SCHEMA.SCHEMATA where schema_name = '${sch}'" \
    -c "$CONN" --format json 2>/dev/null | python -c "import json,sys; print('yes' if list(json.load(sys.stdin)[0].values())[0] else 'no')"
}

grep -v '^#' snowflake/deploy_order.txt | grep -v '^$' | while read -r f; do
  req=$(grep -m1 '^-- requires: ' "snowflake/$f" | sed 's/^-- requires: //' || true)
  if [ -n "$req" ]; then
    if [ "$(schema_exists "$req")" = "yes" ]; then
      snow sql -q "call BRONZE.LOADER.ENABLE_CHANGE_TRACKING('${req#*.}')" -c "$CONN" --role EPITAPH_LOADER --warehouse WH_LOAD --silent >/dev/null
    else
      stub="snowflake/$(dirname "$f")/stubs/$(basename "$f")"
      echo "   $f: ${req} not synced yet, using stub"
      snow sql -f "$stub" -c "$CONN" --silent >/dev/null
      continue
    fi
  fi
  echo "   $f"
  snow sql -f "snowflake/$f" -c "$CONN" --silent >/dev/null
done

echo "4. Load seeds"
python scripts/load_seeds.py

echo "Done"
