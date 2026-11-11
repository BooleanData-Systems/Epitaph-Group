-- requires: BRONZE.FIVETRAN_AMAZON_DSP
-- Until the connector's first sync lands, deploy runs stubs/stg_amazon_dsp.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Amazon DSP (prove first against the F06 file). TapClicks treats the order as the campaign.
-- Custom report fields: Date, Advertiser ID, Currency, Order ID, Order Name, Line Item ID, Line Item Name, Creative ID,
-- Creative Name, Impressions, Click-throughs, Total Cost, Video Start, Video Complete
create or replace view SILVER.STG.STG_AMAZON_DSP as
select
  r.date::date as activity_date, 'Amazon DSP' as source_name, 'Amazon DSP' as platform,
  r.advertiser_id::varchar as account_id, r.currency as account_currency,
  r.order_id::varchar as campaign_id, r.order_name as campaign_name,
  r.line_item_id::varchar as media_buy_id, r.line_item_name as media_buy_name,
  r.creative_id::varchar as creative_id, r.creative_name,
  r.impressions, r.click_throughs as clicks, r.total_cost as spend,
  coalesce(r.video_start, 0) as video_starts, coalesce(r.video_complete, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_AMAZON_DSP.CUSTOM_REPORT r;
