-- requires: BRONZE.FIVETRAN_GA4
-- Until the connector's first sync lands, deploy runs stubs/stg_ga4_sessions.sql instead (same columns, no rows).
-- GA4 sessions (K11). The GA4 Test property is excluded everywhere (Q002, Q22).
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_GA4_SESSIONS as
select
  r.date::date                        as activity_date,
  'Google Analytics 4'                as source_name,
  r.property::varchar                 as property_id,
  r.session_source                    as ga4_session_source,
  r.session_medium                    as ga4_session_medium,
  r.session_campaign_name             as ga4_session_campaign,
  r.session_manual_ad_content         as ga4_manual_ad_content,
  r.sessions
from BRONZE.FIVETRAN_GA4.TRAFFIC_ACQUISITION_SESSION_SOURCE_MEDIUM_REPORT r
where r.property::varchar not in (
  select account_id from GOLD.CONTROL.MAP_PLATFORM_ACCOUNT where platform = 'GA4 Test'
);
