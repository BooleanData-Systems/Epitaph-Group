-- SharePoint loader as a Snowflake Python procedure, run by a task every hour.
-- CI uploads loader/sharepoint_loader.py and config/feeds.yml to @BRONZE.LOADER.CODE before running this file.
use role EPITAPH_LOADER;

create or replace procedure BRONZE.LOADER.LOAD_SHAREPOINT(feed_id varchar default null)
returns varchar
language python
runtime_version = '3.11'
packages = ('snowflake-snowpark-python', 'requests', 'pyyaml', 'openpyxl')
imports = ('@BRONZE.LOADER.CODE/sharepoint_loader.py', '@BRONZE.LOADER.CODE/feeds.yml')
handler = 'sharepoint_loader.main'
external_access_integrations = (EAI_MICROSOFT_GRAPH)
secrets = ('graph_app' = BRONZE.LOADER.GRAPH_APP)
execute as owner
comment = 'Loads new or changed SharePoint files to BRONZE.SHAREPOINT. See loader/sharepoint_loader.py';

-- Make sure every feed table exists (names from config/feeds.yml; CI regenerates this list)
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_RAW_DATA');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_QUOTE_QUALITY');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_GROUP_BREAKDOWN');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_MULTILINE');
call BRONZE.LOADER.ENSURE_FEED_TABLE('DIRECT_BUY_SPEND');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_DV360_CREATIVE');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_AUCTION_PRESSURE');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_VISIBILITY');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SONNET_VS_COMPETITION');
call BRONZE.LOADER.ENSURE_FEED_TABLE('AMAZON_DSP_REACH');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SXM_ADOBE');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SXM_SCORECARD');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SILVERPUSH');
call BRONZE.LOADER.ENSURE_FEED_TABLE('HIVESTACK');
call BRONZE.LOADER.ENSURE_FEED_TABLE('NETFLIX_PAUSE_ADS');
call BRONZE.LOADER.ENSURE_FEED_TABLE('JOLT_MEDIA');
call BRONZE.LOADER.ENSURE_FEED_TABLE('ADARA');
call BRONZE.LOADER.ENSURE_FEED_TABLE('SPOTIFY_FILES');
call BRONZE.LOADER.ENSURE_FEED_TABLE('GOALS');
call BRONZE.LOADER.ENSURE_FEED_TABLE('WILDBRAIN');

create or replace task BRONZE.LOADER.T_LOAD_SHAREPOINT
  warehouse = WH_LOAD
  schedule = 'USING CRON 15 * * * * America/Toronto'
  user_task_timeout_ms = 300000      -- matches the 300 s warehouse statement timeout (checklist)
  suspend_task_after_num_failures = 3
  comment = 'Hourly SharePoint load'
as
  call BRONZE.LOADER.LOAD_SHAREPOINT(null);

alter task BRONZE.LOADER.T_LOAD_SHAREPOINT resume;
