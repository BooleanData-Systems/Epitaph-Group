-- requires: BRONZE.GOOGLE_ANALYTICS_4
-- Until the connector's first sync lands, deploy runs stubs/stg_ga4_sessions.sql instead (same columns, no rows).
-- GA4 sessions (K11). The GA4 Test property is excluded everywhere (Q002, Q22).
-- Custom report session_campaign_report (daily): date, sessionSource, sessionMedium, sessionCampaignName,
-- sessionCampaignId, sessionManualAdContent; sessions. Fivetran adds the property as 'properties/<id>'.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_GA4_SESSIONS as
select
  r.date::date                        as activity_date,
  'Google Analytics 4'                as source_name,
  regexp_replace(r.property, '^properties/', '') as property_id,
  r.session_source                    as ga4_session_source,
  r.session_medium                    as ga4_session_medium,
  r.session_campaign_name             as ga4_session_campaign,
  r.session_campaign_id               as ga4_session_campaign_id,
  r.session_manual_ad_content         as ga4_manual_ad_content,
  r.sessions
from BRONZE.GOOGLE_ANALYTICS_4.SESSION_CAMPAIGN_REPORT r
where regexp_replace(r.property, '^properties/', '') not in (
  select account_id from GOLD.CONTROL.MAP_PLATFORM_ACCOUNT where platform = 'GA4 Test'
);
