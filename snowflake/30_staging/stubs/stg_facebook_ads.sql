-- Stub used until the connector's first sync: same columns as the real view, no rows.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_FACEBOOK_ADS as
select null::date as activity_date, 'Facebook Ads' as source_name, 'Meta' as platform, null::varchar as account_id,
       null::varchar as account_currency, null::varchar as campaign_id, null::varchar as campaign_name,
       null::varchar as media_buy_id, null::varchar as media_buy_name, null::varchar as creative_id,
       null::varchar as creative_name, 0::number as impressions, 0::number as clicks, 0::number(18,4) as spend,
       0::number as video_starts, 0::number as completed_plays, 0::number as post_shares, 0::number as spots
where false;

create or replace view SILVER.STG.STG_FACEBOOK_ADS_CONVERSIONS as
select null::date as activity_date, 'Facebook Ads' as source_name, 'Meta' as platform, null::varchar as account_id,
       null::varchar as campaign_id, null::varchar as campaign_name, null::varchar as campaign_type,
       null::varchar as conversion_tag_name, 0::number(18,4) as conversions, 0::number(18,4) as all_conversions,
       0::number(18,4) as conversion_value, 0::number(18,4) as view_through_conversions
where false;

create or replace view SILVER.STG.STG_FACEBOOK_REACH as
select null::date as activity_date, 'Facebook Ads' as source_name, 'Meta' as platform, null::varchar as campaign_id,
       null::varchar as campaign_name, 0::number as reach, 0::number as impressions
where false;

