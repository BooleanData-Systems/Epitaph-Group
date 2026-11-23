-- requires: BRONZE.BINGADS
-- Until the connector's first sync lands, deploy runs stubs/stg_microsoft_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
use role EPITAPH_TRANSFORMER;

-- Microsoft Advertising. The daily report carries ids only; names come from the latest row of each history table.
create or replace view SILVER.STG.STG_MICROSOFT_ADS as
select
  r.date::date as activity_date, 'Microsoft Advertising' as source_name, 'Microsoft Ads' as platform,
  r.account_id::varchar as account_id, coalesce(r.currency_code, a.currency_code) as account_currency,
  r.campaign_id::varchar as campaign_id, cmp.name as campaign_name,
  r.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.ad_id::varchar as creative_id, coalesce(ad.title, ad.title_part_1, r.ad_id::varchar) as creative_name,
  r.impressions, r.clicks, r.spend,
  coalesce(r.video_views, 0) as video_starts, coalesce(r.completed_video_views, 0) as completed_plays,
  0 as post_shares, 0 as spots
from BRONZE.BINGADS.AD_PERFORMANCE_DAILY_REPORT r
left join (select * from BRONZE.BINGADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by modified_time desc) = 1) cmp on cmp.id = r.campaign_id
left join (select * from BRONZE.BINGADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by modified_time desc) = 1) g on g.id = r.ad_group_id
left join (select * from BRONZE.BINGADS.AD_HISTORY qualify row_number() over (partition by id order by modified_time desc) = 1) ad on ad.id = r.ad_id
left join (select * from BRONZE.BINGADS.ACCOUNT_HISTORY qualify row_number() over (partition by id order by last_modified_time desc) = 1) a on a.id = r.account_id;
