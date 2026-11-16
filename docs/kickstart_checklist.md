# Snowflake Kickstart Checklist v1.0: where each item is set

Every item in the Boolean Snowflake Kickstart Checklist is built into the setup scripts. **Built** means the script
sets it; the tick is given when the script has run and the check in the last column passes. Items owned by "Both"
need an Epitaph action.

## 1. Foundation setup

| Item | Standard | Where | Check | Status |
|---|---|---|---|---|
| LOAD warehouse | XS, 60 s, auto-resume, 300 s timeout | `00_setup/01_account.sql` WH_LOAD | `call GOLD.ADMIN.CHECK_WAREHOUSE_STANDARD()` | Built |
| TRANSFORMATION warehouse | S, 60 s, auto-resume, 300 s timeout | WH_TRANSFORMATION | same | Built |
| ADHOC warehouse | XS, 60 s, auto-resume, 300 s timeout | WH_ADHOC | same | Built |
| BRONZE database | Land data exactly as received | BRONZE (Fivetran schemas, SHAREPOINT, TAPCLICKS, REFERENCE, LOADER) | Objects exist | Built |
| SILVER database | Cleansed, standardised, rules applied | SILVER.STG | Objects exist | Built |
| GOLD database | Business-ready; dashboards connect here | GOLD (MARTS, SEMANTIC, CONTROL, CHECKS, ADMIN) | Omni connects to GOLD.SEMANTIC only | Built |
| Default warehouse per database | Each layer on its warehouse | Default warehouse on each role, user, task and dynamic table (Snowflake has no per-database default) | `desc user` per service account | Built |
| Confirm naming with client | Before proceeding | Proposed names in this file and `user_role_mapping.md` | Epitaph confirms at kickoff | Both: open |

Two additions beyond the standard, for Epitaph to confirm: WH_REPORTING (XS) keeps Omni apart from ad hoc work so
client dashboards stay fast, and WH_HISTORY (S, 3,600 s timeout) runs the one-off history load and is then dropped.

## 2. Roles and access

| Item | Standard | Where | Check | Status |
|---|---|---|---|---|
| DEVELOPER role | Read/write BRONZE and SILVER; TRANSFORMATION warehouse | EPITAPH_DEVELOPER, `03_grants.sql` | `show grants to role` | Built |
| READER role | Read-only on GOLD only | EPITAPH_READER (analysts); EPITAPH_REPORTER (BI) | `show grants to role` | Built |
| LOADER service account | Non-human, LOAD warehouse, owns ingestion | SVC_LOADER | `desc user` | Built |
| TRANSFORMER service account | Non-human, TRANSFORMATION warehouse | SVC_TRANSFORMER | `desc user` | Built |
| REPORTER service account | Non-human, read-only GOLD, BI connection | SVC_REPORTER (Omni) | `desc user` | Built |
| Future grants | New objects inherit permissions | `03_grants.sql`, every role and database | `show future grants in database` | Built |
| Rotate service account passwords | Changed after setup, kept in vault | Service users use key pairs, no passwords: keys rotated after setup and yearly, kept in Epitaph's vault | Rotation date recorded | Both: at setup |
| Document user-role mapping | Delivered to client | `docs/user_role_mapping.md` | Handed over | Built |

## 3. Monitoring and auditing

| Item | Standard | Where | Check | Status |
|---|---|---|---|---|
| Account-level resource monitor | 80% alert, 100% suspend, email DL | RM_EPITAPH_ACCOUNT (400 credits), `04_monitoring.sql` | `show resource monitors` | Built |
| LOAD warehouse monitor | same | RM_WH_LOAD (100) | same | Built |
| TRANSFORMATION warehouse monitor | same | RM_WH_TRANSFORMATION (120) | same | Built |
| ADHOC warehouse monitor | same | RM_WH_ADHOC (20) | same | Built (also RM_WH_REPORTING 160, RM_WH_HISTORY 150) |
| Email notifications | To the DL | User DL_EPITAPH_DATA_ALERTS with the DL's verified email; notification integration EPITAPH_EMAIL | Test email received | Both: DL address needed |
| LOGIN_HISTORY view | Who, when, where | GOLD.ADMIN.V_LOGIN_HISTORY, V_FAILED_LOGINS_24H | Returns rows | Built |
| QUERY_HISTORY view | Top queries by cost and duration | GOLD.ADMIN.V_QUERY_HISTORY_TOP | Returns rows | Built |
| Consumption report | Credits per warehouse per day | GOLD.ADMIN.V_CREDITS_DAILY, V_CREDITS_MONTH_TO_DATE; a page in Omni for Epitaph | Client reviews | Built |
| Statement timeout | 300 s on every warehouse | All warehouses; WH_HISTORY 3,600 s by agreement | CHECK_WAREHOUSE_STANDARD, daily | Built |
| Validate monitoring views | Run each, confirm accurate | Runbook step | Epitaph reviews consumption report | Both: after week 1 |
| Cost governance standards | Thresholds, contacts, escalation | `docs/cost_governance.md` | Handed over | Built |

## 3A. Data pipeline and scheduled task monitoring

| Item | Where | Check | Status |
|---|---|---|---|
| Source to Bronze alerts | A_SOURCE_TO_BRONZE: loader and exchange-rate tasks (failed, missed, long), each Fivetran connector not written within 8 h, file errors | TEST_ALERT('ingestion') | Built |
| Bronze to Silver alerts | A_BRONZE_TO_SILVER: SILVER dynamic tables failed or stalled | TEST_ALERT('transformation') | Built |
| Silver to Gold alerts | A_SILVER_TO_GOLD: GOLD dynamic tables failed or stalled; daily checks failed, missed or long | TEST_ALERT('publishing') | Built |
| Gold to downstream alerts | A_GOLD_TO_DOWNSTREAM: Omni queries failing (what Snowflake can see) | TEST_ALERT('downstream') | Built |
| Scheduled task and job monitoring | GOLD.ADMIN.V_MON_TASKS: failed, missed and long runs across all stages, against MON_SCHEDULE | Suspend loader in a test window | Built |
| Stream staleness alerts | No streams are used (dynamic tables replace them); a daily check covers any stream added later | CHECK_STREAM_STALENESS | Built |
| Data freshness validation | A_DATA_FRESHNESS: source with no new data although its jobs succeeded | TEST_ALERT('freshness') | Built |
| Scheduling and time zones | `seeds/mon_schedule.csv`, `docs/monitoring_and_escalation.md` | Epitaph confirms | Both: open |
| Alert recipients and DLs | GOLD.CONTROL.ALERT_RECIPIENTS per alert | Epitaph names contacts | Both: open |
| Validate end-to-end alerting | Test steps in `docs/monitoring_and_escalation.md` | All tests pass before Group 1 go-live (11 Dec) | Both: week 4 |
| Monitoring and escalation procedures | `docs/monitoring_and_escalation.md` | Handed over | Built |
