-- requires: BRONZE.AMAZON_ADS
-- Until TARGETING_KEYWORD_REPORT and KEYWORD_HISTORY land, deploy runs stubs/stg_amazon_ads_keywords.sql instead.
-- Same columns as every keyword view (see stg_google_ads_keywords.sql).
-- campaign_name and account_id match STG_AMAZON_ADS (campaign from the ad group, account is the profile), so the
-- keyword rows resolve to the same client and Smart Campaign as the delivery rows.
use role EPITAPH_TRANSFORMER;

-- Amazon Ads Sponsored Products keywords. Revenue is 30-day attributed sales; conversions are 30-day purchases.
create or replace view SILVER.STG.STG_AMAZON_ADS_KEYWORDS as
select
  r.date::date as activity_date, 'Amazon Ads' as source_name, 'Amazon' as platform,
  c.profile_id::varchar as account_id, null::varchar as account_currency,
  g.campaign_id::varchar as campaign_id, c.name as campaign_name,
  r.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.keyword_id::varchar as keyword_id, coalesce(k.keyword_text, r.keyword_id::varchar) as keyword,
  coalesce(k.match_type, r.match_type) as match_type,
  r.impressions, r.clicks, r.cost as spend,
  r.purchases_30_d as conversions, r.sales_30_d as revenue
from BRONZE.AMAZON_ADS.TARGETING_KEYWORD_REPORT r
left join (select * from BRONZE.AMAZON_ADS.KEYWORD_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) k on k.id = r.keyword_id
left join (select * from BRONZE.AMAZON_ADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) g on g.id = r.ad_group_id
left join (select * from BRONZE.AMAZON_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by _fivetran_synced desc) = 1) c on c.id = g.campaign_id;
