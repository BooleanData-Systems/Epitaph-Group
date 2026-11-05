# Fixes register

Every data-quality issue found in TapClicks profiling (Q001 to Q019) and every KPI decision Epitaph signed off
(K01 to K22, R00 to R06), with where the fix lives in this repo and how we prove it worked.

Status: **Built** = in this repo; **Waiting** = needs an answer from Epitaph; **Not carried over** = left behind with TapClicks.

## Data-quality issues

| ID | Issue | Fix | Where in the repo | Proof | Status |
|---|---|---|---|---|---|
| Q001 | Overlapping sources (Reddit and Reddit Ads, Spotify and Spotify Ads, Silverpush variants) can count the same spend twice | One source per client, platform and day, chosen by a precedence table | `seeds/ctl_source_precedence.csv`, `snowflake/30_staging/stg_ad_delivery_union.sql` | `dq_source_overlap` check returns zero rows | Built |
| Q002 | GA4 Test mixed into Sonnet sessions and quotes | GA4 Test excluded at staging | `seeds/ctl_source_precedence.csv`, `snowflake/30_staging/stg_ga4_sessions.sql` | Sessions match GA4 for Sonnet in the comparison check | Built |
| Q003 | Widgets with no campaign filter show every campaign for the client | Every element filters on the dashboard's Smart Campaigns. Wurth and Sysco show all campaigns on purpose (Q23) | `specs/dashboards/*.yml` (scope), `seeds/dashboard_smart_campaigns.csv` | Spec validator fails on an unscoped element unless the dashboard is flagged all-campaigns | Built |
| Q004 | Calculated formulas could not be read in TapClicks | Formulas agreed in sign-off and written once | `config/kpis.yml` | Comparison check per KPI against TapClicks values | Built (2 formulas Waiting: K13) |
| Q005 | 24 KPI names had several definitions | One definition per name | `config/kpis.yml`, `snowflake/50_semantic/v_kpi_definitions.sql` | `scripts/validate.py` fails if a name appears twice | Built |
| Q006 | Same cost-per-trial formula under two names | One KPI each; Omni keeps the old label on the charts that used it (K14 answer) | `config/kpis.yml` (`labels_used`), widget `labels` in D091 and D092 specs | Spec review | Built |
| Q007 | VCR blank or overstated where starts are missing | VCR shown per platform only; platforms without starts show a dash | `config/kpis.yml` (VCR), `snowflake/50_semantic/v_media_performance_daily.sql` | `dq_vcr_over_100` check returns zero rows | Built |
| Q008 | Fixed date ranges that no longer move | Every element uses the dashboard date picker (A22). Old setting kept in the spec as `date_range.was` | `specs/dashboards/*.yml` | Spec validator: no element has its own date range | Built |
| Q009 | Wildcard Smart Campaign and name filters on 69 dashboards | Exact Smart Campaign lists from the mapping tables; remaining wildcards become reviewed pattern rules | `scripts/smart_campaign_mapping.py`, `seeds/filter_rules.csv`, `CONTROL.map_smart_campaign_rule` | `smart_campaign_mapping.py check --strict` passes; `dq_unmapped_campaigns` empty for live clients | Built |
| Q010 | "Spend eq 0.01" used as a minimum threshold | Read as "at least", written as `metric_at_least` in specs and an Omni filter `>=` | `scripts/build_specs.py`, `scripts/omni_build.py` | Comparison of row counts on 3 sample widgets | Built |
| Q011 | 34 sources quiet for over 90 days | Not connected; history loaded from TapClicks downloads; widgets on them retired (A23) | `plans/history_download_plan.csv`, notes in specs | Freshness alert lists no live source over its threshold | Built |
| Q012 | 8 sources dated in the future (goals and plans) | Loaded as goals and budget, never added to actuals | `snowflake/40_marts/facts.sql` (FCT_GOALS, FCT_BUDGET) | Goals show beside actuals only | Built |
| Q013 | 4 sources with no freshness date | Not carried over | `plans/history_download_plan.csv` (excluded rows) | n/a | Not carried over |
| Q014 | EQ Works - SiriusXM 2.0 mapped but empty | Not carried over | n/a | n/a | Not carried over |
| Q015 | 22 sources unused | Not carried over | n/a | n/a | Not carried over |
| Q016 | 19 of 26 channel mappings unused | Not carried over; the model replaces channel mappings | n/a | n/a | Not carried over |
| Q017 | Metric labelled "-" | Named Search Impr. share (Auction Insights), as Epitaph gave it; label hidden on the competitor charts (K17) | `config/kpis.yml`, D093 spec `hide_metric_label` | Spec review | Built |
| Q018 | Dashboard list and TapClicks out of step | Only the 29 live dashboards are rebuilt | `specs/dashboards/_index.yml` | n/a | Built |
| Q019 | Universal Analytics still connected | Not carried over | n/a | n/a | Not carried over |

