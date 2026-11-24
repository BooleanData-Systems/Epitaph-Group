-- All keyword rows in one shape (Search Keywords tables, 16 dashboards). Feeds GOLD.MARTS.FCT_KEYWORD_DAILY.
-- Keywords have no TapClicks history in this route: they start at each connector's history_from (config/connectors.yml).
use role EPITAPH_TRANSFORMER;

-- Measures get fixed types so the dynamic table does not fail when a stub's NUMBER becomes a connector's FLOAT
create or replace view SILVER.STG.STG_LIVE_KEYWORDS as
select activity_date, source_name, platform, account_id, account_currency, campaign_id, campaign_name,
       media_buy_id, media_buy_name, keyword_id, keyword, match_type,
       impressions::number(38,6) as impressions, clicks::number(38,6) as clicks, spend::number(38,6) as spend,
       conversions::number(30,4) as conversions, revenue::number(18,4) as revenue
from (
  select * from SILVER.STG.STG_GOOGLE_ADS_KEYWORDS
  union all
  select * from SILVER.STG.STG_MICROSOFT_ADS_KEYWORDS
  union all
  select * from SILVER.STG.STG_AMAZON_ADS_KEYWORDS
);
