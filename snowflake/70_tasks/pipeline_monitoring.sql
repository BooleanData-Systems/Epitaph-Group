-- Kickstart Checklist section 3A: pipeline and scheduled task monitoring.
-- One alert per stage (Source to Bronze, Bronze to Silver, Silver to Gold, Gold to downstream), plus missed and long
-- runs, data freshness and stream staleness. Each stage has a view of open issues: zero rows means healthy.
-- Expected schedules and thresholds live in GOLD.CONTROL.MON_SCHEDULE (seeds/mon_schedule.csv) and are documented in
-- docs/monitoring_and_escalation.md. Emails go to GOLD.CONTROL.ALERT_RECIPIENTS (distribution list plus named people).
-- An issue is emailed once, then again every 6 hours while it stays open (GOLD.CONTROL.MON_ALERT_LOG).
use role EPITAPH_TRANSFORMER;

create table if not exists GOLD.CONTROL.MON_SCHEDULE (
  job_name varchar primary key, stage varchar, kind varchar, schedule varchar, time_zone varchar,
  expected_minutes number, max_minutes number, missed_after_minutes number, owner varchar, notes varchar
) comment = 'seeds/mon_schedule.csv: every monitored job, its schedule, time zone, expected run time and alert thresholds';

create table if not exists GOLD.CONTROL.MON_ALERT_LOG (
  alert_name varchar, issue_key varchar, issue varchar, sent_at timestamp_ltz default current_timestamp()
);

create table if not exists GOLD.CONTROL.MON_TEST_ISSUES (
  alert_name varchar, issue varchar, created_at timestamp_ltz default current_timestamp()
) comment = 'Rows written by TEST_ALERT to prove each alert reaches its recipients (checklist: validate end-to-end alerting)';

-- ---------------------------------------------------------------- task runs across the databases that hold tasks
create or replace view GOLD.ADMIN.V_TASK_RUNS as
-- TASK_HISTORY returns every task in the account the role can monitor, whichever database it sits in
select database_name, schema_name, name as task_name, state, scheduled_time, query_start_time, completed_time,
       datediff(second, query_start_time, coalesce(completed_time, current_timestamp())) / 60 as run_minutes, error_message
from table(GOLD.INFORMATION_SCHEMA.TASK_HISTORY(scheduled_time_range_start => dateadd(hour, -48, current_timestamp()),
                                                result_limit => 10000));

-- Failed, missed and long-running scheduled jobs (any stage)
create or replace view GOLD.ADMIN.V_MON_TASKS as
with last_ok as (
  select task_name, max(completed_time) as last_success from GOLD.ADMIN.V_TASK_RUNS where state = 'SUCCEEDED' group by task_name
)
select 'task-failed:' || r.task_name || ':' || r.scheduled_time as issue_key, s.stage,
       r.task_name || ' failed at ' || to_varchar(r.completed_time, 'YYYY-MM-DD HH24:MI') || ': ' || left(coalesce(r.error_message, ''), 200) as issue
from GOLD.ADMIN.V_TASK_RUNS r join GOLD.CONTROL.MON_SCHEDULE s on s.job_name = r.task_name
where r.state in ('FAILED', 'CANCELLED') and r.completed_time >= dateadd(hour, -6, current_timestamp())
union all
select 'task-long:' || r.task_name || ':' || r.scheduled_time, s.stage,
       r.task_name || ' has run ' || round(r.run_minutes) || ' minutes (limit ' || s.max_minutes || ')'
from GOLD.ADMIN.V_TASK_RUNS r join GOLD.CONTROL.MON_SCHEDULE s on s.job_name = r.task_name
where r.state = 'EXECUTING' and r.run_minutes > s.max_minutes
union all
select 'task-missed:' || s.job_name || ':' || to_varchar(current_date()), s.stage,
       s.job_name || ' has not completed since ' || coalesce(to_varchar(l.last_success, 'YYYY-MM-DD HH24:MI'), 'setup')
       || ' (expected every ' || s.schedule || ', ' || s.time_zone || ')'
from GOLD.CONTROL.MON_SCHEDULE s left join last_ok l on l.task_name = s.job_name
where s.kind = 'task' and coalesce(l.last_success, '2000-01-01') < dateadd(minute, -s.missed_after_minutes, current_timestamp());

