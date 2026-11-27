#!/usr/bin/env bash
# Deploy Snowflake objects in order with the Snowflake CLI. Used by CI; can be run by an engineer with the deploy key.
# Needs: snow CLI, connection "epitaph" configured from environment variables (see .github/workflows/deploy.yml).
# Prints statement status only; queries in these files create objects and never return client rows.
#
#   ./scripts/deploy_snowflake.sh                          # everything, in deploy_order.txt order
#   ./scripts/deploy_snowflake.sh --changed-since <commit> # only what changed between <commit> and HEAD
#
# Changed-only rules (to keep warehouse credits down during development):
#   - SQL: a file in deploy_order.txt runs when it, or its stub, changed. v_kpi_definitions.sql also runs when
#     config/kpis.yml changed. Views are late-bound and dynamic tables follow their sources, so files that only
#     read a changed object do not need to run again.
#   - A change to deploy_order.txt or to this script runs everything.
#   - Loader code goes to the stage only when loader/*.py or config/feeds.yml changed.
#   - Seeds: only the seed files that changed are reloaded.
#   - snowflake/00_setup is one-time setup (account, integrations, grants, resource monitors) and is never run here:
#     a change there is applied by an admin, statement by statement (rerunning 04_monitoring.sql would reset the
#     resource monitors' monthly counters).
# Any failed file stops the deploy and prints that file's error.
#   ./scripts/deploy_snowflake.sh --plan [--changed-since <commit> [--to <commit>]]   # what would run; no Snowflake call
set -euo pipefail
cd "$(dirname "$0")/.."

CONN="${SNOW_CONNECTION:-epitaph}"
BASE=""
TO=HEAD   # --to: the commit to compare with (default HEAD); only for --plan checks of past merges
PLAN=no   # --plan: print what would be deployed and stop before any call to Snowflake
while [ $# -gt 0 ]; do
  case "$1" in
    --changed-since) BASE="${2:?--changed-since needs a commit}"; shift 2 ;;
    --to) TO="${2:?--to needs a commit}"; shift 2 ;;
    --plan) PLAN=yes; shift ;;
    *) echo "Unknown option: $1"; exit 2 ;;
  esac
done
if [ "$TO" != HEAD ] && [ "$PLAN" = no ]; then
  echo "--to works only with --plan (a deploy always runs the files as they are in this checkout)"; exit 2
fi

FULL=yes
CHANGED=""
if [ -n "$BASE" ]; then
  if git cat-file -e "${BASE}^{commit}" 2>/dev/null; then
    CHANGED=$(git diff --name-only "$BASE" "$TO" | tr -d '\r')
    FULL=no
    if echo "$CHANGED" | grep -qxE 'snowflake/deploy_order\.txt|scripts/deploy_snowflake\.sh'; then
      echo "deploy_order.txt or the deploy script changed: deploying everything"
      FULL=yes
    fi
  else
    echo "Commit ${BASE} not found in this checkout: deploying everything"
  fi
fi

changed() {   # $1 = path; true when it changed (always true in a full deploy)
  [ "$FULL" = yes ] || echo "$CHANGED" | grep -qxF "$1"
}

sql_due() {   # $1 = path in deploy_order.txt; true when the file is part of this deploy
  changed "snowflake/$1" || changed "snowflake/$(dirname "$1")/stubs/$(basename "$1")" \
    || { [ "$1" = "50_semantic/v_kpi_definitions.sql" ] && changed "config/kpis.yml"; }
}

ORDER=$(grep -v '^#' snowflake/deploy_order.txt | tr -d '\r' | grep -v '^$')
SEED_FILES=$(echo "$CHANGED" | grep -E '^seeds/[^/]+\.csv$' | xargs -r -n1 basename | paste -sd, - || true)

if [ "$PLAN" = yes ]; then
  if [ "$FULL" = yes ]; then echo "Plan: full deploy"; else echo "Plan: changed since ${BASE}"; fi
  echo "Loader files to upload:"
  for f in loader/sharepoint_loader.py loader/fx_loader.py config/feeds.yml; do changed "$f" && echo "   $f"; done
  echo "SQL files to run (a file whose source is not synced yet runs its stub):"
  while read -r f; do sql_due "$f" && echo "   $f"; done <<< "$ORDER"
  if [ "$FULL" = yes ]; then echo "Seeds: all"; else echo "Seeds: ${SEED_FILES:-none}"; fi
  exit 0
