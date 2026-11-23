-- requires: BRONZE.TIKTOK_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_tiktok_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- TikTok Ads
-- Two parts, so every dollar keeps a campaign and a client:
--   1. ads found in AD_HISTORY: full ad, ad group and campaign detail from AD_REPORT_DAILY.
--   2. the rest of each campaign's day: CAMPAIGN_REPORT_DAILY minus the matched ads. TikTok's ad list (via Fivetran)
--      leaves out some newer ads, so their spend is kept at campaign level, with ad group and ad left empty.
-- Totals per campaign and day therefore equal TikTok's own campaign totals.
create or replace view SILVER.STG.STG_TIKTOK_ADS as
with ads as (
  select * from BRONZE.TIKTOK_ADS.AD_HISTORY qualify row_number() over (partition by ad_id order by _fivetran_synced desc) = 1
),
groups as (
  select * from BRONZE.TIKTOK_ADS.ADGROUP_HISTORY qualify row_number() over (partition by adgroup_id order by _fivetran_synced desc) = 1
),
campaigns as (
  select * from BRONZE.TIKTOK_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by campaign_id order by _fivetran_synced desc) = 1
),
matched as (
  select r.stat_time_day::date as activity_date, ad.advertiser_id, ad.campaign_id, ad.adgroup_id, r.ad_id, ad.ad_name,
         r.impressions, r.clicks, r.spend,
         coalesce(r.video_play_actions, 0) as video_starts, coalesce(r.video_views_p_100, 0) as completed_plays,
         coalesce(r.shares, 0) as post_shares
  from BRONZE.TIKTOK_ADS.AD_REPORT_DAILY r
  join ads ad on ad.ad_id = r.ad_id
),
matched_by_campaign as (
  select activity_date, campaign_id, sum(impressions) as impressions, sum(clicks) as clicks, sum(spend) as spend,
         sum(video_starts) as video_starts, sum(completed_plays) as completed_plays, sum(post_shares) as post_shares
  from matched group by 1, 2
),
remainder as (
  select cr.stat_time_day::date as activity_date, cr.campaign_id,
         coalesce(cr.impressions, 0) - coalesce(m.impressions, 0) as impressions,
         coalesce(cr.clicks, 0) - coalesce(m.clicks, 0) as clicks,
         coalesce(cr.spend, 0) - coalesce(m.spend, 0) as spend,
         coalesce(cr.video_play_actions, 0) - coalesce(m.video_starts, 0) as video_starts,
         coalesce(cr.video_views_p_100, 0) - coalesce(m.completed_plays, 0) as completed_plays,
         coalesce(cr.shares, 0) - coalesce(m.post_shares, 0) as post_shares
  from BRONZE.TIKTOK_ADS.CAMPAIGN_REPORT_DAILY cr
  left join matched_by_campaign m on m.campaign_id = cr.campaign_id and m.activity_date = cr.stat_time_day::date
)
select
  m.activity_date, 'TikTok Ads' as source_name, 'TikTok' as platform,
  m.advertiser_id::varchar as account_id, adv.currency as account_currency,
  m.campaign_id::varchar as campaign_id, c.campaign_name,
  m.adgroup_id::varchar as media_buy_id, g.adgroup_name as media_buy_name,
  m.ad_id::varchar as creative_id, m.ad_name as creative_name,
  m.impressions, m.clicks, m.spend, m.video_starts, m.completed_plays, m.post_shares, 0 as spots
from matched m
left join groups g on g.adgroup_id = m.adgroup_id
left join campaigns c on c.campaign_id = m.campaign_id
left join BRONZE.TIKTOK_ADS.ADVERTISER adv on adv.id = m.advertiser_id
union all
select
  r.activity_date, 'TikTok Ads', 'TikTok',
  c.advertiser_id::varchar, adv.currency,
  r.campaign_id::varchar, c.campaign_name,
  null, null, null, null,
  r.impressions, r.clicks, r.spend, r.video_starts, r.completed_plays, r.post_shares, 0
from remainder r
left join campaigns c on c.campaign_id = r.campaign_id
left join BRONZE.TIKTOK_ADS.ADVERTISER adv on adv.id = c.advertiser_id
-- keep only days where the campaign report holds more than the matched ads (rounding differences under a cent are dropped)
where abs(r.spend) >= 0.01 or r.impressions <> 0;