-- ---------------------------------------------------------------- Source to Bronze
create or replace view GOLD.ADMIN.V_MON_INGESTION as
-- Fivetran: each connector schema must have changed within its window
select 'fivetran-stale:' || t.table_schema as issue_key,
       'Fivetran connector ' || t.table_schema || ' last wrote at ' || to_varchar(max(t.last_altered), 'YYYY-MM-DD HH24:MI') as issue
from BRONZE.INFORMATION_SCHEMA.TABLES t
join GOLD.CONTROL.MON_SCHEDULE s on s.job_name = t.table_schema and s.kind = 'fivetran'
group by t.table_schema, s.missed_after_minutes
having max(t.last_altered) < dateadd(minute, -s.missed_after_minutes, current_timestamp())
union all
-- SharePoint loader: a file that errored (not a rejected file: owners are emailed about those directly)
select 'file-error:' || item_id || ':' || etag, 'SharePoint file ' || file_name || ' could not be processed: ' || left(reason, 200)
from BRONZE.LOADER.LOAD_LOG
where status = 'error' and logged_at >= dateadd(hour, -6, current_timestamp())
union all
select issue_key, issue from GOLD.ADMIN.V_MON_TASKS where stage = 'source_to_bronze'
union all
select 'test:' || created_at, issue from GOLD.CONTROL.MON_TEST_ISSUES
where alert_name = 'ingestion' and created_at >= dateadd(minute, -30, current_timestamp());

-- ---------------------------------------------------------------- Bronze to Silver, and Silver to Gold
-- Dynamic tables: a failed refresh, or data older than three times the target lag, is a stalled transformation.
create or replace view GOLD.ADMIN.V_DYNAMIC_TABLE_HEALTH as
select database_name, schema_name, name, state, state_message, refresh_start_time, refresh_end_time
from table(SILVER.INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
       data_timestamp_start => dateadd(hour, -6, current_timestamp()), error_only => true))
union all
select database_name, schema_name, name, state, state_message, refresh_start_time, refresh_end_time
from table(GOLD.INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
       data_timestamp_start => dateadd(hour, -6, current_timestamp()), error_only => true));

create or replace view GOLD.ADMIN.V_DYNAMIC_TABLE_LAG as
select 'SILVER' as database_name, schema_name, name, target_lag_sec, latest_data_timestamp,
       datediff(second, latest_data_timestamp, current_timestamp()) as lag_sec
from table(SILVER.INFORMATION_SCHEMA.DYNAMIC_TABLES())
union all
select 'GOLD', schema_name, name, target_lag_sec, latest_data_timestamp,
       datediff(second, latest_data_timestamp, current_timestamp())
from table(GOLD.INFORMATION_SCHEMA.DYNAMIC_TABLES());

create or replace view GOLD.ADMIN.V_MON_TRANSFORMATION as
select 'dt-failed:' || name || ':' || refresh_start_time as issue_key,
       'SILVER.' || schema_name || '.' || name || ' refresh ' || lower(state) || ': ' || left(coalesce(state_message, ''), 200) as issue
from GOLD.ADMIN.V_DYNAMIC_TABLE_HEALTH where database_name = 'SILVER'
union all
select 'dt-stalled:' || name || ':' || to_varchar(current_date()),
       'SILVER.' || schema_name || '.' || name || ' data is ' || round(lag_sec / 3600, 1) || ' hours old'
from GOLD.ADMIN.V_DYNAMIC_TABLE_LAG where database_name = 'SILVER' and target_lag_sec > 0 and lag_sec > 3 * target_lag_sec
union all
select issue_key, issue from GOLD.ADMIN.V_MON_TASKS where stage = 'bronze_to_silver'
union all
select 'test:' || created_at, issue from GOLD.CONTROL.MON_TEST_ISSUES
where alert_name = 'transformation' and created_at >= dateadd(minute, -30, current_timestamp());

create or replace view GOLD.ADMIN.V_MON_PUBLISHING as
select 'dt-failed:' || name || ':' || refresh_start_time as issue_key,
       'GOLD.' || schema_name || '.' || name || ' refresh ' || lower(state) || ': ' || left(coalesce(state_message, ''), 200) as issue
