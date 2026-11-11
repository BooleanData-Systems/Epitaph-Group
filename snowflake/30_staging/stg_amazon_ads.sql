-- requires: BRONZE.FIVETRAN_AMAZON_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_amazon_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Amazon Ads (sponsored ads). Reported at ad group level, so creative is the ad group
create or replace view SILVER.STG.STG_AMAZON_ADS as
select
  r.date::date as activity_date, 'Amazon Ads' as source_name, 'Amazon' as platform,
  c.profile_id::varchar as account_id, null::varchar as account_currency,
  r.campaign_id::varchar as campaign_id, c.name as campaign_name,
  r.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.ad_group_id::varchar as creative_id, g.name as creative_name,
  r.impressions, r.clicks, r.cost as spend,
  0 as video_starts, 0 as completed_plays, 0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_AMAZON_ADS.AD_GROUP_LEVEL_REPORT r
left join (select * from BRONZE.FIVETRAN_AMAZON_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) c on c.id = r.campaign_id
left join (select * from BRONZE.FIVETRAN_AMAZON_ADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) g on g.id = r.ad_group_id;
