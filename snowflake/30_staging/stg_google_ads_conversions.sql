-- requires: BRONZE.GOOGLE_ADS
-- Until the custom report CAMPAIGN_CONVERSION_ACTION_STATS lands, deploy runs stubs/stg_google_ads_conversions.sql.
-- Custom report in the Google Ads connector: resource campaign, segments.date, segments.conversion_action_name,
-- metrics.conversions, metrics.all_conversions, metrics.conversions_value, metrics.view_through_conversions,
-- customer.id, campaign.id (lands as ID).
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.STG_GOOGLE_ADS_CONVERSIONS as
select
  s.date::date as activity_date, 'Google Ads' as source_name, 'Google Ads' as platform,
  s.customer_id::varchar as account_id, s.id::varchar as campaign_id, c.name as campaign_name,
  c.advertising_channel_type as campaign_type,
  s.conversion_action_name as conversion_tag_name,
  s.conversions, s.all_conversions, s.conversions_value as conversion_value,
  s.view_through_conversions
from BRONZE.GOOGLE_ADS.CAMPAIGN_CONVERSION_ACTION_STATS s
left join (select * from BRONZE.GOOGLE_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) c on c.id = s.id;   -- the report names campaign.id plain ID
