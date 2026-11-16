# User and role mapping

Delivered to Epitaph at setup and kept current (Kickstart Checklist 2, "Document user-role mapping").
Named people are added by the Epitaph admin; this file lists the role each kind of person gets.

## Roles

| Role | Can do | Warehouse | Layer access |
|---|---|---|---|
| EPITAPH_ADMIN | Owns every object; grants roles | Any | All |
| EPITAPH_DEVELOPER | Build and change data in the raw and cleaned layers | WH_TRANSFORMATION, WH_ADHOC | BRONZE, SILVER: read and write |
| EPITAPH_READER | Query business-ready data | WH_ADHOC | GOLD: read only |
| EPITAPH_LOADER | Ingestion workloads (Fivetran, file load script, exchange rates) | WH_LOAD | BRONZE: write |
| EPITAPH_TRANSFORMER | Transformation workloads (dynamic tables, tasks, checks, alerts) | WH_TRANSFORMATION | BRONZE: read; SILVER, GOLD: own |
| EPITAPH_REPORTER | BI connection | WH_REPORTING | GOLD semantic views (and check results): read only, filtered per client |
| EPITAPH_DEPLOYER | Release pipeline | WH_TRANSFORMATION | Runs as loader and transformer |
| EPITAPH_MONITOR | Read logins, query costs and credits | WH_ADHOC | GOLD.ADMIN: read only |
| EPITAPH_STRUCTURE | See object and column names, no rows | WH_ADHOC | Names only |

## Service accounts (non-human, key-pair sign-in, no passwords)

| User | Role | Warehouse | Used by | Key kept in | Rotation |
|---|---|---|---|---|---|
| SVC_LOADER | EPITAPH_LOADER | WH_LOAD | Fivetran destination | Epitaph vault and Fivetran | Every 12 months |
| SVC_TRANSFORMER | EPITAPH_TRANSFORMER | WH_TRANSFORMATION | Transformation workloads | Epitaph vault | Every 12 months |
| SVC_REPORTER | EPITAPH_REPORTER | WH_REPORTING | Omni connection | Epitaph vault and Omni | Every 12 months |
| SVC_CI | EPITAPH_DEPLOYER | WH_TRANSFORMATION | GitHub Actions deploys | Epitaph vault and GitHub secrets | Every 12 months |
| DL_EPITAPH_DATA_ALERTS | none | none | Receives monitor and alert emails; cannot sign in | Not applicable | Not applicable |

Keys are rotated once after setup and then yearly: set the new public key as `rsa_public_key_2`, switch the client,
then unset the old key, with no downtime.

## People

| Person or group | Roles | Notes |
|---|---|---|
| Epitaph platform owner | EPITAPH_ADMIN | Named by Epitaph at kickoff |
| Epitaph analysts | EPITAPH_READER, EPITAPH_MONITOR | Query GOLD in Snowsight |
| Boolean pod engineers (during the engagement) | EPITAPH_DEVELOPER, EPITAPH_READER | Removed at handover unless Epitaph decides otherwise |
| Boolean pod lead (during the engagement) | EPITAPH_DEVELOPER, EPITAPH_MONITOR | Removed at handover unless Epitaph decides otherwise |
| Client users | None in Snowflake | Clients use Omni only; their access is per client user group and user attributes (omni/README.md) |
