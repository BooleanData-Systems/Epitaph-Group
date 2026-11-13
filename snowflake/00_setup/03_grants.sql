-- Grants by layer (Kickstart Checklist section 2). The rule: each role gets only what its job needs.
-- Future grants on every database, so new objects inherit the right permissions automatically (checklist 2).
-- Run as ACCOUNTADMIN: account-level grants, future grants and grants on schemas it created need it.
use role accountadmin;

-- Warehouses
grant usage on warehouse WH_LOAD to role EPITAPH_LOADER;
grant usage on warehouse WH_HISTORY to role EPITAPH_LOADER;
grant usage on warehouse WH_TRANSFORMATION to role EPITAPH_TRANSFORMER;
grant usage on warehouse WH_TRANSFORMATION to role EPITAPH_DEPLOYER;
grant usage on warehouse WH_REPORTING to role EPITAPH_REPORTER;
grant usage on warehouse WH_ADHOC to role EPITAPH_READER;
grant usage on warehouse WH_TRANSFORMATION to role EPITAPH_DEVELOPER;
grant usage on warehouse WH_ADHOC to role EPITAPH_DEVELOPER;
grant usage on warehouse WH_ADHOC to role EPITAPH_STRUCTURE;
grant usage on warehouse WH_ADHOC to role EPITAPH_MONITOR;

-- Loader: create and write in BRONZE (Fivetran creates its own schemas)
grant usage, create schema on database BRONZE to role EPITAPH_LOADER;
grant usage, create table, create procedure on schema BRONZE.SHAREPOINT to role EPITAPH_LOADER;
grant usage, create table, create procedure, create task on schema BRONZE.LOADER to role EPITAPH_LOADER;
grant usage, create table on schema BRONZE.TAPCLICKS to role EPITAPH_LOADER;
grant usage, create table, create procedure, create task on schema BRONZE.REFERENCE to role EPITAPH_LOADER;
grant read, write on stage BRONZE.LOADER.CODE to role EPITAPH_LOADER;
grant read, write on stage BRONZE.TAPCLICKS.HISTORY_STAGE to role EPITAPH_LOADER;
grant execute task on account to role EPITAPH_LOADER;

-- Transformer: read BRONZE, own SILVER and GOLD
grant usage on database BRONZE to role EPITAPH_TRANSFORMER;
grant usage on all schemas in database BRONZE to role EPITAPH_TRANSFORMER;
grant usage on future schemas in database BRONZE to role EPITAPH_TRANSFORMER;
grant select on all tables in database BRONZE to role EPITAPH_TRANSFORMER;
grant select on future tables in database BRONZE to role EPITAPH_TRANSFORMER;
grant all on database SILVER to role EPITAPH_TRANSFORMER;
grant all on schema SILVER.STG to role EPITAPH_TRANSFORMER;
grant usage on database GOLD to role EPITAPH_TRANSFORMER;
grant all on schema GOLD.MARTS to role EPITAPH_TRANSFORMER;
grant all on schema GOLD.SEMANTIC to role EPITAPH_TRANSFORMER;
grant all on schema GOLD.CONTROL to role EPITAPH_TRANSFORMER;
grant all on schema GOLD.CHECKS to role EPITAPH_TRANSFORMER;
grant execute task, execute alert on account to role EPITAPH_TRANSFORMER;
grant database role SNOWFLAKE.DATA_METRIC_USER to role EPITAPH_TRANSFORMER;
grant execute data metric function on account to role EPITAPH_TRANSFORMER;

-- Deployer (CI): runs DDL as the transformer. Its key lives only in GitHub secrets and its job logs print pass/fail and totals, never rows
grant role EPITAPH_TRANSFORMER to role EPITAPH_DEPLOYER;
grant role EPITAPH_LOADER to role EPITAPH_DEPLOYER;

-- Reporter (Omni): reads the semantic views only (not the marts, which carry no row access policy), plus the
-- check results for the internal reconciliation page. The views run with their owner's rights, so no mart grant is needed.
grant usage on database GOLD to role EPITAPH_REPORTER;
grant usage on schema GOLD.SEMANTIC to role EPITAPH_REPORTER;
grant select on all views in schema GOLD.SEMANTIC to role EPITAPH_REPORTER;
grant select on future views in schema GOLD.SEMANTIC to role EPITAPH_REPORTER;
grant usage on schema GOLD.CHECKS to role EPITAPH_REPORTER;
grant select on future tables in schema GOLD.CHECKS to role EPITAPH_REPORTER;
grant select on future views in schema GOLD.CHECKS to role EPITAPH_REPORTER;

-- Reader (checklist READER): read-only on GOLD only, for analysts
grant usage on database GOLD to role EPITAPH_READER;
grant usage on all schemas in database GOLD to role EPITAPH_READER;
grant usage on future schemas in database GOLD to role EPITAPH_READER;
grant select on all tables in database GOLD to role EPITAPH_READER;
grant select on all views in database GOLD to role EPITAPH_READER;
grant select on all dynamic tables in database GOLD to role EPITAPH_READER;
grant select on future tables in database GOLD to role EPITAPH_READER;
grant select on future views in database GOLD to role EPITAPH_READER;
grant select on future dynamic tables in database GOLD to role EPITAPH_READER;
-- Snowflake ignores database-level future grants in a schema that has its own future grants for the same object type.
-- GOLD.SEMANTIC and GOLD.CHECKS have schema-level ones (for the reporter, below), so the reader is granted there too.
grant select on future views in schema GOLD.SEMANTIC to role EPITAPH_READER;
grant select on future tables in schema GOLD.CHECKS to role EPITAPH_READER;
grant select on future views in schema GOLD.CHECKS to role EPITAPH_READER;

