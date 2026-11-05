-- Bank of Canada USD to CAD rates, daily at 18:00 Eastern (after the 16:30 publication).
-- Used for Kids Help Phone's Reddit and Google Ads Grants spend, which is billed in USD and shown in CAD (Q20).
use role EPITAPH_LOADER;

create or replace procedure BRONZE.REFERENCE.LOAD_FX_RATES(series varchar default 'FXUSDCAD', days_back number default 10)
returns varchar
language python
runtime_version = '3.11'
packages = ('snowflake-snowpark-python', 'requests')
imports = ('@BRONZE.LOADER.CODE/fx_loader.py')
handler = 'fx_loader.main'
external_access_integrations = (EAI_BANK_OF_CANADA)
execute as owner
comment = 'Bank of Canada Valet API. First run loads from 2020-01-01';

create or replace task BRONZE.REFERENCE.T_LOAD_FX_RATES
  warehouse = WH_LOAD
  schedule = 'USING CRON 0 18 * * * America/Toronto'
  suspend_task_after_num_failures = 3
as
  call BRONZE.REFERENCE.LOAD_FX_RATES('FXUSDCAD', 10);

alter task BRONZE.REFERENCE.T_LOAD_FX_RATES resume;
