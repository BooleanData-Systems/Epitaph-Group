**EPITAPH REPORTING ON SNOWFLAKE AND OMNI**

# Scope: Phase 1 and Phase 2

Boolean · 2 November 2026 · matches the proposal and the pitch deck

All 29 live Epitaph client dashboards move from TapClicks to Snowflake
and Omni. Phase 1, the Snowflake Catalyst, puts 20 of them live by 18
Dec 2026 at no cost to Epitaph. Phase 2 builds the last nine, which need
the deepest data, and hands the running data product to Epitaph on 5 Feb
2027, three weeks before TapClicks closes on 28 Feb 2027.

All of it is built as one data product that Epitaph owns, Epitaph Media
Performance: one governed dataset with a named Epitaph owner, a contract
that fixes its KPI definitions, freshness and quality, and clear users.
The dashboards are the first use of it, not the whole of it.

|                     | **Phase 1: Snowflake Catalyst**       | **Phase 2: paid delivery**       |
|---------------------|---------------------------------------|----------------------------------|
| **Dates**           | 2 Nov to 24 Dec 2026 (8 weeks)        | 4 Jan to 5 Feb 2027 (5 weeks)    |
| **Dashboards live** | 20: 7 on 11 Dec, 13 on 18 Dec         | The last 9: on 15, 22 and 29 Jan |
| **Ends with**       | Catalyst readout and Phase 2 go-ahead | Handover and sign-off on 5 Feb   |

In scope are the 29 live dashboards, the 42 live sources behind them, 24
months of history, a 24-month archive for former clients’ data, and the
checks that prove the numbers match TapClicks.

# The data product

| **Part**            | **What it is**                                                                                                                                                                                                                                                                                                                                              |
|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Name**            | Epitaph Media Performance                                                                                                                                                                                                                                                                                                                                   |
| **Owner**           | Nathan Sennema, Epitaph’s single point of contact and final sign-off, who approves every change to its KPIs and access; Mike DeOliveira, his manager, is sponsor                                                                                                                                                                                            |
| **What it answers** | What each client’s campaigns delivered and achieved, at what cost, by day, platform, campaign, media buy and creative                                                                                                                                                                                                                                       |
| **Users**           | The 29 client dashboards in Omni, Epitaph’s account teams, the 07:30 check emails and, later, AI use cases                                                                                                                                                                                                                                                  |
| **Contract**        | 86 KPI definitions signed off; freshness: ad platforms within 7 hours, files within 1 hour; quality: spend, impressions and clicks within 1% of TapClicks, video within 2%, counted conversions and history exact                                                                                                                                           |
| **Governance**      | Access: 9 roles, each client sees only its own rows and allowed columns. Change control: every change a pull request, deployed only on Epitaph’s approval; KPI changes after sign-off by written request. Audit: logins, queries, check results and archive moves logged. Data protection: client data stays in Epitaph’s account and never appears in logs |
| **Not covered**     | Media buying and invoicing, finance data, and anything that compares or shares data across clients                                                                                                                                                                                                                                                          |

# What is included

## Dashboards (29)

| **Group**                      | **Live by**       | **Dashboards**                                                                                                                                                                                                                                             | **Phase** |
|--------------------------------|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| **1, High priority**           | 11 Dec 2026       | Nulo USA (standard); SiriusXM Streaming, SiriusXM Commuter 2.0, Sonnet Insurance 2026 (custom)                                                                                                                                                             | Catalyst  |
| **1, Medium**                  | 11 Dec 2026       | Nulo Product, Conexus Always On, Conexus Investing                                                                                                                                                                                                         | Catalyst  |
| **2, Standard**                | 18 Dec 2026       | Embark Brand; Kicking Horse Coffee Retail; Sysco ROC and QC; Kids Help Phone Counsellor in the Classroom, Good2Talk, Grants, Indigenous, Newcomers, Peer to Peer, RiseUp, Feel Out Loud Youth, Feel Out Loud Adult, Search                                 | Catalyst  |
| **3, Custom and Phase 2 data** | 15 to 29 Jan 2027 | Sonnet Insurance Epitaph Dashboard (custom) and Cobs Bread Evergreen (merged with Evergreen USA, CAD and USD) 15 Jan; Ottawa Tourism Always On Search and Fall 22 Jan; Ottawa Tourism Partnership Campaigns 2026 29 Jan (all three need Adara attribution) | Phase 2   |
| **3, Hand-built**              | 22 to 29 Jan 2027 | Aquamar Rouses Retail, BDO Brand, Wurth Canada 2026, Kicking Horse Coffee Hellbent                                                                                                                                                                         | Phase 2   |

