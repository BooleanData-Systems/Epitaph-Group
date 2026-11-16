# Build sheet: D097 Wurth Canada - 2026

Client: Wurth Canada. Type: Hand-built. Target live date: 2027-01-29.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Shows every campaign for the client, as Epitaph confirmed (Q23).

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  |  |
| [ ] | kpi | Clicks | Clicks (clicks) |  |  |
| [ ] | kpi | Spend | Spend (spend) |  |  |
| [ ] | kpi | CPM | CPM (cpm) |  |  |
| [ ] | kpi | CTR | CTR (ctr) |  |  |
| [ ] | kpi | CPC | CPC (cpc) |  |  |
| [ ] | kpi | Video Fully Played | Completed Plays (completed_plays) |  |  |
| [ ] | kpi | Revenue | Revenue (revenue) |  |  |
| [ ] | kpi | Purchases | Total Conversions (total_conversions) |  | conversion_tag in [Wurth - Purchase Confirmation, Wurth - Purchase, Purchase - Linkedin, Tag1, Add to Cart, Wurth Canada - GA4 (web) purchase] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week |  |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | filter_media_type in [Facebook+Instagram, Search, StndDisplay, Facebook, Linkedin, Video, ..., All outcomes]; Spend >= 0.01; language in [En, Fr] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01 |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week |  |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0 |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0 |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0 |
| [ ] | combo-chart | By Week | CPC (cpc), Clicks (clicks), CTR (ctr) | date:week |  |
| [ ] | combo-chart | Media Type | CPC (cpc), Clicks (clicks), CTR (ctr) | media_type | Clicks >= 1.0 |
| [ ] | combo-chart | Audience | CPC (cpc), Clicks (clicks), CTR (ctr) | audience | Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | CPC (cpc), Clicks (clicks), CTR (ctr) | tactic | Clicks >= 1.0 |
| [ ] | combo-chart | Creative | CPC (cpc), Clicks (clicks), CTR (ctr) | creative_name | Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Revenue (revenue), ROAS (roas) | date:week |  |
| [ ] | combo-chart | Media Type | Revenue (revenue), ROAS (roas) | media_type | Revenue >= 0.01 |
| [ ] | combo-chart | Audience | Revenue (revenue), ROAS (roas) | audience | Revenue >= 0.01 |
| [ ] | combo-chart | Tactic | Revenue (revenue), ROAS (roas) | tactic | Revenue >= 0.01 |
| [ ] | combo-chart | Creative | Revenue (revenue), ROAS (roas) | creative_name | Revenue >= 0.01 |
| [ ] | kpi | CPCV | CPCV (cpcv) |  |  |
| [ ] | kpi | Revenue | ROAS (roas) |  |  |
| [ ] | kpi | Purchases | CPA (cpa) |  | conversion_tag in [Wurth - Purchase Confirmation, Wurth - Purchase, Purchase - Linkedin, Tag1, Bing Purchase, Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation, Purchase - Linkedin, Bing Purchase, Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type | conversion_tag in [Tag1, Purchase - Linkedin, Wurth - Purchase, Wurth - Purchase Confirmation, Wurth Canada - GA4 (web) purchase, Bing Purchase]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation, Purchase - Linkedin, Bing Purchase, Wurth Canada - GA4 (web) purchase]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation, Purchase - Linkedin, Bing Purchase, Wurth Canada - GA4 (web) purchase]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation, Purchase - Linkedin, Bing Purchase, Wurth Canada - GA4 (web) purchase]; Total Conversions >= 1.0 |