-- Archive (A12): only Epitaph admins read it. Schema-level future grants take precedence over the database-level
-- future grants above, so READER gets nothing in GOLD.ARCHIVE; its schema usage is removed as well.
revoke usage on schema GOLD.ARCHIVE from role EPITAPH_READER;
grant all on schema GOLD.ARCHIVE to role EPITAPH_TRANSFORMER;
grant select, insert on future tables in schema GOLD.ARCHIVE to role EPITAPH_TRANSFORMER;
grant select on future views in schema GOLD.ARCHIVE to role EPITAPH_TRANSFORMER;
grant usage on schema GOLD.ARCHIVE to role EPITAPH_ADMIN;
grant select on future tables in schema GOLD.ARCHIVE to role EPITAPH_ADMIN;
grant select on future views in schema GOLD.ARCHIVE to role EPITAPH_ADMIN;

-- Developer (checklist DEVELOPER): read/write on BRONZE and SILVER, on WH_TRANSFORMATION
grant usage on database BRONZE to role EPITAPH_DEVELOPER;
grant usage on database SILVER to role EPITAPH_DEVELOPER;
grant usage, create table, create view on all schemas in database BRONZE to role EPITAPH_DEVELOPER;
grant usage, create table, create view, create dynamic table on all schemas in database SILVER to role EPITAPH_DEVELOPER;
grant usage on future schemas in database BRONZE to role EPITAPH_DEVELOPER;
grant usage on future schemas in database SILVER to role EPITAPH_DEVELOPER;
grant select, insert, update, delete on all tables in database BRONZE to role EPITAPH_DEVELOPER;
grant select, insert, update, delete on future tables in database BRONZE to role EPITAPH_DEVELOPER;
grant select, insert, update, delete on all tables in database SILVER to role EPITAPH_DEVELOPER;
grant select, insert, update, delete on future tables in database SILVER to role EPITAPH_DEVELOPER;
grant select on all views in database SILVER to role EPITAPH_DEVELOPER;
grant select on future views in database SILVER to role EPITAPH_DEVELOPER;
grant select on all dynamic tables in database SILVER to role EPITAPH_DEVELOPER;
grant select on future dynamic tables in database SILVER to role EPITAPH_DEVELOPER;

-- Future grants for the build roles, so objects created later need no manual grant
grant select on future views in database SILVER to role EPITAPH_TRANSFORMER;
grant select on future dynamic tables in database SILVER to role EPITAPH_TRANSFORMER;
grant select on future tables in database GOLD to role EPITAPH_TRANSFORMER;

-- Monitor: the monitoring views in GOLD.ADMIN read Snowflake's account usage
grant imported privileges on database SNOWFLAKE to role EPITAPH_TRANSFORMER;
grant usage on database GOLD to role EPITAPH_MONITOR;
grant usage on schema GOLD.ADMIN to role EPITAPH_MONITOR;
grant select on future views in schema GOLD.ADMIN to role EPITAPH_MONITOR;
grant all on schema GOLD.ADMIN to role EPITAPH_TRANSFORMER;
grant monitor usage on account to role EPITAPH_TRANSFORMER;

-- Structure only: can list objects and columns (INFORMATION_SCHEMA) but has no SELECT on any table or view.
grant usage on database BRONZE to role EPITAPH_STRUCTURE;
grant usage on database SILVER to role EPITAPH_STRUCTURE;
grant usage on database GOLD to role EPITAPH_STRUCTURE;
grant usage on all schemas in database BRONZE to role EPITAPH_STRUCTURE;
grant usage on all schemas in database SILVER to role EPITAPH_STRUCTURE;
grant usage on all schemas in database GOLD to role EPITAPH_STRUCTURE;
grant references on future tables in database GOLD to role EPITAPH_STRUCTURE;
grant references on future views in database GOLD to role EPITAPH_STRUCTURE;
-- same rule: schemas with their own future grants need the structure role granted there as well
grant references on future views in schema GOLD.SEMANTIC to role EPITAPH_STRUCTURE;
grant references on future tables in schema GOLD.CHECKS to role EPITAPH_STRUCTURE;
grant references on future views in schema GOLD.CHECKS to role EPITAPH_STRUCTURE;
grant references on future views in schema GOLD.ADMIN to role EPITAPH_STRUCTURE;

-- Loader may call the email helper GOLD.CONTROL.NOTIFY (grant on the procedure is in 10_control)
grant usage on database GOLD to role EPITAPH_LOADER;
grant usage on schema GOLD.CONTROL to role EPITAPH_LOADER;

-- Pipeline monitoring (checklist 3A): the transformer role reads every task's history, including the loader's tasks
grant monitor on all tasks in database BRONZE to role EPITAPH_TRANSFORMER;
grant monitor on future tasks in database BRONZE to role EPITAPH_TRANSFORMER;
grant usage on all schemas in database BRONZE to role EPITAPH_TRANSFORMER;
