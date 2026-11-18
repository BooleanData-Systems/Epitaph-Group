-- Stub used until the connector's first sync: same columns as the real view, no rows.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_AMAZON_ADS as
select null::date as activity_date, 'Amazon Ads' as source_name, 'Amazon' as platform, null::varchar as account_id,
       null::varchar as account_currency, null::varchar as campaign_id, null::varchar as campaign_name,
       null::varchar as media_buy_id, null::varchar as media_buy_name, null::varchar as creative_id,
       null::varchar as creative_name, 0::number as impressions, 0::number as clicks, 0::number(18,4) as spend,
       0::number as video_starts, 0::number as completed_plays, 0::number as post_shares, 0::number as spots
where false;
