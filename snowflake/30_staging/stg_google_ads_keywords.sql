-- requires: BRONZE.GOOGLE_ADS
-- Until KEYWORD_STATS and AD_GROUP_CRITERION_HISTORY land, deploy runs stubs/stg_google_ads_keywords.sql instead.
-- Every keyword view has the same columns: activity_date, source_name, platform, account_id, account_currency,
-- campaign_id, campaign_name, media_buy_id, media_buy_name, keyword_id, keyword, match_type, impressions, clicks,
-- spend, conversions, revenue. Column names follow the Fivetran connector schema (checked by check_fivetran_schema.py).
use role EPITAPH_TRANSFORMER;

-- Google Ads keywords (Search Keywords tables). KEYWORD_STATS splits each keyword's day by device and network; the
-- fact adds them up. Keyword text and match type come from the latest row of AD_GROUP_CRITERION_HISTORY; a criterion
-- id is unique only within its ad group, so the join uses both.
create or replace view SILVER.STG.STG_GOOGLE_ADS_KEYWORDS as
select
  s.date::date                                   as activity_date,
  'Google Ads'                                   as source_name,
  'Google Ads'                                   as platform,
  s.customer_id::varchar                         as account_id,
  a.currency_code                                as account_currency,
  s.campaign_id::varchar                         as campaign_id,
  c.name                                         as campaign_name,
  s.ad_group_id::varchar                         as media_buy_id,
  g.name                                         as media_buy_name,
  s.ad_group_criterion_criterion_id::varchar     as keyword_id,
  coalesce(k.keyword_text, s.ad_group_criterion_criterion_id::varchar) as keyword,
  k.keyword_match_type                           as match_type,
  s.impressions, s.clicks,
  s.cost_micros / 1e6                            as spend,
  s.conversions,
  s.conversions_value                            as revenue
from BRONZE.GOOGLE_ADS.KEYWORD_STATS s
left join (select * from BRONZE.GOOGLE_ADS.AD_GROUP_CRITERION_HISTORY qualify row_number() over (partition by ad_group_id, id order by updated_at desc) = 1) k
  on k.ad_group_id = s.ad_group_id and k.id = s.ad_group_criterion_criterion_id
left join (select * from BRONZE.GOOGLE_ADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) c on c.id = s.campaign_id
left join (select * from BRONZE.GOOGLE_ADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) g on g.id = s.ad_group_id
left join (select * from BRONZE.GOOGLE_ADS.ACCOUNT_HISTORY qualify row_number() over (partition by id order by updated_at desc) = 1) a on a.id = s.customer_id;
