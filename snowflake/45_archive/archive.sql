-- Archive (Epitaph answer A12): a former client's data older than 24 months moves out of the live path into
-- GOLD.ARCHIVE. Nothing is deleted anywhere:
--   * BRONZE is never touched, so a restore rebuilds the client from the original rows.
--   * GOLD.ARCHIVE keeps a frozen copy of the client's Silver rows, tagged with a batch id.
--   * Silver leaves the rows out only after the copy's row counts and totals match the source (CTL_ARCHIVE_STATE).
-- Archived rows stay out of every hourly refresh and out of Omni. Only EPITAPH_ADMIN can read GOLD.ARCHIVE.
-- Requests: seeds/ctl_archive_requests.csv (pull request approved by Epitaph). Runs monthly: T_MONTHLY_ARCHIVE.
-- Steps marked "-- step:" in RUN_ARCHIVE are also run by scripts/e2e_local.py, so the tested SQL is the deployed SQL.
use role EPITAPH_TRANSFORMER;
use schema GOLD.ARCHIVE;

-- Same columns as the Silver tables, plus who moved them and when. If a Silver column is added, add it here too
-- (the archive check below fails the deploy until the shapes match).
create table if not exists AD_DELIVERY as
  select cast(null as varchar) as batch_id, cast(null as varchar) as client_code, cast(null as timestamp_ltz) as archived_at, d.*
  from SILVER.STG.INT_AD_DELIVERY d where 1 = 0;

create table if not exists CONVERSIONS as
  select cast(null as varchar) as batch_id, cast(null as varchar) as client_code, cast(null as timestamp_ltz) as archived_at, c.*
  from SILVER.STG.INT_CONVERSIONS c where 1 = 0;

-- Every move and restore, with the totals compared. Kept for audit.
create table if not exists ARCHIVE_LOG (
  batch_id              varchar,
  client_code           varchar,
  action                varchar,          -- archive | archive_stopped | restore
  archive_before        date,
  source_rows           number,
  archived_rows         number,
  source_spend          number(18, 2),
  archived_spend        number(18, 2),
  source_impressions    number,
  archived_impressions  number,
  source_conversions    number(18, 2),
  archived_conversions  number(18, 2),
  verified              boolean,
  logged_at             timestamp_ltz default current_timestamp()
);

-- Clients due to move. The date is never later than the first of the month 24 months ago, whatever the request says.
create or replace view V_ARCHIVE_DUE as
select r.client_code,
       any_value(m.client_name) as client_name,
       least(r.archive_before, dateadd(month, -24, date_trunc('month', current_date()))) as archive_before
from GOLD.CONTROL.CTL_ARCHIVE_REQUESTS r
join GOLD.CONTROL.MAP_CLIENT_ACCOUNT m on m.client_code = r.client_code
left join GOLD.CONTROL.CTL_ARCHIVE_STATE s on s.client_code = r.client_code
where r.action = 'archive' and r.approved_by is not null
  and (s.client_code is null or s.state <> 'archived')
group by r.client_code, r.archive_before;

-- Clients due to come back
create or replace view V_RESTORE_DUE as
select r.client_code
from GOLD.CONTROL.CTL_ARCHIVE_REQUESTS r
join GOLD.CONTROL.CTL_ARCHIVE_STATE s on s.client_code = r.client_code
where r.action = 'restore' and r.approved_by is not null and s.state = 'archived';

-- Daily check: archived clients have nothing left in the live path before their date; restored clients are back
-- in full (live totals equal the archived copy).
create or replace view GOLD.CHECKS.DQ_ARCHIVE as
with live as (
  select s.client_code, count(*) as live_rows, coalesce(sum(d.spend), 0) as live_spend
  from GOLD.CONTROL.CTL_ARCHIVE_STATE s
  join SILVER.STG.INT_AD_DELIVERY d on lower(d.client_part) = lower(s.client_name) and d.activity_date < s.archive_before
  group by s.client_code
),
arc as (
  select batch_id, count(*) as archived_rows, coalesce(sum(spend), 0) as archived_spend
  from GOLD.ARCHIVE.AD_DELIVERY group by batch_id
)
select s.client_code, s.state, s.archive_before, coalesce(l.live_rows, 0) as live_rows, coalesce(a.archived_rows, 0) as archived_rows,
       case when s.state = 'archived' and coalesce(l.live_rows, 0) > 0 then 'archived rows still live'
            when s.state = 'restored' and (coalesce(l.live_rows, 0) <> coalesce(a.archived_rows, 0)
                                           or abs(coalesce(l.live_spend, 0) - coalesce(a.archived_spend, 0)) >= 0.005)
                 then 'restore incomplete' end as problem
from GOLD.CONTROL.CTL_ARCHIVE_STATE s
left join live l on l.client_code = s.client_code
left join arc a on a.batch_id = s.batch_id
where problem is not null;

