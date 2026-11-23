-- requires: BRONZE.DOUBLE_CLICK_CAMPAIGN_MANAGER
-- Until the connector's first sync lands, deploy runs stubs/stg_cm360.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Campaign Manager 360.
-- Custom report fields (set when the connector is created): Date, Advertiser ID, Campaign ID, Campaign, Placement ID,
-- Placement, Ad ID, Ad, Impressions, Clicks, Media Cost, Video Plays, Video Completions
create or replace view SILVER.STG.STG_CM360 as
select
  r.date::date as activity_date, 'Campaign Manager 360' as source_name, 'CM360' as platform,
  r.advertiser_id::varchar as account_id, null::varchar as account_currency,
  r.campaign_id::varchar as campaign_id, r.campaign as campaign_name,
  r.placement_id::varchar as media_buy_id, r.placement as media_buy_name,
  r.ad_id::varchar as creative_id, r.ad as creative_name,
  r.impressions, r.clicks, r.media_cost as spend,
  coalesce(r.video_plays, 0) as video_starts, coalesce(r.video_completions, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.DOUBLE_CLICK_CAMPAIGN_MANAGER.CUSTOM_REPORT r
-- Some CM360 user profiles are network logins that also see advertisers outside Epitaph, so only advertisers mapped
-- to a client in map_platform_account.csv pass. An advertiser appears once someone adds it there.
where r.advertiser_id::varchar in (select account_id from GOLD.CONTROL.MAP_PLATFORM_ACCOUNT where platform = 'Campaign Manager 360')
-- The report runs once per CM360 user profile, and profiles that see the same advertiser return the same rows
-- (two profiles carried identical data on the first sync), so keep one row per day, advertiser, campaign, placement and ad
qualify row_number() over (partition by r.date, r.advertiser_id, r.campaign_id, r.placement_id, r.ad_id
                           order by r.impressions desc nulls last, r.profile_id) = 1;