fi

LOG=$(mktemp)
trap 'rm -f "$LOG"' EXIT
run_sql() {   # $1 = file to run, $2 = label; stops the deploy with the error if the file fails
  if ! snow sql -f "$1" -c "$CONN" >"$LOG" 2>&1 </dev/null; then
    echo "FAILED: $2"
    grep -v -i 'encoding mismatch\|warnings.warn' "$LOG" | tail -40
    exit 1
  fi
}

if [ "$FULL" = yes ]; then echo "Mode: full deploy"; else echo "Mode: changed since ${BASE}"; fi

echo "1. Upload loader code to @BRONZE.LOADER.CODE"
n=0
for f in loader/sharepoint_loader.py loader/fx_loader.py config/feeds.yml; do
  if changed "$f"; then
    snow stage copy "$f" @BRONZE.LOADER.CODE --overwrite -c "$CONN" --role EPITAPH_LOADER >/dev/null
    echo "   $f"
    n=$((n + 1))
  fi
done
[ "$n" -gt 0 ] || echo "   nothing changed"

echo "2. Generate KPI definitions from config/kpis.yml"
python scripts/gen_semantic.py

echo "3. Run SQL in order"
schema_exists() {   # $1 = DATABASE.SCHEMA ; prints yes or no
  local db="${1%%.*}" sch="${1#*.}"
  snow sql -q "select count(*) from ${db}.INFORMATION_SCHEMA.SCHEMATA where schema_name = '${sch}'" \
    -c "$CONN" --format json 2>/dev/null | python -c "import json,sys; print('yes' if list(json.load(sys.stdin)[0].values())[0] else 'no')" \
    | tr -d '\r'   # Python on Windows ends lines with \r\n
}

missing_tables() {   # $1 = DATABASE.SCHEMA, $2 = SQL file ; prints the tables of that schema the file reads that do not exist yet
  local sch="${1#*.}" want have
  want=$(grep -oiE "BRONZE\.${sch}\.[A-Za-z0-9_]+" "$2" | cut -d. -f3 | tr '[:lower:]' '[:upper:]' | sort -u)
  have=$(snow sql -q "select table_name from BRONZE.INFORMATION_SCHEMA.TABLES where table_schema = '${sch}'" \
    -c "$CONN" --format json 2>/dev/null </dev/null | python -c "import json,sys; print('\n'.join(r['TABLE_NAME'] for r in json.load(sys.stdin)))")
  comm -23 <(echo "$want") <(echo "$have" | tr -d '\r' | sort -u) | paste -sd, -
}

ran=0
while read -r f; do
  stub="snowflake/$(dirname "$f")/stubs/$(basename "$f")"
  sql_due "$f" || continue
  ran=$((ran + 1))
  req=$(grep -m1 '^-- requires: ' "snowflake/$f" | sed 's/^-- requires: //' | tr -d '\r' || true)
  if [ -n "$req" ]; then
    # A connector can create its schema before the report tables the view reads (Amazon DSP did), so check both.
    missing=""
    if [ "$(schema_exists "$req" </dev/null)" = "yes" ]; then missing=$(missing_tables "$req" "snowflake/$f"); else missing="schema"; fi
    if [ -z "$missing" ]; then
      snow sql -q "call BRONZE.LOADER.ENABLE_CHANGE_TRACKING('${req#*.}')" -c "$CONN" --role EPITAPH_LOADER --warehouse WH_LOAD --silent >/dev/null </dev/null
    else
      echo "   $f: ${req} not synced yet (missing: ${missing}), using stub"
      run_sql "$stub" "$stub"
      continue
    fi
  fi
  echo "   $f"
  run_sql "snowflake/$f" "snowflake/$f"
done <<< "$ORDER"
[ "$ran" -gt 0 ] || echo "   nothing changed"

echo "4. Load seeds"
if [ "$FULL" = yes ]; then
  python scripts/load_seeds.py
else
  if [ -n "$SEED_FILES" ]; then python scripts/load_seeds.py --only "$SEED_FILES"; else echo "   nothing changed"; fi
fi

echo "Done"
