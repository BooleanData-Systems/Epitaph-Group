# Build sheet: D092 SiriusXM - Commuter 2.0

Client: SiriusXM. Type: Custom. Target live date: 2026-12-11.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.


## Acquisition

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPC | CPC (cpc) |  | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Commuters Complete | Total Conversions (total_conversions), CPA (cpa) |  | smart_campaign in [SiriusXM: Commuter Acquisition]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete, SXM Satellite Acquisition 2026 Complete, SiriusXM - Commuters Complete] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | smart_campaign in [SiriusXM: Commuter Acquisition]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete, SXM Satellite Acquisition 2026 Complete, SiriusXM - Commuters Complete] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type | smart_campaign in [SiriusXM: Commuter Acquisition]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete, SXM Satellite Acquisition 2026 Complete, SiriusXM - Commuters Complete]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | smart_campaign in [SiriusXM: Commuter Acquisition]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete, SXM Satellite Acquisition 2026 Complete, SiriusXM - Commuters Complete]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | smart_campaign in [SiriusXM: Commuter Acquisition]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete, SXM Satellite Acquisition 2026 Complete, SiriusXM - Commuters Complete]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | smart_campaign in [SiriusXM: Commuter Acquisition]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete, SXM Satellite Acquisition 2026 Complete, SiriusXM - Commuters Complete]; Total Conversions >= 1.0 |

## Adobe Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total | Starts - Commuter (starts_commuter), Activations - Commuter (activations_commuter), Throughput (throughput) |  | program_code in [PERF1246, PARTNER1246, COMMCA1246]; site_key not in [Unclassified] |
| [ ] | kpi | COMMCA1246 Total | Starts - Commuter (starts_commuter), Activations - Commuter (activations_commuter), Throughput (throughput) |  | program_code in [COMMCA1246]; site_key not in [Unclassified] |
| [ ] | kpi | PERF1246 Total | Starts - Commuter (starts_commuter), Activations - Commuter (activations_commuter), Throughput (throughput) |  | program_code in [PERF1246]; site_key not in [Unclassified] |
| [ ] | combo-chart | COMMCA1246 Starts by Campaign | Starts - Commuter (starts_commuter), Throughput (throughput) | media_type, campaign_name | program_code in [COMMCA1246]; site_key not in [Unclassified]; Starts - Commuter >= 1.0 |
| [ ] | combo-chart | PERF1246 Starts by Campaign | Starts - Commuter (starts_commuter), Throughput (throughput) | media_type, campaign_name | program_code in [PERF1246]; site_key not in [Unclassified]; Starts - Commuter >= 1.0 |
| [ ] | bar-chart | COMMCA1246 Activations by Campaign | Activations - Commuter (activations_commuter) | campaign_name, media_type | program_code in [COMMCA1246]; site_key not in [Unclassified]; Activations - Commuter >= 1.0 |
| [ ] | bar-chart | PERF1246 Activations by Campaign | Activations - Commuter (activations_commuter) | campaign_name, media_type | program_code in [PERF1246]; site_key not in [Unclassified]; Activations - Commuter >= 1.0 |
| [ ] | kpi | PARTNER1246 Total | Starts - Commuter (starts_commuter), Activations - Commuter (activations_commuter), Throughput (throughput) |  | program_code in [PARTNER1246]; site_key not in [Unclassified] |
| [ ] | combo-chart | BRAND1246  Starts by Campaign | Starts - Commuter (starts_commuter), Throughput (throughput) | media_type, campaign_name | program_code in [PARTNER1246]; site_key not in [Unclassified]; Starts - Commuter >= 1.0 |
| [ ] | bar-chart | PARTNER1246 Activations by Campaign | Activations - Commuter (activations_commuter) | campaign_name, media_type | program_code in [PARTNER1246]; site_key not in [Unclassified]; Activations - Commuter >= 1.0 |

