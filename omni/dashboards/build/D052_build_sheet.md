# Build sheet: D052 KHP - Search

Client: Kids Help Phone. Type: Standard. Target live date: 2026-12-18.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Google Ads Grants spend is USD and shows in CAD via dim_fx_rate (Q20).

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) |  | source_name in [Google Ads, Microsoft Advertising] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | source_name in [Google Ads, Microsoft Advertising] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | language in [En, Fr]; Spend >= 0.01; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | bar-chart | Campaign | Spend (spend) | campaign_filter | Spend >= 0.01; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Campaign | Impressions (impressions), CPM (cpm) | campaign_filter | Impressions >= 1.0; source_name in [Microsoft Advertising, Google Ads] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; source_name in [Microsoft Advertising, Google Ads] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; source_name in [Google Ads, Microsoft Advertising] |
| [ ] | combo-chart | Campaign | Clicks (clicks), CPC (cpc), CTR (ctr) | campaign_filter | Clicks >= 1.0; source_name in [Google Ads, Microsoft Advertising] |

## Search - Bing

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) |  | source_name in [Microsoft Advertising]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Microsoft Advertising] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | source_name in [Microsoft Advertising]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | source_name in [Microsoft Advertising]; Spend >= 0.01; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | source_name in [Microsoft Advertising]; Spend >= 0.01; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | source_name in [Microsoft Advertising]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | source_name in [Microsoft Advertising]; Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | source_name in [Microsoft Advertising]; Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | source_name in [Microsoft Advertising]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | source_name in [Microsoft Advertising]; Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | source_name in [Microsoft Advertising]; Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Campaign | Spend (spend) | campaign_filter | source_name in [Microsoft Advertising]; Spend >= 0.01; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Campaign | Impressions (impressions), CPM (cpm) | campaign_filter | source_name in [Microsoft Advertising]; Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Campaign | Clicks (clicks), CPC (cpc), CTR (ctr) | campaign_filter | source_name in [Microsoft Advertising]; Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes] |

## Search - Google Grants

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 1.0; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 1.0; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |

## Search - Google Paid

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) |  | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Campaign | Spend (spend) | campaign_filter | filter_media_type in [Search, All outcomes]; Spend >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Campaign | Impressions (impressions), CPM (cpm) | campaign_filter | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Campaign | Clicks (clicks), CPC (cpc), CTR (ctr) | campaign_filter | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; source_name in [Google Ads]; smart_campaign not in [Kids Help Phone: Grants] |

