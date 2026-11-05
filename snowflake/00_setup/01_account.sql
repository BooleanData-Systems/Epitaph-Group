-- Epitaph reporting: account setup, following the Boolean Snowflake Kickstart Checklist v1.0 (sections 1 and 2).
-- Run once by ACCOUNTADMIN. Safe to re-run: every statement is CREATE ... IF NOT EXISTS, or ALTER to the standard.
-- Snowflake Enterprise, Canada Central. Single production environment.
-- Naming confirmed with Epitaph at kickoff (checklist 1: "Confirm naming with client"); see docs/kickstart_checklist.md.

use role accountadmin;

-- ================================================================ 2. Roles
create role if not exists EPITAPH_ADMIN       comment = 'Owns all Epitaph reporting objects; held by Epitaph';
create role if not exists EPITAPH_DEVELOPER   comment = 'Checklist DEVELOPER: read/write on BRONZE and SILVER, uses WH_TRANSFORMATION';
create role if not exists EPITAPH_READER      comment = 'Checklist READER: read-only on GOLD only, for analysts (uses WH_ADHOC)';
create role if not exists EPITAPH_LOADER      comment = 'Ingestion workloads: Fivetran and the SharePoint and FX loaders; writes to BRONZE only';
create role if not exists EPITAPH_TRANSFORMER comment = 'Transformation workloads: owns SILVER and GOLD dynamic tables, tasks and alerts';
create role if not exists EPITAPH_REPORTER    comment = 'BI connection (Omni): read-only on GOLD';
create role if not exists EPITAPH_DEPLOYER    comment = 'CI pipeline: deploys code. Key held only in GitHub secrets; job output is pass/fail and totals';
create role if not exists EPITAPH_STRUCTURE   comment = 'Structure only: object and column names, no row reads. Used for code work';
create role if not exists EPITAPH_MONITOR     comment = 'Reads the monitoring views in GOLD.ADMIN (logins, queries, credits)';

grant role EPITAPH_DEVELOPER, EPITAPH_READER, EPITAPH_LOADER, EPITAPH_TRANSFORMER, EPITAPH_REPORTER,
           EPITAPH_DEPLOYER, EPITAPH_STRUCTURE, EPITAPH_MONITOR to role EPITAPH_ADMIN;
grant role EPITAPH_ADMIN to role SYSADMIN;

-- ================================================================ 1. Warehouses
-- Checklist standard: auto-suspend 60 s, auto-resume on, statement timeout 300 s on every warehouse.
create warehouse if not exists WH_LOAD           warehouse_size = xsmall auto_suspend = 60 auto_resume = true initially_suspended = true
  statement_timeout_in_seconds = 300 comment = 'LOAD: Fivetran, SharePoint loader, exchange rates';
create warehouse if not exists WH_TRANSFORMATION warehouse_size = small  auto_suspend = 60 auto_resume = true initially_suspended = true
  statement_timeout_in_seconds = 300 comment = 'TRANSFORMATION: dynamic tables, tasks, checks, alerts';
create warehouse if not exists WH_ADHOC          warehouse_size = xsmall auto_suspend = 60 auto_resume = true initially_suspended = true
  statement_timeout_in_seconds = 300 comment = 'ADHOC: analysts and developers';
create warehouse if not exists WH_REPORTING      warehouse_size = xsmall auto_suspend = 60 auto_resume = true initially_suspended = true
  statement_timeout_in_seconds = 300 min_cluster_count = 1 max_cluster_count = 2 scaling_policy = economy
  comment = 'BI: Omni only, kept apart so dashboards are not slowed by ad hoc work';
create warehouse if not exists WH_HISTORY        warehouse_size = small  auto_suspend = 60 auto_resume = true initially_suspended = true
  statement_timeout_in_seconds = 3600 comment = 'One-off history load and first full builds. Agreed exception to the 300 s timeout. Dropped after history sign-off';

-- Re-apply the standard if a warehouse already existed
alter warehouse WH_LOAD           set warehouse_size = xsmall auto_suspend = 60 auto_resume = true statement_timeout_in_seconds = 300;
alter warehouse WH_TRANSFORMATION set warehouse_size = small  auto_suspend = 60 auto_resume = true statement_timeout_in_seconds = 300;
alter warehouse WH_ADHOC          set warehouse_size = xsmall auto_suspend = 60 auto_resume = true statement_timeout_in_seconds = 300;
alter warehouse WH_REPORTING      set auto_suspend = 60 auto_resume = true statement_timeout_in_seconds = 300;

-- ================================================================ 1. Databases (medallion layers)
create database if not exists BRONZE comment = 'Raw ingestion layer: land data exactly as received, no transformations';
create database if not exists SILVER comment = 'Cleansed, standardised and governed layer: business rules applied here';
create database if not exists GOLD   comment = 'Business-ready consumption layer: dashboards and reports connect here';

