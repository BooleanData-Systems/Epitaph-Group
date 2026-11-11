-- requires: BRONZE.FIVETRAN_SPOTIFY_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_spotify_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Spotify Ads (prove first; Cobs Bread stays on its file, F15)
create or replace view SILVER.STG.STG_SPOTIFY_ADS as
select
  r.date::date as activity_date, 'Spotify Ads' as source_name, 'Spotify' as platform,
  r.ad_account_id::varchar as account_id, null::varchar as account_currency,
  r.campaign_id::varchar as campaign_id, r.campaign_name,
  r.ad_set_id::varchar as media_buy_id, r.ad_set_name as media_buy_name,
  r.ad_id::varchar as creative_id, r.ad_name as creative_name,
  r.impressions, r.clicks, r.spend,
  0 as video_starts, 0 as completed_plays, 0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_SPOTIFY_ADS.AD_REPORT r;
