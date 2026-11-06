-- Control tables: everything a person decides (mapping, cut-over, access, tolerances) lives here, not in code.
-- Seeds in /seeds are loaded into these tables by scripts/load_seeds.py on every deploy (merge on the key).
use role EPITAPH_TRANSFORMER;
use schema GOLD.CONTROL;

-- ---------------------------------------------------------------- Master Client Index (MCI)
-- One golden record per Epitaph client, and every identifier that points to it. Every fact gets its client from the
-- MCI (SILVER.STG.MCI_CLIENT_RESOLUTION), never from a name match written into a view. Nathan Sennema is the data
-- steward: a new client or identifier is a reviewed change to seeds/mci_client.csv or seeds/mci_client_identifier.csv.
create table if not exists MCI_CLIENT (
  client_code         varchar not null,     -- C01 to C13; never reused
  client_name         varchar not null,     -- the name shown on every dashboard
  legal_name          varchar,              -- as named in TapClicks; Epitaph to confirm
  reporting_currency  varchar(3) not null,  -- currency every dashboard shows for this client
  home_country        varchar(2),
  status              varchar not null default 'active',   -- active | paused | former
  effective_from      date not null,        -- first day of data the product holds for the client
  effective_to        date default '9999-12-31',
  steward             varchar,              -- who approves changes to this client's identifiers
  notes               varchar,
  primary key (client_code)
) comment = 'seeds/mci_client.csv. Golden record per client';

create table if not exists MCI_CLIENT_IDENTIFIER (
  client_code   varchar not null,
  id_type       varchar not null,   -- campaign_prefix | campaign_token | sharepoint_feed | ga4_property | platform_account
  system        varchar not null,   -- source the identifier belongs to; '*' = any source
  id_value      varchar not null,
  status        varchar not null default 'proposed',   -- approved | proposed (proposed rows never resolve a client)
  valid_from    date default '2000-01-01',
  valid_to      date default '9999-12-31',
  approved_by   varchar,
  notes         varchar,
  primary key (id_type, system, id_value, valid_from)
) comment = 'seeds/mci_client_identifier.csv. Identifiers not already held in MAP_CLIENT_ACCOUNT, MAP_CLIENT_ALIAS or MAP_PLATFORM_ACCOUNT';

create table if not exists MAP_CLIENT_ACCOUNT (
  client_code               varchar not null,
  client_name               varchar not null,
  tapclicks_client_account  varchar not null,
  dashboards                varchar,
  reporting_currency        varchar(3) default 'CAD',
  primary key (tapclicks_client_account)
) comment = 'seeds/map_client_account.csv';

-- Short names clients go by in vendor campaign names (KHP, Sonnet, Kicking Horse). Used to find the client in shared vendor files.
create table if not exists MAP_CLIENT_ALIAS (
  alias        varchar not null,
  client_name  varchar not null,
  primary key (alias)
) comment = 'seeds/map_client_alias.csv';

create table if not exists MAP_PLATFORM_ACCOUNT (
  platform        varchar not null,     -- Google Ads, Facebook Ads, ...
  account_id      varchar not null,
  client_code     varchar not null,
  account_currency varchar(3) not null,
  convert_to      varchar(3),           -- Q20: Kids Help Phone USD accounts shown in CAD
  valid_from      date default '2000-01-01',
  valid_to        date default '9999-12-31',
  primary key (platform, account_id, valid_from)
) comment = 'Ad account to client. Filled at connector setup from the Fivetran account list';

create table if not exists MAP_MEDIA_TYPE (
  raw_value       varchar not null primary key,
  media_type      varchar not null,
  channel         varchar not null,
  platform_family varchar,
  notes           varchar
) comment = 'seeds/map_media_type.csv. Media type is the 4th part of the media buy name';

create table if not exists MAP_SMART_CAMPAIGN_RULE (
  smart_campaign  varchar not null,
  client          varchar not null,
  rule_type       varchar not null,     -- campaign_contains | campaign_like | job_number
  pattern         varchar not null,
  priority        number default 100,   -- lower wins
  approved        varchar default 'no',
  approved_by     varchar,
  approved_at     timestamp_ntz,
  primary key (smart_campaign, rule_type, pattern)
) comment = 'scripts/smart_campaign_mapping.py propose, then reviewed by Epitaph';

