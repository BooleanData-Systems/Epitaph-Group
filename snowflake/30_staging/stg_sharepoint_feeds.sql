-- SharePoint feeds, typed. BRONZE keeps every row as delivered (RECORD variant); here each feed gets its columns.
-- Column names are the normalised headers (lower case, underscores) as they appear in the real files, checked on
-- the sample files Epitaph sent on 2 Nov 2026. A renamed column shows up as NULL and fails the not-null check in 60_checks.
--
-- Two rules apply to every feed:
--   1. Only the latest version of each file counts (same ITEM_ID loaded again: older rows dropped).
--   2. Many reports repeat a rolling window (the Adobe exports carry 30 days, the Sonnet emails about a week).
--      For each feed and day, only the newest file counts, so overlapping files never double count.
use role EPITAPH_TRANSFORMER;

create or replace function SILVER.STG.NUM(v variant) returns number(38,6) as
$$ try_to_decimal(nullif(trim(replace(replace(replace(v::varchar, ',', ''), '$', ''), '%', '')), 'null'), 38, 6) $$;

-- Dates arrive as 2026-10-01, 10/01/2026, 10/01/26, 2026/10/01, Oct 1, 2026, October 1, 2026, Oct 2026.
-- Two-digit years are matched first so 10/01/26 never becomes the year 26.
create or replace function SILVER.STG.DAY(v variant) returns date as
$$
  case
    when regexp_like(trim(v::varchar), '[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}') then try_to_date(trim(v::varchar), 'MM/DD/YY')
    else coalesce(try_to_date(v::varchar, 'YYYY-MM-DD'), try_to_date(v::varchar, 'MM/DD/YYYY'), try_to_date(v::varchar, 'YYYY/MM/DD'),
                  try_to_date(v::varchar, 'MON DD YYYY'), try_to_date(v::varchar, 'MON DD, YYYY'), try_to_date(v::varchar, 'MMMM DD, YYYY'),
                  try_to_date(left(v::varchar, 10), 'YYYY-MM-DD'), try_to_date(v::varchar, 'YYYY-MM'), try_to_date(v::varchar, 'MON YYYY'))
  end
$$;

-- Text as delivered, with the strings the exports use for "nothing" turned into NULL
create or replace function SILVER.STG.TXT(v variant) returns varchar as
$$ nullif(nullif(nullif(trim(v::varchar), ''), 'null'), '-') $$;

-- Latest version of every file
create or replace view SILVER.STG.SP_LATEST_FILES as
select item_id, etag, logged_at
from BRONZE.LOADER.LOAD_LOG
where status = 'loaded'
qualify row_number() over (partition by item_id order by logged_at desc) = 1;

-- Client names and the short names used in vendor campaign names (KHP, Sonnet, Kicking Horse), from the
-- Master Client Index (mci_identifiers.sql): whole-word identifiers only
create or replace view SILVER.STG.CLIENT_NAME_MATCH as
select distinct c.client_name, i.id_norm as alias
from SILVER.STG.MCI_IDENTIFIERS i
join GOLD.CONTROL.MCI_CLIENT c on c.client_code = i.client_code
where i.id_type in ('alias', 'campaign_token');