create schema if not exists BRONZE.SHAREPOINT comment = 'One table per SharePoint feed (config/feeds.yml)';
create schema if not exists BRONZE.LOADER     comment = 'Load log, stages and loader procedures';
create schema if not exists BRONZE.TAPCLICKS  comment = 'History from TapClicks CSV downloads';
create schema if not exists BRONZE.REFERENCE  comment = 'Bank of Canada exchange rates';
create schema if not exists SILVER.STG        comment = 'Typed, cleaned, one shape per source; cut-over and source rules';
create schema if not exists GOLD.MARTS        comment = 'Facts and dimensions';
create schema if not exists GOLD.SEMANTIC     comment = 'KPI views Omni reads';
create schema if not exists GOLD.CONTROL      comment = 'Mapping, cut-over, access and check settings';
create schema if not exists GOLD.CHECKS       comment = 'Comparison and quality results';
create schema if not exists GOLD.ARCHIVE      comment = 'Former clients'' rows older than 24 months, moved out of the live path; Epitaph admins only';
create schema if not exists GOLD.ADMIN        comment = 'Monitoring views: logins, queries, credits, pipeline health';

-- Checklist 1, "Set default warehouse per database": Snowflake has no database-level default warehouse, so the
-- default is set on each role and user that works in that layer (below), and on every task and dynamic table.
--   BRONZE -> WH_LOAD    SILVER -> WH_TRANSFORMATION    GOLD -> WH_TRANSFORMATION (build), WH_REPORTING (BI), WH_ADHOC (analysts)

grant ownership on database BRONZE to role EPITAPH_ADMIN copy current grants;
grant ownership on database SILVER to role EPITAPH_ADMIN copy current grants;
grant ownership on database GOLD   to role EPITAPH_ADMIN copy current grants;
grant ownership on all schemas in database BRONZE to role EPITAPH_ADMIN copy current grants;
grant ownership on all schemas in database SILVER to role EPITAPH_ADMIN copy current grants;
grant ownership on all schemas in database GOLD   to role EPITAPH_ADMIN copy current grants;
grant ownership on warehouse WH_LOAD           to role EPITAPH_ADMIN copy current grants;
grant ownership on warehouse WH_TRANSFORMATION to role EPITAPH_ADMIN copy current grants;
grant ownership on warehouse WH_ADHOC          to role EPITAPH_ADMIN copy current grants;
grant ownership on warehouse WH_REPORTING      to role EPITAPH_ADMIN copy current grants;
grant ownership on warehouse WH_HISTORY        to role EPITAPH_ADMIN copy current grants;

-- ================================================================ 2. Service accounts (non-human, key-pair only)
-- Service users cannot have passwords. The checklist's "rotate service account passwords" is met by rotating the
-- key pairs after setup and keeping them in Epitaph's password vault (and GitHub secrets for CI).
create user if not exists SVC_LOADER      type = service default_role = EPITAPH_LOADER      default_warehouse = WH_LOAD
  comment = 'LOADER service account: Fivetran destination; owns ingestion workloads';
create user if not exists SVC_TRANSFORMER type = service default_role = EPITAPH_TRANSFORMER default_warehouse = WH_TRANSFORMATION
  comment = 'TRANSFORMER service account: owns transformation workloads';
create user if not exists SVC_REPORTER    type = service default_role = EPITAPH_REPORTER    default_warehouse = WH_REPORTING
  comment = 'REPORTER service account: Omni connection, read-only on GOLD';
create user if not exists SVC_CI          type = service default_role = EPITAPH_DEPLOYER    default_warehouse = WH_TRANSFORMATION
  comment = 'GitHub Actions deploy';
grant role EPITAPH_LOADER      to user SVC_LOADER;
grant role EPITAPH_TRANSFORMER to user SVC_TRANSFORMER;
grant role EPITAPH_REPORTER    to user SVC_REPORTER;
grant role EPITAPH_DEPLOYER    to user SVC_CI;
-- Set each public key outside this script: alter user SVC_LOADER set rsa_public_key = '...';
-- Rotation: set rsa_public_key_2, switch the client, then unset rsa_public_key (no downtime). Every 12 months.

-- Alert distribution list as a user, so resource monitors and alerts can email it (address verified in Snowsight).
create user if not exists DL_EPITAPH_DATA_ALERTS type = person login_name = 'DL_EPITAPH_DATA_ALERTS'
  comment = 'Email-only user for the alert distribution list. No password or key is ever set, so it cannot log in. Set EMAIL to the DL and verify it';
-- alter user DL_EPITAPH_DATA_ALERTS set email = '<distribution list>';   (set by the Epitaph admin, not stored here)

-- Network policy: Omni, Fivetran and GitHub runner egress ranges are added by the admin, not stored here.
-- create network policy NP_EPITAPH_SERVICES allowed_network_rule_list = (...);
