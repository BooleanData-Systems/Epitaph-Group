-- Daily checks and email alerts. Loader tasks are in 20_raw. Dynamic tables refresh on their own target lag.
use role EPITAPH_TRANSFORMER;

create or replace task GOLD.CHECKS.T_DAILY_CHECKS
  warehouse = WH_TRANSFORMATION
  schedule = 'USING CRON 0 7 * * * America/Toronto'
  comment = 'Quality checks every morning; comparison for the last full week during the parallel run'
as
begin
  call GOLD.CHECKS.RUN_DQ_CHECKS();
  call GOLD.CHECKS.RUN_LIVE_COMPARISON(dateadd(day, -14, date_trunc('week', current_date())), dateadd(day, -1, date_trunc('week', current_date())));
end;

alter task GOLD.CHECKS.T_DAILY_CHECKS resume;

-- Archive (A12): at 05:00 on the 1st of each month, moves approved former clients older than 24 months
create or replace task GOLD.ARCHIVE.T_MONTHLY_ARCHIVE
  warehouse = WH_TRANSFORMATION
  schedule = 'USING CRON 0 5 1 * * America/Toronto'
  comment = 'Moves approved former clients older than 24 months to GOLD.ARCHIVE; restores approved clients'
as
  call GOLD.ARCHIVE.RUN_ARCHIVE();

alter task GOLD.ARCHIVE.T_MONTHLY_ARCHIVE resume;

-- Email when any check fails. Recipients: GOLD.CONTROL.ALERT_RECIPIENTS (set by the Epitaph admin).
create or replace alert GOLD.CHECKS.A_CHECK_FAILURES
  warehouse = WH_TRANSFORMATION
  schedule = 'USING CRON 30 7 * * * America/Toronto'
  if (exists (
    select 1 from GOLD.CHECKS.DQ_RESULTS
    where checked_at >= dateadd(hour, -2, current_timestamp()) and failing_rows > 0
      and check_name in ('freshness', 'source_overlap', 'impossible_values', 'missing_fx', 'rejected_files', 'archive')
    union all
    select 1 from GOLD.CHECKS.RECON_RESULTS
    where checked_at >= dateadd(hour, -2, current_timestamp()) and status = 'fail'
  ))
  then
    call GOLD.CONTROL.NOTIFY('alert', 'check_failures', 'Epitaph reporting: checks need attention',
      'One or more data checks failed this morning. Open the Data Checks page in Omni for the list.');

alter alert GOLD.CHECKS.A_CHECK_FAILURES resume;
