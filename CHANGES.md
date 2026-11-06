# Master Client Index and data mapping: changed files

Copy these files over the same paths in the reporting repo, then run `python scripts/load_seeds.py` and redeploy
in the order in `snowflake/deploy_order.txt`. Two new SQL files are added to that order.

## New (10)

| File | What it is |
|---|---|
| `seeds/mci_client.csv` | Master Client Index: one golden record per client (13) |
| `seeds/mci_client_identifier.csv` | Identifiers not held elsewhere: single-client feeds, extra campaign prefixes, proposed tokens |
| `snowflake/30_staging/mci_identifiers.sql` | `SILVER.STG.MCI_IDENTIFIERS` and `MCI_FEED_CLIENT`: every identifier with its match rule and rank |
| `snowflake/30_staging/mci_resolution.sql` | `SILVER.STG.MCI_CLIENT_RESOLUTION`: the client for every source, account and campaign |
| `specs/data_product_contract.yml` | The product's public interface: owner, consumers, layers, MCI, service levels, access, change control |
| `specs/data_mapping.csv` | Field-level mapping, source to Raw / Bronze, Silver, Gold and Semantic (257 rows) |
| `scripts/build_data_mapping.py` | Generates `specs/data_mapping.csv` |
| `docs/master_client_index.md` | How the index works and who changes it |
| `tests/test_mci.py` | MCI seeds: one record per client, no identifier pointing to two clients, no client named in SQL |
| `tests/test_data_mapping.py` | The mapping matches the SQL and is current |

## Changed (15)

| File | Change |
|---|---|
| `snowflake/10_control/control_tables.sql` | Adds `MCI_CLIENT` and `MCI_CLIENT_IDENTIFIER` |
| `snowflake/deploy_order.txt` | Adds `mci_identifiers.sql` and `mci_resolution.sql` |
| `snowflake/30_staging/stg_sharepoint_feeds.sql` | Client name matching reads the MCI; single-client feeds take their client from the MCI (no client names in SQL); Sonnet, SiriusXM, Adara, auction and Amazon DSP rows carry `client_code` |
| `snowflake/30_staging/stg_ad_delivery_union.sql` | `mci_key` on `INT_AD_DELIVERY` and `INT_CONVERSIONS` |
| `snowflake/40_marts/dims.sql` | `DIM_CLIENT` from the MCI golden record; new `DIM_CLIENT_IDENTIFIER`; `DIM_CAMPAIGN` client from the MCI (`client_from`) |
| `snowflake/40_marts/facts.sql` | `client_key` and `client_code` on delivery and conversions; `client_code` on Sonnet, SiriusXM, Adara and auction facts; goals and GA4 clients from the MCI |
| `snowflake/45_archive/archive.sql` | Client names read from `MCI_CLIENT` |
| `snowflake/50_semantic/v_media_performance_daily.sql` | Client from each fact; hardcoded client codes and names removed |
| `snowflake/60_checks/dq_checks.sql` | New `DQ_UNRESOLVED_CLIENTS` and `DQ_MCI_CONFLICTS`, added to the daily results |
| `specs/gold_contract.yml` | MCI columns on the facts; `DIM_CLIENT` and `DIM_CLIENT_IDENTIFIER` |
| `scripts/gen_semantic_view.py` | Generates the semantic view with the client from each fact |
| `scripts/load_seeds.py` | Loads the two MCI seeds |
| `scripts/e2e_local.py` | Loads the MCI seeds; four new Master Client Index checks |
| `scripts/semantic_harness.py` | Test harness builds `DIM_CLIENT` from the MCI seed |
| `tests/test_semantic_layer.py` | Sonnet and SiriusXM test rows carry their client |

## Checks after the change

85 tests pass in this package, validation reports 0 problems, and the end-to-end run passes 30 of 30 checks on the TapClicks export.
