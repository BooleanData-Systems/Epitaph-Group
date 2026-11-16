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

Emails go to the alert distribution list (user DL_EPITAPH_DATA_ALERTS). Expected use is 260 to 295 credits a month,
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
| GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK | Daily record that each warehouse still meets the standard |

## When a limit is reached

1. The 80% email arrives: the Boolean pod lead (during the engagement) or Epitaph's platform owner opens
   V_QUERY_HISTORY_TOP for that warehouse and finds what changed.
2. If the use is expected (for example a history reload), the platform owner raises the limit in
   `snowflake/00_setup/04_monitoring.sql` through a pull request, and the admin re-runs it.
3. At 100% the warehouse is suspended. Dashboards stop refreshing until the admin raises the limit or the month
   resets. Raise the limit first, then investigate.
4. Escalation: Epitaph platform owner, then Mike DeOliveira; during the engagement, the Boolean pod lead and CTO.
