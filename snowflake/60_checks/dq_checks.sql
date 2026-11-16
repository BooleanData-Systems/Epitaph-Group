-- Data-quality checks that run every day, plus Snowflake data metric functions on the main facts.
-- Each check is a view: zero rows means healthy. The daily task writes counts to DQ_RESULTS and alerts email on failures.
use role EPITAPH_TRANSFORMER;
use schema GOLD.CHECKS;

-- Freshness: last data date per live source against its expected delay (Q011)
create or replace view DQ_FRESHNESS as
select c.source_name, c.route, max(f.date_day) as last_data_date,
       datediff(day, max(f.date_day), current_date()) as days_behind,
       iff(c.route = 'fivetran', 2, 3) as allowed_days
from GOLD.CONTROL.CTL_CUTOVER c
left join GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY f on f.source_name = c.source_name and f.loaded_from = 'new_route'
where c.status = 'live'
group by c.source_name, c.route
having days_behind > allowed_days or last_data_date is null;

-- Campaigns with spend and no Smart Campaign (Q009): they would be missing from every dashboard
create or replace view DQ_UNMAPPED_CAMPAIGNS as
select campaign_name, client_part, first_seen, last_seen, spend_to_date
from GOLD.MARTS.DIM_CAMPAIGN
where smart_campaign = 'Unmapped' and spend_to_date > 0 and last_seen >= dateadd(day, -90, current_date());

-- Names that break the naming convention
create or replace view DQ_NAMING_EXCEPTIONS as
select 'campaign' as object_type, campaign_name as name, 'Client_Campaign_Job_Lang_Country' as expected, first_seen
from GOLD.MARTS.DIM_CAMPAIGN where not campaign_name_valid and last_seen >= dateadd(day, -90, current_date())
union all
select 'media buy', media_buy_name, 'Client_Campaign_Job_Platform_Tactic-Audience_Lang_Country_Audience', null
from GOLD.MARTS.DIM_MEDIA_BUY where media_type = 'Unclassified' and media_buy_name is not null;

-- Two sources for the same client, platform and day after precedence (Q001): should be empty
create or replace view DQ_SOURCE_OVERLAP as
select client_part, platform, activity_date, count(distinct source_name) as sources, listagg(distinct source_name, ', ') as names
from SILVER.STG.INT_AD_DELIVERY
where platform is not null
group by client_part, platform, activity_date
having count(distinct source_name) > 1;

-- VCR over 100% or completions without starts (Q007)
create or replace view DQ_VCR as
select platform, source_name, date_trunc('week', activity_date) as week, sum(video_starts) starts, sum(completed_plays) completed
from SILVER.STG.INT_AD_DELIVERY
group by all
having sum(completed_plays) > sum(video_starts) and sum(completed_plays) > 0;

-- Negative or impossible values
create or replace view DQ_IMPOSSIBLE_VALUES as
select source_name, activity_date, campaign_name, spend, impressions, clicks
from SILVER.STG.INT_AD_DELIVERY
where spend < 0 or impressions < 0 or clicks < 0 or clicks > impressions * 1.5 and impressions > 100;

-- USD accounts marked for CAD conversion on a day with no exchange rate
create or replace view DQ_MISSING_FX as
select d.date_day from GOLD.MARTS.DIM_FX_RATE d where d.rate is null and d.date_day >= '2020-01-02';

-- Live conversion tags not yet decided (T01 to T11): conversions that count nowhere
create or replace view DQ_UNDECIDED_TAGS as
select c.client_code, f.platform, f.conversion_tag_name, sum(f.platform_conversions) as conversions_90d
from GOLD.MARTS.FCT_CONVERSIONS_DAILY f
join GOLD.MARTS.DIM_CAMPAIGN c on c.campaign_key = f.campaign_key
where f.conversion_tag_key is null and f.date_key >= to_number(to_char(dateadd(day, -90, current_date()), 'YYYYMMDD'))
group by all;

-- Rejected SharePoint files in the last 7 days
create or replace view DQ_REJECTED_FILES as
select feed_id, file_name, reason, logged_at from BRONZE.LOADER.LOAD_LOG
where status = 'rejected' and logged_at >= dateadd(day, -7, current_timestamp());

create table if not exists DQ_RESULTS (check_name varchar, failing_rows number, checked_at timestamp_ltz default current_timestamp());

-- K20 Sonnet files: rows that cannot be right (multiline customers above all customers, or a quality band other than
-- Red, Yellow, Green). Multiline customers are a monthly count of customers, not of quotes (seen on the sample files),
-- so they are not compared with Quotes. Information for the Data Checks page, not an alert.
create or replace view DQ_SONNET_FILES as
select 'monoline below zero' as problem, date_key, province, channel, customers as value
from GOLD.MARTS.FCT_SONNET_QUOTES_DAILY
where line_type = 'Monoline' and customers < 0
union all
select 'unknown quality band', date_key, province, channel, quality_quotes
from GOLD.MARTS.FCT_SONNET_QUOTES_DAILY
where file_type = 'quote_quality' and coalesce(quality_band, '?') not in ('Red', 'Yellow', 'Green');

create or replace procedure RUN_DQ_CHECKS()
returns varchar language sql execute as owner as
$$
begin
  insert into GOLD.CHECKS.DQ_RESULTS (check_name, failing_rows)
            select 'freshness', count(*) from GOLD.CHECKS.DQ_FRESHNESS
  union all select 'unmapped_campaigns', count(*) from GOLD.CHECKS.DQ_UNMAPPED_CAMPAIGNS
  union all select 'naming_exceptions', count(*) from GOLD.CHECKS.DQ_NAMING_EXCEPTIONS
  union all select 'source_overlap', count(*) from GOLD.CHECKS.DQ_SOURCE_OVERLAP
  union all select 'vcr', count(*) from GOLD.CHECKS.DQ_VCR
  union all select 'archive', count(*) from GOLD.CHECKS.DQ_ARCHIVE
  union all select 'impossible_values', count(*) from GOLD.CHECKS.DQ_IMPOSSIBLE_VALUES
  union all select 'missing_fx', count(*) from GOLD.CHECKS.DQ_MISSING_FX
  union all select 'undecided_tags', count(*) from GOLD.CHECKS.DQ_UNDECIDED_TAGS
  union all select 'rejected_files', count(*) from GOLD.CHECKS.DQ_REJECTED_FILES
  union all select 'sonnet_files', count(*) from GOLD.CHECKS.DQ_SONNET_FILES;
  return 'ok';
end;
$$;

-- Snowflake data metric functions on the main fact (row count, freshness, nulls in keys)
alter dynamic table GOLD.MARTS.FCT_AD_DELIVERY_DAILY set data_metric_schedule = 'USING CRON 30 6 * * * America/Toronto';
alter dynamic table GOLD.MARTS.FCT_AD_DELIVERY_DAILY add data metric function SNOWFLAKE.CORE.ROW_COUNT on ();
alter dynamic table GOLD.MARTS.FCT_AD_DELIVERY_DAILY add data metric function SNOWFLAKE.CORE.NULL_COUNT on (campaign_key);
alter dynamic table GOLD.MARTS.FCT_AD_DELIVERY_DAILY add data metric function SNOWFLAKE.CORE.NULL_COUNT on (source_key);
