-- Comparison checks: do the new numbers match TapClicks within the agreed tolerances (R02 to R06)?
-- Results go to GOLD.CHECKS.RECON_RESULTS; a dashboard in Omni shows them, and an alert emails on any fail.
-- Output is totals and pass/fail per client, source and period. No row-level data leaves Snowflake.
use role EPITAPH_TRANSFORMER;
use schema GOLD.CHECKS;

create table if not exists RECON_RESULTS (
  run_id        varchar,
  check_name    varchar,         -- live_vs_tapclicks | history_vs_download | widget_baseline
  rule_id       varchar,         -- R02 to R06
  client_part   varchar,
  source_name   varchar,
  period_start  date,
  period_grain  varchar,
  measure       varchar,
  snowflake_value number(38,4),
  tapclicks_value number(38,4),
  diff          number(38,4),
  diff_pct      number(10,4),
  tolerance_pct number(5,2),
  status        varchar,         -- pass | fail | no_tapclicks_data | no_snowflake_data
  cause         varchar,         -- filled by the team when a fail is explained
  checked_at    timestamp_ltz default current_timestamp()
);

-- ---------------------------------------------------------------- live route vs TapClicks (parallel run)
-- Compares the new route with TapClicks downloads for the same days, ignoring the cut-over rule.
create or replace procedure RUN_LIVE_COMPARISON(period_start date, period_end date)
returns varchar language sql execute as owner as
$$
declare run_id varchar default uuid_string();
begin
  insert into GOLD.CHECKS.RECON_RESULTS (run_id, check_name, rule_id, client_part, source_name, period_start, period_grain,
                                          measure, snowflake_value, tapclicks_value, diff, diff_pct, tolerance_pct, status)
  with new_route as (
    select split_part(campaign_name, '_', 1) as client_part, source_name, date_trunc('week', activity_date) as wk,
           sum(spend) spend, sum(impressions) impressions, sum(clicks) clicks,
           sum(video_starts) video_starts, sum(completed_plays) completed_plays
    from SILVER.STG.STG_LIVE_DELIVERY
    where activity_date between :period_start and :period_end
    group by all
  ),
  tc as (
    select split_part(campaign_name, '_', 1) as client_part, source_name, date_trunc('week', activity_date) as wk,
           sum(spend) spend, sum(impressions) impressions, sum(clicks) clicks,
           sum(video_starts) video_starts, sum(completed_plays) completed_plays
    from SILVER.STG.STG_TAPCLICKS_HISTORY
    where activity_date between :period_start and :period_end and conversion_tag_name is null
    group by all
  ),
  joined as (
    select coalesce(n.client_part, t.client_part) client_part, coalesce(n.source_name, t.source_name) source_name,
           coalesce(n.wk, t.wk) wk, m.measure,
           case m.measure when 'spend' then n.spend when 'impressions' then n.impressions when 'clicks' then n.clicks
                          when 'video_starts' then n.video_starts else n.completed_plays end as sf,
           case m.measure when 'spend' then t.spend when 'impressions' then t.impressions when 'clicks' then t.clicks
                          when 'video_starts' then t.video_starts else t.completed_plays end as tcv,
           m.rule_id, m.tol
    from new_route n
    full outer join tc t on t.client_part = n.client_part and t.source_name = n.source_name and t.wk = n.wk
    cross join (select 'spend' measure, 'R02' rule_id, 1.0 tol union all select 'impressions', 'R02', 1.0
                union all select 'clicks', 'R02', 1.0 union all select 'video_starts', 'R03', 2.0
                union all select 'completed_plays', 'R03', 2.0) m
  )
  select :run_id, 'live_vs_tapclicks', rule_id, client_part, source_name, wk, 'week', measure, sf, tcv,
         sf - tcv, iff(tcv = 0, null, (sf - tcv) / tcv * 100), tol,
         case when tcv is null then 'no_tapclicks_data' when sf is null then 'no_snowflake_data'
              when abs(coalesce(sf, 0) - coalesce(tcv, 0)) <= abs(coalesce(tcv, 0)) * tol / 100 then 'pass' else 'fail' end
  from joined
  where coalesce(sf, 0) <> 0 or coalesce(tcv, 0) <> 0;
  return run_id;
end;
$$;

