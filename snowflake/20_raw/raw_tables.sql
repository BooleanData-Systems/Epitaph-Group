-- BRONZE tables written by the loaders. Fivetran creates its own schemas (BRONZE.FIVETRAN_GOOGLE_ADS, ...).
use role EPITAPH_LOADER;

create table if not exists BRONZE.LOADER.LOAD_LOG (
  run_id        varchar,
  item_id       varchar not null,      -- SharePoint drive item id
  etag          varchar not null,      -- changes with every new version of the file
  feed_id       varchar,
  file_name     varchar,
  file_path     varchar,
  file_modified timestamp_tz,
  bytes         number,
  status        varchar,               -- loaded | rejected
  reason        varchar,
  rows_loaded   number,
  min_date      date,
  max_date      date,
  logged_at     timestamp_ltz default current_timestamp()
) change_tracking = true comment = 'One row per file version the SharePoint loader looked at';

-- One table per SharePoint feed. Every row as delivered, in RECORD, with the file it came from.
-- The procedure below creates any table named in feeds.yml that does not exist yet.
create or replace procedure BRONZE.LOADER.ENSURE_FEED_TABLE(table_name varchar)
returns varchar language sql execute as owner as
$$
begin
  execute immediate 'create table if not exists BRONZE.SHAREPOINT.' || :table_name || ' (
      item_id varchar, etag varchar, file_name varchar, feed_id varchar, report varchar, grain varchar,
      row_number number, record variant, run_id varchar,
      loaded_at timestamp_ltz default current_timestamp()) change_tracking = true';
  return 'ok';
end;
$$;

-- TapClicks history: Data Table export columns (Data_Table_Export.csv layout). Rates are not loaded.
create table if not exists BRONZE.TAPCLICKS.TAPCLICKS_HISTORY (
  activity_date_text   varchar,
  data_source_name     varchar,
  campaign_name        varchar,
  media_buy_name       varchar,
  creative_name        varchar,
  conversion_tag_name  varchar,
  impressions          varchar,
  clicks               varchar,
  spend                varchar,
  starts               varchar,
  completed_plays      varchar,
  total_conversions    varchar,
  file_name            varchar,
  file_row_number      number,
  loaded_at            timestamp_ltz default current_timestamp()
) change_tracking = true comment = 'From SharePoint History/TapClicks via COPY INTO. Kept as text; typed in staging';

create or replace procedure BRONZE.LOADER.LOAD_TAPCLICKS_HISTORY(pattern varchar)
returns varchar language sql execute as owner as
$$
begin
  -- The SharePoint loader copies History/TapClicks files to the stage; this loads any not loaded before.
  -- COPY options do not take bind variables, so the statement is built as text
  execute immediate 'copy into BRONZE.TAPCLICKS.TAPCLICKS_HISTORY (activity_date_text, data_source_name, campaign_name,
         media_buy_name, creative_name, conversion_tag_name, impressions, clicks, spend, starts, completed_plays,
         total_conversions, file_name, file_row_number)
  from (select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, metadata$filename, metadata$file_row_number
        from @BRONZE.TAPCLICKS.HISTORY_STAGE)
  pattern = ''' || replace(:pattern, '''', '') || '''
  on_error = abort_statement';
  return 'loaded';
end;
$$;

create table if not exists BRONZE.REFERENCE.FX_RATES (
  series        varchar not null,      -- FXUSDCAD
  rate_date     date not null,
  rate          number(18,6) not null,
  source        varchar default 'Bank of Canada Valet',
  loaded_at     timestamp_ltz default current_timestamp(),
  primary key (series, rate_date)
) change_tracking = true comment = 'Bank of Canada daily rates. Replaces the exchange rate Google Sheet (F18)';

-- Dynamic tables downstream need change tracking on every BRONZE table they read. Fivetran creates its tables as
-- EPITAPH_LOADER, so this procedure (owned by the same role) switches it on for a connector's schema.
-- Deploy calls it for each connector schema that exists; safe to run again.
create or replace procedure BRONZE.LOADER.ENABLE_CHANGE_TRACKING(schema_name varchar)
returns varchar language sql execute as owner as
$$
declare
  n integer default 0;
  c cursor for select table_name from BRONZE.INFORMATION_SCHEMA.TABLES
               where table_schema = upper(?) and table_type = 'BASE TABLE';
begin
  open c using (schema_name);
  for t in c do
    execute immediate 'alter table BRONZE.' || upper(:schema_name) || '."' || t.table_name || '" set change_tracking = true';
    n := n + 1;
  end for;
  return n || ' tables';
end;
$$;
