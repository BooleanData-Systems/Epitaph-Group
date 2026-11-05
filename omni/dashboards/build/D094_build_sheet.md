# Build sheet: D094 Sonnet Insurance - Epitaph Dashboard

Client: Sonnet Insurance. Type: Custom. Target live date: 2027-01-15.
Omni topic: media_performance. Fields are the measure names in omni/model/media_performance_daily.view.yaml.

- GA4 Test source excluded (Q22). Quotes come from Sonnet Raw Data (K22).
- Not rebuilt: 1 widget, marked do-not-use in TapClicks

## Amazon CTV

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | kpi | Completed Plays | Completed Plays (completed_plays) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [Amazon DSP]; channel in [*Paid Video*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Clicks (clicks), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Completed Plays (completed_plays), CPCV (cpcv) | province | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Completed Plays (completed_plays), CPCV (cpcv) | product | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | table | Creative Raw Data Table | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |
| [ ] | kpi | Impressions | Reach |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | kpi | Impressions | Frequency |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Reach, Frequency | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Reach, Frequency | province | source_name not in [Sonnet - DV360 Creative]; Reach >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Reach, Frequency | product | source_name not in [Sonnet - DV360 Creative]; Reach >= 1.0; channel in [*Paid Video*]; platform in [Amazon DSP] |

## Amazon StndDisplay

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [Amazon DSP]; channel in [*Display*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Creative | Clicks (clicks), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Display*]; platform in [Amazon DSP] |
| [ ] | table | Creative Raw Data Table | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Sonnet - DV360 Creative]; channel in [*Display*]; platform in [Amazon DSP]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |

## Bing Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Microsoft Advertising] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [Microsoft Ads]; channel in [*Paid Search*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Search*]; platform in [Microsoft Ads] |

## Campaign Overview

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | Completed Plays | Completed Plays (completed_plays) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | Total Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | Total Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Cross Network, Display, Paid Search, Paid Video, Social, Direct, ...] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Cross Network, Display, Paid Search, Paid Video, Social, Direct, ...] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Cross Network, Display, Paid Search, Paid Video, Social, Direct, ...] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Cross Network, Display, Paid Search, Paid Video, Social, Direct, ...] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative] |
| [ ] | combo-chart | By Channel & Platform | Spend (spend) | platform, channel | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01 |
| [ ] | combo-chart | By Province | Spend (spend) | source_name, province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01 |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01 |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Display & Video 360 IO]; Spend >= 0.01 |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative] |
| [ ] | combo-chart | By Channel & Platform | Impressions (impressions), CPM (cpm) | platform, channel | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0 |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0 |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0 |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Display & Video 360 IO]; Impressions >= 1.0 |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative] |
| [ ] | combo-chart | By Channel & Platform | Clicks (clicks), CTR (ctr), CPC (cpc) | platform, channel | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0 |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0 |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0 |
| [ ] | combo-chart | By Creative | Clicks (clicks), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Display & Video 360 IO]; Clicks >= 1.0 |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | source_name not in [Sonnet - DV360 Creative] |
| [ ] | combo-chart | By Channel & Platform | Completed Plays (completed_plays), CPCV (cpcv) | platform, channel | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0 |
| [ ] | combo-chart | By Province | Completed Plays (completed_plays), CPCV (cpcv) | province | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0 |
| [ ] | combo-chart | By Product | Completed Plays (completed_plays), CPCV (cpcv) | product | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0 |
| [ ] | combo-chart | By Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Display & Video 360 IO]; Completed Plays >= 1.0 |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative] |
| [ ] | combo-chart | By Channel & Platform | Quotes (quotes), CPQ (cpq) | platform, channel | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0 |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0 |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0 |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative] |
| [ ] | combo-chart | By Channel & Platform | Binds (binds), QTB (qtb) | platform, channel | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0 |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0 |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0 |
| [ ] | table | Creative Raw Data Table (Epitaph Run Only) | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Completed Plays (completed_plays), CPCV (cpcv) | source_name, province, creative_name | source_name in [Sonnet - DV360 Creative, Amazon DSP, HiveStack, Silverpush - Automated Report]; channel in [Paid Video, Display, DOOH]; platform in [Amazon DSP, DV360, HiveStack]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |
| [ ] | table | By Channel & Platform | Spend (spend) | province, channel, product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01 |
| [ ] | table | By Channel & Platform | Quotes (quotes) | province, channel, product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0 |

## DOOH

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [HiveStack]; channel in [*DOOH*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*DOOH*]; platform in [HiveStack] |
| [ ] | table | Creative Raw Data Table | Impressions (impressions), Spend (spend), CPM (cpm) | creative_name | source_name not in [Sonnet - DV360 Creative]; channel in [*DOOH*]; platform in [HiveStack]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |

