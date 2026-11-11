-- requires: BRONZE.FIVETRAN_SNAPCHAT_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_snapchat_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- Snapchat Ads. Snapchat reports spend in micro-currency; swipes are its clicks
create or replace view SILVER.STG.STG_SNAPCHAT_ADS as
select
  r.date::date as activity_date, 'SnapChat' as source_name, 'Snapchat' as platform,
  c.ad_account_id::varchar as account_id, null::varchar as account_currency,
  c.id::varchar as campaign_id, c.name as campaign_name,
  sq.id::varchar as media_buy_id, sq.name as media_buy_name,
  r.ad_id::varchar as creative_id, ad.name as creative_name,
  r.impressions, r.swipes as clicks, r.spend / 1e6 as spend,
  coalesce(r.video_views, 0) as video_starts, coalesce(r.view_completion, 0) as completed_plays,
  coalesce(r.shares, 0) as post_shares, 0 as spots
from BRONZE.FIVETRAN_SNAPCHAT_ADS.AD_DAILY_REPORT r
left join (select * from BRONZE.FIVETRAN_SNAPCHAT_ADS.AD_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) ad on ad.id = r.ad_id
left join (select * from BRONZE.FIVETRAN_SNAPCHAT_ADS.AD_SQUAD_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) sq on sq.id = ad.ad_squad_id
left join (select * from BRONZE.FIVETRAN_SNAPCHAT_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) c on c.id = sq.campaign_id;
