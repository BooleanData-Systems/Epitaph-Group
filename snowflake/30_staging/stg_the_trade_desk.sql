-- requires: BRONZE.FIVETRAN_THE_TRADE_DESK
-- Until the connector's first sync lands, deploy runs stubs/stg_the_trade_desk.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- The Trade Desk (waiting for the API addendum).
-- Custom report fields: Date, Advertiser ID, Advertiser Currency Code, Campaign ID, Campaign, Ad Group ID, Ad Group,
-- Creative ID, Creative, Impressions, Clicks, Advertiser Cost (Adv Currency), Player Starts, Player Completed Views
create or replace view SILVER.STG.STG_THE_TRADE_DESK as
select
  r.date::date as activity_date, 'The Trade Desk' as source_name, 'The Trade Desk' as platform,
  r.advertiser_id::varchar as account_id, r.advertiser_currency_code as account_currency,
  r.campaign_id::varchar as campaign_id, r.campaign as campaign_name,
  r.ad_group_id::varchar as media_buy_id, r.ad_group as media_buy_name,
  r.creative_id::varchar as creative_id, r.creative as creative_name,
  r.impressions, r.clicks, r.advertiser_cost_adv_currency as spend,
  coalesce(r.player_starts, 0) as video_starts, coalesce(r.player_completed_views, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_THE_TRADE_DESK.CUSTOM_REPORT r;
