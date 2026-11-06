-- Master Client Index: the client for every source, account and campaign that reaches Silver.
-- One row per mci_key (source | account | campaign | vendor file client). The best-ranked identifier that matches
-- wins (mci_identifiers.sql). Two clients at the same rank is a conflict: the row gets no client and is listed in
-- GOLD.CHECKS.DQ_UNRESOLVED_CLIENTS, so a wrong client never reaches a dashboard.
use role EPITAPH_TRANSFORMER;

create or replace dynamic table SILVER.STG.MCI_CLIENT_RESOLUTION
  target_lag = '1 hour' warehouse = WH_TRANSFORMATION
as
with keys as (
  select mci_key, any_value(source_name) as source_name, any_value(account_id) as account_id,
         any_value(campaign_name) as campaign_name, any_value(client_hint) as client_hint,
         any_value(client_part) as client_part, max(activity_date) as last_seen
  from (select mci_key, source_name, account_id, campaign_name, client_hint, client_part, activity_date from SILVER.STG.INT_AD_DELIVERY
        union all
        select mci_key, source_name, account_id, campaign_name, null, client_part, activity_date from SILVER.STG.INT_CONVERSIONS)
  group by mci_key
),
ids as (
  select * from SILVER.STG.MCI_IDENTIFIERS
),
candidates as (
  -- 10: the ad account (or GA4 property), valid on the last day the key was seen
  select k.mci_key, i.client_code, i.id_type as matched_by, i.match_rank
  from keys k join ids i
    on i.id_type = 'platform_account' and i.system = k.source_name and i.id_value = k.account_id
   and k.last_seen between i.valid_from and i.valid_to
  union all
  -- 20: the client a single-client feed or a vendor file named (STG_VENDOR_DELIVERY.client_hint)
  select k.mci_key, c.client_code, 'sharepoint_feed', 20
  from keys k join GOLD.CONTROL.MCI_CLIENT c on lower(c.client_name) = lower(k.client_hint)
  union all
  -- 40: the client part of the naming convention (Client_Campaign_Job_Lang_Country)
  select k.mci_key, i.client_code, i.id_type, i.match_rank
  from keys k join ids i
    on i.id_type = 'campaign_prefix' and (i.system = '*' or i.system = k.source_name) and lower(i.id_value) = lower(k.client_part)
  union all
  -- 50 and 60: a client name, short name or token found as a whole word anywhere in the campaign name
  select k.mci_key, i.client_code, i.id_type, i.match_rank
  from keys k join ids i
    on i.id_type in ('alias', 'campaign_token') and (i.system = '*' or i.system = k.source_name)
   and ' ' || regexp_replace(lower(k.campaign_name), '[^a-z0-9]+', ' ') || ' ' like '% ' || i.id_norm || ' %'
),
best as (
  select * from candidates
  qualify rank() over (partition by mci_key order by match_rank) = 1
),
decided as (
  select mci_key, count(distinct client_code) as clients, min(client_code) as client_code,
         min(matched_by) as matched_by, min(match_rank) as match_rank
  from best group by mci_key
)
select
  k.mci_key, k.source_name, k.account_id, k.campaign_name, k.client_hint, k.client_part, k.last_seen,
  iff(d.clients = 1, d.client_code, null)                                       as client_code,
  iff(d.clients = 1, sha2(d.client_code, 256), null)                            as client_key,
  case when d.clients is null then 'unresolved' when d.clients > 1 then 'conflict' else d.matched_by end as matched_by,
  d.match_rank
from keys k
left join decided d on d.mci_key = k.mci_key;
