-- Master Client Index: every identifier that points to a client, in one list (SILVER.STG.MCI_IDENTIFIERS).
-- The index reads the client-related control tables; nothing else in the pipeline matches clients by name.
--
--   id_type            match       rank  held in
--   platform_account   exact       10    MAP_PLATFORM_ACCOUNT (ad account or GA4 property, by source; dated)
--   sharepoint_feed    exact       20    MCI_CLIENT_IDENTIFIER (a feed that only ever carries one client)
--   tapclicks_account  exact       30    MAP_CLIENT_ACCOUNT (history reference; TapClicks rows do not carry it)
--   campaign_prefix    exact       40    MCI_CLIENT (client name) + MCI_CLIENT_IDENTIFIER (other prefixes)
--   alias              whole word  50    MCI_CLIENT (client name) + MAP_CLIENT_ALIAS (KHP, Sonnet, SXM ...)
--   campaign_token     whole word  60    MCI_CLIENT_IDENTIFIER (a word in campaign names that only one client uses)
--
-- The lowest rank that matches wins. Only approved MCI_CLIENT_IDENTIFIER rows take part; proposed rows are shown
-- on the Data Checks page as suggestions until Epitaph approves them.
use role EPITAPH_TRANSFORMER;

create or replace view SILVER.STG.MCI_IDENTIFIERS as
with ids as (
  select client_code, 'campaign_prefix' as id_type, '*' as system, client_name as id_value,
         '2000-01-01'::date as valid_from, '9999-12-31'::date as valid_to, 'MCI_CLIENT' as held_in
  from GOLD.CONTROL.MCI_CLIENT
  union all
  select client_code, 'alias', '*', client_name, '2000-01-01'::date, '9999-12-31'::date, 'MCI_CLIENT'
  from GOLD.CONTROL.MCI_CLIENT
  union all
  select c.client_code, 'alias', '*', a.alias, '2000-01-01'::date, '9999-12-31'::date, 'MAP_CLIENT_ALIAS'
  from GOLD.CONTROL.MAP_CLIENT_ALIAS a
  join GOLD.CONTROL.MCI_CLIENT c on lower(c.client_name) = lower(a.client_name)
  union all
  select client_code, 'tapclicks_account', 'TapClicks', tapclicks_client_account, '2000-01-01'::date, '9999-12-31'::date,
         'MAP_CLIENT_ACCOUNT'
  from GOLD.CONTROL.MAP_CLIENT_ACCOUNT
  union all
  select client_code, 'platform_account', platform, account_id, valid_from, valid_to, 'MAP_PLATFORM_ACCOUNT'
  from GOLD.CONTROL.MAP_PLATFORM_ACCOUNT
  union all
  select client_code, iff(id_type = 'ga4_property', 'platform_account', id_type), system, id_value, valid_from, valid_to,
         'MCI_CLIENT_IDENTIFIER'
  from GOLD.CONTROL.MCI_CLIENT_IDENTIFIER
  where status = 'approved'
)
select distinct
  client_code, id_type, system, id_value,
  trim(regexp_replace(lower(id_value), '[^a-z0-9]+', ' '))                 as id_norm,
  case id_type when 'platform_account' then 'exact' when 'sharepoint_feed' then 'exact'
               when 'tapclicks_account' then 'exact' when 'campaign_prefix' then 'exact' else 'whole word' end as match_rule,
  case id_type when 'platform_account' then 10 when 'sharepoint_feed' then 20 when 'tapclicks_account' then 30
               when 'campaign_prefix' then 40 when 'alias' then 50 else 60 end as match_rank,
  valid_from, valid_to, held_in
from ids;

-- Client for each single-client SharePoint feed (Sonnet, SiriusXM, Adara, Spotify Cobs Bread)
create or replace view SILVER.STG.MCI_FEED_CLIENT as
select i.id_value as feed_id, i.client_code, c.client_name
from SILVER.STG.MCI_IDENTIFIERS i
join GOLD.CONTROL.MCI_CLIENT c on c.client_code = i.client_code
where i.id_type = 'sharepoint_feed';