## Brand Awareness

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | CPM | CPM (cpm) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | CPC | CPC (cpc) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | Video Fully Played | Starts (starts) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | By Day | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | date:day | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Media Type | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | media_type | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Audience | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | audience | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Tactic | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | tactic | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | combo-chart | Creative | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |
| [ ] | kpi | Video Fully Played | Completed Plays (completed_plays) |  | smart_campaign in [SiriusXM: Commuter Brand]; campaign_name not in [Commuter Acquisition Trailers, Commuter Acquisition Trialers, Commuter Acquisition Winback] |

## CTV

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [CTV, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [CTV, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [CTV, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [CTV, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [CTV, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [CTV, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [CTV, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [CTV, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [CTV, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [CTV, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPC | CPC (cpc) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Views | Starts (starts) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Video Fully Played | Completed Plays (completed_plays) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | filter_media_type in [Facebook+Instagram, Snapchat, Search, StndDisplay, TikTok, Video, ..., All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | date:day | smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Media Type | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | media_type | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | audience | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | tactic | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |

## DOOH

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [DOOH, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [DOOH, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [DOOH, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [DOOH, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [DOOH, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [DOOH, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [DOOH, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [DOOH, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [DOOH, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [DOOH, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [DOOH, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |

## Display

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Netflix Pause Ads, Direct Buys - One Time Uploads] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | bar-chart | Platform | Spend (spend) | source_name, creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Platform | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |
| [ ] | combo-chart | Platform | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name not in [Campaign Manager 360, Direct Buys - One Time Uploads, Netflix Pause Ads] |

## Jolt Media

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Planned Impressions: 23,809,524 | Impressions (impressions) |  |  |
| [ ] | combo-chart | By Day | Impressions (impressions), Spots (spots), Spend (spend) | date:day |  |
| [ ] | combo-chart | By Province | Impressions (impressions), Spots (spots), Spend (spend) | province |  |
| [ ] | combo-chart | By Creative | Impressions (impressions), Spots (spots), Spend (spend) | creative_name |  |
| [ ] | kpi | Total Spend: $43,200.00 | Spend (spend) |  |  |
| [ ] | kpi | Untitled widget | Spots (spots) |  |  |

## Meta - Acquisition

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |

## Meta - Brand

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Views | Starts (starts) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Video fully played | Completed Plays (completed_plays) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Campaign | Spend (spend) | campaign_name | filter_media_type in [Facebook+Instagram, Facebook, Instagram, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Campaign | Impressions (impressions), CPM (cpm) | campaign_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Campaign | Clicks (clicks), CPC (cpc), CTR (ctr) | campaign_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Campaign | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | campaign_name | filter_media_type in [Facebook, Facebook+Instagram, Instagram, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |

## Pause Ads

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition]; source_name in [Campaign Manager 360, Netflix Pause Ads] |

## Reddit

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Reddit, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Reddit, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Reddit, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Reddit, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Reddit, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Reddit, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [*Reddit*, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [*Reddit*, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [*Reddit*, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [*Reddit*, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [*Reddit*, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [*Reddit*, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [*Reddit*, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [*Reddit*, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [*Reddit*, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [*Reddit*, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [*Reddit*, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [*Reddit*, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |

## Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Impressions (impressions) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Impressions (impressions) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Acquisition] |

## TikTok

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Views | Starts (starts) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | Video fully played | Completed Plays (completed_plays) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [TikTok, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [TikTok, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [TikTok, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | By Day | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | date:day | filter_media_type in [TikTok, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Audience | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [TikTok, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Tactic | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [TikTok, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |
| [ ] | combo-chart | Creative | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [TikTok, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand, SiriusXM: Commuter Acquisition] |

## YouTube

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Views | Starts (starts) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | Video fully played | Completed Plays (completed_plays) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Youtube, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Youtube, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Youtube, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Youtube, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Youtube, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Youtube, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Youtube, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Youtube, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Youtube, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | By Day | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | date:day | filter_media_type in [Youtube, All outcomes]; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Audience | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [Youtube, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Tactic | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [Youtube, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |
| [ ] | combo-chart | Creative | Starts (starts), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [Youtube, All outcomes]; Completed Plays >= 1.0; Starts >= 1.0; smart_campaign in [SiriusXM: Commuter Brand] |

