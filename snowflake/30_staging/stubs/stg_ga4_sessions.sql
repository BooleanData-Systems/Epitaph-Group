-- Stub used until the connector's first sync: same columns as the real view, no rows.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_GA4_SESSIONS as
select null::date as activity_date, 'Google Analytics 4' as source_name, null::varchar as property_id,
       null::varchar as ga4_session_source, null::varchar as ga4_session_medium, null::varchar as ga4_session_campaign,
       null::varchar as ga4_manual_ad_content, 0::number as sessions
where false;