create table if not exists MAP_SMART_CAMPAIGN_OVERRIDE (
  campaign_name   varchar not null primary key,
  smart_campaign  varchar not null,
  set_by          varchar,
  set_at          timestamp_ntz default current_timestamp(),
  reason          varchar
) comment = 'Exact campaign to Smart Campaign; beats any rule';

create table if not exists DASHBOARD_SMART_CAMPAIGNS (
  dashboard_id    varchar not null,
  client          varchar,
  mode            varchar not null,     -- include | exclude
  smart_campaign  varchar not null,
  wildcard        boolean
) comment = 'seeds/dashboard_smart_campaigns.csv';

create table if not exists FILTER_RULES (
  dashboard_id    varchar, field varchar, pattern varchar, sql_like varchar, decision varchar, resolution varchar
) comment = 'seeds/filter_rules.csv: wildcard filters kept as reviewed pattern rules (Q009)';

create table if not exists MAP_CONVERSION_TAG (
  client_code       varchar not null,
  platform          varchar not null,     -- source name as in the model: Google Ads, Facebook Ads, ...
  tag_name          varchar not null,     -- conversion action as named in the platform
  kpi_group         varchar,              -- find_a_retailer, lead, order, landing_page_view ...
  counts_toward_kpi boolean not null,
  approved_by       varchar,
  valid_from        date default '2000-01-01',
  valid_to          date default '9999-12-31',
  primary key (client_code, platform, tag_name, valid_from)
) comment = 'From the Conversion tags sheet (T01 to T11). platform * = any platform; * in tag_name = any text (most specific row wins). Changes after 13 Nov by change request (R01)';

create table if not exists CTL_CUTOVER (
  source_name   varchar not null primary key,
  route         varchar not null,          -- fivetran | sharepoint | history_only
  cutover_date  date,                      -- TapClicks history before this date, new route from it
  status        varchar default 'planned', -- planned | testing | live | fallback
  owner         varchar,
  notes         varchar
) comment = 'One row per source. Filled from the source register';

create table if not exists CTL_SOURCE_PRECEDENCE (
  client_pattern    varchar not null,
  platform          varchar not null,
  preferred_source  varchar not null,
  suppressed_source varchar not null,
  decision          varchar,
  notes             varchar
) comment = 'seeds/ctl_source_precedence.csv (Q001, Q002)';

create table if not exists DQ_TOLERANCES (
  rule_id varchar primary key, measure_group varchar, measures varchar, grain_live varchar, grain_history varchar,
  tolerance_pct number(5,2), exact boolean, notes varchar
) comment = 'seeds/dq_tolerances.csv (R02 to R06)';

create table if not exists CLIENT_ACCESS (
  principal     varchar not null,   -- Omni user email or Snowflake role
  client_code   varchar not null,   -- '*' for Epitaph staff
  granted_by    varchar,
  granted_at    timestamp_ntz default current_timestamp(),
  primary key (principal, client_code)
) comment = 'Row access: who sees which client';

create table if not exists FEED_OWNERS (
  owner_key varchar primary key,    -- referenced by config/feeds.yml
  email     varchar not null
) comment = 'Filled by the Epitaph admin. Not in the repo';

create table if not exists ALERT_RECIPIENTS (
  alert_name varchar, email varchar
) comment = 'Filled by the Epitaph admin. Not in the repo';

create table if not exists CTL_HISTORY_LOAD (
  source_name   varchar not null,
  month         date not null,
  priority      number,
  file_name     varchar,
  rows_loaded   number,
  status        varchar default 'to download',   -- to download | downloaded | loaded | matched | corrected | skipped
  checked_at    timestamp_ntz,
  notes         varchar,
  primary key (source_name, month)
) comment = 'plans/history_download_plan.csv; one row per source and month';

create table if not exists CTL_HISTORY_CORRECTIONS (
  source_name varchar, activity_date date, measure varchar, tapclicks_value number(38,6), corrected_value number(38,6),
  reason varchar, approved_by varchar, approved_at timestamp_ntz
) comment = 'Where a history day is knowingly corrected (for example a known TapClicks double count)';