-- ---------------------------------------------------------------- vendor delivery files -> ad delivery shape
-- One block per file layout. client_hint: the client for single-client files; for shared vendor files the client
-- whose name (or short name) appears as a whole word in the campaign name. INT_AD_DELIVERY uses it before the
-- naming convention. Spend is NULL where the vendor file has none (Silverpush, Jolt).
create or replace view SILVER.STG.STG_VENDOR_DELIVERY as
with v as (
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Silverpush - Automated Report' as source_name, 'Silverpush' as platform,
         SILVER.STG.DAY(record:date) as activity_date, null::varchar as fixed_client,
         SILVER.STG.TXT(record:advertiser) as campaign_name, SILVER.STG.TXT(record:line_item) as media_buy_name,
         SILVER.STG.TXT(record:line_item_id) as media_buy_id, null::varchar as creative_name,
         SILVER.STG.NUM(record:impressions) as impressions, SILVER.STG.NUM(record:clicks) as clicks, null::number as spend,
         SILVER.STG.NUM(record:starts_video) as video_starts, SILVER.STG.NUM(record:complete_views_video) as completed_plays,
         null::number as spots, null::varchar as currency
  from BRONZE.SHAREPOINT.SILVERPUSH r where feed_id = 'F09'
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Silverpush - CTV', 'Silverpush', SILVER.STG.DAY(record:date), null,
         SILVER.STG.TXT(record:advertiser), null, null, SILVER.STG.TXT(record:creative),
         SILVER.STG.NUM(record:impressions), null, null,
         SILVER.STG.NUM(record:player_starts), SILVER.STG.NUM(record:player_completed_views), null, null
  from BRONZE.SHAREPOINT.SILVERPUSH r where feed_id = 'F10'
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'HiveStack', 'HiveStack', SILVER.STG.DAY(record:date), null,
         SILVER.STG.TXT(record:campaign), SILVER.STG.TXT(record:line_item), null, SILVER.STG.TXT(record:creative),
         SILVER.STG.NUM(record:impressions), null, SILVER.STG.NUM(record:spend),
         null, null, SILVER.STG.NUM(record:plays), null
  from BRONZE.SHAREPOINT.HIVESTACK r
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Netflix Pause Ads', 'Netflix', SILVER.STG.DAY(record:date), null,
         SILVER.STG.TXT(record:line_item), SILVER.STG.TXT(record:line_item), null, SILVER.STG.TXT(record:creative),
         SILVER.STG.NUM(record:ad_server_impressions), SILVER.STG.NUM(record:ad_server_clicks),
         SILVER.STG.NUM(record:ad_server_cpm_and_cpc_revenue), null, null, null, null
  from BRONZE.SHAREPOINT.NETFLIX_PAUSE_ADS r
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Jolt Media', 'Jolt Media', SILVER.STG.DAY(record:day), null,
         SILVER.STG.TXT(record:order_name), SILVER.STG.TXT(record:venue_name), SILVER.STG.TXT(record:venue_id), SILVER.STG.TXT(record:creative),
         SILVER.STG.NUM(record:impressions), null, null, null, null, SILVER.STG.NUM(record:spots), null
  from BRONZE.SHAREPOINT.JOLT_MEDIA r
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Spotify - Cobs Bread', 'Spotify', SILVER.STG.DAY(record:date), null,
         SILVER.STG.TXT(record:campaign_name), SILVER.STG.TXT(record:ad_set_name), SILVER.STG.TXT(record:ad_set_id), null,
         SILVER.STG.NUM(record:impressions), SILVER.STG.NUM(record:clicks), SILVER.STG.NUM(record:spend),
         null, null, null, null
  from BRONZE.SHAREPOINT.SPOTIFY_FILES r
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Sonnet - Direct Buy Offline Spend', 'Direct', SILVER.STG.DAY(record:date), null,
         'Sonnet Direct Buy ' || coalesce(SILVER.STG.TXT(record:channel), ''), SILVER.STG.TXT(record:province), null, null,
         0, 0, SILVER.STG.NUM(coalesce(record:grouped_spend, record:spend)), null, null, null, null
  from BRONZE.SHAREPOINT.DIRECT_BUY_SPEND r
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Sonnet - DV360 Creative', 'DV360', SILVER.STG.DAY(record:date), null,
         SILVER.STG.TXT(record:insertion_order), SILVER.STG.TXT(record:line_item), SILVER.STG.TXT(record:line_item_id), SILVER.STG.TXT(record:youtube_ad),
         SILVER.STG.NUM(record:impressions), SILVER.STG.NUM(record:clicks), SILVER.STG.NUM(record:media_cost_advertiser_currency),
         null, SILVER.STG.NUM(record:complete_views_video), null, SILVER.STG.TXT(record:advertiser_currency)
  from BRONZE.SHAREPOINT.SONNET_DV360_CREATIVE r
  union all
  select r.item_id, r.etag, r.file_name, r.row_number, r.feed_id, 'Wildbrain 2.0', 'WildBrain', SILVER.STG.DAY(record:date), null,
         coalesce(SILVER.STG.TXT(record:campaign_name), SILVER.STG.TXT(record:campaign)), SILVER.STG.TXT(record:line_item), null,
         coalesce(SILVER.STG.TXT(record:creative_name), SILVER.STG.TXT(record:creative)),
         SILVER.STG.NUM(record:impressions), SILVER.STG.NUM(record:clicks), SILVER.STG.NUM(record:spend),
         SILVER.STG.NUM(record:starts), SILVER.STG.NUM(record:completed_plays), null, null
  from BRONZE.SHAREPOINT.WILDBRAIN r
),
newest as (
  select v.*, f.logged_at
  from v join SILVER.STG.SP_LATEST_FILES f on f.item_id = v.item_id and f.etag = v.etag
  qualify dense_rank() over (partition by v.source_name, v.activity_date order by f.logged_at desc, v.item_id desc) = 1
),
named as (
  -- a single-client feed takes its client from the MCI feed list; a shared vendor file from the client named in the campaign
  select n.*, coalesce(fc.client_name, m.client_name) as matched_client
  from newest n
  left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = n.feed_id
  left join SILVER.STG.CLIENT_NAME_MATCH m
    on fc.feed_id is null
   and ' ' || regexp_replace(lower(n.campaign_name), '[^a-z0-9]+', ' ') || ' '
       like '% ' || m.alias || ' %'
  qualify row_number() over (partition by n.item_id, n.row_number order by length(m.alias) desc nulls last) = 1
)
select
  activity_date, source_name, platform,
  null::varchar                                                   as account_id,
  -- US_ campaign prefix = a US-dollar buy (Spotify, Silverpush US); otherwise the currency in the file, else CAD
  case when upper(left(campaign_name, 3)) = 'US_' then 'USD' else coalesce(currency, 'CAD') end as account_currency,
  null::varchar                                                   as campaign_id,
  campaign_name, media_buy_id, media_buy_name,
  null::varchar                                                   as creative_id,
  creative_name,
  coalesce(impressions, 0) as impressions, coalesce(clicks, 0) as clicks, coalesce(spend, 0) as spend,
  coalesce(video_starts, 0) as video_starts, coalesce(completed_plays, 0) as completed_plays,
  0 as post_shares, coalesce(spots, 0) as spots,
  coalesce(fixed_client, matched_client)                          as client_hint,
  spend is null                                                   as spend_missing,
  file_name, item_id, feed_id, logged_at