-- ---------------------------------------------------------------- history vs the download (R06: exact, per source and day)
create or replace procedure RUN_HISTORY_CHECK()
returns varchar language sql execute as owner as
$$
declare run_id varchar default uuid_string();
begin
  insert into GOLD.CHECKS.RECON_RESULTS (run_id, check_name, rule_id, client_part, source_name, period_start, period_grain,
                                          measure, snowflake_value, tapclicks_value, diff, diff_pct, tolerance_pct, status)
  with raw_rows as (        -- straight from the downloaded files, latest download per source and month
    select data_source_name as source_name,
           coalesce(try_to_date(activity_date_text, 'MON DD YYYY'), try_to_date(activity_date_text, 'YYYY-MM-DD')) as d,
           spend, impressions, clicks, conversion_tag_name, file_name,
           max(loaded_at) over (partition by file_name) as file_loaded_at
    from BRONZE.TAPCLICKS.TAPCLICKS_HISTORY
    qualify dense_rank() over (partition by data_source_name, date_trunc('month', d) order by file_loaded_at desc, file_name desc) = 1
  ),
  raw_totals as (           -- only the days the model takes from history (before a live cut-over)
    select r.source_name, r.d,
           sum(coalesce(try_to_decimal(replace(replace(r.spend, ',', ''), '$', ''), 18, 4), 0)) as spend,
           sum(coalesce(try_to_number(replace(r.impressions, ',', '')), 0)) as impressions,
           sum(coalesce(try_to_number(replace(r.clicks, ',', '')), 0)) as clicks
    from raw_rows r
    left join GOLD.CONTROL.CTL_CUTOVER c on c.source_name = r.source_name
    where coalesce(r.conversion_tag_name, '') = ''
      and (c.cutover_date is null or c.status not in ('testing', 'live') or r.d < c.cutover_date)
    group by all
  ),
  model_totals as (        -- what the model holds for history days
    select s.source_name, d.date_day as d, sum(f.spend_account_currency) spend, sum(f.impressions) impressions, sum(f.clicks) clicks
    from GOLD.MARTS.FCT_AD_DELIVERY_DAILY f
    join GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key
    join GOLD.MARTS.DIM_SOURCE s on s.source_key = f.source_key
    where f.loaded_from = 'tapclicks_history'
    group by all
  ),
  m as (select 'spend' measure union all select 'impressions' union all select 'clicks')
  select :run_id, 'history_vs_download', 'R06', null, coalesce(r.source_name, t.source_name), coalesce(r.d, t.d), 'day', m.measure,
         case m.measure when 'spend' then t.spend when 'impressions' then t.impressions else t.clicks end,
         case m.measure when 'spend' then r.spend when 'impressions' then r.impressions else r.clicks end,
         null, null, 0, null
  from raw_totals r
  full outer join model_totals t on t.source_name = r.source_name and t.d = r.d
  cross join m;

  -- Days the precedence rule or a recorded correction changed on purpose are not failures
  update GOLD.CHECKS.RECON_RESULTS r set
    diff = coalesce(snowflake_value, 0) - coalesce(tapclicks_value, 0),
    status = case when coalesce(snowflake_value, 0) = coalesce(tapclicks_value, 0) then 'pass'
                  when exists (select 1 from GOLD.CONTROL.CTL_HISTORY_CORRECTIONS c
                               where c.source_name = r.source_name and c.activity_date = r.period_start and c.measure = r.measure) then 'pass'
                  -- a suppressed source differs on purpose only on days its preferred source has data
                  when exists (select 1 from GOLD.CONTROL.CTL_SOURCE_PRECEDENCE p
                               join SILVER.STG.INT_AD_DELIVERY i on i.source_name = p.preferred_source and i.activity_date = r.period_start
                               where p.suppressed_source = r.source_name) then 'expected_difference'
                  else 'fail' end
  where run_id = :run_id;
  return run_id;
end;
$$;

-- Latest result per check, client, source, period and measure: what the checks dashboard shows
create or replace view V_RECON_LATEST as
select * from RECON_RESULTS
qualify row_number() over (partition by check_name, client_part, source_name, period_start, measure order by checked_at desc) = 1;

create or replace view V_RECON_SUMMARY as
select check_name, rule_id, source_name, count(*) as checks,
       count_if(status = 'pass') as passed, count_if(status = 'fail') as failed,
       count_if(status like 'no_%') as missing, max(checked_at) as last_checked
from V_RECON_LATEST group by all;
