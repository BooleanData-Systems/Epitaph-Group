# Smart Campaign mapping: review list

`seeds/map_smart_campaign_override.csv` holds the campaign to Smart Campaign list taken from TapClicks on
11 Nov 2026 (read-only, through the TapClicks app API).

What TapClicks holds: all 316 Smart Campaigns are hand-picked campaign lists. None uses a name pattern, so the
mapping is exact campaign names (overrides), and `seeds/map_smart_campaign_rule.csv` stays empty unless a decision
below needs a rule.

| | Count |
|---|---|
| Smart Campaigns the live dashboards use (`seeds/dashboard_smart_campaigns.csv`) | 34 |
| Found in TapClicks and written to the seed | 31 |
| Campaign rows in the seed | 2,178 |
| Campaigns held back because they sit in more than one Smart Campaign | 6 |
| Smart Campaigns not found in TapClicks | 3 (1 is a wildcard, covered) |

Silverpush rows are mapped by advertiser, the field `snowflake/30_staging/stg_sharepoint_feeds.sql` uses as the
campaign name for that feed.

## 1. Campaigns in more than one Smart Campaign (decision needed)

The override table allows one Smart Campaign per campaign, so these are not in the seed yet.

| # | Campaign | TapClicks puts it in | Dashboards | Proposed answer |
|---|---|---|---|---|
| S01 | Kids Help Phone (GA4) | All 8 KHP Smart Campaigns below | D035, D038, D041, D043, D044, D046, D049, D051 | GA4 is site traffic, not a campaign. Show KHP GA4 on every KHP dashboard through the client filter, not a Smart Campaign |
| S02 | Kids Help Phone (GA4 New) | Same 8 | Same | As S01 |
| S03 | Raisin - GA4 | Same 8 | Same | As S01 |
| S04 | CA_Epitaph Group_Kids Help Phone_FOL Youth 2.0 SHORTS -_US//SP-2025/910281 (Silverpush) | Feel Out Loud Adult; Youth - Feel Out Loud - National | D051, D043, D049 | TapClicks splits it by line item. Choose one, or map at line item level (needs a model change) |
| S05 | Kids Help Phone_Peer2Peer_2023-343_En_CA | Good2Talk; Peer to Peer | D038, D044, D046 | Peer to Peer (the name says Peer2Peer) |
| S06 | Kids Help Phone - 2017 | Grants; Public Fundraising | D039, D052, D051 | Epitaph to choose |

KHP Smart Campaigns in S01 to S03: Counsellor in the Classroom, Feel Out Loud Adult, Good2Talk, Indigenous,
Newcomers, Peer to Peer, RiseUp, Youth - Feel Out Loud - National.

## 2. Smart Campaigns on dashboards but not in TapClicks

| # | Smart Campaign | Dashboard | Finding | Proposed answer |
|---|---|---|---|---|
| S07 | Kids Help Phone: Youth - Feel Out Loud 2.0 | D049 | No Smart Campaign with this name in TapClicks; the filter matches nothing there today | Drop from the D049 filter, or Epitaph names the campaigns it should hold |
| S08 | Ottawa Tourism: Fall 2024 | D061 | Not in TapClicks; matches nothing today | Drop; D061 also filters on `*Ottawa Tourism: Fall*`, which matches "Ottawa Tourism: Fall" (in the seed) |
| S09 | \*Ottawa Tourism: Fall\* (wildcard) | D061 | Matches "Ottawa Tourism: Fall" | None; covered |

## 3. Campaign ids TapClicks could not resolve to a name

TapClicks lists some Smart Campaign members by internal id. These ids returned no campaign for any date from 2018 to
today, mostly old or deleted campaigns and retired sources. They are not in the seed.

| # | Smart Campaign | Source | Ids | Dashboards | Proposed answer |
|---|---|---|---|---|---|
| S10 | SiriusXM: Streaming | SiriusXM - Adobe - Streaming Starts (OLD), SiriusXM - Adobe - Streaming (OLD), Adobe Organic - Streaming, Scorecard - SiriusXM | 502 | D091 | The Adobe and Scorecard feeds are mapped by report, not campaign (F07, F08). Confirm D091 reads them through the feed, not the Smart Campaign |
| S11 | Conexus: Investing; KHP Youth - Feel Out Loud - Alberta, Good2Talk, RiseUp | Billups - DOOH (CA) | 418 | D017, D049, D038, D046 | History only. Map from the TapClicks history download (campaign names are in the file) |
| S12 | Kicking Horse Coffee: Retail | Amazon Ads | 94 | D026 | Check in TapClicks whether these campaigns still have data; if yes, add by name |
| S13 | Nulo: Non Epitaph Data | Facebook Ads | 74 | D053 | Important: D053 excludes this Smart Campaign, so an unmapped campaign would show on Nulo USA. Confirm with Epitaph that these are inactive |
| S14 | Kicking Horse Coffee: Hellbent | Direct Buys - One Time Uploads | 20 | D032 | Map from the direct buy file names |
| S15 | Other | Facebook Ads, Google Ads, GA4, Reddit Ads, TikTok Ads, The Trade Desk, HiveStack, Wattpad, KHP P2P Patch, 55 Rush | about 90 across 20 Smart Campaigns | Several | Left out. `dq_unmapped_campaigns` shows any of them that still deliver |

## After review

1. Epitaph answers S01 to S14; the answers go into the two seed files by pull request (`docs/change_control.md`).
2. `python scripts/smart_campaign_mapping.py check --export <TapClicks campaign export> --strict` passes.
3. After the next deploy, `DQ_UNMAPPED_CAMPAIGNS` is empty for the live clients.
