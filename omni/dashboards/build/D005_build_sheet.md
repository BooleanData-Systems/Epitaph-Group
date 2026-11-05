# Build sheet: D005 Cobs Bread - Evergreen

Client: Cobs Bread. Type: Standard. Target live date: 2027-01-15.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Merge Cobs Bread Evergreen and Evergreen USA into this one dashboard (A16), each account in its own currency (CAD and USD).
- Every money tile (spend, CPM, CPC, CPA and other cost KPIs) is split by currency_code: accounts in different currencies are never added together.

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | CPM | CPM (cpm) | currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Spend | Spend (spend) | currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | CPC | CPC (cpc) | currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type, currency_code | Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; filter_media_type in [DemandGen, Search, Search - Perfmax, Meta, TikTok, All outcomes]; country in [Canada, USA] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name, currency_code | Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type, currency_code | Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name, currency_code | Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type, currency_code | Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name, currency_code | Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*] |
| [ ] | kpi | Loyalty Sign Ups | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)] |

## DemandGen

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Spend | Spend (spend) | currency_code | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | CPM | CPM (cpm) | currency_code | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | CPC | CPC (cpc) | currency_code | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [DemandGen, All outcomes] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [DemandGen, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [DemandGen, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name, currency_code | filter_media_type in [DemandGen, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [DemandGen, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [DemandGen, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name, currency_code | filter_media_type in [DemandGen, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [DemandGen, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [DemandGen, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [DemandGen, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name, currency_code | filter_media_type in [DemandGen, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [DemandGen, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [DemandGen, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [DemandGen, All outcomes] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [DemandGen, All outcomes] |

## Meta - Consideration

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | Spend | Spend (spend) | currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | CPM | CPM (cpm) | currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | CPC | CPC (cpc) | currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [Meta, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [Meta, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name, currency_code | filter_media_type in [Meta, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [Meta, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [Meta, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name, currency_code | filter_media_type in [Meta, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [Meta, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [Meta, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name, currency_code | filter_media_type in [Meta, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Traffic*] |

## Meta - Conversion

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | Spend | Spend (spend) | currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | CPM | CPM (cpm) | currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | CPC | CPC (cpc) | currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [Meta, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [Meta, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name, currency_code | filter_media_type in [Meta, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [Meta, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [Meta, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name, currency_code | filter_media_type in [Meta, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [Meta, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [Meta, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name, currency_code | filter_media_type in [Meta, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | kpi | Loyalty Sign Ups | Completed Registration (completed_registration) |  | smart_campaign in [Cobs Bread: Evergreen]; filter_media_type in [Meta, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | By Day | Completed Registration (completed_registration) | date:day | filter_media_type in [Meta, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Audience | Completed Registration (completed_registration) | audience | filter_media_type in [Meta, All outcomes]; Completed Registration >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Tactic | Completed Registration (completed_registration) | tactic | filter_media_type in [Meta, All outcomes]; Completed Registration >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Creative | Completed Registration (completed_registration) | creative_name | filter_media_type in [Meta, All outcomes]; Completed Registration >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |

## Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | Spend (spend) | currency_code | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | CPM (cpm) | currency_code | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | CPC (cpc) | currency_code | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword, currency_code | smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [Search, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search, All outcomes] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search, All outcomes] |
| [ ] | kpi | Loyalty Sign Ups | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search, All outcomes] |

## Search - Performance Max

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | Spend (spend) | currency_code | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | CPM (cpm) | currency_code | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Total Metrics | CPC (cpc) | currency_code | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [Search - Perfmax, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | Loyalty Sign Ups | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | table | PerfMax Conversions Audit | Conversions - PerfMax (conversions_perfmax), Conversions (conversions), All Conv. (all_conv) (labels: Conversions - PerfMax as *Conversions - PerfMax) | campaign_name, conversion_tag | campaign_name in [*Loyalty*] |

## TikTok - Consideration

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | Spend | Spend (spend) | currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | CPM | CPM (cpm) | currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | CPC | CPC (cpc) | currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name, currency_code | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name, currency_code | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name, currency_code | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Traffic*] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Traffic*] |

## TikTok - Conversion

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | Spend | Spend (spend) | currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | CPM | CPM (cpm) | currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | CPC | CPC (cpc) | currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | kpi | Find a Bakery | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day, currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Audience | Spend (spend) | audience, currency_code | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic, currency_code | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name, currency_code | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day, currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience, currency_code | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic, currency_code | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name, currency_code | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day, currency_code | filter_media_type in [TikTok, All outcomes]; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience, currency_code | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic, currency_code | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name, currency_code | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [Cobs Bread: Evergreen]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [COBS Bread - GA4 (web) find_a_bakery_page_click, *Custom.find A Bakery Click*]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | kpi | Loyalty Sign Ups | Total Conversions (total_conversions), CPA (cpa) | currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day, currency_code | smart_campaign in [Cobs Bread: Evergreen]; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name, currency_code | smart_campaign in [Cobs Bread: Evergreen]; Total Conversions >= 1.0; conversion_tag in [Sign-up (Google Analytics event sign_up)]; filter_media_type in [TikTok, All outcomes]; campaign_name in [*Conversion*] |

