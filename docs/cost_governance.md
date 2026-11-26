# Cost governance

How Snowflake spend is limited and watched (Kickstart Checklist 3, "Document cost governance standards").

## Limits

| Monitor | Applies to | Monthly credits | At 80% | At 100% |
|---|---|---|---|---|
| RM_EPITAPH_ACCOUNT | Whole account | 400 | Email | Suspend all warehouses |
| RM_WH_LOAD | WH_LOAD (X-Small) | 100 | Email | Suspend |
| RM_WH_TRANSFORMATION | WH_TRANSFORMATION (Small) | 120 | Email | Suspend |
| RM_WH_REPORTING | WH_REPORTING (X-Small, Omni) | 160 | Email | Suspend |
| RM_WH_ADHOC | WH_ADHOC (X-Small) | 20 | Email | Suspend |
| RM_WH_HISTORY | WH_HISTORY (Small, one-off) | 150 in total | Email | Suspend |

Emails go to the alert distribution list (user DL_EPITAPH_DATA_ALERTS, epitaph@booleandata.ai) and to Nathan Sennema (user NATHANEPITAPH; his address is set by the Epitaph admin). Expected use is 260 to 295 credits a month,
so the account limit leaves about 35% headroom.

Every warehouse suspends after 60 seconds idle, resumes on demand, and stops any statement after 300 seconds.
WH_HISTORY allows 3,600 seconds for the bulk history load and is dropped once history is signed off.

## Where to look

| View | Shows |
|---|---|
| GOLD.ADMIN.V_CREDITS_DAILY | Credits per warehouse per day, with cost at list price |
| GOLD.ADMIN.V_CREDITS_MONTH_TO_DATE | Month to date per warehouse against its limit |
| GOLD.ADMIN.V_QUERY_HISTORY_TOP | The 500 most expensive or longest queries of the last 30 days |
| GOLD.ADMIN.V_LOGIN_HISTORY, V_FAILED_LOGINS_24H | Who signed in, when and from where; failed sign-ins |
| GOLD.ADMIN.V_LOGIN_SUMMARY_DAILY | Last 24 hours per user: attempts, failures, last sign-in, client types |
| GOLD.ADMIN.V_QUERY_PERFORMANCE_SUMMARY | Last 24 hours per warehouse: query count, average and longest time, slow (over 60 s) and queued queries |
| GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG, WH_ALERT_HISTORY | Daily credit limit per warehouse for the daily report; what each report showed |
| GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK | Daily record that each warehouse still meets the standard |

## Daily consumption report

Every day at 09:30 Toronto time, task `GOLD.ADMIN.T_DAILY_CONSUMPTION_REPORT` emails the Warehouse Consumption Report
(`snowflake/70_tasks/consumption_report.sql`) to the alert distribution list and Nathan Sennema. It shows, per
warehouse, credits and cost for the last 24 hours against a daily limit, plus month to date, year to date and storage.
Rows are green (within limit), red (exceeded) or yellow (no limit set). Recipients are the `consumption_report` rows in
`GOLD.CONTROL.ALERT_RECIPIENTS`. The daily limits start at each monthly quota divided by 30 and are changed with an
`update` on `GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG`. A new warehouse appears as "Not Configured" until its limit is set.
Unlike the monitors above, this report never suspends anything: it shows a bad day before the monthly 80% email.

## When a limit is reached

1. The 80% email arrives: the Boolean pod lead (during the engagement) or Epitaph's platform owner opens
   V_QUERY_HISTORY_TOP for that warehouse and finds what changed.
2. If the use is expected (for example a history reload), the platform owner raises the limit in
   `snowflake/00_setup/04_monitoring.sql` through a pull request, and the admin re-runs it.
3. At 100% the warehouse is suspended. Dashboards stop refreshing until the admin raises the limit or the month
   resets. Raise the limit first, then investigate.
4. Escalation: Epitaph platform owner, then Mike DeOliveira; during the engagement, the Boolean pod lead and CTO.
