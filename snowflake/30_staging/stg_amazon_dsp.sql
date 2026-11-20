-- requires: BRONZE.AMAZON_DSP
-- Until the connector's first sync lands, deploy runs stubs/stg_amazon_dsp.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Amazon DSP (prove first against the F06 file). TapClicks treats the order as the campaign.
-- Fivetran's CAMPAIGN table is the DSP campaign report: one row per day, order, line item and creative, with the order
-- name but only IDs for the line item and creative. Names come from AD_GROUP (the line item) and AD_CREATIVE, the
-- currency from ADVERTISER. Impressions and click-throughs are Amazon's net figures: gross minus invalid.
create or replace view SILVER.STG.STG_AMAZON_DSP as
select
  r.date::date as activity_date, 'Amazon DSP' as source_name, 'Amazon DSP' as platform,
  r.advertiser_id::varchar as account_id, a.currency as account_currency,
  r.order_id::varchar as campaign_id, r.order_name as campaign_name,
  r.line_item_id::varchar as media_buy_id, li.name as media_buy_name,
  r.creative_id::varchar as creative_id, cr.name as creative_name,
  coalesce(r.gross_impressions, 0) - coalesce(r.invalid_impressions, 0) as impressions,
  coalesce(r.gross_click_throughs, 0) - coalesce(r.invalid_click_throughs, 0) as clicks,
  r.total_cost as spend,
  coalesce(r.video_ad_start, 0) as video_starts, coalesce(r.video_ad_complete, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.AMAZON_DSP.CAMPAIGN r
left join BRONZE.AMAZON_DSP.AD_GROUP li on li.id::varchar = r.line_item_id::varchar
left join BRONZE.AMAZON_DSP.AD_CREATIVE cr on cr.id::varchar = r.creative_id::varchar
left join BRONZE.AMAZON_DSP.ADVERTISER a on a.id::varchar = r.advertiser_id::varchar;
