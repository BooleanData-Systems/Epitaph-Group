-- requires: BRONZE.FIVETRAN_DV360
-- Until the connector's first sync lands, deploy runs stubs/stg_dv360.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Display & Video 360. TapClicks treats the insertion order as the campaign.
-- Custom report fields: Date, Advertiser ID, Advertiser Currency, Insertion Order ID, Insertion Order, Line Item ID,
-- Line Item, Creative ID, Creative, Impressions, Clicks, Revenue (Adv Currency), Starts (Video), Complete Views (Video)
create or replace view SILVER.STG.STG_DV360 as
select
  r.date::date as activity_date, 'Display & Video 360 IO' as source_name, 'DV360' as platform,
  r.advertiser_id::varchar as account_id, r.advertiser_currency as account_currency,
  r.insertion_order_id::varchar as campaign_id, r.insertion_order as campaign_name,
  r.line_item_id::varchar as media_buy_id, r.line_item as media_buy_name,
  r.creative_id::varchar as creative_id, r.creative as creative_name,
  r.impressions, r.clicks, r.revenue_adv_currency as spend,
  coalesce(r.starts_video, 0) as video_starts, coalesce(r.complete_views_video, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_DV360.CUSTOM_REPORT r;
