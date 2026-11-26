-- requires: BRONZE.SPOTIFY_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_spotify_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Spotify Ads (prove first; Cobs Bread stays on its file, F15)
-- AD_REPORT is the custom report set up in the connector (dimension AD, granularity DAY). It holds ids and metrics only:
-- one row per ad (entity_id) and day, where start_time is midnight UTC and end_time is 24 hours later. Names come from
-- the AD > AD_SET > CAMPAIGN tables and the currency from AD_ACCOUNT (Cobs Bread USA reports in USD).
-- Spotify's ad set is the media buy. Starts and completes are ad plays started and finished (audio or video).
-- Reach and frequency are in the report but left out here: they are not additive across days or ads (R60).
create or replace view SILVER.STG.STG_SPOTIFY_ADS as
select
  r.start_time::date as activity_date, 'Spotify Ads' as source_name, 'Spotify' as platform,
  r.ad_account_id::varchar as account_id, acc.currency_code as account_currency,
  c.id::varchar as campaign_id, c.name as campaign_name,
  s.id::varchar as media_buy_id, s.name as media_buy_name,
  r.entity_id::varchar as creative_id, a.name as creative_name,
  coalesce(r.impressions, 0)::number as impressions, coalesce(r.clicks, 0)::number as clicks,
  coalesce(r.spend, 0)::number(18,4) as spend,
  coalesce(r.starts, 0)::number as video_starts, coalesce(r.completes, 0)::number as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.SPOTIFY_ADS.AD_REPORT r
left join BRONZE.SPOTIFY_ADS.AD a on a.id = r.entity_id
left join BRONZE.SPOTIFY_ADS.AD_SET s on s.id = a.ad_set_id
left join BRONZE.SPOTIFY_ADS.CAMPAIGN c on c.id = s.campaign_id
left join BRONZE.SPOTIFY_ADS.AD_ACCOUNT acc on acc.id = r.ad_account_id
where r.entity_type = 'AD' and r.granularity = 'DAY';