from named;

-- Amazon DSP reach and frequency (K09 open): kept apart, never summed with delivery
create or replace view SILVER.STG.STG_AMAZON_DSP_REACH as
select SILVER.STG.DAY(record:date) as activity_date, 'Amazon DSP' as source_name, fc.client_code,
       SILVER.STG.TXT(record:campaign_id) as campaign_id, SILVER.STG.TXT(record:campaign_name) as campaign_name,
       SILVER.STG.TXT(record:ad_group_id) as ad_group_id, SILVER.STG.TXT(record:ad_group_name) as ad_group_name,
       SILVER.STG.NUM(record:user_reach) as reach, SILVER.STG.NUM(record:average_user_impression_frequency) as frequency
from BRONZE.SHAREPOINT.AMAZON_DSP_REACH r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = r.feed_id
qualify dense_rank() over (partition by SILVER.STG.DAY(record:date) order by f.logged_at desc, r.item_id desc) = 1;

-- ---------------------------------------------------------------- Sonnet (K20, K22)
-- Raw Data is the source of truth for Quotes and Binds (K22; quotes and binds can be fractional, as Sonnet sends them).
-- Quote Quality and Group Breakdown split quotes by band and by segment; their totals differ from Raw Data, so each
-- keeps its own column in the fact. Multiline is monthly: customers in the month, split into multiline and monoline.
create or replace view SILVER.STG.STG_SONNET_QUOTES as
with rows_ as (
  select 'raw_data' as file_type, SILVER.STG.DAY(record:quote_date) as activity_date,
         SILVER.STG.TXT(record:pol_province_cd) as province, SILVER.STG.TXT(record:product) as product,
         SILVER.STG.TXT(record:lob) as lob, SILVER.STG.TXT(record:channel_grouping) as channel,
         SILVER.STG.TXT(record:utm_source) as utm_source, null::varchar as segment,
         SILVER.STG.NUM(record:quotes) as quotes, SILVER.STG.NUM(record:binds) as binds, r.item_id, r.feed_id, f.logged_at
  from BRONZE.SHAREPOINT.SONNET_RAW_DATA r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
  union all
  select 'quote_quality', SILVER.STG.DAY(record:quote_date), SILVER.STG.TXT(record:pol_province_cd), null, null,
         SILVER.STG.TXT(record:channel_grouping), SILVER.STG.TXT(record:utm_source),
         upper(left(SILVER.STG.TXT(record:pvm), 1)) || lower(substr(SILVER.STG.TXT(record:pvm), 2)),  -- red -> Red
         SILVER.STG.NUM(record:quotes), null, r.item_id, r.feed_id, f.logged_at
  from BRONZE.SHAREPOINT.SONNET_QUOTE_QUALITY r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
  union all
  select 'group_breakdown', SILVER.STG.DAY(record:quote_date), SILVER.STG.TXT(record:pol_province_cd), null, null, null,
         SILVER.STG.TXT(record:utm_source), SILVER.STG.TXT(record:segment),
         SILVER.STG.NUM(record:quotes), null, r.item_id, r.feed_id, f.logged_at
  from BRONZE.SHAREPOINT.SONNET_GROUP_BREAKDOWN r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
  union all
  select 'multiline', date_trunc('month', SILVER.STG.DAY(record:month)), SILVER.STG.TXT(record:pol_province_cd), null, null,
         SILVER.STG.TXT(record:channel), SILVER.STG.TXT(record:utm_source), 'Multiline',
         SILVER.STG.NUM(record:multiline_customer), null, r.item_id, r.feed_id, f.logged_at
  from BRONZE.SHAREPOINT.SONNET_MULTILINE r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
  union all
  select 'multiline', date_trunc('month', SILVER.STG.DAY(record:month)), SILVER.STG.TXT(record:pol_province_cd), null, null,
         SILVER.STG.TXT(record:channel), SILVER.STG.TXT(record:utm_source), 'Monoline',
         SILVER.STG.NUM(record:customer_count) - coalesce(SILVER.STG.NUM(record:multiline_customer), 0), null, r.item_id, r.feed_id, f.logged_at
  from BRONZE.SHAREPOINT.SONNET_MULTILINE r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
)
select rows_.activity_date, fc.client_code, rows_.province, rows_.product, rows_.lob, rows_.channel, rows_.utm_source,
       rows_.segment, rows_.quotes, rows_.binds, rows_.file_type