from GOLD.ADMIN.V_DYNAMIC_TABLE_HEALTH where database_name = 'GOLD'
union all
select 'dt-stalled:' || name || ':' || to_varchar(current_date()),
       'GOLD.' || schema_name || '.' || name || ' data is ' || round(lag_sec / 3600, 1) || ' hours old'
from GOLD.ADMIN.V_DYNAMIC_TABLE_LAG where database_name = 'GOLD' and target_lag_sec > 0 and lag_sec > 3 * target_lag_sec
union all
select issue_key, issue from GOLD.ADMIN.V_MON_TASKS where stage = 'silver_to_gold'
union all
select 'test:' || created_at, issue from GOLD.CONTROL.MON_TEST_ISSUES
where alert_name = 'publishing' and created_at >= dateadd(minute, -30, current_timestamp());

-- ---------------------------------------------------------------- Gold to downstream (Omni)
-- Monitored where Snowflake can see it: queries from the Omni service user that fail.
create or replace view GOLD.ADMIN.V_MON_DOWNSTREAM as
select 'omni-errors:' || to_varchar(date_trunc('hour', current_timestamp())) as issue_key,
       count(*) || ' Omni queries failed in the last hour, for example: ' || left(any_value(error_message), 200) as issue
from table(GOLD.INFORMATION_SCHEMA.QUERY_HISTORY_BY_USER(user_name => 'SVC_REPORTER',
       end_time_range_start => dateadd(hour, -1, current_timestamp()), result_limit => 1000))
where execution_status like 'FAIL%'
having count(*) >= 5
union all
select 'test:' || created_at, issue from GOLD.CONTROL.MON_TEST_ISSUES
where alert_name = 'downstream' and created_at >= dateadd(minute, -30, current_timestamp());

-- ---------------------------------------------------------------- Freshness: a run succeeded but no new data arrived
create or replace view GOLD.ADMIN.V_MON_FRESHNESS as
select 'stale:' || source_name || ':' || to_varchar(current_date()) as issue_key,
       source_name || ' (' || route || ') has no data since ' || coalesce(to_varchar(last_data_date), 'go-live')
       || '; allowed ' || allowed_days || ' days' as issue
from GOLD.CHECKS.DQ_FRESHNESS
union all
select 'test:' || created_at, issue from GOLD.CONTROL.MON_TEST_ISSUES
where alert_name = 'freshness' and created_at >= dateadd(minute, -30, current_timestamp());

-- ---------------------------------------------------------------- Streams: none are used (dynamic tables replace them).
-- The check still runs, so a stream added later is covered: it lists any stream within 2 days of going stale.
create or replace procedure GOLD.ADMIN.CHECK_STREAM_STALENESS()
returns varchar language sql execute as caller as
$$
declare n integer default 0;
begin
  show streams in account;
  select count(*) into :n from table(result_scan(last_query_id()))
   where "stale" = 'true' or try_to_timestamp_ltz("stale_after") < dateadd(day, 2, current_timestamp());
  if (n > 0) then
    call GOLD.CONTROL.NOTIFY('alert', 'streams', 'Epitaph data: ' || n || ' stream(s) stale or close to stale',
      'Run SHOW STREAMS IN ACCOUNT and read a stream before its stale_after time.');
  end if;
  return n || ' stream(s) at risk';
end;
$$;

-- ---------------------------------------------------------------- send open issues once, then every 6 hours
create or replace procedure GOLD.CONTROL.SEND_ISSUES(alert_name varchar, view_name varchar, subject varchar)
returns varchar language sql execute as owner as
$$
declare
  body varchar;
  n integer default 0;
