-- requires: BRONZE.BINGADS
-- Until KEYWORD_PERFORMANCE_DAILY_REPORT and KEYWORD_HISTORY land, deploy runs stubs/stg_microsoft_ads_keywords.sql.
-- Same columns as every keyword view (see stg_google_ads_keywords.sql).
use role EPITAPH_TRANSFORMER;

-- Microsoft Advertising keywords. The daily report splits each keyword's day by device, network and delivered match
-- type; the fact adds them up. Keyword text (name) and match type come from the latest row of KEYWORD_HISTORY.
create or replace view SILVER.STG.STG_MICROSOFT_ADS_KEYWORDS as
select
  r.date::date as activity_date, 'Microsoft Advertising' as source_name, 'Microsoft Ads' as platform,
  r.account_id::varchar as account_id, coalesce(r.currency_code, a.currency_code) as account_currency,
  r.campaign_id::varchar as campaign_id, cmp.name as campaign_name,
  r.ad_group_id::varchar as media_buy_id, g.name as media_buy_name,
  r.keyword_id::varchar as keyword_id, coalesce(k.name, r.keyword_id::varchar) as keyword,
  coalesce(k.match_type, r.bid_match_type) as match_type,
  r.impressions, r.clicks, r.spend,
  r.conversions, r.revenue
from BRONZE.BINGADS.KEYWORD_PERFORMANCE_DAILY_REPORT r
left join (select * from BRONZE.BINGADS.KEYWORD_HISTORY qualify row_number() over (partition by id order by modified_time desc) = 1) k on k.id = r.keyword_id
left join (select * from BRONZE.BINGADS.CAMPAIGN_HISTORY qualify row_number() over (partition by id order by modified_time desc) = 1) cmp on cmp.id = r.campaign_id
left join (select * from BRONZE.BINGADS.AD_GROUP_HISTORY qualify row_number() over (partition by id order by modified_time desc) = 1) g on g.id = r.ad_group_id
left join (select * from BRONZE.BINGADS.ACCOUNT_HISTORY qualify row_number() over (partition by id order by last_modified_time desc) = 1) a on a.id = r.account_id;
