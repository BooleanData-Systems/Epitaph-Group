# Build sheet: D091 SiriusXM - Streaming

Client: SiriusXM. Type: Custom. Target live date: 2026-12-11.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Not rebuilt: 6 widgets, source Goloot stopped over 90 days ago (A23); 21 widgets, source GoLoot stopped over 90 days ago (A23)

## 2024 - Monthly

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | combo-chart | Trials Goal | Performance Trials (performance_trials), Organic Trials (organic_trials), Trials - Goal (trials_goal) | date | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*] |
| [ ] | combo-chart | Flow Starts VS Trials | Total Flow Starts (total_flow_starts), Total Trials (total_trials), Trials - SC (trials_sc) | date | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Satellite*, *Other*] |
| [ ] | combo-chart | Adobe by Month - Performance | Performance Trials (performance_trials), Performance Flow Starts (performance_flow_starts) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | combo-chart | Adobe by Month - Organic | Organic Trials (organic_trials), Organic Flow Starts (organic_flow_starts) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | line-chart | Clicks by Month | Clicks (clicks) | media_type, date:month | Spend >= 0.01; filter_media_type not in [Unclassified, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Trials over Clicks - Monthly | Clicks (clicks), Performance Trials (performance_trials), Organic Trials (organic_trials) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | line-chart | Adobe and Scorecard CPT Monthly | CPT (cpt), Performance CPT (performance_cpt), Scorecard CPT (scorecard_cpt) (labels: CPT as Adobe CPT, Performance CPT as Adobe Performance CPT) | date:month | site_key not in [Scorecard - IAP, Default Site Key, *IAP*, *Satellite*, *Other*] |

## 2025 - Monthly

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | combo-chart | Trials Goal | Performance Trials (performance_trials), Organic Trials (organic_trials), Trials - Goal (trials_goal) | date | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*] |
| [ ] | combo-chart | Flow Starts VS Trials | Total Flow Starts (total_flow_starts), Total Trials (total_trials), Trials - SC (trials_sc) | date | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Satellite*, *Other*] |
| [ ] | combo-chart | Adobe by Month - Performance | Performance Trials (performance_trials), Performance Flow Starts (performance_flow_starts) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | combo-chart | Adobe by Month - Organic | Organic Trials (organic_trials), Organic Flow Starts (organic_flow_starts) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | line-chart | Clicks by Month | Clicks (clicks) | media_type, date:month | Spend >= 0.01; filter_media_type not in [Unclassified, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Trials over Clicks - Monthly | Clicks (clicks), Performance Trials (performance_trials), Organic Trials (organic_trials) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | line-chart | Adobe and Scorecard CPT Monthly | CPT (cpt), Performance CPT (performance_cpt), Scorecard CPT (scorecard_cpt) (labels: CPT as Adobe CPT, Performance CPT as Adobe Performance CPT) | date:month | site_key not in [Scorecard - IAP, Default Site Key, *IAP*, *Satellite*, *Other*] |

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Adobe | Performance Trials (performance_trials), Performance CPT (performance_cpt), Organic Trials (organic_trials), CPT (cpt) |  | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO, Streaming - Organic] |
| [ ] | kpi | Platform Conversions | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [SiriusXM - Streaming Subscription Complete, Streaming Purchase, *SiriusXM - Streaming - Subscriber Confirmation*, Inactive Purchase, SiriusXM - Inactive Subscription Complete, SiriusXM - Satellite - Complete, ...]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Performance Trials (performance_trials), Performance CPT (performance_cpt), Organic Trials (organic_trials), CPT (cpt), Trials - SC (trials_sc) | date:day | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Satellite*, *Other*]; campaign_name in [*Streaming*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO, Streaming - Organic] |
| [ ] | bar-chart | Media Type by Adobe Trials | Performance Trials (performance_trials) | media_type | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; Performance Trials >= 1.0; campaign_name in [*Streaming*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO] |
| [ ] | bar-chart | Media Type by CPT | Performance CPT (performance_cpt) | media_type | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; Performance Trials >= 1.0; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | conversion_tag in [SiriusXM - Streaming Subscription Complete, Streaming Purchase, *SiriusXM - Streaming - Subscriber Confirmation*, Inactive Purchase, SiriusXM - Inactive Subscription Complete, SiriusXM - Satellite - Complete, ...]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type | conversion_tag in [SiriusXM - Streaming Subscription Complete, Streaming Purchase, SiriusXM - Streaming - Subscriber Confirmation, Inactive Purchase, SiriusXM - Inactive Subscription Complete, SiriusXM - Satellite - Complete, ...]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | conversion_tag in [SiriusXM - Streaming Subscription Complete, Streaming Purchase, *SiriusXM - Streaming - Subscriber Confirmation*, Inactive Purchase, SiriusXM - Inactive Subscription Complete, SiriusXM - Satellite - Complete, ...]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | conversion_tag in [SiriusXM - Streaming Subscription Complete, Streaming Purchase, *SiriusXM - Streaming - Subscriber Confirmation*, Inactive Purchase, SiriusXM - Inactive Subscription Complete, SiriusXM - Satellite - Complete, ...]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Media Type | Completed Plays (completed_plays), CPCV (cpcv) | media_type | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv) | audience | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv) | tactic | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPM | CPM (cpm) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPC | CPC (cpc) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | conversion_tag in [SiriusXM - Streaming Subscription Complete, Streaming Purchase, *SiriusXM - Streaming - Subscriber Confirmation*, Inactive Purchase, SiriusXM - Inactive Subscription Complete, SiriusXM - Satellite - Complete, ...]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |

## Display

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Platform Conversions | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase, SiriusXM - Satellite - Complete, SiriusXM - Streaming 6MOFREE - Complete, SiriusXM - Satellite 6MOFREE - Complete]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase, SiriusXM - Satellite - Complete, SiriusXM - Satellite 6MOFREE - Complete, SiriusXM - Streaming 6MOFREE - Complete]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase, SiriusXM - Satellite - Complete, SiriusXM - Streaming 6MOFREE - Complete, SiriusXM - Satellite 6MOFREE - Complete]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase, SiriusXM - Satellite - Complete, SiriusXM - Satellite 6MOFREE - Complete, SiriusXM - Streaming 6MOFREE - Complete]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [StndDisplay, NativeDis, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [NativeDis, StndDisplay, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase, SiriusXM - Satellite - Complete, SiriusXM - Streaming 6MOFREE - Complete, SiriusXM - Satellite 6MOFREE - Complete]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [NativeDis, StndDisplay, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [StndDisplay, NativeDis, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CATPSRTP4MOFREE | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE]; filter_media_type in [Programmatic, All outcomes] |
| [ ] | kpi | PARTNERSAT4MO | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [PARTNERSAT4MO]; filter_media_type in [Programmatic, All outcomes] |

## GoLoot (not rebuilt)

every widget in this section is retired; data stays available by date range

## Main

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Organic | Trials - SC (trials_sc) |  | site_key in [Scorecard - Organic] |
| [ ] | kpi | Total | Trials - SC (trials_sc), Scorecard CPT (scorecard_cpt) (labels: Scorecard CPT as CPT - SC) |  | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Other*, *Satellite*] |
| [ ] | combo-chart | Trials Goal | Performance Trials (performance_trials), Organic Trials (organic_trials), Trials - Goal (trials_goal) | date | site_key not in [Default Site Key, *IAP*, *Other*, *Satellite*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO, Streaming - Organic] |
| [ ] | combo-chart | Flow Starts VS Trials | Total Flow Starts (total_flow_starts), Total Trials (total_trials), Trials - SC (trials_sc) | date | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Other*, *Satellite*] |
| [ ] | combo-chart | Adobe by Month - Performance | Performance Trials (performance_trials), Performance Flow Starts (performance_flow_starts) | date:month | site_key not in [Default Site Key, *IAP*, *Other*, *Satellite*]; campaign_name in [Streaming] |
| [ ] | line-chart | Clicks by Month | Clicks (clicks) | media_type, date:month | Spend >= 0.01; filter_media_type not in [Unclassified, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Trials over Clicks - Daily | Clicks (clicks), Performance Trials (performance_trials), Organic Trials (organic_trials) | date:day | site_key not in [Default Site Key, *Satellite*, *IAP*, *Other*]; campaign_name in [Streaming] |
| [ ] | line-chart | Adobe Flow Starts by Day | Performance Flow Starts (performance_flow_starts), Organic Flow Starts (organic_flow_starts) | date:day | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | combo-chart | Flow Starts VS Trials Daily | Total Flow Starts (total_flow_starts), Total Trials (total_trials) | date:day | site_key not in [Default Site Key, Scorecard - IAP, *IAP*, *Satellite*, *Other*] |
| [ ] | table | Untitled Widget | Throughput Percentage (throughput_percentage) | date | site_key in [Programmatic - Streaming, Search - Streaming, Social Paid - Streaming, Streaming - Organic] |
| [ ] | combo-chart | Adobe by Month - Organic | Organic Trials (organic_trials), Organic Flow Starts (organic_flow_starts) | date:month | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; campaign_name in [Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Total Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPM | CPM (cpm) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPC | CPC (cpc) |  | smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Trials over Clicks - Monthly | Clicks (clicks), Performance Trials (performance_trials), Organic Trials (organic_trials) | date:month | site_key not in [Default Site Key, *IAP*, *Other*, *Satellite*]; campaign_name in [Streaming] |
| [ ] | line-chart | Adobe and Scorecard CPT Monthly | CPT (cpt), Performance CPT (performance_cpt), Scorecard CPT (scorecard_cpt) (labels: CPT as Adobe CPT, Performance CPT as Adobe Performance CPT) | date:month | site_key not in [Scorecard - IAP, Default Site Key, *IAP*, *Satellite*, *Other*] |
| [ ] | kpi | Streaming | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE] |
| [ ] | kpi | Total | Performance Trials (performance_trials), Performance CPT (performance_cpt) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [PARTNERSAT4MO, CATPSRTP4MOFREE]; campaign_name not in [Commuter Streaming Test] |
| [ ] | kpi | Organic Trial Total | Organic Trials (organic_trials), CPT (cpt) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [Streaming - Organic] |
| [ ] | kpi | Trials Total | Total Trials (total_trials), CPT (cpt) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO, Streaming - Organic, 5 for 12 - Satellite, 5 for 12 - Streaming] |
| [ ] | kpi | Starts Totals | Performance Flow Starts (performance_flow_starts), Organic Flow Starts (organic_flow_starts), Total Flow Starts (total_flow_starts), Throughput Percentage (throughput_percentage) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*] |
| [ ] | kpi | Satellite | Trials - SC (trials_sc) |  | site_key in [Search - Dual Offer, Social Paid - Dual Offer, Programmatic - Dual Offer] |
| [ ] | bar-chart | SXMDUAL Daily | Performance Trials (performance_trials) | date:day | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [SXMDUAL] |
| [ ] | kpi | Satellite | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [PARTNERSAT4MO] |
| [ ] | line-chart | CATPSRTP4MOFREE | Performance Trials (performance_trials) | date | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE] |
| [ ] | line-chart | 3MOPARTNER2 | Performance Trials (performance_trials) | date | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [3MOPARTNER2] |
| [ ] | kpi | 5 for 12 Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Dual Offer Spend | Spend (spend) |  | smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Satellite | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [5 for 12 - Satellite] |
| [ ] | kpi | Streaming | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [5 for 12 - Streaming] |
| [ ] | kpi | Total | Performance Trials (performance_trials), Performance CPT (performance_cpt) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [5 for 12 - Satellite, 5 for 12 - Streaming]; campaign_name in [Commuter Streaming Test] |
| [ ] | kpi | 5 for 12 | Trials - SC (trials_sc) |  | site_key in [Search - Dual Offer, Social Paid - Dual Offer, Programmatic - Dual Offer] |

## Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Platform Conversions | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [Streaming Purchase, SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, SiriusXM - Inactive Subscription Complete]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | combo-chart | By Day | Performance Trials (performance_trials), Performance CPT (performance_cpt) | date:day | site_key in [Search - Streaming, Search - Dual Offer, Search - Streaming Dual Offer]; campaign_name not in [*IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Search, All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, SiriusXM - Inactive Subscription Complete]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Search, All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, SiriusXM - Inactive Subscription Complete]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name not in [*_Offer_Test*, *Commuter*] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Search, All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, SiriusXM - Inactive Subscription Complete]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CATPSRTP4MOFREE | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE]; filter_media_type in [Search, All outcomes] |
| [ ] | kpi | PARTNERSAT4MO | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [PARTNERSAT4MO]; filter_media_type in [Search, All outcomes] |
| [ ] | kpi | Performance Trial Total | Performance Trials (performance_trials), Performance CPT (performance_cpt) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO]; filter_media_type in [Search, All outcomes] |
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Platform Conversions | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [SXM Commuters 5$ for 12 Months - Complete]; smart_campaign in [SiriusXM: Streaming]; campaign_name in [*_Offer_Test*, *Commuter*] |
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Platform Conversions | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [Streaming Purchase, SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, SiriusXM - Inactive Subscription Complete, SXM Commuters 5$ for 12 Months - Complete]; smart_campaign in [SiriusXM: Streaming] |