-- Archive (A12). Requests come from seeds/ctl_archive_requests.csv, changed only by an approved pull request.
-- action 'archive': move the client's rows older than archive_before (never later than 24 months ago) to GOLD.ARCHIVE.
-- action 'restore': put an archived client back in the live path. Nothing is ever deleted.
create table if not exists CTL_ARCHIVE_REQUESTS (
  client_code     varchar not null primary key,
  action          varchar not null,           -- archive | restore
  archive_before  date not null,
  requested_by    varchar,
  approved_by     varchar,                    -- Epitaph sponsor; no approval, no move
  approved_on     date,
  note            varchar
) comment = 'seeds/ctl_archive_requests.csv';

-- Written only by GOLD.ARCHIVE.RUN_ARCHIVE. Silver leaves out a client's rows before archive_before while state = 'archived'.
create table if not exists CTL_ARCHIVE_STATE (
  client_code     varchar not null primary key,
  client_name     varchar not null,
  archive_before  date not null,
  state           varchar not null,           -- archived | restored
  batch_id        varchar not null,
  changed_at      timestamp_ltz default current_timestamp()
) comment = 'Archive state per client, written by the monthly archive job';

create table if not exists REF_TAPCLICKS_BASELINE (
  dashboard_id varchar, widget_id number, metric varchar, period_start date, period_end date,
  filters varchar, value number(38,6), captured_at timestamp_ntz default current_timestamp(), captured_by varchar
) comment = 'TapClicks widget values captured before switch-off; acceptance reference';

create table if not exists COLUMN_GROUPS (
  column_group varchar primary key, columns varchar, default_for_clients varchar, notes varchar
) comment = 'seeds/column_groups.csv: which columns belong to which group';

create table if not exists CLIENT_COLUMN_ACCESS (
  client_code  varchar not null,   -- '*' = default for every client; a client row overrides it
  column_group varchar not null,
  access       varchar not null,   -- show | hide
  approved_by  varchar,
  notes        varchar,
  primary key (client_code, column_group)
) comment = 'seeds/client_column_access.csv: per-client column visibility (Epitaph staff always see all)';

-- Row access policy used by every client-facing view
create row access policy if not exists RAP_CLIENT as (p_client_code varchar) returns boolean ->
  is_role_in_session('EPITAPH_READER')
  or is_role_in_session('EPITAPH_TRANSFORMER')
  or exists (select 1 from GOLD.CONTROL.CLIENT_ACCESS a
             where a.principal in (current_user(), current_role())
               and (a.client_code = p_client_code or a.client_code = '*'));

-- Email helpers. Addresses stay in Snowflake tables; code passes only a key.
create or replace procedure GOLD.CONTROL.NOTIFY(recipient_kind varchar, recipient_key varchar, subject varchar, body varchar)
returns varchar language sql execute as owner as
$$
declare to_list varchar;
begin
  if (recipient_kind = 'feed_owner') then
    select listagg(email, ',') into :to_list from GOLD.CONTROL.FEED_OWNERS where owner_key = :recipient_key;
  else
    select listagg(email, ',') into :to_list from GOLD.CONTROL.ALERT_RECIPIENTS where alert_name = :recipient_key;
  end if;
  if (to_list is null) then
    return 'no recipients for ' || recipient_key;
  end if;
  call SYSTEM$SEND_EMAIL('EPITAPH_EMAIL', :to_list, :subject, :body);
  return 'sent';
end;
$$;
grant usage on procedure GOLD.CONTROL.NOTIFY(varchar, varchar, varchar, varchar) to role EPITAPH_LOADER;


-- Column access for direct Snowflake users. Epitaph staff and the build roles see everything; a user mapped to a
-- client sees a column group only if that client's setting is 'show' (the client's own row first, then the '*'
-- default). Omni applies the same seed through access grants in its model (omni/README.md),
-- because Omni queries as one service user. Policies per group are in snowflake/50_semantic/column_masking.sql.
create or replace function GOLD.CONTROL.CAN_SEE(col_group varchar) returns boolean as
$$
  is_role_in_session('EPITAPH_READER') or is_role_in_session('EPITAPH_TRANSFORMER') or is_role_in_session('EPITAPH_REPORTER')
  or coalesce((
    select c.access = 'show'
    from GOLD.CONTROL.CLIENT_ACCESS a
    join GOLD.CONTROL.CLIENT_COLUMN_ACCESS c
      on c.column_group = col_group and c.client_code in (a.client_code, '*')
    where a.principal in (current_user(), current_role())
    order by iff(c.client_code = '*', 1, 0)
    limit 1
  ), false)
$$;
