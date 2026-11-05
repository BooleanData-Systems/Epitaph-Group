-- requires: BRONZE.FIVETRAN_MICROSOFT_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_microsoft_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
use role EPITAPH_TRANSFORMER;

-- Microsoft Advertising
create or replace view SILVER.STG.STG_MICROSOFT_ADS as
select
  r.date::date as activity_date, 'Microsoft Advertising' as source_name, 'Microsoft Ads' as platform,
  r.account_id::varchar as account_id, r.currency_code as account_currency,
  r.campaign_id::varchar as campaign_id, r.campaign_name,
  r.ad_group_id::varchar as media_buy_id, r.ad_group_name as media_buy_name,
  r.ad_id::varchar as creative_id, coalesce(r.ad_title, r.ad_id::varchar) as creative_name,
  r.impressions, r.clicks, r.spend, 0 as video_starts, 0 as completed_plays, 0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_MICROSOFT_ADS.AD_PERFORMANCE_DAILY_REPORT r;