## Sources

| **Route**                       | **Sources**                                                                                                                                                                                                                                                         |
|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Fivetran (15)**               | Google Ads, Microsoft Advertising, Facebook Ads, LinkedIn Ads, TikTok Ads, SnapChat, Pinterest Ads, Reddit Ads, Google Analytics 4, Campaign Manager 360, Display & Video 360, Amazon Ads, The Trade Desk; Amazon DSP and Spotify Ads once proven against the files |
| **SharePoint load script (27)** | Sonnet (13 files: 4 daily emails, 6 auction reports, direct buy spend, DV360 creative, Amazon DSP reach), SiriusXM (5 Adobe reports and the Scorecard), vendors (Silverpush x2, HiveStack, Netflix Pause Ads, Jolt Media, Adara, Spotify for Cobs Bread), Goals     |
| **Reference**                   | Bank of Canada USD to CAD rates, replacing the exchange-rate Google Sheet                                                                                                                                                                                           |
| **History only (94)**           | Stopped or dormant sources, loaded once from TapClicks downloads                                                                                                                                                                                                    |

## Also in scope

| **Item**                  | **What is included**                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **KPIs**                  | 86 KPI definitions, each tied to its sign-off decision; rates recalculated from totals, never averaged                                                                                                                                                                                                                                                                                                                                                                               |
| **Data product**          | Epitaph Media Performance: Bronze, Silver and Gold in Snowflake; one semantic view that every dashboard reads; Smart Campaign and media type mapping; its contract and governance as above                                                                                                                                                                                                                                                                                           |
| **History**               | 24 months (Nov 2024 onward) for every live source, plus the 94 history-only sources, loaded from TapClicks downloads and checked to the cent                                                                                                                                                                                                                                                                                                                                         |
| **Archive**               | A low-cost archive in Snowflake for former clients’ data older than 24 months (Epitaph’s answer A12). Epitaph approves each move; a monthly job copies the client’s old rows, checks the totals match and only then takes them out of the live path; one approved change restores a client in full. Nothing is deleted, archived data stays out of every refresh and out of Omni, and only Epitaph admins can see it. Built and tested in Phase 2: 4 days of work including testing. |
| **Checks**                | Daily side-by-side comparison with TapClicks from 7 Dec 2026 to switch-off, data-quality checks, freshness alerts, 07:30 email on any failure                                                                                                                                                                                                                                                                                                                                        |
| **Client access**         | 13 clients, each with its own Omni user group, rows filtered to its client code, column groups hidden as Epitaph chooses; tested per client before go-live                                                                                                                                                                                                                                                                                                                           |
| **Report delivery**       | Shared links and scheduled PDF emails per client contact                                                                                                                                                                                                                                                                                                                                                                                                                             |
| **Platform setup**        | Snowflake to the Boolean Kickstart standard: warehouses, roles, service users with key pairs, resource monitors, cost and login monitoring                                                                                                                                                                                                                                                                                                                                           |
| **Training and handover** | Five sessions, recorded; runbook, change-control process and user and role mapping; admin rights handed to Epitaph                                                                                                                                                                                                                                                                                                                                                                   |

# Scope by phase

