-- Stub used until the keyword tables' first sync: same columns as the real view, no rows.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_GOOGLE_ADS_KEYWORDS as
select null::date as activity_date, 'Google Ads' as source_name, 'Google Ads' as platform, null::varchar as account_id,
       null::varchar as account_currency, null::varchar as campaign_id, null::varchar as campaign_name,
       null::varchar as media_buy_id, null::varchar as media_buy_name, null::varchar as keyword_id,
       null::varchar as keyword, null::varchar as match_type, 0::number as impressions, 0::number as clicks,
       0::number(18,4) as spend, 0::number(18,4) as conversions, 0::number(18,4) as revenue
where false;
