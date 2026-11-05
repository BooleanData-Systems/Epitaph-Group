# Build sheet: D053 Nulo - USA

Client: Nulo. Type: Standard. Target live date: 2026-12-11.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Reported in USD, the ad account's currency (Q19).
- Not rebuilt: 1 widget, marked do-not-use in TapClicks

## CTV

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Starts (starts) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Completed Plays (completed_plays) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | VCR (vcr) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPCV (cpcv) |  | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [CTV, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [CTV, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [CTV, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [CTV, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [CTV, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [CTV, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | date:week | filter_media_type in [CTV, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | audience | filter_media_type in [CTV, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | tactic | filter_media_type in [CTV, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | creative_name | filter_media_type in [CTV, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Find a Retailer | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) |  | Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | kpi | Show Now Clicks | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Nulo - Shop Now, *shop_now*]; Total Conversions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | filter_media_type in [CTV, Facebook+Instagram, Search, TikTok, Video, YouTube, ..., All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | media_type | Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | audience | Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | tactic | Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | creative_name | Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Media Type | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | media_type | Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Audience | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | audience | Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, *where_to_buy*, https://www.nulo.com - GA4 (web) GA4 Where To Buy] |
| [ ] | combo-chart | Tactic | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | tactic | Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Creative | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | creative_name | Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Nulo - Shop Now, *shop_now*]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type | conversion_tag in [Nulo - Shop Now, *shop_now*]; Total Conversions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Nulo - Shop Now, *shop_now*]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Nulo - Shop Now, *shop_now*]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | Total Conversions >= 1.0; conversion_tag in [Nulo - Shop Now, *shop_now*]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## Chewy

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; filter_media_type in [Chewy, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; filter_media_type in [Chewy, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## DOOH

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions), Spend (spend), CPM (cpm) |  | filter_media_type in [DOOH, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [DOOH, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [DOOH, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [DOOH, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [DOOH, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [DOOH, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [DOOH, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [DOOH, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [DOOH, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Find a Retailer | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) |  | Find a Retailer - Nulo >= 1.0; filter_media_type in [Search, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | kpi | Shop Now Clicks | Total Conversions (total_conversions), CPA (cpa) |  | Total Conversions >= 1.0; conversion_tag in [Nulo - Shop Now, *shop_now*]; filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign not in [Nulo: Canada] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Audience | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | audience | Find a Retailer - Nulo >= 1.0; filter_media_type in [Search, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Tactic | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | tactic | Find a Retailer - Nulo >= 1.0; filter_media_type in [Search, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Nulo - Shop Now, *shop_now*]; filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Nulo - Shop Now, *shop_now*]; filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Nulo - Shop Now, *shop_now*]; filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## Search - Amazon

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search - Amazon, All outcomes]; Spend >= 0.01; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search - Amazon, All outcomes]; Spend >= 0.01; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search - Amazon, All outcomes]; Impressions >= 1.0; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search - Amazon, All outcomes]; Impressions >= 1.0; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search - Amazon, All outcomes]; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search - Amazon, All outcomes]; Clicks >= 1.0; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search - Amazon, All outcomes]; Clicks >= 1.0; source_name in [Amazon Ads]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## Social

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Starts (starts) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Completed Plays (completed_plays) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | VCR (vcr) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPCV (cpcv) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Find a Retailer | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) |  | Find a Retailer - Nulo >= 1.0; filter_media_type in [Instagram, TikTok, Facebook+Instagram, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Pinterest, Snapchat, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Facebook, Facebook+Instagram, Pinterest, TikTok, Snapchat, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | media_type | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | date:week | filter_media_type in [Instagram, TikTok, Facebook+Instagram, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Media Type | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | media_type | Find a Retailer - Nulo >= 1.0; filter_media_type in [Instagram, TikTok, Facebook+Instagram, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, *where_to_buy*, https://www.nulo.com - GA4 (web) GA4 Where To Buy] |
| [ ] | combo-chart | Audience | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | audience | Find a Retailer - Nulo >= 1.0; filter_media_type in [Instagram, TikTok, Facebook+Instagram, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Tactic | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | tactic | filter_media_type in [Instagram, TikTok, Facebook+Instagram, All outcomes]; Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | combo-chart | Creative | Find a Retailer - Nulo (find_a_retailer_nulo), Find a Retailer - CPA (find_a_retailer_cpa) | creative_name | filter_media_type in [Instagram, TikTok, Facebook+Instagram, All outcomes]; Find a Retailer - Nulo >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; conversion_tag in [Find A Retailer, Nulo - Find a Retailer, Tiktok - Find a Retailer, https://www.nulo.com - GA4 (web) GA4 Where To Buy, *where_to_buy*] |
| [ ] | kpi | LPV | LPV (lpv) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | CPLPV | CPLPV (cplpv) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | LPV (lpv), CPLPV (cplpv) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Media Type | LPV (lpv), CPLPV (cplpv) | media_type | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; LPV >= 1.0 |
| [ ] | combo-chart | Audience | LPV (lpv), CPLPV (cplpv) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; LPV >= 1.0 |
| [ ] | combo-chart | Tactic | LPV (lpv), CPLPV (cplpv) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; LPV >= 1.0 |
| [ ] | combo-chart | Creative | LPV (lpv), CPLPV (cplpv) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; LPV >= 1.0 |

## StndDisplay

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data]; filter_media_type in [StndDisplay, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | Clicks >= 1.0; filter_media_type in [StndDisplay, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## Video

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Starts (starts) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Completed Plays (completed_plays) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | VCR (vcr) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPCV (cpcv) |  | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Video, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Video, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Video, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Video, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Video, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Video, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Video, All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Video, All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Video, All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | date:week | filter_media_type in [Video, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | audience | filter_media_type in [Video, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | tactic | filter_media_type in [Video, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | creative_name | filter_media_type in [Video, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

## YouTube

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Starts (starts) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | Completed Plays (completed_plays) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | VCR (vcr) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | kpi | Total Metrics | CPCV (cpcv) |  | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [YouTube, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [YouTube, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [YouTube, All outcomes]; Spend >= 0.01; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [YouTube, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [YouTube, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [YouTube, All outcomes]; Impressions >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [YouTube, All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [YouTube, All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [YouTube, All outcomes]; Clicks >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | date:week | filter_media_type in [YouTube, All outcomes]; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | audience | filter_media_type in [YouTube, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | tactic | filter_media_type in [YouTube, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv), VCR (vcr) | creative_name | filter_media_type in [YouTube, All outcomes]; Completed Plays >= 1.0; smart_campaign not in [Nulo: Canada, Nulo: Non Epitaph Data] |

