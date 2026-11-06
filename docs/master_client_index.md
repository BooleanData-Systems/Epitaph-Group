# Master Client Index

The Master Client Index (MCI) is the one place that says which client a row of data belongs to. Every fact in
the reporting product takes its client from it, so a dashboard never shows another client's data and no row is
counted twice.

## What it holds

| Part | Where | What it is |
|---|---|---|
| Client record | `seeds/mci_client.csv` (GOLD.CONTROL.MCI_CLIENT) | One row per client: code, name, legal name, reporting currency, status, dates, steward |
| Identifiers | `seeds/mci_client_identifier.csv`, plus the TapClicks account, alias and ad account lists | Every value that points to a client |
| Index | GOLD.MARTS.DIM_CLIENT_IDENTIFIER | All identifiers, approved and proposed, in one table |
| Resolution | SILVER.STG.MCI_CLIENT_RESOLUTION | The client chosen for every source, account and campaign |

## How a row finds its client

The best match wins, in this order:

1. The ad account or GA4 property the row came from.
2. The SharePoint feed, for feeds that only carry one client (Sonnet, SiriusXM, Adara, Spotify for Cobs Bread).
3. The client part of the campaign name (`Conexus_Investing_2026-001_En_CA`).
4. A client name or short name found as a whole word in the campaign name (KHP, Sonnet, SXM).
5. An approved word that only one client uses in its campaign names.

If two clients match equally well, the row gets no client. Rows with no client never reach a client
dashboard; they are listed on the Data Checks page (Unresolved clients) with their spend, and with a suggested
client when a proposed identifier would match.

## Who changes it

Nathan Sennema is the data steward. A new client, a new short name or a new ad account is a reviewed change to
the seed files, approved by Nathan. A proposed identifier is shown as a suggestion and has no effect until it is
approved.

## Open items

| Item | Status |
|---|---|
| Ad account and GA4 property list | Filled at connector setup from the Fivetran account list |
| The word "ohtoah" in 2026 Google Ads Search campaign names | Proposed for Ottawa Tourism; Epitaph to confirm |
| Legal names | Taken from the TapClicks account names; Epitaph to confirm |