## Google Search

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [Google Ads]; channel in [*Paid Search*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Search*]; platform in [Google Ads] |
| [ ] | table | Search Keywords | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc) (labels: Impressions as Impression) | keyword | source_name in [Google Ads] |

## Meta

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Completed Plays | Completed Plays (completed_plays) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [Meta]; channel in [*Social*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Creative | Clicks (clicks), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Province | Completed Plays (completed_plays), CPCV (cpcv) | province | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Product | Completed Plays (completed_plays), CPCV (cpcv) | product | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Social*]; platform in [Meta] |
| [ ] | table | Creative Raw Data Table | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Meta]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |

## Reddit

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Completed Plays | Completed Plays (completed_plays) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [Reddit]; channel in [*Social*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Creative | Clicks (clicks), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Province | Completed Plays (completed_plays), CPCV (cpcv) | province | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Product | Completed Plays (completed_plays), CPCV (cpcv) | product | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Social*]; platform in [Reddit] |
| [ ] | table | Creative Raw Data Table | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Sonnet - DV360 Creative]; channel in [*Social*]; platform in [Reddit]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |

## YouTube

| Done | Element | Title | Metrics (Omni field) | Group by | Filters |
|---|---|---|---|---|---|
| [ ] | kpi | Impressions | Impressions (impressions) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | Clicks | Clicks (clicks) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | Spend | Spend (spend) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | CPM | CPM (cpm) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | CTR | CTR (ctr) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | CPC | CPC (cpc) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | kpi | Completed Plays | Completed Plays (completed_plays) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | kpi | CPCV | CPCV (cpcv) |  | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | kpi | Paid Quotes | Quotes (quotes) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | Paid Binds | Binds (binds) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | Paid | CPQ (cpq) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | kpi | Paid | QTB (qtb) |  | source_name not in [Sonnet - DV360 Creative]; channel in [Paid Video]; platform in [DV360] |
| [ ] | combo-chart | By Day | Spend (spend) | date:day | source_name not in [Sonnet - DV360 Creative]; platform in [DV360]; channel in [*Paid Video*] |
| [ ] | combo-chart | By Province | Spend (spend) | province | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Product | Spend (spend) | product | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Creative | Spend (spend) | creative_name | source_name not in [Display & Video 360 IO]; Spend >= 0.01; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Day | Impressions (impressions), CPM (cpm) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Province | Impressions (impressions), CPM (cpm) | province | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Product | Impressions (impressions), CPM (cpm) | product | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Creative | Impressions (impressions), CPM (cpm) | creative_name | source_name not in [Display & Video 360 IO]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Day | Clicks (clicks), CTR (ctr), CPC (cpc) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Province | Clicks (clicks), CTR (ctr), CPC (cpc) | province | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Product | Clicks (clicks), CTR (ctr), CPC (cpc) | product | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Creative | Clicks (clicks), CTR (ctr), CPC (cpc) | creative_name | source_name not in [Display & Video 360 IO]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Day | Completed Plays (completed_plays), CPCV (cpcv) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Province | Completed Plays (completed_plays), CPCV (cpcv) | province | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Product | Completed Plays (completed_plays), CPCV (cpcv) | product | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Creative | Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Display & Video 360 IO]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Day | Quotes (quotes), CPQ (cpq) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Province | Quotes (quotes), CPQ (cpq) | province | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Product | Quotes (quotes), CPQ (cpq) | product | source_name not in [Sonnet - DV360 Creative]; Quotes >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Day | Binds (binds), QTB (qtb) | date:day | source_name not in [Sonnet - DV360 Creative]; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Province | Binds (binds), QTB (qtb) | province | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Product | Binds (binds), QTB (qtb) | product | source_name not in [Sonnet - DV360 Creative]; Binds >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | table | Creative Raw Data Table | Impressions (impressions), Clicks (clicks), Spend (spend), CPM (cpm), CTR (ctr), CPC (cpc), Completed Plays (completed_plays), CPCV (cpcv) | creative_name | source_name not in [Display & Video 360 IO]; channel in [Paid Video]; platform in [DV360]; Impressions >= 1.0; Clicks >= 1.0; Spend >= 0.01 |
| [ ] | combo-chart | By Source | Spend (spend) | source_name | source_name not in [Sonnet - DV360 Creative]; Spend >= 0.01; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Source | Impressions (impressions), CPM (cpm) | source_name | source_name not in [Sonnet - DV360 Creative]; Impressions >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Source | Clicks (clicks), CTR (ctr), CPC (cpc) | source_name | source_name not in [Sonnet - DV360 Creative]; Clicks >= 1.0; channel in [*Paid Video*]; platform in [DV360] |
| [ ] | combo-chart | By Source | Completed Plays (completed_plays), CPCV (cpcv) | source_name | source_name not in [Sonnet - DV360 Creative]; Completed Plays >= 1.0; channel in [*Paid Video*]; platform in [DV360] |