## DemandGen - Google

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [DemandGen, All outcomes]; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [DemandGen, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [DemandGen, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [DemandGen, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [DemandGen, All outcomes]; Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [DemandGen, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [DemandGen, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [DemandGen, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [DemandGen, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [DemandGen, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [DemandGen, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [DemandGen, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [DemandGen, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Revenue (revenue), ROAS (roas) | date:week | filter_media_type in [DemandGen, All outcomes] |
| [ ] | combo-chart | Audience | Revenue (revenue), ROAS (roas) | audience | filter_media_type in [DemandGen, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | Tactic | Revenue (revenue), ROAS (roas) | tactic | filter_media_type in [DemandGen, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | Creative | Revenue (revenue), ROAS (roas) | creative_name | filter_media_type in [DemandGen, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | filter_media_type in [DemandGen, All outcomes]; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [DemandGen, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [DemandGen, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [DemandGen, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | kpi | Revenue | Revenue (revenue) |  | filter_media_type in [DemandGen, All outcomes] |
| [ ] | kpi | ROAS | ROAS (roas) |  | filter_media_type in [DemandGen, All outcomes] |

## Linkedin

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Linkedin, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Linkedin, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Linkedin, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Linkedin, All outcomes]; Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Linkedin, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Linkedin, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Linkedin, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | By Week | CPC (cpc), Clicks (clicks), CTR (ctr) | date:week | filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Audience | CPC (cpc), Clicks (clicks), CTR (ctr) | audience | Clicks >= 1.0; filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Tactic | CPC (cpc), Clicks (clicks), CTR (ctr) | tactic | filter_media_type in [Linkedin, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Creative | CPC (cpc), Clicks (clicks), CTR (ctr) | creative_name | filter_media_type in [Linkedin, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Leads (leads), CPL (cpl) | date:week | filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Audience | Leads (leads), CPL (cpl) | audience | filter_media_type in [Linkedin, All outcomes]; Leads >= 1.0 |
| [ ] | combo-chart | Tactic | Leads (leads), CPL (cpl) | tactic | filter_media_type in [Linkedin, All outcomes]; Leads >= 1.0 |
| [ ] | combo-chart | Creative | Leads (leads), CPL (cpl) | creative_name | filter_media_type in [Linkedin, All outcomes]; Leads >= 1.0 |
| [ ] | kpi | Leads | Leads (leads), CPL (cpl) |  | filter_media_type in [Linkedin, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Purchase - Linkedin]; filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Purchase - Linkedin]; filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | conversion_tag in [Purchase - Linkedin]; Total Conversions >= 1.0; filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | conversion_tag in [Purchase - Linkedin]; Total Conversions >= 1.0; filter_media_type in [Linkedin, All outcomes] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | conversion_tag in [Purchase - Linkedin]; Total Conversions >= 1.0; filter_media_type in [Linkedin, All outcomes] |

## Meta

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | Revenue | Revenue (revenue) |  | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Wurth - Purchase, Wurth - Purchase Confirmation, Tag1]; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | By Week | CPC (cpc), Clicks (clicks), CTR (ctr) | date:week | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Audience | CPC (cpc), Clicks (clicks), CTR (ctr) | audience | Clicks >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Tactic | CPC (cpc), Clicks (clicks), CTR (ctr) | tactic | Clicks >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Creative | CPC (cpc), Clicks (clicks), CTR (ctr) | creative_name | Clicks >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation]; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation]; Total Conversions >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation]; Total Conversions >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | conversion_tag in [Tag1, Wurth - Purchase, Wurth - Purchase Confirmation]; Total Conversions >= 1.0; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | bar-chart | By Week | Revenue (revenue) | date:week | filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | bar-chart | Audience | Revenue (revenue) | audience | Revenue >= 0.01; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Tactic | Revenue (revenue) | tactic | Revenue >= 0.01; filter_media_type in [Facebook+Instagram, All outcomes] |
| [ ] | combo-chart | Creative | Revenue (revenue) | creative_name | Revenue >= 0.01; filter_media_type in [Facebook+Instagram, All outcomes] |

## Search - Bing

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Revenue | Revenue (revenue) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | ROAS | ROAS (roas) |  | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax-OLD, PerfMax2, All outcomes] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Revenue (revenue), ROAS (roas) (labels: Impressions as Impression) | keyword |  |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; filter_tactic not in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; filter_tactic not in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax-OLD, PerfMax2, All outcomes] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax-OLD, PerfMax2, All outcomes] |
| [ ] | combo-chart | By Week | Revenue (revenue), ROAS (roas) | date:week | filter_tactic not in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Audience | Revenue (revenue), ROAS (roas) | audience | Revenue >= 0.01; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Tactic | Revenue (revenue), ROAS (roas) | tactic | Revenue >= 0.01; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Wurth Canada - GA4 (web) purchase, Bing Purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic not in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |

## Search - Bing - Performance Max

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, Performance Max, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | ROAS | ROAS (roas) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Revenue | Revenue (revenue) |  | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax-OLD, PerfMax2, All outcomes] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; filter_tactic in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; filter_tactic in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax-OLD, PerfMax2, All outcomes] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax-OLD, PerfMax2, All outcomes] |
| [ ] | combo-chart | By Week | Revenue (revenue), ROAS (roas) | date:week | filter_tactic in [PerfMax-OLD, PerfMax, PerfMax2, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Audience | Revenue (revenue), ROAS (roas) | audience | Revenue >= 0.01; filter_tactic in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | Tactic | Revenue (revenue), ROAS (roas) | tactic | Revenue >= 0.01; filter_tactic in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search - Bing, All outcomes] |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Wurth Canada - GA4 (web) purchase, Bing Purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Bing, All outcomes]; filter_tactic in [PerfMax, PerfMax2, PerfMax-OLD, All outcomes] |

## Search - Google

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | Revenue | Revenue (revenue) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | ROAS | ROAS (roas) |  | filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search, All outcomes]; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Revenue (revenue), ROAS (roas) (labels: Impressions as Impression) | keyword | source_name in [Google Ads] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Revenue (revenue), ROAS (roas) | date:week | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes] |
| [ ] | combo-chart | Audience | Revenue (revenue), ROAS (roas) | audience | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | Tactic | Revenue (revenue), ROAS (roas) | tactic | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; filter_tactic not in [PerfMax2, PerfMax-OLD, PerfMax, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Wurth Canada - GA4 (web) purchase, Bing Purchase]; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_tactic not in [PerfMax-OLD, PerfMax2, PerfMax, All outcomes]; filter_media_type in [Search, All outcomes] |

## Search - Google - Performance Max

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | Revenue | Revenue (revenue) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | ROAS | ROAS (roas) |  | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | By Week | CPC (cpc), Clicks (clicks), CTR (ctr) | date:week | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Audience | CPC (cpc), Clicks (clicks), CTR (ctr) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | CPC (cpc), Clicks (clicks), CTR (ctr) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Revenue (revenue), ROAS (roas) | date:week | filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Audience | Revenue (revenue), ROAS (roas) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | Tactic | Revenue (revenue), ROAS (roas) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Revenue >= 0.01 |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Wurth Canada - GA4 (web) purchase, Bing Purchase]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Perfmax, All outcomes] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Bing Purchase, Wurth Canada - GA4 (web) purchase]; filter_media_type in [Search - Perfmax, All outcomes] |

## StndDisplay - Google

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [StndDisplay - Google, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [StndDisplay - Google, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [StndDisplay - Google, All outcomes]; Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [StndDisplay - Google, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [StndDisplay - Google, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [StndDisplay - Google, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [StndDisplay - Google, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [StndDisplay - Google, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [StndDisplay - Google, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [StndDisplay - Google, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | filter_media_type in [StndDisplay - Google, All outcomes]; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [StndDisplay - Google, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [StndDisplay - Google, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [StndDisplay - Google, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Wurth Canada - GA4 (web) purchase] |
| [ ] | kpi | Purchases | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [StndDisplay - Google, All outcomes]; conversion_tag in [Wurth Canada - GA4 (web) purchase] |

## YouTube

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Total Metrics | Impressions (impressions) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | Clicks (clicks) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | Spend (spend) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | CPM (cpm) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | CTR (ctr) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | CPC (cpc) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | Completed Plays (completed_plays) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | kpi | Total Metrics | CPCV (cpcv) |  | filter_media_type in [YouTube, All outcomes] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [YouTube, All outcomes] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [YouTube, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [YouTube, All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [YouTube, All outcomes]; Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [YouTube, All outcomes] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [YouTube, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [YouTube, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [YouTube, All outcomes]; Impressions >= 1.0 |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [YouTube, All outcomes] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [YouTube, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [YouTube, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [YouTube, All outcomes]; Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv) | date:week | filter_media_type in [YouTube, All outcomes] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [YouTube, All outcomes]; Completed Plays >= 1.0 |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [YouTube, All outcomes]; Completed Plays >= 1.0 |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [YouTube, All outcomes]; Completed Plays >= 1.0 |

