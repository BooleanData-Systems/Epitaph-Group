-- requires: BRONZE.APPLE_SEARCH_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_apple_search_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
use role EPITAPH_TRANSFORMER;

-- Apple Search Ads. source_name is 'Apple Ads', the name TapClicks history uses, so the cut-over rule joins the two.
-- The ad group report is the lowest level synced: the ad group is both the media buy and the creative (as Amazon Ads).
-- The account is the Apple Ads organization; taps are clicks; spend is in the organization's currency.
create or replace view SILVER.STG.STG_APPLE_SEARCH_ADS as
select
  r.date::date as activity_date, 'Apple Ads' as source_name, 'Apple' as platform,
  c.organization_id::varchar as account_id, coalesce(r.local_spend_currency, o.currency) as account_currency,
  g.campaign_id::varchar as campaign_id, c.name as campaign_name,
  r.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.ad_group_id::varchar as creative_id, g.name as creative_name,
  r.impressions, r.taps as clicks, r.local_spend_amount as spend,
  0 as video_starts, 0 as completed_plays, 0 as post_shares, 0 as spots
from BRONZE.APPLE_SEARCH_ADS.AD_GROUP_REPORT r
left join (select * from BRONZE.APPLE_SEARCH_ADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by modification_time desc) = 1) g on g.id = r.ad_group_id
left join (select * from BRONZE.APPLE_SEARCH_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by modification_time desc) = 1) c on c.id = g.campaign_id
left join BRONZE.APPLE_SEARCH_ADS.ORGANIZATION o on o.id = c.organization_id;
