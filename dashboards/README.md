# Dashboards as code (Omni)

The two client layouts (Clean and Cockpit, from the HTML demos) live here as spec files. A spec lists every tile:
its title, chart type, fields, sorts, filters and limit, using the field names of `omni/model/media_performance_daily.view.yaml`.
`scripts/omni_dashboard_build.py` checks the spec against the model and creates the dashboard through Omni's API.

| Path | What |
|---|---|
| `specs/cockpit.yml` | Cockpit layout: 10 KPIs, funnel, best day, trend, media type, audience, tactic, creative, Channels / Search Keywords / Creative pages |
| `specs/clean.yml` | Clean layout: the same without the funnel and best-day row |
| `templates/` | visConfig per chart type, captured from a dashboard styled in the Omni UI (`capture`) |
| `build/` | Generated payloads (`plan`). Not edited by hand. |
| `exports/` | Finished dashboards exported from Omni (`scripts/omni_dashboard.py export`) |

## Workflow

1. Change a spec in a branch, open a PR. CI validates every field and attaches the planned payloads.
2. After merge, run the **omni-dashboard-build** workflow (spec + new version, e.g. `v2`). It runs every tile query
   against Omni, then creates the dashboard. The `omni` environment needs approval.
3. In Omni, do the spec's `manual_steps` once: layout, pages, filters, controls (field switcher, timeframe switcher,
   period over period), theme. Omni's API cannot set these.
4. Export the finished dashboard into git: `python scripts/omni_dashboard.py export --dashboard-id <id> --out dashboards/exports/<name>.json`.
   From there `clone` and `import` make the client copies (see `scripts/omni_dashboard.py`).

## Local commands

```bash
pip install pyyaml
python scripts/omni_dashboard_build.py validate dashboards/specs/cockpit.yml
python scripts/omni_dashboard_build.py plan     dashboards/specs/cockpit.yml --version v1
python scripts/omni_dashboard_build.py create   dashboards/specs/cockpit.yml --version v1 --dry-run

# against Omni (Organization API key, shared model id)
export OMNI_BASE_URL=https://<org>.omniapp.co OMNI_API_KEY=... OMNI_MODEL_ID=...
python scripts/omni_dashboard_build.py test   dashboards/specs/cockpit.yml
python scripts/omni_dashboard_build.py create dashboards/specs/cockpit.yml --version v1
```

Windows cmd: use `set OMNI_BASE_URL=...` instead of `export`, and `\` in paths.

## First run: confirm three things

The documents API is Omni's documented way to create dashboards with tiles, but its docs do not show every inner
field. Confirm these on the first run in the trial or demo account, not the client's:

1. **Chart styling.** Build one tile of each chart type in the UI the way you want it, then
   `python scripts/omni_dashboard_build.py capture <identifier>`. Later builds reuse that styling.
2. **Filter shape.** `keywords` and `video_table` use tile filters. Compare the generated filter with the raw capture
   (`templates/_capture_*.json`) and adjust `omni_filter()` if Omni stores it differently.
3. **Best day of week.** `date_day[day_of_week_name]` is marked experimental. If `test` fails on it, change the
   timeframe name to the one Omni shows in the field picker.

Omni marks `POST /api/v1/documents` as superseded by a v2 documents API (draft and publish). If v1 is switched off,
only `cmd_create` needs to change.
