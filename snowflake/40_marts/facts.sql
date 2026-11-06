-- Facts. Each holds measures only; every rate is computed in the semantic views from these totals (K02).
use role EPITAPH_TRANSFORMER;
use schema GOLD.MARTS;

-- Ad delivery (K01, K04, K06). Spend in the account currency; USD accounts flagged for CAD are converted (Q20).
-- History rows keep the spend TapClicks showed: TapClicks already converted Kids Help Phone USD spend with its
-- exchange-rate sheet, so history is not converted again. The history check (R06) confirms this on the first load.
create or replace dynamic table FCT_AD_DELIVERY_DAILY target_lag = '1 hour' warehouse = WH_TRANSFORMATION
  cluster by (date_key) as
select
  to_number(to_char(a.activity_date, 'YYYYMMDD'))                                as date_key,
  sha2(a.source_name, 256)                                                       as source_key,
  r.client_key,                                                                  -- Master Client Index
  r.client_code,
  sha2(a.campaign_name, 256)                                                     as campaign_key,
  sha2(coalesce(a.media_buy_name, '(none)') || '|' || a.campaign_name, 256)      as media_buy_key,
  sha2(coalesce(a.creative_name, '(none)'), 256)                                 as creative_key,
  a.platform, a.media_type, a.channel,
  sum(a.impressions)                                                             as impressions,
  sum(a.clicks)                                                                  as clicks,
  sum(a.spend)                                                                   as spend_account_currency,
  any_value(coalesce(pa.account_currency, a.account_currency, 'CAD'))            as account_currency,
  sum(iff(a.loaded_from = 'new_route' and pa.convert_to = 'CAD' and coalesce(pa.account_currency, a.account_currency) = 'USD',
          a.spend * fx.rate, a.spend)) as spend,
  any_value(case when a.loaded_from = 'tapclicks_history' then coalesce(cl.reporting_currency, 'CAD')
                 when pa.convert_to is not null then pa.convert_to
                 else coalesce(pa.account_currency, a.account_currency, 'CAD') end) as currency_code,
  sum(a.video_starts)                                                            as video_starts,
  sum(a.completed_plays)                                                         as completed_plays,
  sum(a.post_shares)                                                             as post_shares,
  sum(a.spots)                                                                   as spots,
  any_value(a.loaded_from)                                                       as loaded_from
from SILVER.STG.INT_AD_DELIVERY a
left join GOLD.CONTROL.MAP_PLATFORM_ACCOUNT pa
  on pa.platform = a.source_name and pa.account_id = a.account_id
 and a.activity_date between pa.valid_from and pa.valid_to
left join DIM_FX_RATE fx on fx.date_day = a.activity_date
left join SILVER.STG.MCI_CLIENT_RESOLUTION r on r.mci_key = a.mci_key
left join GOLD.CONTROL.MCI_CLIENT cl on cl.client_code = r.client_code
group by all;

