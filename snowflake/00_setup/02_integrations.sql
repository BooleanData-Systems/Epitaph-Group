-- Network access for the loaders, secrets, email, and the code stage.
-- Secret values are set by the Epitaph admin in Snowflake, never in this repo or in CI logs.

use role accountadmin;

-- ---------------------------------------------------------------- Microsoft Graph (SharePoint loader)
create network rule if not exists BRONZE.LOADER.NR_MICROSOFT_GRAPH
  mode = egress type = host_port value_list = ('login.microsoftonline.com:443', 'graph.microsoft.com:443');
-- Graph answers a file download with a redirect to the tenant's own SharePoint host, so that host must be allowed
-- too. Replace TENANT with the tenant's SharePoint name (TENANT.sharepoint.com) before running this statement.
alter network rule BRONZE.LOADER.NR_MICROSOFT_GRAPH set value_list =
  ('login.microsoftonline.com:443', 'graph.microsoft.com:443', 'TENANT.sharepoint.com:443');

create secret if not exists BRONZE.LOADER.GRAPH_APP
  type = generic_string
  secret_string = '{"tenant_id":"SET_BY_ADMIN","client_id":"SET_BY_ADMIN","client_secret":"SET_BY_ADMIN","site_id":"SET_BY_ADMIN"}'
  comment = 'Entra app with Sites.Selected on the Epitaph Reporting site only. Rotate every 12 months';

create external access integration if not exists EAI_MICROSOFT_GRAPH
  allowed_network_rules = (BRONZE.LOADER.NR_MICROSOFT_GRAPH)
  allowed_authentication_secrets = (BRONZE.LOADER.GRAPH_APP)
  enabled = true comment = 'SharePoint loader only';

-- ---------------------------------------------------------------- Bank of Canada Valet API (exchange rates, Q20)
create network rule if not exists BRONZE.LOADER.NR_BANK_OF_CANADA
  mode = egress type = host_port value_list = ('www.bankofcanada.ca:443');

create external access integration if not exists EAI_BANK_OF_CANADA
  allowed_network_rules = (BRONZE.LOADER.NR_BANK_OF_CANADA)
  enabled = true comment = 'FX loader only; public API, no secret';

-- ---------------------------------------------------------------- email (rejected files, failed checks, freshness)
create notification integration if not exists EPITAPH_EMAIL
  type = email enabled = true
  comment = 'Recipients must be verified Snowflake users. Addresses live in GOLD.CONTROL.FEED_OWNERS and ALERT_RECIPIENTS';

-- ---------------------------------------------------------------- code stage (CI uploads loader code here)
create stage if not exists BRONZE.LOADER.CODE comment = 'Python files and feeds.yml for the loader procedures; written by CI';
create stage if not exists BRONZE.TAPCLICKS.HISTORY_STAGE comment = 'TapClicks CSV downloads copied from SharePoint History for COPY INTO'
  file_format = (type = csv field_optionally_enclosed_by = '"' skip_header = 1 null_if = ('') empty_field_as_null = true encoding = 'UTF8');

grant usage on integration EAI_MICROSOFT_GRAPH to role EPITAPH_LOADER;
grant usage on integration EAI_BANK_OF_CANADA to role EPITAPH_LOADER;
grant usage on integration EPITAPH_EMAIL to role EPITAPH_LOADER;
grant usage on integration EPITAPH_EMAIL to role EPITAPH_TRANSFORMER;
grant read on secret BRONZE.LOADER.GRAPH_APP to role EPITAPH_LOADER;
grant usage on secret BRONZE.LOADER.GRAPH_APP to role EPITAPH_LOADER;
