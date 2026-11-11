# Columns the dashboards use that the model does not carry yet

From `specs/required_columns.yml`: fields the live dashboards filter or group on that are not yet in the semantic
views. Each needs a source column and a line in staging before the dashboards that use it are built.

| Column | Used on | In TapClicks it came from | Plan | Needed by |
|---|---|---|---|---|
| keyword | 17 dashboards (Search Keywords tables) | Epitaph - Keyword Mapping | Add Google Ads and Microsoft keyword reports to the connectors; new fact `fct_keyword_daily` and view `v_keyword_daily` | Group 1 (Nulo D053) |
| site_key (Kids Help Phone) | Kids Help Phone (8 dashboards) | Epitaph - Data Mapping, Site Key | A traffic channel label set per source and media type (`facebook`, `paidsearch`, `paidsearch - bing`, `programmatic / paidvideo`, `reddit / paiddisplay`, `tiktok`, `snapchat`, `youtube`). Values from TapClicks in `plans/tapclicks_site_key_data_mapping.csv`; 293 of 301 source and media type pairs give one value. Load as a seed keyed on source and media type; the 8 pairs with two values (CM360 YouTube vs video, Reddit display vs video) need a rule from Epitaph. On GA4 it follows session source and medium | Group 2 |
| site_key (SiriusXM) | SiriusXM D091, D092 | SXM - Adobe Mapping, Site Key | A channel and program group (`Search - Streaming`, `Social Paid - Dual Offer`, `Commuter Trialer - Paid Social`). Set per source, media type and campaign, not by source alone. Values with spend in `plans/tapclicks_site_key_sxm.csv`; load as a seed keyed on source, media type and campaign | Group 1 (SiriusXM) |
| program_code | SiriusXM D091, D092 | SXM - Adobe Mapping, Program Code | The Adobe offer code (`COMMCA1246`, `CAPSRTP3MOFREEPART4`) on the Adobe and Scorecard feeds; blank on ad platforms. Comes from the files (`program_code_v98_evar98` is already read in `snowflake/30_staging/stg_sharepoint_feeds.sql`); carry it through to the SiriusXM view. Examples in `plans/tapclicks_site_key_sxm.csv` | Group 1 |
| province, product, site, account_name | Sonnet D093, D094 (and one Jolt widget on D092) | Sonnet - Custom Mapping, Sonnet auction files | Province and product from Sonnet Raw Data; site and account name from the auction files; add to Sonnet views | Group 1 (Sonnet D093) |
| campaign_filter | Kids Help Phone D052 | Epitaph - Data Mapping, calculation on Smart Campaign | The Smart Campaign name without the client prefix ("Kids Help Phone: Grants" gives "Grants"). No new data: derive it in the semantic view as `trim(split_part(smart_campaign, ':', 2))` | Group 2 |
| order_name | Embark D023 | Amazon DSP | TapClicks treats the Amazon DSP order as the campaign; the Amazon DSP staging view (`STG_AMAZON_DSP`) carries it as `campaign_name` | Group 2 |
| attribution_group | Ottawa Tourism D061 | Adara file | Column in the Adara file (F14); add to `STG_ADARA` | Group 3 (Phase 2) |
| bulk_status_khc, category_khc, size_khc | Kicking Horse Coffee D026 (one widget each) | Epitaph - Data Mapping: Product, Size - KHC, Category - KHC, Bulk Status - KHC | Set on Amazon Ads campaigns only, one value set per campaign (26 campaigns; some are "Unclassified"). TapClicks values in `plans/tapclicks_khc_products.csv`; load as a seed keyed on campaign name | Group 2 |

Columns already covered elsewhere: GA4 session fields (`V_WEB_SESSIONS_DAILY`), competitor domain
(`V_SONNET_AUCTION`), quote quality and segment (`V_SONNET_DAILY`), date (`date_day`, `week_start`, `month_start`).
