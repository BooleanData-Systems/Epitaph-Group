-- requires: BRONZE.FIVETRAN_REDDIT_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_reddit_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Reddit Ads. Spend in micro-currency. Video columns are added once the first sync shows their names
create or replace view SILVER.STG.STG_REDDIT_ADS as
select
  r.date::date as activity_date, 'Reddit Ads' as source_name, 'Reddit' as platform,
  ad.account_id::varchar as account_id, null::varchar as account_currency,
  ad.campaign_id::varchar as campaign_id, c.name as campaign_name,
  ad.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.ad_id::varchar as creative_id, ad.name as creative_name,
  r.impressions, r.clicks, r.spend / 1e6 as spend,
  0 as video_starts, 0 as completed_plays, 0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_REDDIT_ADS.AD_REPORT r
left join (select * from BRONZE.FIVETRAN_REDDIT_ADS.AD qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) ad on ad.id = r.ad_id
left join (select * from BRONZE.FIVETRAN_REDDIT_ADS.AD_GROUP qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) g on g.id = ad.ad_group_id
left join (select * from BRONZE.FIVETRAN_REDDIT_ADS.CAMPAIGN qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) c on c.id = ad.campaign_id;
