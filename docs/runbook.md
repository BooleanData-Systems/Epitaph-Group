# Runbook

## First-time setup (in this order)

| # | Step | Who | Done when |
|---|---|---|---|
| 1 | Create the Snowflake account (Enterprise, Canada Central) | Epitaph | Account URL shared |
| 2 | Run `snowflake/00_setup/01_account.sql`, `02_integrations.sql` (first replace TENANT with the tenant's SharePoint name), `03_grants.sql` as ACCOUNTADMIN; run `04_monitoring.sql` after step 3a, since resource monitors email a verified address | Epitaph admin with the Boolean pod lead | `call GOLD.ADMIN.CHECK_WAREHOUSE_STANDARD()` says all warehouses meet the standard |
| 3 | Create key pairs for SVC_LOADER, SVC_TRANSFORMER, SVC_REPORTER and SVC_CI; set each public key on its user; keep the private keys in Epitaph's vault (CI key also in GitHub secrets) | Epitaph admin | `desc user` shows a key; keys rotated after setup |
| 3a | Set the email of DL_EPITAPH_DATA_ALERTS to the alert distribution list and verify it in Snowsight; add the DL and named contacts to GOLD.CONTROL.ALERT_RECIPIENTS for each alert (ingestion, transformation, publishing, downstream, freshness, check_failures, streams) | Epitaph admin | Test alerts received (see `docs/monitoring_and_escalation.md`) |
| 4 | Create the SharePoint site "Epitaph Reporting" and the folders in `config/feeds.yml` | Epitaph IT | Folders exist |
| 5 | Register an Entra app with Microsoft Graph Sites.Selected; grant it read and write on that site only | Epitaph IT | Admin consent given |
| 6 | Put tenant id, client id, secret and site id in BRONZE.LOADER.GRAPH_APP (`alter secret ... set secret_string = ...`) | Epitaph admin | Loader test run lists files |
| 7 | Fill GOLD.CONTROL.FEED_OWNERS and ALERT_RECIPIENTS; verify each address in Snowflake | Epitaph admin | Test email received |
| 8 | Set up Power Automate flows that save emailed reports (Sonnet, SiriusXM, vendors) into their folders | Epitaph IT | A test email lands as a file |
| 9 | Create the Fivetran connectors in `config/connectors.yml` to the BRONZE database | Boolean pod (data engineering) | First sync complete |
| 10 | GitHub: create the repo under Epitaph's organisation; add secrets SNOWFLAKE_ACCOUNT, SNOWFLAKE_PRIVATE_KEY, OMNI_BASE_URL, OMNI_API_KEY, OMNI_MODEL_ID, OMNI_BRANCH_ID to the "production" environment with a required reviewer | Epitaph admin | Deploy workflow runs |
| 11 | Omni: Snowflake connection, git-connected model with required pull requests, user attributes, client user groups, theme, logos, master dashboard (see `omni/README.md`) | Boolean pod (dashboard build) | Master approved by Epitaph |

## Every day (automatic)
| Time (Toronto) | What |
|---|---|
| :15 every hour | SharePoint loader (BRONZE.LOADER.T_LOAD_SHAREPOINT) |
| Every 6 hours | Fivetran syncs |
| 07:00 | Quality checks and the comparison with TapClicks for the last two weeks (GOLD.CHECKS.T_DAILY_CHECKS) |
| 07:30 | Email if any check failed (GOLD.CHECKS.A_CHECK_FAILURES) |
| 18:00 | Bank of Canada exchange rates |

## When something goes wrong

**A file owner gets a "File not loaded" email.** The file is in `Rejected/<folder>` with the time in its name.
The email says why (missing column, unreadable dates, wrong file name). Fix and save it back to the original folder.

**Freshness alert.** Check DQ_FRESHNESS for the source. Fivetran: open the connector and look at the last sync error.
SharePoint: check BRONZE.LOADER.LOAD_LOG for that feed and whether the email flow ran.

**Comparison check fails.** Open the Data Checks page in Omni, filter to the client and source. Common causes:
a platform restated its numbers (re-sync the last 30 days), a campaign maps to no Smart Campaign (DQ_UNMAPPED_CAMPAIGNS),
or a conversion action is not decided yet (DQ_UNDECIDED_TAGS). Record the cause in RECON_RESULTS.cause.

**A new campaign does not show on a dashboard.** It is in DQ_UNMAPPED_CAMPAIGNS. Either rename it to the naming
convention so a rule matches, or add a row to `seeds/map_smart_campaign_override.csv` in a pull request.

**Switch a source back to TapClicks history (during the parallel run).** Set its CTL_CUTOVER status to `fallback`
in `seeds/ctl_cutover.csv`. The model goes back to history for that source on the next refresh.

## Adding a client dashboard after go-live
1. Add the client to `seeds/map_client_account.csv` and its ad accounts to `seeds/map_platform_account.csv`.
2. Add Smart Campaign rules and counted conversion actions (change request, see `docs/change_control.md`).
3. Copy a standard spec, change the client, sections and Smart Campaigns, and open a pull request. CI builds and
   publishes the dashboard from the master template.
4. Grant viewers in GOLD.CONTROL.CLIENT_ACCESS.

## Archiving a former client (A12)
Data for a former client that is older than 24 months moves to `GOLD.ARCHIVE`, out of every hourly refresh and out
of Omni. Nothing is deleted: BRONZE keeps the original rows and the archive keeps a checked copy. Only
EPITAPH_ADMIN can read the archive.

**Archive a client.**
1. Open a pull request adding a row to `seeds/ctl_archive_requests.csv`: `client_code`, `action = archive`,
   `archive_before` (the date before which data moves), `requested_by`, and `approved_by` (the sponsor). A row
   with no `approved_by` does nothing.
2. Whatever date is requested, nothing newer than the first of the month 24 months ago moves.
3. At 05:00 on the 1st of the month the task `GOLD.ARCHIVE.T_MONTHLY_ARCHIVE` copies the client's rows, compares
   rows, spend, impressions and conversions with the source, and only then marks the client archived. The rows
   leave the dashboards within the hour. To run it now: `call GOLD.ARCHIVE.RUN_ARCHIVE();` as EPITAPH_TRANSFORMER.
4. If the copy does not match, nothing moves, the move is logged as `archive_stopped` and the alert list is emailed.

**Restore a client.** Change the row's `action` to `restore` in a pull request (approved by the sponsor). The next
run puts the client back; the rows rebuild from BRONZE within the hour. The archived copy is kept for audit.

**Check it.** `GOLD.ARCHIVE.ARCHIVE_LOG` lists every move and restore with both sets of totals. The daily check
`GOLD.CHECKS.DQ_ARCHIVE` (in the 07:30 alert) flags an archived client with rows still live, or a restored client
whose live totals differ from its archived copy.

**When Silver gains a column.** Add the same column to `GOLD.ARCHIVE.AD_DELIVERY` or `CONVERSIONS` in the same pull
request; the local end-to-end run (`scripts/e2e_local.py`) fails until the shapes match.
