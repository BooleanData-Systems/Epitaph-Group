# Monitoring and escalation

Every job that moves data is watched, and a failure, a missed run, a run that takes too long or data that stops
arriving sends an email (Kickstart Checklist 3A). This page lists what is watched, when, who is told and what to do.

## Schedules and thresholds

The full list is `seeds/mon_schedule.csv` (loaded to GOLD.CONTROL.MON_SCHEDULE). In short:

| Job | Stage | Runs | Time zone | Expected | Alert if longer than | Alert if no success for |
|---|---|---|---|---|---|---|
| T_LOAD_SHAREPOINT | Source to Bronze | Hourly at :15 | America/Toronto | 3 min | 5 min | 2 h 15 min |
| T_LOAD_FX_RATES | Source to Bronze | Daily 18:00 | America/Toronto | 1 min | 5 min | 26 h |
| 15 Fivetran connectors | Source to Bronze | Every 6 hours | UTC (Fivetran) | 15 min | 60 min | 8 h |
| SILVER dynamic tables | Bronze to Silver | Within 1 hour of new data | n/a | 2 min | 5 min | Data older than 3 x target |
| GOLD dynamic tables | Silver to Gold | Within 1 hour of new data | n/a | 2 min | 5 min | Data older than 3 x target |
| T_DAILY_CHECKS | Silver to Gold | Daily 07:00 | America/Toronto | 3 min | 5 min | 26 h |
| T_DAILY_PLATFORM_CHECKS | Silver to Gold | Daily 06:30 | America/Toronto | 1 min | 5 min | 26 h |
| Omni queries | Gold to downstream | On demand | n/a | n/a | n/a | 5 or more failures in an hour |
| Each live source | Freshness | Hourly 08:00 to 20:00 | America/Toronto | n/a | n/a | 2 days (Fivetran) or 3 days (files) without new data |

## Alerts

| Alert | Checks every | Watches | Email subject starts |
|---|---|---|---|
| A_SOURCE_TO_BRONZE | 15 min | Loader and exchange-rate task failures, missed or long runs; Fivetran connectors not written within 8 h; files that errored | Epitaph data: ingestion problem |
| A_BRONZE_TO_SILVER | 15 min | Failed or stalled SILVER dynamic tables | Epitaph data: transformation problem |
| A_SILVER_TO_GOLD | 15 min | Failed or stalled GOLD dynamic tables; failed, missed or long daily checks | Epitaph data: publishing problem |
| A_GOLD_TO_DOWNSTREAM | 30 min | Omni queries failing | Epitaph data: dashboard queries failing |
| A_DATA_FRESHNESS | Hourly 08:00 to 20:00 | A source with no new data although its jobs succeeded | Epitaph data: source not up to date |
| A_CHECK_FAILURES | Daily 07:30 | Comparison with TapClicks and data-quality checks | Epitaph reporting: checks need attention |
| Stream staleness | Daily 06:30 | Any Snowflake stream within 2 days of going stale (none are used today; dynamic tables replace streams) | Epitaph data: stream(s) stale |
| Rejected files | Each load | A file that failed its checks is emailed to the file's owner directly | File not loaded |
| Resource monitors | Continuous | 80% and 100% of each credit limit | Snowflake resource monitor |

Each email lists the open issues. The same issue is emailed again every 6 hours while it stays open.
Fivetran also sends its own sync-failure emails; set them to the same distribution list.

## Recipients

GOLD.CONTROL.ALERT_RECIPIENTS holds, for each alert name (ingestion, transformation, publishing, downstream,
freshness, check_failures, streams), the distribution list and any named contacts. Addresses must be verified in
Snowflake before email can reach them. File owners are in GOLD.CONTROL.FEED_OWNERS.

## Proving the alerts work (before go-live)

1. `call GOLD.CONTROL.TEST_ALERT('ingestion');` and the same for transformation, publishing, downstream and freshness.
2. Within the alert interval each recipient gets an email starting "TEST:". Record who received it.
3. Suspend the loader task for 2.5 hours in a test window to prove the missed-run alert; resume it.
4. Drop a file with a missing column into a feed folder to prove the rejected-file email.
5. `call GOLD.ADMIN.CHECK_WAREHOUSE_STANDARD();` to prove the warehouse settings.
6. Record the results in `docs/kickstart_checklist.md`.

## Escalation

| When | First | Then | Then |
|---|---|---|---|
| During the engagement | Boolean pod, on call (same business day) | Boolean pod lead | Boolean CTO and Epitaph product owner |
| After handover | Epitaph analyst on the distribution list | Epitaph platform owner | Mike DeOliveira; Boolean if a support agreement is in place |

What to do for each kind of email is in `docs/runbook.md`, "When something goes wrong". The health views in
GOLD.ADMIN (V_MON_INGESTION, V_MON_TRANSFORMATION, V_MON_PUBLISHING, V_MON_DOWNSTREAM, V_MON_FRESHNESS,
V_TASK_RUNS, V_DYNAMIC_TABLE_LAG) show the same issues the emails list.
