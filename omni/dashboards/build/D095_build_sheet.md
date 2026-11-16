# Build sheet: D095 Sysco - ROC & QC

Client: Sysco. Type: Standard. Target live date: 2026-12-18.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Shows every campaign for the client, as Epitaph confirmed (Q23).

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  |  |
| [ ] | kpi | Sign Ups | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Sysco Canada Website - GA4 (web) sign_up] |
| [ ] | kpi | Form Submits | Total Conversions (total_conversions) |  | conversion_tag in [Sysco Canada Website - GA4 (web) form_submit] |
| [ ] | kpi | Call Contacts | Total Conversions (total_conversions) |  | conversion_tag in [Sysco.ca - GA4 (web) call_contact] |
| [ ] | kpi | Email Submissions | Total Conversions (total_conversions) |  | conversion_tag in [Sysco.ca - GA4 (web) email_contact] |
| [ ] | kpi | Catalog Downloads | Total Conversions (total_conversions) |  | conversion_tag in [Sysco Canada Website - GA4 (web) Download] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week |  |
| [ ] | bar-chart | Campaign | Spend (spend) | campaign_name | filter_media_type in [Facebook+Instagram, Search, StndDisplay, *NativeDis*, *Display*, *Search - Bing*, ..., All outcomes]; Spend >= 0.01 |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01 |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week |  |
| [ ] | combo-chart | Campaign | Impressions (impressions), CPM (cpm) | campaign_name | Impressions >= 1.0 |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0 |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week |  |
| [ ] | combo-chart | Campaign | Clicks (clicks), CPC (cpc), CTR (ctr) | campaign_name | Clicks >= 1.0 |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0 |
| [ ] | combo-chart | By Week | Total Conversions (total_conversions), CPA (cpa) | date:week | conversion_tag in [Sysco Canada Website - GA4 (web) sign_up] |
| [ ] | combo-chart | Campaign | Total Conversions (total_conversions), CPA (cpa) | campaign_name | conversion_tag in [Sysco Canada Website - GA4 (web) sign_up]; Total Conversions >= 1.0 |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Sysco Canada Website - GA4 (web) sign_up] |
| [ ] | kpi | Clicks | Clicks (clicks) |  |  |
| [ ] | kpi | Spend | Spend (spend) |  |  |
| [ ] | kpi | CPM | CPM (cpm) |  |  |
| [ ] | kpi | CTR | CTR (ctr) |  |  |
| [ ] | kpi | CPC | CPC (cpc) |  |  |
| [ ] | kpi | Total Conversions | Total Conversions (total_conversions) |  |  |
| [ ] | kpi | CPA | CPA (cpa) |  |  |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01 |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0 |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0 |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Sysco Canada Website - GA4 (web) sign_up] |

## Search - QC

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Sign Ups | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Sysco Canada Website - GA4 (web) sign_up]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Form Submits | Total Conversions (total_conversions) |  | conversion_tag in [Sysco Canada Website - GA4 (web) form_submit]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Email Submissions | Total Conversions (total_conversions) |  | conversion_tag in [Sysco.ca - GA4 (web) email_contact]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Call Contacts | Total Conversions (total_conversions) |  | conversion_tag in [Sysco.ca - GA4 (web) call_contact]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Catalog Downloads | Total Conversions (total_conversions) |  | conversion_tag in [Sysco Canada Website - GA4 (web) Download]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Total Conversions | Total Conversions (total_conversions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CPA | CPA (cpa) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: QC] |

## Search - ROC

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads]; smart_campaign in [Sysco: ROC] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: ROC] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: ROC] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Sign Ups | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Sysco Canada Website - GA4 (web) sign_up]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Form Submits | Total Conversions (total_conversions) |  | conversion_tag in [Sysco Canada Website - GA4 (web) form_submit]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Call Contacts | Total Conversions (total_conversions) |  | conversion_tag in [Sysco.ca - GA4 (web) call_contact]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Email Submissions | Total Conversions (total_conversions) |  | conversion_tag in [Sysco.ca - GA4 (web) email_contact]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Catalog Downloads | Total Conversions (total_conversions) |  | conversion_tag in [Sysco Canada Website - GA4 (web) Download]; filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | Total Conversions | Total Conversions (total_conversions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | kpi | CPA | CPA (cpa) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Sysco: ROC] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: ROC] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: ROC] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: ROC] |

## Social - QC

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | By Week | Spend (spend) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | By Week | Impressions (impressions), CPM (cpm) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Pinterest, Snapchat, Linkedin, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | By Week | Clicks (clicks), CPC (cpc), CTR (ctr) | date:week | filter_media_type in [Facebook, Facebook+Instagram, Snapchat, TikTok, Pinterest, Linkedin, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Facebook, Facebook+Instagram, Pinterest, TikTok, Snapchat, Linkedin, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | By Week | Completed Plays (completed_plays), CPCV (cpcv) | date:week | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Audience | Completed Plays (completed_plays), CPCV (cpcv) | audience | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Completed Plays >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Tactic | Completed Plays (completed_plays), CPCV (cpcv) | tactic | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Completed Plays >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Linkedin, Pinterest, Snapchat, All outcomes]; smart_campaign in [Sysco: QC] |
| [ ] | bar-chart | Creative | Spend (spend) | creative_name | filter_media_type in [Facebook+Instagram, Facebook, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Spend >= 0.01; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Creative | Impressions (impressions), CPM (cpm) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Impressions >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Creative | Clicks (clicks), CPC (cpc), CTR (ctr) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Clicks >= 1.0; smart_campaign in [Sysco: QC] |
| [ ] | combo-chart | Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | filter_media_type in [Facebook, Facebook+Instagram, TikTok, Snapchat, Pinterest, Linkedin, All outcomes]; Completed Plays >= 1.0; smart_campaign in [Sysco: QC] |

