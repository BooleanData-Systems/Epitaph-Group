-- Dimensions. Keys are hashes of the natural key so history and live rows join the same way.
use role EPITAPH_TRANSFORMER;
use schema GOLD.MARTS;

create or replace dynamic table DIM_DATE target_lag = downstream warehouse = WH_TRANSFORMATION as
select
  to_number(to_char(d, 'YYYYMMDD'))           as date_key,
  d                                           as date_day,
  date_trunc('week', d)                       as week_start,      -- Monday (WEEK_START = 1 on the account)
  date_trunc('month', d)                      as month_start,
  date_trunc('quarter', d)                    as quarter_start,
  year(d)                                     as year,
  dayname(d)                                  as day_name
from (select dateadd(day, seq4(), '2020-01-01'::date) as d from table(generator(rowcount => 4018)));  -- to 2030

-- Client: the Master Client Index golden record (GOLD.CONTROL.MCI_CLIENT), with its TapClicks accounts and dashboards
create or replace dynamic table DIM_CLIENT target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select
  sha2(c.client_code, 256) as client_key,
  c.client_code, c.client_name, c.legal_name, c.reporting_currency, c.home_country, c.status,
  c.effective_from, c.effective_to, c.steward,
  t.tapclicks_accounts, t.dashboards
from GOLD.CONTROL.MCI_CLIENT c
left join (select client_code,
                  listagg(tapclicks_client_account, '; ') within group (order by tapclicks_client_account) as tapclicks_accounts,
                  listagg(dashboards, ' ') within group (order by dashboards) as dashboards
           from GOLD.CONTROL.MAP_CLIENT_ACCOUNT group by client_code) t on t.client_code = c.client_code;

-- The published index: every identifier and the client it points to (approved), plus proposed ones awaiting Epitaph
create or replace dynamic table DIM_CLIENT_IDENTIFIER target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select sha2(client_code, 256) as client_key, client_code, id_type, system, id_value, match_rule, match_rank,
       valid_from, valid_to, held_in, 'approved' as status
from SILVER.STG.MCI_IDENTIFIERS
union all
select sha2(client_code, 256), client_code, id_type, system, id_value,
       iff(id_type = 'campaign_token', 'whole word', 'exact'), null, valid_from, valid_to, 'MCI_CLIENT_IDENTIFIER', status
from GOLD.CONTROL.MCI_CLIENT_IDENTIFIER
where status <> 'approved';

-- Campaign to Smart Campaign: override first, then approved rules by priority, else Unmapped (Q009)
create or replace dynamic table DIM_CAMPAIGN target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
with campaigns as (
  -- the client comes from the Master Client Index (MCI_CLIENT_RESOLUTION); one campaign name, one client
  select a.campaign_name,
         any_value(a.client_part) as client_part, any_value(a.campaign_part) as campaign_part,
         any_value(a.job_number) as job_number, any_value(a.language) as language, any_value(a.country) as country,
         boolor_agg(a.campaign_name_valid) as campaign_name_valid,
         min(a.activity_date) as first_seen, max(a.activity_date) as last_seen, sum(a.spend) as spend_to_date,
         iff(count(distinct r.client_code) = 1, min(r.client_code), null) as mci_client_code
  from SILVER.STG.INT_AD_DELIVERY a
  left join SILVER.STG.MCI_CLIENT_RESOLUTION r on r.mci_key = a.mci_key
  group by a.campaign_name
),
by_rule as (
  select c.campaign_name, r.smart_campaign, r.client,
         row_number() over (partition by c.campaign_name order by r.priority, length(r.pattern) desc) as rn
  from campaigns c
  join GOLD.CONTROL.MAP_SMART_CAMPAIGN_RULE r
    on r.approved = 'yes'
   and ( (r.rule_type = 'campaign_contains' and c.campaign_name ilike '%' || r.pattern || '%')
      or (r.rule_type = 'campaign_like'     and c.campaign_name ilike r.pattern)
      or (r.rule_type = 'job_number'        and c.job_number = r.pattern) )
)
select
  sha2(c.campaign_name, 256)                                  as campaign_key,
  c.campaign_name, c.client_part, c.campaign_part, c.job_number, c.language, c.country,
  c.campaign_name_valid,
  coalesce(o.smart_campaign, br.smart_campaign, 'Unmapped')   as smart_campaign,
  case when o.smart_campaign is not null then 'override' when br.smart_campaign is not null then 'rule' else 'none' end as mapped_by,
  coalesce(c.mci_client_code, cl.client_code)                 as client_code,
  case when c.mci_client_code is not null then 'mci' when cl.client_code is not null then 'smart_campaign' end as client_from,
  c.first_seen, c.last_seen, c.spend_to_date
