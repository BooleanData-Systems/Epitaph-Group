# Epitaph Group reporting

The reporting pipeline that replaces TapClicks: platform data lands in Snowflake (Fivetran connectors and SharePoint
files), is shaped through BRONZE, SILVER and GOLD, and is shown in Omni.

| Folder | What it holds |
|---|---|
| `snowflake/` | All Snowflake SQL, run in the order in `snowflake/deploy_order.txt`. `00_setup/` is one-time account setup applied by an admin. |
| `loader/` | The SharePoint file loader and the FX rate loader (Python, run inside Snowflake). |
| `seeds/` | Mapping and control tables (clients, accounts, Smart Campaigns, conversion tags, cut-over). A change is a pull request. |
| `config/` | Feeds, Fivetran connectors and KPI definitions. |
| `specs/` | One spec per dashboard, the data mapping and the data product contract. |
| `omni/` | Omni build output and dashboard build sheets. Omni's own synced model is in `omni/Epitaph Snowflake - GOLD/`. |
| `scripts/` | Deploy, seed loading, semantic layer generation, checks and Omni tooling. |
| `docs/` | Runbook, scope, change control, monitoring, cost governance and user roles. |
| `plans/` | TapClicks history plan and baseline capture. |
| `tests/` | Checks run on every pull request. |

## Making a change
1. Create a branch from `main` and open a pull request.
2. The `validate` workflow runs the tests and checks (no credentials needed).
3. After review, merge. The `deploy` workflow deploys the Snowflake changes of that merge: only the SQL files and
   loader code that changed, plus a full reload of the seeds. Omni model changes go through Omni's Git sync.

To see what a deploy would run without touching Snowflake:

    ./scripts/deploy_snowflake.sh --plan --changed-since <commit>

To deploy everything by hand, run the `deploy` workflow from the Actions tab with "everything".

## Running the checks locally

    pip install -r requirements.txt
    python -m pytest -q tests loader/tests
    python scripts/validate.py

Operational details (schedules, alerts, what to do when a feed fails) are in `docs/runbook.md` and
`docs/monitoring_and_escalation.md`.
