# Columns the dashboards use that the model does not carry yet

From `specs/required_columns.yml`: fields the live dashboards filter or group on that are not yet in the semantic
views. Each needs a source column and a line in staging before the dashboards that use it are built.

| Column | Used on | In TapClicks it came from | Plan | Needed by |
|---|---|---|---|---|
| keyword | 17 dashboards (Search Keywords tables) | Epitaph - Keyword Mapping | Add Google Ads and Microsoft keyword reports to the connectors; new fact `fct_keyword_daily` and view `v_keyword_daily` | Group 1 (Nulo D053) |
| site_key | Kids Help Phone (8 dashboards), SiriusXM D091, D092 | A custom field in Epitaph - Data Mapping and SXM - Adobe Mapping | Ask Epitaph what Site Key is; likely the placement or site in DV360 or the Adobe site section | Group 1 (SiriusXM) |
| program_code | SiriusXM D091, D092 | SXM - Adobe Mapping | Column in the Adobe files (F07); add to `STG_SXM` | Group 1 |
| province, product, site, account_name | Sonnet D093, D094 (and one Jolt widget on D092) | Sonnet - Custom Mapping, Sonnet auction files | Province and product from Sonnet Raw Data; site and account name from the auction files; add to Sonnet views | Group 1 (Sonnet D093) |
| campaign_filter | Kids Help Phone D052 | Epitaph - Data Mapping custom field | Confirm meaning with Epitaph; likely a campaign group that a Smart Campaign rule can replace | Group 2 |
| order_name | Embark D023 | Amazon DSP | Amazon DSP order name, available in the Fivetran report | Group 2 |
| attribution_group | Ottawa Tourism D061 | Adara file | Column in the Adara file (F14); add to `STG_ADARA` | Group 3 (Phase 2) |
| bulk_status_khc, category_khc, size_khc | Kicking Horse Coffee D026 (one widget each) | Product feed fields in Epitaph - Data Mapping | Confirm the product feed with Epitaph or drop the three widgets | Group 2 |

Columns already covered elsewhere: GA4 session fields (`V_WEB_SESSIONS_DAILY`), competitor domain
(`V_SONNET_AUCTION`), quote quality and segment (`V_SONNET_DAILY`), date (`date_day`, `week_start`, `month_start`).