from rows_
left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = rows_.feed_id
qualify dense_rank() over (partition by rows_.file_type, rows_.activity_date order by rows_.logged_at desc, rows_.item_id desc) = 1;

-- Auction Insights (K17, K18). Google shows small and large shares as "< 10%" and "> 90%": the text is kept as
-- reported (what the dashboards show) and the number is NULL for those rows, so nothing is ever averaged from a bound.
create or replace view SILVER.STG.STG_SONNET_AUCTION as
select r.feed_id, fc.client_code, r.grain,
       SILVER.STG.DAY(coalesce(record:week, record:month, record:date)) as period_start,
       SILVER.STG.TXT(record:account_name) as account_name,
       SILVER.STG.TXT(record:customer_id)  as customer_id,
       SILVER.STG.TXT(record:display_url_domain) as competitor_domain,
       SILVER.STG.TXT(coalesce(record:campaign, record:campaign_name)) as campaign_name,
       SILVER.STG.NUM(coalesce(record:search_impr_share, record:search_impr_share_auction_insights)) as search_impr_share,
       SILVER.STG.NUM(record:click_share)              as click_share,
       SILVER.STG.NUM(record:impr_abs_top)             as impr_abs_top_pct,
       SILVER.STG.NUM(record:search_lost_is_budget)    as search_lost_is_budget,
       SILVER.STG.NUM(record:search_lost_is_rank)      as search_lost_is_rank,
       SILVER.STG.TXT(coalesce(record:search_impr_share, record:search_impr_share_auction_insights)) as search_impr_share_reported,
       SILVER.STG.TXT(record:click_share)              as click_share_reported,
       SILVER.STG.TXT(record:impr_abs_top)             as impr_abs_top_reported,
       SILVER.STG.TXT(record:search_lost_is_budget)    as search_lost_is_budget_reported,
       SILVER.STG.TXT(record:search_lost_is_rank)      as search_lost_is_rank_reported
