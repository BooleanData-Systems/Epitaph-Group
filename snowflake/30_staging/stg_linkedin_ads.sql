-- requires: BRONZE.FIVETRAN_LINKEDIN_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_linkedin_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
-- campaign_name is the level TapClicks calls the campaign, so the Smart Campaign mapping matches on the same names.
use role EPITAPH_TRANSFORMER;

-- LinkedIn Ads. LinkedIn has no ad set level: the campaign is also the media buy
create or replace view SILVER.STG.STG_LINKEDIN_ADS as
select
  r.day::date as activity_date, 'LinkedIn Ads' as source_name, 'LinkedIn' as platform,
  c.account_id::varchar as account_id, null::varchar as account_currency,
  c.id::varchar as campaign_id, c.name as campaign_name,
  c.id::varchar as media_buy_id, c.name as media_buy_name,
  r.creative_id::varchar as creative_id, r.creative_id::varchar as creative_name,
  r.impressions, r.clicks, r.cost_in_local_currency as spend,
  coalesce(r.video_starts, 0) as video_starts, coalesce(r.video_completions, 0) as completed_plays,
  coalesce(r.shares, 0) as post_shares, 0 as spots
from BRONZE.FIVETRAN_LINKEDIN_ADS.AD_ANALYTICS_BY_CREATIVE r
left join (select * from BRONZE.FIVETRAN_LINKEDIN_ADS.CREATIVE_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) cr on cr.id = r.creative_id
left join (select * from BRONZE.FIVETRAN_LINKEDIN_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) c on c.id = cr.campaign_id;
