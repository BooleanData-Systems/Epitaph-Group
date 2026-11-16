-- All ad delivery in one shape, with the cut-over rule and the source precedence rule applied.
--   Before a source's cut-over date: TapClicks history.  From the cut-over date: Fivetran or SharePoint.
--   Where two sources report the same platform for the same client (Q001), the preferred source wins.
-- Naming convention parsed here (Client_Campaign_Job_Lang_Country, media buy and creative patterns).
use role EPITAPH_TRANSFORMER;

-- Every live-route source in one shape, before the cut-over rule. Also used by the comparison checks.
create or replace view SILVER.STG.STG_LIVE_DELIVERY as
  select activity_date, source_name, platform, account_id, account_currency, campaign_id, campaign_name,
         media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend,
         video_starts, completed_plays, post_shares, spots, null::varchar as client_hint, 'new_route' as loaded_from
  from SILVER.STG.STG_GOOGLE_ADS
  union all
  select activity_date, source_name, platform, account_id, account_currency, campaign_id, campaign_name,
         media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend,
         video_starts, completed_plays, post_shares, spots, null, 'new_route'
  from SILVER.STG.STG_MICROSOFT_ADS
  union all
  select activity_date, source_name, platform, account_id, account_currency, campaign_id, campaign_name,
         media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend,
         video_starts, completed_plays, post_shares, spots, null, 'new_route'
  from SILVER.STG.STG_FACEBOOK_ADS
  union all
  select activity_date, source_name, platform, account_id, account_currency, campaign_id, campaign_name,
         media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend,
         video_starts, completed_plays, post_shares, spots, client_hint, 'new_route'
  from SILVER.STG.STG_VENDOR_DELIVERY
  -- further Fivetran connectors are added here as their staging views go live (config/connectors.yml)
;

create or replace dynamic table SILVER.STG.INT_AD_DELIVERY
  target_lag = '1 hour' warehouse = WH_TRANSFORMATION
as
with live as (
  select * from SILVER.STG.STG_LIVE_DELIVERY
),
hist as (
  select activity_date, source_name, null as platform, null as account_id, null as account_currency, null as campaign_id,
         campaign_name, null as media_buy_id, media_buy_name, null as creative_id, creative_name,
         sum(impressions) as impressions, sum(clicks) as clicks, sum(spend) as spend,
         sum(video_starts) as video_starts, sum(completed_plays) as completed_plays, 0 as post_shares, 0 as spots,
         null as client_hint, 'tapclicks_history' as loaded_from
  from SILVER.STG.STG_TAPCLICKS_HISTORY
  where conversion_tag_name is null            -- delivery rows only; conversion rows go to INT_CONVERSIONS
  group by all
),
cut as (
  select l.* from live l
  join GOLD.CONTROL.CTL_CUTOVER c on c.source_name = l.source_name
  where c.status in ('testing', 'live') and l.activity_date >= c.cutover_date
  union all
  select h.* from hist h
  left join GOLD.CONTROL.CTL_CUTOVER c on c.source_name = h.source_name
  -- history until the new route is actually live: a source still 'planned' after its date keeps its history (no gap)
  where c.cutover_date is null or c.status not in ('testing', 'live') or h.activity_date < c.cutover_date
),
parsed as (
  select cut.*,
    -- vendor files: the client found in the file (client_hint); everything else: the naming convention
    coalesce(client_hint, split_part(campaign_name, '_', 1))                as client_part,
    split_part(campaign_name, '_', 2)                                       as campaign_part,
    split_part(campaign_name, '_', 3)                                       as job_number,
    split_part(campaign_name, '_', 4)                                       as language,
    split_part(campaign_name, '_', 5)                                       as country,
    nullif(split_part(media_buy_name, '_', 4), '')                          as media_type_raw,
    nullif(split_part(split_part(media_buy_name, '_', 5), '-', 1), '')      as tactic,
    nullif(trim(split_part(media_buy_name, '_', 8)), '')                    as audience,
    nullif(split_part(creative_name, '_', 7), '')                           as creative_format,
    nullif(split_part(creative_name, '_', 9), '')                           as call_to_action,
    regexp_like(campaign_name, '^[^_]+_[^_]+_[0-9]{4}-[0-9]+_[A-Za-z]{2}_[A-Za-z]{2}$') as campaign_name_valid
  from cut
),
-- Q001: days on which a preferred source has data for a client
preferred_days as (
  select distinct sp.suppressed_source, p.client_part, p.activity_date
  from parsed p
  join GOLD.CONTROL.CTL_SOURCE_PRECEDENCE sp
    on sp.preferred_source = p.source_name
   and (sp.client_pattern = '*' or p.client_part ilike replace(sp.client_pattern, '*', '%'))
)
select p.*, coalesce(mt.media_type, 'Unclassified') as media_type, coalesce(mt.channel, 'Unclassified') as channel
from parsed p
left join GOLD.CONTROL.MAP_MEDIA_TYPE mt on mt.raw_value = p.media_type_raw
left join preferred_days pd
  on pd.suppressed_source = p.source_name and pd.client_part = p.client_part and pd.activity_date = p.activity_date