create or replace procedure GOLD.ARCHIVE.RUN_ARCHIVE()
returns varchar language sql execute as owner as
$$
declare
  v_batch varchar; v_client varchar; v_name varchar; v_before date; v_ok boolean;
  n_archived integer default 0; n_restored integer default 0; n_stopped integer default 0;
  due cursor for select client_code, client_name, archive_before from GOLD.ARCHIVE.V_ARCHIVE_DUE;
  back cursor for select client_code from GOLD.ARCHIVE.V_RESTORE_DUE;
begin
  for r in due do
    v_client := r.client_code; v_name := r.client_name; v_before := r.archive_before; v_batch := uuid_string();
    begin transaction;
    -- step: copy_delivery
    insert into GOLD.ARCHIVE.AD_DELIVERY
      select :v_batch, :v_client, current_timestamp(), d.*
      from SILVER.STG.INT_AD_DELIVERY d
      where lower(d.client_part) = lower(:v_name) and d.activity_date < :v_before;
    -- step: copy_conversions
    insert into GOLD.ARCHIVE.CONVERSIONS
      select :v_batch, :v_client, current_timestamp(), c.*
      from SILVER.STG.INT_CONVERSIONS c
      where lower(c.client_part) = lower(:v_name) and c.activity_date < :v_before;
    -- step: compare_and_log
    insert into GOLD.ARCHIVE.ARCHIVE_LOG (batch_id, client_code, action, archive_before, source_rows, archived_rows,
        source_spend, archived_spend, source_impressions, archived_impressions, source_conversions, archived_conversions, verified)
      with src as (
        select count(*) as n, coalesce(sum(spend), 0) as spend, coalesce(sum(impressions), 0) as imp
        from SILVER.STG.INT_AD_DELIVERY where lower(client_part) = lower(:v_name) and activity_date < :v_before),
      src_c as (
        select count(*) as n, coalesce(sum(conversions), 0) as conv
        from SILVER.STG.INT_CONVERSIONS where lower(client_part) = lower(:v_name) and activity_date < :v_before),
      arc as (
        select count(*) as n, coalesce(sum(spend), 0) as spend, coalesce(sum(impressions), 0) as imp
        from GOLD.ARCHIVE.AD_DELIVERY where batch_id = :v_batch),
      arc_c as (
        select count(*) as n, coalesce(sum(conversions), 0) as conv
        from GOLD.ARCHIVE.CONVERSIONS where batch_id = :v_batch)
      select :v_batch, :v_client, 'archive', :v_before, src.n + src_c.n, arc.n + arc_c.n,
             src.spend, arc.spend, src.imp, arc.imp, src_c.conv, arc_c.conv,
             src.n = arc.n and src_c.n = arc_c.n and src.n + src_c.n > 0
             and abs(src.spend - arc.spend) < 0.005 and src.imp = arc.imp and abs(src_c.conv - arc_c.conv) < 0.005
      from src, src_c, arc, arc_c;
    select verified into :v_ok from GOLD.ARCHIVE.ARCHIVE_LOG where batch_id = :v_batch and action = 'archive';
    if (v_ok) then
      -- step: mark_archived
      merge into GOLD.CONTROL.CTL_ARCHIVE_STATE s
      using (select :v_client as client_code, :v_name as client_name, :v_before as archive_before, :v_batch as batch_id) n
        on s.client_code = n.client_code
      when matched then update set client_name = n.client_name, archive_before = n.archive_before, state = 'archived',
                                   batch_id = n.batch_id, changed_at = current_timestamp()
      when not matched then insert (client_code, client_name, archive_before, state, batch_id, changed_at)
                            values (n.client_code, n.client_name, n.archive_before, 'archived', n.batch_id, current_timestamp());
      commit;
      n_archived := n_archived + 1;
    else
      rollback;      -- nothing copied, nothing hidden
      insert into GOLD.ARCHIVE.ARCHIVE_LOG (batch_id, client_code, action, archive_before, verified)
        values (:v_batch, :v_client, 'archive_stopped', :v_before, false);
      call GOLD.CONTROL.NOTIFY('alert', 'check_failures', 'Epitaph reporting: archive stopped',
        'The archive for client ' || :v_client || ' stopped because the copy did not match. Nothing was moved.');
      n_stopped := n_stopped + 1;
    end if;
  end for;
  for r in back do
    v_client := r.client_code;
    -- step: mark_restored
    update GOLD.CONTROL.CTL_ARCHIVE_STATE set state = 'restored', changed_at = current_timestamp()
      where client_code = :v_client and state = 'archived';
    insert into GOLD.ARCHIVE.ARCHIVE_LOG (batch_id, client_code, action, archive_before, verified)
      select batch_id, client_code, 'restore', archive_before, null from GOLD.CONTROL.CTL_ARCHIVE_STATE where client_code = :v_client;
    n_restored := n_restored + 1;
  end for;
  return n_archived || ' archived, ' || n_restored || ' restored, ' || n_stopped || ' stopped';
end;
$$;