begin
  execute immediate 'create or replace temporary table MON_NEW as select v.issue_key, v.issue from ' || :view_name || ' v
     where not exists (select 1 from GOLD.CONTROL.MON_ALERT_LOG l where l.alert_name = ''' || :alert_name || '''
                       and l.issue_key = v.issue_key and l.sent_at >= dateadd(hour, -6, current_timestamp()))';
  select count(*), listagg('- ' || issue, '\n') within group (order by issue) into :n, :body from MON_NEW;
  if (n = 0) then
    return 'nothing new';
  end if;
  insert into GOLD.CONTROL.MON_ALERT_LOG (alert_name, issue_key, issue) select :alert_name, issue_key, issue from MON_NEW;
  call GOLD.CONTROL.NOTIFY('alert', :alert_name, :subject || ' (' || n || ')',
       :body || '\n\nWhat to do: docs/monitoring_and_escalation.md. Health views: GOLD.ADMIN.');
  return n || ' issue(s) sent';
end;
$$;

-- Validate end-to-end alerting: writes a test issue for one alert; its next run emails the recipients.
create or replace procedure GOLD.CONTROL.TEST_ALERT(alert_name varchar)
returns varchar language sql execute as owner as
$$
begin
  insert into GOLD.CONTROL.MON_TEST_ISSUES (alert_name, issue)
    values (:alert_name, 'TEST: this is a test of the ' || :alert_name || ' alert. No action needed.');
  return 'test issue written; expect an email within the alert interval';
end;
$$;

-- ---------------------------------------------------------------- the alerts (one per stage)
create or replace alert GOLD.ADMIN.A_SOURCE_TO_BRONZE warehouse = WH_TRANSFORMATION schedule = '15 minute'
  if (exists (select 1 from GOLD.ADMIN.V_MON_INGESTION))
  then call GOLD.CONTROL.SEND_ISSUES('ingestion', 'GOLD.ADMIN.V_MON_INGESTION', 'Epitaph data: ingestion problem');

create or replace alert GOLD.ADMIN.A_BRONZE_TO_SILVER warehouse = WH_TRANSFORMATION schedule = '15 minute'
  if (exists (select 1 from GOLD.ADMIN.V_MON_TRANSFORMATION))
  then call GOLD.CONTROL.SEND_ISSUES('transformation', 'GOLD.ADMIN.V_MON_TRANSFORMATION', 'Epitaph data: transformation problem');

create or replace alert GOLD.ADMIN.A_SILVER_TO_GOLD warehouse = WH_TRANSFORMATION schedule = '15 minute'
  if (exists (select 1 from GOLD.ADMIN.V_MON_PUBLISHING))
  then call GOLD.CONTROL.SEND_ISSUES('publishing', 'GOLD.ADMIN.V_MON_PUBLISHING', 'Epitaph data: publishing problem');

create or replace alert GOLD.ADMIN.A_GOLD_TO_DOWNSTREAM warehouse = WH_TRANSFORMATION schedule = '30 minute'
  if (exists (select 1 from GOLD.ADMIN.V_MON_DOWNSTREAM))
  then call GOLD.CONTROL.SEND_ISSUES('downstream', 'GOLD.ADMIN.V_MON_DOWNSTREAM', 'Epitaph data: dashboard queries failing');

create or replace alert GOLD.ADMIN.A_DATA_FRESHNESS warehouse = WH_TRANSFORMATION
  schedule = 'USING CRON 0 8-20 * * * America/Toronto'
  if (exists (select 1 from GOLD.ADMIN.V_MON_FRESHNESS))
  then call GOLD.CONTROL.SEND_ISSUES('freshness', 'GOLD.ADMIN.V_MON_FRESHNESS', 'Epitaph data: source not up to date');

create or replace task GOLD.ADMIN.T_DAILY_PLATFORM_CHECKS warehouse = WH_TRANSFORMATION
  schedule = 'USING CRON 30 6 * * * America/Toronto'
as
begin
  call GOLD.ADMIN.CHECK_STREAM_STALENESS();
  call GOLD.ADMIN.CHECK_WAREHOUSE_STANDARD();
end;

alter alert GOLD.ADMIN.A_SOURCE_TO_BRONZE resume;
alter alert GOLD.ADMIN.A_BRONZE_TO_SILVER resume;
alter alert GOLD.ADMIN.A_SILVER_TO_GOLD resume;
alter alert GOLD.ADMIN.A_GOLD_TO_DOWNSTREAM resume;
alter alert GOLD.ADMIN.A_DATA_FRESHNESS resume;
alter task GOLD.ADMIN.T_DAILY_PLATFORM_CHECKS resume;
