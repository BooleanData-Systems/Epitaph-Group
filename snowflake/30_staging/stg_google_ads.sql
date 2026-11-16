-- requires: BRONZE.FIVETRAN_GOOGLE_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_google_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
use role EPITAPH_TRANSFORMER;

-- Google Ads
create or replace view SILVER.STG.STG_GOOGLE_ADS as
select
  s.date::date                                   as activity_date,
  'Google Ads'                                   as source_name,
  'Google Ads'                                   as platform,
  s.customer_id::varchar                         as account_id,
  a.currency_code                                as account_currency,
  s.campaign_id::varchar                         as campaign_id,
  c.name                                         as campaign_name,
  c.advertising_channel_type                     as campaign_type,
  s.ad_group_id::varchar                         as media_buy_id,
  g.name                                         as media_buy_name,
  s.ad_id::varchar                               as creative_id,
  coalesce(ad.name, ad.id::varchar)              as creative_name,
  s.impressions, s.clicks,
  s.cost_micros / 1e6                            as spend,
  coalesce(s.video_views, 0)                     as video_starts,
  coalesce(s.video_quartile_p_100_rate * s.impressions, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.FIVETRAN_GOOGLE_ADS.AD_STATS s
left join (select * from BRONZE.FIVETRAN_GOOGLE_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) c on c.id = s.campaign_id
left join (select * from BRONZE.FIVETRAN_GOOGLE_ADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) g on g.id = s.ad_group_id
left join (select * from BRONZE.FIVETRAN_GOOGLE_ADS.AD_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) ad on ad.id = s.ad_id
left join (select * from BRONZE.FIVETRAN_GOOGLE_ADS.ACCOUNT_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) a on a.id = s.customer_id;

create or replace view SILVER.STG.STG_GOOGLE_ADS_CONVERSIONS as
select
  s.date::date as activity_date, 'Google Ads' as source_name, 'Google Ads' as platform,
  s.customer_id::varchar as account_id, s.campaign_id::varchar as campaign_id, c.name as campaign_name,
  c.advertising_channel_type as campaign_type,
  s.conversion_action_name as conversion_tag_name,
  s.conversions, s.all_conversions, s.conversions_value as conversion_value,
  s.view_through_conversions
from BRONZE.FIVETRAN_GOOGLE_ADS.CAMPAIGN_CONVERSION_ACTION_STATS s
left join (select * from BRONZE.FIVETRAN_GOOGLE_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) c on c.id = s.campaign_id;
