-- Stub used until the custom report syncs: same columns as the real view, no rows.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_GOOGLE_ADS_CONVERSIONS as
select null::date as activity_date, 'Google Ads' as source_name, 'Google Ads' as platform, null::varchar as account_id,
       null::varchar as campaign_id, null::varchar as campaign_name, null::varchar as campaign_type,
       null::varchar as conversion_tag_name, 0::number(18,4) as conversions, 0::number(18,4) as all_conversions,
       0::number(18,4) as conversion_value, 0::number(18,4) as view_through_conversions
where false;