from (
  select * from BRONZE.SHAREPOINT.SONNET_AUCTION_PRESSURE
  union all select * from BRONZE.SHAREPOINT.SONNET_VISIBILITY
  union all select * from BRONZE.SHAREPOINT.SONNET_VS_COMPETITION
) r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = r.feed_id
qualify dense_rank() over (partition by r.feed_id, SILVER.STG.DAY(coalesce(record:week, record:month, record:date))
                           order by f.logged_at desc, r.item_id desc) = 1;

-- ---------------------------------------------------------------- SiriusXM (Adobe and Scorecard)
-- Adobe reports (feed setting "report"):
--   commuter_activations, commuter_starts: Visits by campaign code (PERF1246, COMMCA1246, PARTNER1246)
--   streaming_starts, dual_offer_streaming: Visits = performance flow starts, Orders = performance trials
--   organic_streaming: Starts = organic flow starts, 4th column = organic trials (header row holds a total; see feeds.yml)
-- Adobe repeats some values ("paidsearch,paidsearch"): the first value is used.
create or replace view SILVER.STG.STG_SXM as
with a as (
  select r.report, r.feed_id, SILVER.STG.DAY(coalesce(record:date, record:day)) as activity_date,
         split_part(SILVER.STG.TXT(record:utm_medium_v27_evar27), ',', 1) as channel,
         coalesce(split_part(SILVER.STG.TXT(record:online_campaign_code_v70_evar70), ',', 1),
                  SILVER.STG.TXT(record:program_code_v98_evar98), SILVER.STG.TXT(record:segment)) as campaign_name,
         split_part(SILVER.STG.TXT(record:utm_source_v26_evar26), ',', 1) as utm_source,
         SILVER.STG.NUM(record:visits) as visits, SILVER.STG.NUM(record:orders) as orders,
         SILVER.STG.NUM(record:starts) as starts, SILVER.STG.NUM(record:trials) as trials,
         r.item_id, f.logged_at
  from BRONZE.SHAREPOINT.SXM_ADOBE r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
  qualify dense_rank() over (partition by r.report, SILVER.STG.DAY(coalesce(record:date, record:day))
                             order by f.logged_at desc, r.item_id desc) = 1
)
select a.activity_date, fc.client_code, a.report, a.channel, a.campaign_name, a.utm_source,
       iff(report in ('streaming_starts', 'dual_offer_streaming'), orders, null) as performance_trials,
       iff(report = 'organic_streaming', trials, null)                          as organic_trials,
       iff(report in ('streaming_starts', 'dual_offer_streaming'), visits, null) as performance_flow_starts,
       iff(report = 'organic_streaming', starts, null)                          as organic_flow_starts,
       iff(report = 'commuter_starts', visits, null)                            as commuter_starts,
       iff(report = 'commuter_activations', visits, null)                       as commuter_activations,
       null::number                                                             as scorecard_trials
from a
left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = a.feed_id
union all
select SILVER.STG.DAY(record:activation_date), fc.client_code, 'scorecard', SILVER.STG.TXT(record:plan_description),
       SILVER.STG.TXT(record:promo_code), null,
       null, null, null, null, null, null, SILVER.STG.NUM(record:total_trial_starts)