from campaigns c
left join GOLD.CONTROL.MAP_SMART_CAMPAIGN_OVERRIDE o on o.campaign_name = c.campaign_name
left join by_rule br on br.campaign_name = c.campaign_name and br.rn = 1
-- fallback only: the client named in an approved Smart Campaign ("Nulo: Product")
left join GOLD.CONTROL.MCI_CLIENT cl
  on lower(cl.client_name) = lower(split_part(coalesce(o.smart_campaign, br.smart_campaign), ':', 1));

create or replace dynamic table DIM_SMART_CAMPAIGN target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select sha2(smart_campaign, 256) as smart_campaign_key, smart_campaign,
       any_value(client_code) as client_code, min(first_seen) as first_seen, max(last_seen) as last_seen
from DIM_CAMPAIGN group by smart_campaign;

create or replace dynamic table DIM_MEDIA_BUY target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select sha2(coalesce(media_buy_name, '(none)') || '|' || campaign_name, 256) as media_buy_key,
       any_value(media_buy_name) as media_buy_name, any_value(sha2(campaign_name, 256)) as campaign_key,
       any_value(media_type) as media_type, any_value(channel) as channel, any_value(tactic) as tactic,
       any_value(audience) as audience, any_value(platform) as platform
from SILVER.STG.INT_AD_DELIVERY
group by coalesce(media_buy_name, '(none)') || '|' || campaign_name;

create or replace dynamic table DIM_CREATIVE target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select sha2(coalesce(creative_name, '(none)'), 256) as creative_key,
       any_value(creative_name) as creative_name, any_value(creative_format) as creative_format,
       any_value(call_to_action) as call_to_action
from SILVER.STG.INT_AD_DELIVERY
group by coalesce(creative_name, '(none)');

create or replace dynamic table DIM_SOURCE target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select sha2(s.source_name, 256) as source_key, s.source_name, c.route, c.cutover_date, c.status, c.owner
from (select distinct source_name from SILVER.STG.INT_AD_DELIVERY
      union select distinct source_name from SILVER.STG.INT_CONVERSIONS) s
left join GOLD.CONTROL.CTL_CUTOVER c on c.source_name = s.source_name;

create or replace dynamic table DIM_CONVERSION_TAG target_lag = '1 hour' warehouse = WH_TRANSFORMATION as
select sha2(client_code || '|' || platform || '|' || tag_name || '|' || valid_from, 256) as conversion_tag_key,
       client_code, platform, tag_name, kpi_group, counts_toward_kpi, valid_from, valid_to, approved_by
from GOLD.CONTROL.MAP_CONVERSION_TAG;

-- One rate for every day: the last Bank of Canada rate on or before the day (weekends and holidays carry forward).
-- Runs a week ahead of today so a late refresh never leaves a day without a rate.
create or replace dynamic table DIM_FX_RATE target_lag = '1 hour' refresh_mode = full warehouse = WH_TRANSFORMATION as
select d.date_day, 'USD' as from_currency, 'CAD' as to_currency,
       last_value(f.rate ignore nulls) over (order by d.date_day rows between unbounded preceding and current row) as rate
from DIM_DATE d
left join BRONZE.REFERENCE.FX_RATES f on f.rate_date = d.date_day and f.series = 'FXUSDCAD'
where d.date_day <= dateadd(day, 7, current_date());
