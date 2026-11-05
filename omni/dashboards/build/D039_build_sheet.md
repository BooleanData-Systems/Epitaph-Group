# Build sheet: D039 KHP - Grants

Client: Kids Help Phone. Type: Standard. Target live date: 2026-12-18.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Google Ads Grants spend is USD and shows in CAD via dim_fx_rate (Q20).

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | bar-chart | By Week | Spend (spend) | date:week | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | language in [En, Fr]; Spend >= 0.01; filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Impressions (impressions) | date:week | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Media Type | Impressions (impressions) | media_type | Impressions >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Impressions (impressions) | audience | Impressions >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Impressions (impressions) | tactic | Impressions >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | smart_campaign in [Kids Help Phone: Grants] |

## Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Kids Help Phone: Grants] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Kids Help Phone: Grants] |