from BRONZE.SHAREPOINT.SXM_SCORECARD r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = r.feed_id
qualify dense_rank() over (partition by SILVER.STG.DAY(record:activation_date) order by f.logged_at desc, r.item_id desc) = 1;

-- ---------------------------------------------------------------- Adara (Ottawa Tourism, K13)
-- K13 as agreed: Travel Search Signals = enriched flight + enriched hotel searches;
-- Attributed Books = enriched flight + enriched hotel bookings. One row per tracker and attribution type (cl / imp).
create or replace view SILVER.STG.STG_ADARA as
select SILVER.STG.DAY(record:date) as activity_date, fc.client_code,
       SILVER.STG.TXT(record:attribution_group_name) as campaign_name,
       SILVER.STG.TXT(record:tracker_name)           as tracker_name,
       SILVER.STG.TXT(record:attribution_type)       as attribution_type,
       SILVER.STG.NUM(record:site_visits) as site_visits,
       SILVER.STG.NUM(record:flight_searches) as flight_searches, SILVER.STG.NUM(record:flight_bookings) as flight_bookings,
       SILVER.STG.NUM(record:hotel_searches) as hotel_searches, SILVER.STG.NUM(record:hotel_bookings) as hotel_bookings,
       SILVER.STG.NUM(record:uniques_reached) as uniques_reached, SILVER.STG.NUM(record:impressions_clicks) as impressions_per_clicks,
       coalesce(SILVER.STG.NUM(record:enriched_flight_searches), 0) + coalesce(SILVER.STG.NUM(record:enriched_hotel_searches), 0) as travel_search_signals,
       coalesce(SILVER.STG.NUM(record:enriched_flight_bookings), 0) + coalesce(SILVER.STG.NUM(record:enriched_hotel_bookings), 0) as attributed_books
from BRONZE.SHAREPOINT.ADARA r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
left join SILVER.STG.MCI_FEED_CLIENT fc on fc.feed_id = r.feed_id
qualify dense_rank() over (partition by SILVER.STG.DAY(record:date) order by f.logged_at desc, r.item_id desc) = 1;

-- ---------------------------------------------------------------- Goals (K12)
-- The Goal Smart Connector file: one row per day and goal line, e.g.
--   "Conexus - Investing Awr 2026 - Meta Impression Goal", 54,087.28
-- Client = text before the first " - "; smart campaign = the middle part; platform and metric from the last part.
-- Daily goals are summed to the month. Only impression goals arrive in this file today.
create or replace view SILVER.STG.STG_GOALS as
with g as (
  select SILVER.STG.DAY(record:date) as goal_date,
         SILVER.STG.TXT(record:campaign_name) as goal_line,
         SILVER.STG.NUM(coalesce(record:impressions_goal, record:goal)) as goal_value,
         r.item_id, f.logged_at
  from BRONZE.SHAREPOINT.GOALS r join SILVER.STG.SP_LATEST_FILES f using (item_id, etag)
  qualify dense_rank() over (partition by SILVER.STG.DAY(record:date) order by f.logged_at desc, r.item_id desc) = 1
)
select trim(split_part(goal_line, ' - ', 1))                                as client,
       trim(split_part(goal_line, ' - ', 2))                                as smart_campaign,
       trim(split_part(trim(split_part(goal_line, ' - ', 3)), ' ', 1))      as platform,
       date_trunc('month', goal_date)                                       as period_month,
       case when goal_line ilike '%impression goal%' then 'impressions'
            when goal_line ilike '%click goal%'      then 'clicks'
            when goal_line ilike '%spend goal%'      then 'spend'
            when goal_line ilike '%quote goal%'      then 'quotes'
            when goal_line ilike '%trial goal%'      then 'trials'
            when goal_line ilike '%cpq goal%'        then 'cpq'
            else 'unknown' end                                              as goal_metric,
       goal_value
from g;
