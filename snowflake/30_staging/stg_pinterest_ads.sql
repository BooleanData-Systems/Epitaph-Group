-- requires: BRONZE.FIVETRAN_PINTEREST_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_pinterest_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Pinterest Ads. Paid (_1) plus earned (_2) impressions and clicks, as Pinterest reports totals; spend in micro-dollars
create or replace view SILVER.STG.STG_PINTEREST_ADS as
select
  r.date::date as activity_date, 'Pinterest Ads' as source_name, 'Pinterest' as platform,
  r.advertiser_id::varchar as account_id, null::varchar as account_currency,
  r.campaign_id::varchar as campaign_id, c.name as campaign_name,
  r.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.pin_promotion_id::varchar as creative_id, p.name as creative_name,
  coalesce(r.impression_1, 0) + coalesce(r.impression_2, 0) as impressions,
  coalesce(r.clickthrough_1, 0) + coalesce(r.clickthrough_2, 0) as clicks,
  r.spend_in_micro_dollar / 1e6 as spend,
  0 as video_starts, 0 as completed_plays, 0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_PINTEREST_ADS.PIN_PROMOTION_REPORT r
left join (select * from BRONZE.FIVETRAN_PINTEREST_ADS.PIN_PROMOTION_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) p on p.id = r.pin_promotion_id
left join (select * from BRONZE.FIVETRAN_PINTEREST_ADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) g on g.id = r.ad_group_id
left join (select * from BRONZE.FIVETRAN_PINTEREST_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) c on c.id = r.campaign_id;
