# Build sheet: D059 Ottawa Tourism - Always on Search

Client: Ottawa Tourism. Type: Standard. Target live date: 2027-01-22.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- Likely merged into one Ottawa Tourism dashboard once Epitaph approves the template.

## Adara

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Untitled widget | Impressions / Clicks |  | campaign_name in [Always On] |
| [ ] | kpi | Untitled widget | Site Visits (site_visits) |  | campaign_name in [Always On] |
| [ ] | kpi | Untitled widget | Uniques Reached |  | campaign_name in [Always On] |
| [ ] | kpi | Untitled widget | Flight Searches (flight_searches) |  | campaign_name in [Always On] |
| [ ] | kpi | Untitled widget | Flight Bookings (flight_bookings) |  | campaign_name in [Always On] |
| [ ] | kpi | Untitled widget | Hotel Searches (hotel_searches) |  | campaign_name in [Always On] |
| [ ] | kpi | Untitled widget | Hotel Bookings (hotel_bookings) |  | campaign_name in [Always On] |
| [ ] | bar-chart | By Month | Impressions / Clicks, Site Visits (site_visits), Uniques Reached | date:month | campaign_name in [Always On] |
| [ ] | bar-chart | By Channel | Impressions / Clicks, Site Visits (site_visits), Uniques Reached | media_type | campaign_name in [Always On] |
| [ ] | bar-chart | By Month | Flight Searches (flight_searches), Flight Bookings (flight_bookings) | date:month | campaign_name in [Always On] |
| [ ] | bar-chart | By Channel | Flight Searches (flight_searches), Flight Bookings (flight_bookings) | media_type | campaign_name in [Always On] |
| [ ] | bar-chart | By Month | Hotel Searches (hotel_searches), Hotel Bookings (hotel_bookings) | date:month | campaign_name in [Always On] |
| [ ] | bar-chart | By Channel | Hotel Searches (hotel_searches), Hotel Bookings (hotel_bookings) | media_type | campaign_name in [Always On] |

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Media Type | Spend (spend) | media_type | Spend >= 0.01; filter_media_type in [Search, Search - Perfmax, Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search]; language in [En, Fr] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Media Type | Impressions (impressions), CPM (cpm) | media_type | Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Media Type | Clicks (clicks), CPC (cpc), CTR (ctr) | media_type | Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type | Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Booking Search | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Booking Confirmation | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Booking Confirmation]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Ottawa Pass Add to Cart | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Media Type | Total Conversions (total_conversions), CPA (cpa) | media_type | Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | clicks | Clicks (clicks) |  | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Spend | Spend (spend) |  | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPM | CPM (cpm) |  | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CTR | CTR (ctr) |  | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPC | CPC (cpc) |  | smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Ottawa Pass Purchase | Total Conversions (total_conversions), CPA (cpa) |  | conversion_tag in [Ottawa Pass Purchase]; smart_campaign in [Ottawa Tourism: Always On Search] |

## Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | smart_campaign in [Ottawa Tourism: Always On Search]; source_name in [Google Ads] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Search, All outcomes]; source_name in [Google Ads]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Booking Search | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Search, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Booking Confirmation | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [Booking Confirmation]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Ottawa Pass Add to Cart | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Search, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Search, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Search, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; source_name in [Google Ads]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search, All outcomes]; Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search, All outcomes]; Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search, All outcomes]; Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Search, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Search, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; source_name in [Google Ads]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Ottawa Pass Purchase | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search, All outcomes]; conversion_tag in [Ottawa Pass Purchase]; smart_campaign in [Ottawa Tourism: Always On Search] |

## Search - Bing

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | smart_campaign in [Ottawa Tourism: Always On Search]; source_name in [Microsoft Advertising] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search - Bing, All outcomes]; Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search - Bing, All outcomes]; Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search - Bing, All outcomes]; Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search - Bing, All outcomes]; Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Search - Bing, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search - Bing, All outcomes]; Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search - Bing, All outcomes]; Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |

## Search - Perfmax

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Spend | Spend (spend) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPM | CPM (cpm) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CPC | CPC (cpc) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | CTR | CTR (ctr) |  | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Booking Search | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search - Perfmax, All outcomes]; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Booking Confirmation | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search - Perfmax, All outcomes]; conversion_tag in [Booking Confirmation]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Ottawa Pass Add to Cart | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search - Perfmax, All outcomes]; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | By Day | Spend (spend) | date:day | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Audience | Spend (spend) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | bar-chart | Tactic | Spend (spend) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Spend >= 0.01; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | filter_media_type in [Search - Perfmax, All outcomes]; source_name in [Google Ads]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Impressions (impressions), CPM (cpm) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Impressions (impressions), CPM (cpm) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Impressions >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Clicks (clicks), CPC (cpc), CTR (ctr) | date:day | filter_media_type in [Search - Perfmax, All outcomes]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Clicks (clicks), CPC (cpc), CTR (ctr) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Clicks (clicks), CPC (cpc), CTR (ctr) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Clicks >= 1.0; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Search - Perfmax, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Booking Search]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | By Day | Total Conversions (total_conversions), CPA (cpa) | date:day | filter_media_type in [Search - Perfmax, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Audience | Total Conversions (total_conversions), CPA (cpa) | audience | filter_media_type in [Search - Perfmax, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; source_name in [Google Ads]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | combo-chart | Tactic | Total Conversions (total_conversions), CPA (cpa) | tactic | filter_media_type in [Search - Perfmax, All outcomes]; Total Conversions >= 1.0; conversion_tag in [Ottawa Pass Add to Cart]; source_name in [Google Ads]; smart_campaign in [Ottawa Tourism: Always On Search] |
| [ ] | kpi | Ottawa Pass Purchase | Total Conversions (total_conversions), CPA (cpa) |  | filter_media_type in [Search - Perfmax, All outcomes]; conversion_tag in [Ottawa Pass Purchase]; smart_campaign in [Ottawa Tourism: Always On Search] |