## Social

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Streaming - Platform Conversions | Total Conversions (total_conversions) |  | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Performance Trials (performance_trials), Performance CPT (performance_cpt) | date:day | site_key in [Social Paid, Social Paid - Streaming, Social Paid - Dual Offer, Social Paid - Streaming Dual Offer]; campaign_name not in [*Satellite*, *IAP*, *Other*]; program_code in [CATPSRTP4MOFREE, PARTNERSAT4MO] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, Inactive Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, Inactive Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, Inactive Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Pinterest, Snapchat, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Facebook, Facebook+Instagram, Pinterest, TikTok, Snapchat, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, Inactive Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Inactive - Platform Conversions | Total Conversions (total_conversions) |  | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [Inactive Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Platform Conversions CPA | CPA (cpa) |  | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase, Inactive Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CATPSRTP4MOFREE | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [CATPSRTP4MOFREE]; filter_media_type in [Social, All outcomes] |
| [ ] | kpi | PARTNERSAT4MO | Performance Trials (performance_trials) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [PARTNERSAT4MO]; filter_media_type in [Social, All outcomes] |
| [ ] | kpi | Performance Trial Total | Performance Trials (performance_trials), Performance CPT (performance_cpt) |  | site_key not in [Default Site Key, *IAP*, *Satellite*, *Other*]; program_code in [PARTNERSAT4MO, CATPSRTP4MOFREE]; filter_media_type in [Social, All outcomes] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [SiriusXM - Streaming - Subscriber Confirmation, SiriusXM - Streaming Subscription Complete, Streaming Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [Inactive Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [Inactive Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [Inactive Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, ..., All outcomes]; conversion_tag in [Inactive Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |

## Video

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Platform Conversions | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Video, CTV, YouTube, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [CTV, Video, YouTube, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Video, CTV, YouTube, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [CTV, Video, YouTube, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [YouTube, Video, CTV, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [CTV, YouTube, Video, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Video, CTV, YouTube, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [CTV, Video, YouTube, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [CTV, YouTube, Video, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [CTV, YouTube, Video, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [CTV, Video, YouTube, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [CTV, YouTube, Video, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [CTV, Video, YouTube, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | filter_media_type in [CTV, YouTube, Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [Video, CTV, YouTube, All outcomes]; Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [CTV, YouTube, Video, All outcomes]; Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | filter_media_type in [Video, All outcomes]; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Total Conversions (total_conversions), CPA (cpa) | creative_name | filter_media_type in [CTV, Video, YouTube, All outcomes]; conversion_tag in [SiriusXM - Streaming Subscription Complete, *SiriusXM - Streaming - Subscriber Confirmation*, Streaming Purchase]; Total Conversions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Video, CTV, YouTube, All outcomes]; Spend >= 0.01; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [CTV, YouTube, Video, All outcomes]; Impressions >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [CTV, Video, YouTube, All outcomes]; Clicks >= 1.0; smart_campaign in [SiriusXM: Streaming] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [CTV, YouTube, Video, All outcomes]; Completed Plays >= 1.0; smart_campaign in [SiriusXM: Streaming] |