## KPI decisions (signed off 29 Oct 2026)

| ID | Decision | Where |
|---|---|---|
| K01 | One definition each for Clicks, Impressions, Revenue, ROAS | `config/kpis.yml` |
| K02 | CPM, CPC, CTR always from totals | `config/kpis.yml`, `snowflake/50_semantic/v_media_performance_daily.sql` |
| K03 | Impression shown as Impressions | `scripts/build_specs.py` METRIC_MAP |
| K04 | Spend in the ad account's currency; on Cobs Bread (CAD and USD merged, A16) every money tile is split by currency | `snowflake/40_marts/facts.sql` (FCT_AD_DELIVERY_DAILY), DIM_FX_RATE in `snowflake/40_marts/dims.sql`, D005 spec `split_money_by` |
| K05 | CPV name kept | `config/kpis.yml` |
| K06 | Starts = video starts only | `snowflake/30_staging/stg_facebook_ads.sql` |
| K07 | VCR per platform: the Omni measure is blank when a tile blends platforms | `config/kpis.yml` (`per_platform_only`), `scripts/omni_build.py` (`platforms_in_view`) |
| K08 | Video Fully Played = Completed Plays | METRIC_MAP |
| K09 | Reach and frequency not added up | **Waiting** for Epitaph's answer; built as per-platform, per-period |
| K10 | CPA = spend / counted conversions | `config/kpis.yml`; counted actions from Nathan's T01 to T11 answers (2 Nov) in `seeds/map_conversion_tag.csv`; Conexus Trade Desk start date (D-008) and four assumptions pending objection by 13 Nov |
| K11 | Sessions from GA4, Test excluded | `snowflake/30_staging/stg_ga4_sessions.sql` |
| K12 | Goals beside actuals; CPQ Goal is a rate, averaged across months, never summed | `snowflake/40_marts/facts.sql` (FCT_GOALS), template block `goal_gauges`, `config/kpis.yml` (CPQ Goal) |
| K13 | Ottawa Adara measures: as delivered in the monthly Adara upload (Epitaph's answer) | `config/kpis.yml`, `config/feeds.yml` F14 |
| K14 | Duplicate CPT formulas kept once, labels kept per chart | `config/kpis.yml`, D091/D092 specs |
| K15 | Split spend metrics become Spend with a media-type filter; GoLoot not rebuilt | METRIC_MAP, D091 spec notes |
| K16 | Throughput % = trials / flow starts; Trials - SC x 100 dropped | `config/kpis.yml` |
| K17 | "-" = Search Impr. share (Auction Insights); label hidden on the chart, not renamed "-" | `config/kpis.yml`, D093 spec `hide_metric_label` |
| K18 | Auction shares as reported | `snowflake/40_marts/facts.sql` (FCT_AUCTION_INSIGHTS) |
| K19 | Google Trends competition widgets not rebuilt | D093 spec notes |
| K20 | Quote quality (daily, band from the pvm column) and monoline/multiline (monthly Multiline file: customers, not quotes) from the Sonnet emails; rows that cannot be right are listed on the Data Checks page | `config/feeds.yml` F01; `snowflake/40_marts/facts.sql` (FCT_SONNET_QUOTES_DAILY); `snowflake/60_checks/dq_checks.sql` (DQ_SONNET_FILES) |
| K21 | Platform Conversions name kept | `config/kpis.yml` |
| K22 | Quotes from Sonnet Raw Data | `snowflake/40_marts/facts.sql` (FCT_SONNET_QUOTES_DAILY) |
| R00 | Other KPIs unchanged | `config/kpis.yml` (decision R00) |
| R01 | Changes after 13 Nov by written change request | `docs/change_control.md` |
| R02 to R06 | Comparison tolerances | `seeds/dq_tolerances.csv`, `snowflake/60_checks/comparison_checks.sql` |