-- Conversions (K10). Kept apart from delivery because platforms report conversions on rows with no spend.
-- The counted actions come from MAP_CONVERSION_TAG (Nathan's T01 to T11 answers). A mapping row may name any platform
-- ('*') and use * in the tag name; when several rows match, the most specific wins: exact platform first, then an
-- exact tag name, then the longest pattern. Unmatched tags count as not counted and are listed in DQ_UNDECIDED_TAGS.
create or replace dynamic table FCT_CONVERSIONS_DAILY target_lag = '1 hour' warehouse = WH_TRANSFORMATION
  cluster by (date_key) as
with conv as (
  -- client from the Master Client Index; a campaign seen only in conversions falls back to its campaign's client
  select c.*, coalesce(r.client_code, dc.client_code) as client_code
  from SILVER.STG.INT_CONVERSIONS c
  left join SILVER.STG.MCI_CLIENT_RESOLUTION r on r.mci_key = c.mci_key
  left join DIM_CAMPAIGN dc on dc.campaign_name = c.campaign_name
),
tag_match as (
  select k.client_code, k.source_name, k.conversion_tag_name, t.conversion_tag_key, t.kpi_group, t.counts_toward_kpi,
         t.valid_from, t.valid_to
  from (select distinct client_code, source_name, conversion_tag_name from conv) k
  join DIM_CONVERSION_TAG t
    on t.client_code = k.client_code
   and (t.platform = k.source_name or t.platform = '*')
   and lower(k.conversion_tag_name) like lower(replace(t.tag_name, '*', '%'))
  qualify row_number() over (
    partition by k.client_code, k.source_name, k.conversion_tag_name, t.valid_from
    order by iff(t.platform = '*', 1, 0), iff(contains(t.tag_name, '*'), 1, 0), length(t.tag_name) desc) = 1
)
select
  to_number(to_char(c.activity_date, 'YYYYMMDD'))   as date_key,
  sha2(c.source_name, 256)                          as source_key,
  sha2(c.client_code, 256)                          as client_key,
  c.client_code,
  sha2(c.campaign_name, 256)                        as campaign_key,
  c.platform, c.campaign_type,
  c.conversion_tag_name,
  t.conversion_tag_key, t.kpi_group,
  coalesce(t.counts_toward_kpi, false)              as counts_toward_kpi,
  sum(c.conversions)                                as conversions,
  sum(c.conversions)                                as platform_conversions,
  sum(c.all_conversions)                            as platform_all_conversions,
  sum(c.conversion_value)                           as revenue,
  sum(c.conversions - coalesce(c.view_through_conversions, 0)) as click_through_conversions,
  sum(c.view_through_conversions)                   as view_through_conversions,
  any_value(c.loaded_from)                          as loaded_from
from conv c
left join tag_match t
  on t.client_code = c.client_code and t.source_name = c.source_name and t.conversion_tag_name = c.conversion_tag_name
 and c.activity_date between t.valid_from and t.valid_to
group by all;

create or replace dynamic table FCT_WEB_SESSIONS_DAILY target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select to_number(to_char(s.activity_date, 'YYYYMMDD')) as date_key,
       pa.client_code, s.property_id, s.ga4_session_source, s.ga4_session_medium, s.ga4_session_campaign,
       s.ga4_manual_ad_content, sum(s.sessions) as sessions
from SILVER.STG.STG_GA4_SESSIONS s
left join SILVER.STG.MCI_IDENTIFIERS pa
  on pa.id_type = 'platform_account' and pa.system = 'GA4' and pa.id_value = s.property_id
 and s.activity_date between pa.valid_from and pa.valid_to
group by all;

-- Reach and frequency (K09, open): never summed across platforms or periods in the semantic layer
create or replace dynamic table FCT_REACH_FREQUENCY target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select to_number(to_char(activity_date, 'YYYYMMDD')) as date_key, source_name, platform,
       sha2(campaign_name, 256) as campaign_key, reach, impressions,
       impressions / nullif(reach, 0) as frequency
from SILVER.STG.STG_FACEBOOK_REACH;

create or replace dynamic table FCT_AUCTION_INSIGHTS target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select period_start, grain, feed_id, client_code, account_name, customer_id, campaign_name, competitor_domain,
       search_impr_share, click_share, impr_abs_top_pct, search_lost_is_budget, search_lost_is_rank,
       search_impr_share_reported, click_share_reported, impr_abs_top_reported,
       search_lost_is_budget_reported, search_lost_is_rank_reported
from SILVER.STG.STG_SONNET_AUCTION;

-- Sonnet quotes (K22: Raw Data is the source of truth for Quotes and Binds). Quote Quality and Group Breakdown split
-- quotes by band and by segment but their totals differ from Raw Data, so each count keeps its own column
-- (quality_quotes, segment_quotes) and is never added to quotes. Multiline rows are monthly (dated the 1st).
create or replace dynamic table FCT_SONNET_QUOTES_DAILY target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select to_number(to_char(activity_date, 'YYYYMMDD')) as date_key, client_code, province, product, channel, utm_source,
       iff(file_type = 'quote_quality', segment, null)   as quality_band,
       iff(file_type = 'multiline', segment, null)       as line_type,
       iff(file_type = 'group_breakdown', segment, null) as segment,
       sum(iff(file_type = 'raw_data', quotes, 0))        as quotes,
       sum(iff(file_type = 'quote_quality', quotes, 0))   as quality_quotes,
       sum(iff(file_type = 'group_breakdown', quotes, 0)) as segment_quotes,
       sum(iff(file_type = 'raw_data', binds, 0))        as binds,
       sum(iff(file_type = 'multiline', quotes, 0))      as customers,
       file_type
from SILVER.STG.STG_SONNET_QUOTES
group by all;

create or replace dynamic table FCT_SXM_SCORECARD target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select to_number(to_char(activity_date, 'YYYYMMDD')) as date_key, client_code, report, channel, campaign_name,
       sum(performance_trials) as performance_trials, sum(organic_trials) as organic_trials,
       sum(performance_flow_starts) as performance_flow_starts, sum(organic_flow_starts) as organic_flow_starts,
       sum(commuter_starts) as commuter_starts, sum(commuter_activations) as commuter_activations,
       sum(scorecard_trials) as scorecard_trials
from SILVER.STG.STG_SXM group by all;

create or replace dynamic table FCT_ADARA_DAILY target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select to_number(to_char(activity_date, 'YYYYMMDD')) as date_key, client_code, campaign_name, tracker_name, attribution_type,
       sum(site_visits) as site_visits, sum(flight_searches) as flight_searches, sum(flight_bookings) as flight_bookings,
       sum(hotel_searches) as hotel_searches, sum(hotel_bookings) as hotel_bookings,
       sum(travel_search_signals) as travel_search_signals, sum(attributed_books) as attributed_books,
       max(uniques_reached) as uniques_reached, max(impressions_per_clicks) as impressions_per_clicks
from SILVER.STG.STG_ADARA group by all;

-- Goals (K12) and budget: shown next to actuals, never added to them
create or replace dynamic table FCT_GOALS target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select g.period_month, c.client_code, g.smart_campaign, g.platform, g.goal_metric, sum(g.goal_value) as goal_value
from SILVER.STG.STG_GOALS g
-- client named at the start of the goal line, found in the Master Client Index (client name or short name)
left join (select lower(id_value) as id_value, client_code from SILVER.STG.MCI_IDENTIFIERS
           where id_type in ('campaign_prefix', 'alias')
           qualify row_number() over (partition by lower(id_value) order by match_rank, client_code) = 1) c
  on c.id_value = lower(g.client)
group by all;

create table if not exists FCT_BUDGET (
  period_month date, client_code varchar, smart_campaign varchar, platform varchar,
  budget_amount number(18,2), currency_code varchar(3), source varchar
) comment = 'Budget source still open with Epitaph. Table ready; loader added once the source is agreed';
