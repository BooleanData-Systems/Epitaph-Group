-- Kickstart Checklist section 3: resource monitors, cost visibility and query auditing.
-- Run as ACCOUNTADMIN after 01 to 03. Monitor emails go to the alert distribution list user (verified email).
use role accountadmin;

-- ================================================================ Resource monitors: alert at 80%, suspend at 100%
create or replace resource monitor RM_EPITAPH_ACCOUNT with credit_quota = 400 frequency = monthly start_timestamp = immediately
  notify_users = (DL_EPITAPH_DATA_ALERTS)
  triggers on 80 percent do notify on 100 percent do suspend;
alter account set resource_monitor = RM_EPITAPH_ACCOUNT;

create or replace resource monitor RM_WH_LOAD with credit_quota = 100 frequency = monthly start_timestamp = immediately
  notify_users = (DL_EPITAPH_DATA_ALERTS) triggers on 80 percent do notify on 100 percent do suspend;
create or replace resource monitor RM_WH_TRANSFORMATION with credit_quota = 120 frequency = monthly start_timestamp = immediately
  notify_users = (DL_EPITAPH_DATA_ALERTS) triggers on 80 percent do notify on 100 percent do suspend;
create or replace resource monitor RM_WH_ADHOC with credit_quota = 20 frequency = monthly start_timestamp = immediately
  notify_users = (DL_EPITAPH_DATA_ALERTS) triggers on 80 percent do notify on 100 percent do suspend;
create or replace resource monitor RM_WH_REPORTING with credit_quota = 160 frequency = monthly start_timestamp = immediately
  notify_users = (DL_EPITAPH_DATA_ALERTS) triggers on 80 percent do notify on 100 percent do suspend;
create or replace resource monitor RM_WH_HISTORY with credit_quota = 150 frequency = never start_timestamp = immediately
  notify_users = (DL_EPITAPH_DATA_ALERTS) triggers on 80 percent do notify on 100 percent do suspend;

alter warehouse WH_LOAD           set resource_monitor = RM_WH_LOAD;
alter warehouse WH_TRANSFORMATION set resource_monitor = RM_WH_TRANSFORMATION;
alter warehouse WH_ADHOC          set resource_monitor = RM_WH_ADHOC;
alter warehouse WH_REPORTING      set resource_monitor = RM_WH_REPORTING;
alter warehouse WH_HISTORY        set resource_monitor = RM_WH_HISTORY;

-- ================================================================ Monitoring views (GOLD.ADMIN)
use role EPITAPH_TRANSFORMER;

-- Who logged in, when and from where (Snowflake keeps 365 days; account usage lags up to 2 hours)
create or replace view GOLD.ADMIN.V_LOGIN_HISTORY as
select event_timestamp, user_name, client_ip, reported_client_type, first_authentication_factor,
       second_authentication_factor, is_success, error_code, error_message
from SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
where event_timestamp >= dateadd(day, -90, current_timestamp());

-- Failed logins in the last day: a quick security check
create or replace view GOLD.ADMIN.V_FAILED_LOGINS_24H as
select user_name, client_ip, count(*) as failures, max(event_timestamp) as last_failure, any_value(error_message) as error_message
from SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
where is_success = 'NO' and event_timestamp >= dateadd(day, -1, current_timestamp())
group by user_name, client_ip;

-- Top queries by cost and duration, last 30 days (query text cut to 300 characters)
create or replace view GOLD.ADMIN.V_QUERY_HISTORY_TOP as
select q.query_id, q.start_time, q.user_name, q.role_name, q.warehouse_name, q.warehouse_size,
       q.execution_status, round(q.total_elapsed_time / 1000, 1) as elapsed_seconds,
       round(q.bytes_scanned / power(1024, 3), 2) as gb_scanned,
       a.credits_attributed_compute as credits, left(q.query_text, 300) as query_text
from SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY q
left join SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY a on a.query_id = q.query_id
where q.start_time >= dateadd(day, -30, current_timestamp())
qualify row_number() over (order by coalesce(a.credits_attributed_compute, 0) desc, q.total_elapsed_time desc) <= 500;

-- Consumption: credits per warehouse per day, with an estimated cost at list price (Enterprise, Canada Central)
create or replace view GOLD.ADMIN.V_CREDITS_DAILY as
select to_date(start_time) as usage_date, warehouse_name,
       round(sum(credits_used_compute), 3) as compute_credits,
       round(sum(credits_used_cloud_services), 3) as cloud_services_credits,
       round(sum(credits_used), 3) as total_credits,
       round(sum(credits_used) * 3.50, 2) as est_cost_usd
from SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
where start_time >= dateadd(day, -90, current_timestamp())
group by 1, 2;

-- Month to date per warehouse against its monitor quota
create or replace view GOLD.ADMIN.V_CREDITS_MONTH_TO_DATE as
select c.warehouse_name, sum(c.total_credits) as credits_mtd, q.quota,
       round(sum(c.total_credits) / nullif(q.quota, 0) * 100, 1) as pct_of_quota
from GOLD.ADMIN.V_CREDITS_DAILY c
left join (select column1 as warehouse_name, column2 as quota from values
           ('WH_LOAD', 100), ('WH_TRANSFORMATION', 120), ('WH_ADHOC', 20), ('WH_REPORTING', 160), ('WH_HISTORY', 150)) q
  on q.warehouse_name = c.warehouse_name
where c.usage_date >= date_trunc('month', current_date())
group by c.warehouse_name, q.quota;

-- Checklist "Validate all monitoring views" and "Set statement timeout per warehouse": this procedure records each
-- warehouse's actual settings against the standard, so the check is a query, not a screenshot.
create table if not exists GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK (
  checked_at timestamp_ltz, warehouse varchar, setting varchar, actual varchar, expected varchar, ok boolean
);

create or replace procedure GOLD.ADMIN.CHECK_WAREHOUSE_STANDARD()
returns varchar language sql execute as caller as
$$
declare
  whs array default ['WH_LOAD', 'WH_TRANSFORMATION', 'WH_ADHOC', 'WH_REPORTING', 'WH_HISTORY'];
  wh varchar;
  expected_timeout varchar;
  bad integer default 0;
begin
  for i in 0 to array_size(:whs) - 1 do
    wh := whs[i];
    expected_timeout := iff(wh = 'WH_HISTORY', '3600', '300');
    execute immediate 'show parameters like ''STATEMENT_TIMEOUT_IN_SECONDS'' in warehouse ' || wh;
    insert into GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK
      select current_timestamp(), :wh, 'statement_timeout_in_seconds', "value", :expected_timeout, "value" = :expected_timeout
      from table(result_scan(last_query_id()));
    execute immediate 'show warehouses like ''' || wh || '''';
    insert into GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK
      select current_timestamp(), :wh, 'auto_suspend', "auto_suspend", '60', "auto_suspend" = '60'
      from table(result_scan(last_query_id()))
      union all
      select current_timestamp(), :wh, 'auto_resume', "auto_resume", 'true', "auto_resume" = 'true'
      from table(result_scan(last_query_id()));   -- same SHOW result: last_query_id() is fixed for the whole statement
  end for;
  select count(*) into :bad from GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK
   where not ok and checked_at >= dateadd(minute, -5, current_timestamp());
  return iff(bad = 0, 'all warehouses meet the standard', bad || ' settings differ: see GOLD.ADMIN.WAREHOUSE_STANDARD_CHECK');
end;
$$;
