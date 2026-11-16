-- requires: BRONZE.FIVETRAN_FACEBOOK_ADS
-- Until the connector's first sync lands, deploy runs stubs/stg_facebook_ads.sql instead (same columns, no rows).
-- Every ad view has the same columns: activity_date, source_name, platform, account_id, account_currency, campaign_id,
-- campaign_name, media_buy_id, media_buy_name, creative_id, creative_name, impressions, clicks, spend, video_starts,
-- completed_plays, post_shares, spots. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
use role EPITAPH_TRANSFORMER;

-- Facebook Ads (K06: only video ads count starts)
create or replace view SILVER.STG.STG_FACEBOOK_ADS as
select
  b.date::date as activity_date, 'Facebook Ads' as source_name, 'Meta' as platform,
  b.account_id::varchar as account_id, acc.currency as account_currency,
  ad.campaign_id::varchar as campaign_id, cmp.name as campaign_name,
  ad.ad_set_id::varchar as media_buy_id, ads.name as media_buy_name,
  b.ad_id::varchar as creative_id, ad.name as creative_name,
  b.impressions, b.inline_link_clicks as clicks, b.spend,
  iff(cr.object_type = 'VIDEO' or cr.video_id is not null, coalesce(v.video_play, 0), 0) as video_starts,
  iff(cr.object_type = 'VIDEO' or cr.video_id is not null, coalesce(v.video_p100, 0), 0) as completed_plays,
  coalesce(sh.post_shares, 0) as post_shares, 0 as spots
from BRONZE.FIVETRAN_FACEBOOK_ADS.BASIC_AD b
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.AD_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) ad on ad.id = b.ad_id
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.AD_SET_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) ads on ads.id = ad.ad_set_id
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) cmp on cmp.id = ad.campaign_id
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.CREATIVE_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) cr on cr.id = ad.creative_id
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.ACCOUNT_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) acc on acc.id = b.account_id
left join (select ad_id, date, sum(iff(action_type = 'video_view', value, 0)) as video_play,
                  sum(iff(action_type = 'video_p100_watched_actions', value, 0)) as video_p100
           from BRONZE.FIVETRAN_FACEBOOK_ADS.BASIC_AD_VIDEO_ACTIONS group by 1, 2) v on v.ad_id = b.ad_id and v.date = b.date
left join (select ad_id, date, sum(value) as post_shares from BRONZE.FIVETRAN_FACEBOOK_ADS.BASIC_AD_ACTIONS
           where action_type = 'post' group by 1, 2) sh on sh.ad_id = b.ad_id and sh.date = b.date;

create or replace view SILVER.STG.STG_FACEBOOK_ADS_CONVERSIONS as
select
  a.date::date as activity_date, 'Facebook Ads' as source_name, 'Meta' as platform,
  b.account_id::varchar as account_id, ad.campaign_id::varchar as campaign_id, cmp.name as campaign_name,
  null as campaign_type,
  a.action_type as conversion_tag_name,
  a.value as conversions, a.value as all_conversions, 0 as conversion_value, coalesce(a._1_d_view, 0) as view_through_conversions
from BRONZE.FIVETRAN_FACEBOOK_ADS.BASIC_AD_ACTIONS a
join BRONZE.FIVETRAN_FACEBOOK_ADS.BASIC_AD b on b.ad_id = a.ad_id and b.date = a.date
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.AD_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) ad on ad.id = a.ad_id
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) cmp on cmp.id = ad.campaign_id;

create or replace view SILVER.STG.STG_FACEBOOK_REACH as
select b.date::date as activity_date, 'Facebook Ads' as source_name, 'Meta' as platform,
       ad.campaign_id::varchar as campaign_id, cmp.name as campaign_name,
       sum(b.reach) as reach, sum(b.impressions) as impressions
from BRONZE.FIVETRAN_FACEBOOK_ADS.BASIC_AD b
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.AD_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) ad on ad.id = b.ad_id
left join (select * from BRONZE.FIVETRAN_FACEBOOK_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_time desc) = 1) cmp on cmp.id = ad.campaign_id
group by all;
-- Note: reach summed across ads in a day overstates true campaign reach. K09 (open) decides what is shown.