|                   | **Phase 1: Catalyst, 2 Nov to 24 Dec 2026, no cost**                                                                                                                             | **Phase 2: paid, 4 Jan to 5 Feb 2027**                                                                                                                                                                                                                                                  |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Dashboards**    | 20 live: 7 on 11 Dec (Nulo USA, Nulo Product, SiriusXM Streaming, SiriusXM Commuter 2.0, Sonnet Insurance 2026, Conexus Always On, Conexus Investing) and 13 on 18 Dec (Group 2) | The last 9: Sonnet Insurance Epitaph Dashboard and Cobs Bread Evergreen 15 Jan; Aquamar Rouses Retail, BDO Brand, Ottawa Tourism Always On Search and Ottawa Tourism Fall 22 Jan; Ottawa Tourism Partnership Campaigns 2026, Wurth Canada 2026 and Kicking Horse Coffee Hellbent 29 Jan |
| **Data**          | 15 Fivetran connectors and 27 file feeds live; Bank of Canada rates; every live source cut over from TapClicks history to its new route                                          | Silver to Gold for the remaining data: Sonnet groups and sites, Adara attribution, Amazon DSP orders, SiriusXM program codes; Cobs Bread CAD and USD merge; budget table if its source is agreed                                                                                        |
| **History**       | Nov 2024 onward for every live source, loaded and matched day by day                                                                                                             | The 94 history-only sources downloaded and moved through Bronze, Silver and Gold                                                                                                                                                                                                        |
| **Archive**       | Not in Phase 1                                                                                                                                                                   | 24-month archive for former clients (A12): built week of 18 Jan, move and restore tested week of 25 Jan, 4 days including testing; runbook section and daily check included                                                                                                             |
| **Platform**      | Snowflake set up as code to the Kickstart standard; GitHub pipeline; Omni connected; master template approved                                                                    | Performance tuning; cost review from real use; access review                                                                                                                                                                                                                            |
| **Checks**        | Daily checks with a 07:30 email on any failure; weekly side-by-side comparison from 7 Dec                                                                                        | All 29 dashboards matched against TapClicks over 4 weeks of overlap; final acceptance report                                                                                                                                                                                            |
| **Client access** | Omni user group per client for the 20 live dashboards, tested per client before each go-live                                                                                     | The same for the last 9; final access review                                                                                                                                                                                                                                            |
| **Handover**      | Monitoring, first runbook, Catalyst results report and readout                                                                                                                   | Five training sessions, final runbook, change-control process, admin rights handed to Epitaph on 5 Feb                                                                                                                                                                                  |

# Done when

**24 December 2026, end of Phase 1**

- A Snowflake Enterprise account in Canada, set up as code, with spend
  limits

- 15 Fivetran connectors syncing every 6 hours and the SharePoint load
  script running every hour

- One definition for every KPI on the live dashboards, the same in
  Snowflake and Omni

- 20 dashboards live in Omni, each viewer seeing only their own client

- Daily checks against TapClicks, with an email when anything is out of
  tolerance

- History for the live sources from Nov 2024, loaded and matched day by
  day

**5 February 2027, end of Phase 2**

- All 29 dashboards live, signed off and matched against TapClicks

- History from Nov 2024 for every source still needed, including those
  that have stopped

- A 24-month archive for former clients’ data: approved moves only,
  every move checked against the source, a client restored in full on
  request, nothing deleted

- A runbook, change-control process and trained Epitaph staff who can
  add a client dashboard from the template without Boolean

- Weekly comparison downloads continuing to 28 Feb, run by Epitaph from
  the plan we leave

# Not included

- Finance: Simpli.fi spend and invoices.

- The TapOrders replacement and budget pacing beyond loading a budget
  table once its source is agreed.

- Google Trends, Universal Analytics, test and one-off uploads (HVC Heat
  Map, StackAdapt Conexus Geo Split).

- The 70 dashboards not marked live, any dashboard beyond the 29, and AI
  or forecasting features.

- History before Nov 2024, unless Epitaph asks for it (priced as a
  change request, and it must finish before 28 Feb 2027). If requested,
  it loads straight into the archive.

# Acceptance and changes

A dashboard is accepted when it shows every element in its
specification, its numbers are within the agreed tolerances of TapClicks
for two weeks in a row, and Nathan Sennema, Epitaph’s single point of
contact, signs it off. Boolean works through Nathan only. The tolerances
are spend, impressions and clicks within 1% per client per week; video
within 2%; counted conversions exact; history daily totals exact.

Changes after KPI sign-off on 13 Nov 2026 go through a written change
request. The dates depend on the Epitaph inputs listed in the proposal;
a late input moves the affected dashboard, not the 28 Feb switch-off.
