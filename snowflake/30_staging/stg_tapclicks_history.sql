-- TapClicks history, typed. One row per day x source x campaign x media buy x creative x conversion tag.
-- If a source-month was downloaded twice, only the latest download is used.
use role EPITAPH_TRANSFORMER;

create or replace dynamic table SILVER.STG.STG_TAPCLICKS_HISTORY
  target_lag = downstream warehouse = WH_TRANSFORMATION
  comment = 'History before each source''s cut-over date (CONTROL.CTL_CUTOVER)'
as
with typed as (
  select
    coalesce(try_to_date(activity_date_text, 'MON DD YYYY'), try_to_date(activity_date_text, 'YYYY-MM-DD'))  as activity_date,
    trim(data_source_name)                                as source_name,
    trim(campaign_name)                                   as campaign_name,
    nullif(trim(media_buy_name), '')                      as media_buy_name,
    nullif(trim(creative_name), '')                       as creative_name,
    nullif(trim(conversion_tag_name), '')                 as conversion_tag_name,
    coalesce(try_to_number(replace(impressions, ',', '')), 0)            as impressions,
    coalesce(try_to_number(replace(clicks, ',', '')), 0)                 as clicks,
    coalesce(try_to_decimal(replace(replace(spend, ',', ''), '$', ''), 18, 4), 0) as spend,
    coalesce(try_to_number(replace(starts, ',', '')), 0)                 as video_starts,
    coalesce(try_to_number(replace(completed_plays, ',', '')), 0)        as completed_plays,
    coalesce(try_to_decimal(replace(total_conversions, ',', ''), 18, 4), 0) as conversions,
    file_name, loaded_at,
    max(loaded_at) over (partition by file_name)          as file_loaded_at   -- one time per file, even if rows were inserted one by one
  from BRONZE.TAPCLICKS.TAPCLICKS_HISTORY
)
select *
from typed
where activity_date is not null
qualify dense_rank() over (partition by source_name, date_trunc('month', activity_date) order by file_loaded_at desc, file_name desc) = 1;