-- archive (A12): an archived former client's rows before its archive date leave the live path (they sit in GOLD.ARCHIVE)
left join GOLD.CONTROL.CTL_ARCHIVE_STATE ar
  on ar.state = 'archived' and lower(ar.client_name) = lower(p.client_part) and p.activity_date < ar.archive_before
-- drop a suppressed source's row only when the preferred source covers that client and day
where pd.suppressed_source is null and ar.client_code is null;

-- Every live-route conversion source in one shape, before the cut-over rule
create or replace view SILVER.STG.STG_LIVE_CONVERSIONS as
  select activity_date, source_name, platform, account_id, campaign_id, campaign_name, campaign_type, conversion_tag_name,
         conversions, all_conversions, conversion_value, view_through_conversions, 'new_route' as loaded_from
  from SILVER.STG.STG_GOOGLE_ADS_CONVERSIONS
  union all
  select activity_date, source_name, platform, account_id, campaign_id, campaign_name, campaign_type, conversion_tag_name,
         conversions, all_conversions, conversion_value, view_through_conversions, 'new_route'
  from SILVER.STG.STG_FACEBOOK_ADS_CONVERSIONS
;

create or replace dynamic table SILVER.STG.INT_CONVERSIONS
  target_lag = '1 hour' warehouse = WH_TRANSFORMATION
as
with hist as (
  select activity_date, source_name, null as platform, null as account_id, null as campaign_id, campaign_name,
         null as campaign_type, conversion_tag_name,
         sum(conversions) as conversions, sum(conversions) as all_conversions, 0 as conversion_value,
         0 as view_through_conversions, 'tapclicks_history' as loaded_from
  from SILVER.STG.STG_TAPCLICKS_HISTORY
  where conversion_tag_name is not null
  group by all
),
cut as (
  select l.* from SILVER.STG.STG_LIVE_CONVERSIONS l
  join GOLD.CONTROL.CTL_CUTOVER c on c.source_name = l.source_name
  where c.status in ('testing', 'live') and l.activity_date >= c.cutover_date
  union all
  select h.* from hist h
  left join GOLD.CONTROL.CTL_CUTOVER c on c.source_name = h.source_name
  where c.cutover_date is null or c.status not in ('testing', 'live') or h.activity_date < c.cutover_date
),
withclient as (
  select cut.*, split_part(campaign_name, '_', 1) as client_part from cut
),
-- Q001: the same precedence rule as delivery, so overlapping sources do not double conversions
preferred_days as (
  select distinct sp.suppressed_source, w.client_part, w.activity_date
  from withclient w
  join GOLD.CONTROL.CTL_SOURCE_PRECEDENCE sp
    on sp.preferred_source = w.source_name
   and (sp.client_pattern = '*' or w.client_part ilike replace(sp.client_pattern, '*', '%'))
)
select w.*
from withclient w
left join preferred_days pd
  on pd.suppressed_source = w.source_name and pd.client_part = w.client_part and pd.activity_date = w.activity_date
left join GOLD.CONTROL.CTL_ARCHIVE_STATE ar
  on ar.state = 'archived' and lower(ar.client_name) = lower(w.client_part) and w.activity_date < ar.archive_before
where pd.suppressed_source is null and ar.client_code is null;
