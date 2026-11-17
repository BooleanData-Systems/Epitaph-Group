-- requires: BRONZE.FIVETRAN_TIKTOK_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_tiktok_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- TikTok Ads
create or replace view SILVER.STG.STG_TIKTOK_ADS as
select
  r.stat_time_day::date as activity_date, 'TikTok Ads' as source_name, 'TikTok' as platform,
  ad.advertiser_id::varchar as account_id, null::varchar as account_currency,
  ad.campaign_id::varchar as campaign_id, c.campaign_name,
  ad.adgroup_id::varchar as media_buy_id, g.adgroup_name as media_buy_name,
  r.ad_id::varchar as creative_id, ad.ad_name as creative_name,
  r.impressions, r.clicks, r.spend,
  coalesce(r.video_play_actions, 0) as video_starts, coalesce(r.video_watched_p_100, 0) as completed_plays,
  coalesce(r.shares, 0) as post_shares, 0 as spots
from BRONZE.FIVETRAN_TIKTOK_ADS.AD_REPORT_DAILY r
left join (select * from BRONZE.FIVETRAN_TIKTOK_ADS.AD_HISTORY qualify row_number() over (partition by ad_id order by _fivetran_synced desc) = 1) ad on ad.ad_id = r.ad_id
left join (select * from BRONZE.FIVETRAN_TIKTOK_ADS.ADGROUP_HISTORY qualify row_number() over (partition by adgroup_id order by _fivetran_synced desc) = 1) g on g.adgroup_id = ad.adgroup_id
left join (select * from BRONZE.FIVETRAN_TIKTOK_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by campaign_id order by _fivetran_synced desc) = 1) c on c.campaign_id = ad.campaign_id;
