"""Generate the main semantic view, GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY, from one list of row blocks.

Every fact is stacked into one view (union all) with the same columns: each block fills its own measures and
dimensions and leaves the rest as 0 or null. That lets every KPI in config/kpis.yml, including the ones that mix
facts (CPQ = spend / quotes, cost per trial, cost per session), be computed in one place from totals, at whatever
level a dashboard filters to. Writes snowflake/50_semantic/v_media_performance_daily.sql (the other semantic views
in that file are kept as they are).

    python scripts/gen_semantic_view.py
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "snowflake" / "50_semantic" / "v_media_performance_daily.sql"

# column -> type, in view order
DIMS = [
    ("row_type", "varchar"), ("date_day", "date"), ("week_start", "date"), ("month_start", "date"),
    ("client_code", "varchar"), ("client_name", "varchar"), ("smart_campaign", "varchar"), ("campaign_name", "varchar"),
    ("job_number", "varchar"), ("language", "varchar"), ("country", "varchar"), ("campaign_name_valid", "boolean"),
    ("source_name", "varchar"), ("platform", "varchar"), ("media_type", "varchar"), ("channel", "varchar"),
    ("media_buy_name", "varchar"), ("tactic", "varchar"), ("audience", "varchar"),
    ("creative_name", "varchar"), ("creative_format", "varchar"), ("call_to_action", "varchar"),
    ("conversion_tag", "varchar"), ("kpi_group", "varchar"), ("counts_toward_kpi", "boolean"), ("campaign_type", "varchar"),
    ("ga4_session_source", "varchar"), ("ga4_session_medium", "varchar"), ("ga4_session_campaign", "varchar"),
    ("province", "varchar"), ("product", "varchar"), ("segment", "varchar"), ("quality_band", "varchar"), ("line_type", "varchar"),
    ("goal_metric", "varchar"), ("currency_code", "varchar"), ("loaded_from", "varchar"),
]
MEASURES = [
    "impressions", "clicks", "spend", "video_starts", "completed_plays", "post_shares", "spots",
    "conversions", "platform_conversions", "platform_all_conversions", "revenue", "click_through_conversions",
    "view_through_conversions", "sessions", "quotes", "quality_quotes", "binds", "customers",
    "performance_trials", "organic_trials", "scorecard_trials", "performance_flow_starts", "organic_flow_starts",
    "commuter_starts", "commuter_activations", "site_visits", "flight_searches", "flight_bookings", "hotel_searches",
    "hotel_bookings", "travel_search_signals", "attributed_books", "goal_value",
]

CAMPAIGN_DIMS = {
    "client_code": "coalesce(f.client_code, c.client_code)", "client_name": "cl.client_name", "smart_campaign": "c.smart_campaign",
    "campaign_name": "c.campaign_name", "job_number": "c.job_number", "language": "c.language", "country": "c.country",
    "campaign_name_valid": "c.campaign_name_valid", "source_name": "s.source_name", "platform": "f.platform",
}
DATE_DIMS = {"date_day": "d.date_day", "week_start": "d.week_start", "month_start": "d.month_start"}
# Every fact carries its client from the Master Client Index (f.client_code); no client is named in this view
CLIENT_JOIN = "left join GOLD.MARTS.DIM_CLIENT cl on cl.client_code = f.client_code"

BLOCKS = [
    {"row_type": "delivery",
     "from": """GOLD.MARTS.FCT_AD_DELIVERY_DAILY f
join GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key
left join GOLD.MARTS.DIM_CAMPAIGN c on c.campaign_key = f.campaign_key
left join GOLD.MARTS.DIM_CLIENT cl on cl.client_code = coalesce(f.client_code, c.client_code)
left join GOLD.MARTS.DIM_SOURCE s on s.source_key = f.source_key
left join GOLD.MARTS.DIM_MEDIA_BUY mb on mb.media_buy_key = f.media_buy_key
left join GOLD.MARTS.DIM_CREATIVE cr on cr.creative_key = f.creative_key""",
     "cols": {**DATE_DIMS, **CAMPAIGN_DIMS, "media_type": "f.media_type", "channel": "f.channel",
              "media_buy_name": "mb.media_buy_name", "tactic": "mb.tactic", "audience": "mb.audience",
              "creative_name": "cr.creative_name", "creative_format": "cr.creative_format", "call_to_action": "cr.call_to_action",
              "currency_code": "f.currency_code", "loaded_from": "f.loaded_from",
              **{m: f"f.{m}" for m in ("impressions", "clicks", "spend", "video_starts", "completed_plays", "post_shares", "spots")}}},
    {"row_type": "conversion",
     "from": """GOLD.MARTS.FCT_CONVERSIONS_DAILY f
join GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key
left join GOLD.MARTS.DIM_CAMPAIGN c on c.campaign_key = f.campaign_key
left join GOLD.MARTS.DIM_CLIENT cl on cl.client_code = coalesce(f.client_code, c.client_code)
left join GOLD.MARTS.DIM_SOURCE s on s.source_key = f.source_key""",
     "cols": {**DATE_DIMS, **CAMPAIGN_DIMS, "conversion_tag": "f.conversion_tag_name", "kpi_group": "f.kpi_group",
              "counts_toward_kpi": "f.counts_toward_kpi", "campaign_type": "f.campaign_type", "loaded_from": "f.loaded_from",
              **{m: f"f.{m}" for m in ("conversions", "platform_conversions", "platform_all_conversions", "revenue",
                                       "click_through_conversions", "view_through_conversions")}}},
    {"row_type": "web_sessions",
     "from": """GOLD.MARTS.FCT_WEB_SESSIONS_DAILY f
join GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key
left join GOLD.MARTS.DIM_CLIENT cl on cl.client_code = f.client_code""",
     "cols": {**DATE_DIMS, "client_code": "f.client_code", "client_name": "cl.client_name", "source_name": "'Google Analytics 4'",
              "ga4_session_source": "f.ga4_session_source", "ga4_session_medium": "f.ga4_session_medium",
              "ga4_session_campaign": "f.ga4_session_campaign", "sessions": "f.sessions"}},
    {"row_type": "sonnet",
     "from": "GOLD.MARTS.FCT_SONNET_QUOTES_DAILY f\njoin GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key\n"
             + CLIENT_JOIN,
     "cols": {**DATE_DIMS, "client_code": "f.client_code", "client_name": "cl.client_name", "source_name": "'Sonnet files'",
              "province": "f.province", "product": "f.product", "channel": "f.channel", "segment": "f.segment",
              "quality_band": "f.quality_band", "line_type": "f.line_type",
              **{m: f"f.{m}" for m in ("quotes", "quality_quotes", "binds", "customers")}}},
    {"row_type": "siriusxm",
     "from": "GOLD.MARTS.FCT_SXM_SCORECARD f\njoin GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key\n"
             + CLIENT_JOIN,
     "cols": {**DATE_DIMS, "client_code": "f.client_code", "client_name": "cl.client_name", "source_name": "'SiriusXM files'",
              "channel": "f.channel", "campaign_name": "f.campaign_name",
              **{m: f"f.{m}" for m in ("performance_trials", "organic_trials", "scorecard_trials", "performance_flow_starts",
                                       "organic_flow_starts", "commuter_starts", "commuter_activations")}}},
    {"row_type": "adara",
     "from": "GOLD.MARTS.FCT_ADARA_DAILY f\njoin GOLD.MARTS.DIM_DATE d on d.date_key = f.date_key\n"
             + CLIENT_JOIN,
     "cols": {**DATE_DIMS, "client_code": "f.client_code", "client_name": "cl.client_name", "source_name": "'Adara - Ottawa Tourism'",
              "campaign_name": "f.campaign_name",
              **{m: f"f.{m}" for m in ("site_visits", "flight_searches", "flight_bookings", "hotel_searches", "hotel_bookings",
                                       "travel_search_signals", "attributed_books")}}},
    {"row_type": "goal",
     "from": "GOLD.MARTS.FCT_GOALS f\nleft join GOLD.MARTS.DIM_CLIENT cl on cl.client_code = f.client_code",
     "cols": {"date_day": "f.period_month", "week_start": "f.period_month", "month_start": "f.period_month",
              "client_code": "f.client_code", "client_name": "cl.client_name", "smart_campaign": "f.smart_campaign",
              "source_name": "'Goals'", "goal_metric": "f.goal_metric", "goal_value": "f.goal_value"}},
]


def block_sql(b):
    lines = [f"  '{b['row_type']}' as row_type"]
    for col, typ in DIMS[1:]:
        lines.append(f"  {b['cols'][col]} as {col}" if col in b["cols"] else f"  null::{typ} as {col}")
    for m in MEASURES:
        lines.append(f"  coalesce({b['cols'][m]}, 0) as {m}" if m in b["cols"] else f"  0 as {m}")
    return "select\n" + ",\n".join(lines) + "\nfrom " + b["from"]


def main():
    head = """-- Generated by scripts/gen_semantic_view.py. Do not edit the main view by hand.
-- The one view every dashboard reads. Every fact is stacked (union all) with the same columns, so every KPI,
-- including those that mix facts (CPQ, cost per trial, cost per session), is computed from totals at any level
-- (K02). Each row_type fills only its own measures; the rest are 0.
-- Filters: a filter on a delivery column (media type, tactic, creative) must keep outcome rows (conversions,
--   quotes, trials, sessions). The Omni model gives each such column a hidden filter_<column> field that reads
--   'All outcomes' on outcome rows; scripts/omni_build.py writes tile filters on it (filter_media_type in [CTV, All outcomes]). Rates that divide spend by an outcome are only
--   meaningful at client or campaign level, which is how the dashboards use them.
-- conversions holds every conversion; Total Conversions and CPA count only rows where counts_toward_kpi is true.
use role EPITAPH_TRANSFORMER;

create or replace view GOLD.SEMANTIC.V_MEDIA_PERFORMANCE_DAILY
  with row access policy GOLD.CONTROL.RAP_CLIENT on (client_code)
as
"""
    body = "\nunion all\n".join(block_sql(b) for b in BLOCKS) + ";\n"
    old = OUT.read_text()
    marker = "-- Custom dashboards read these alongside the main view"
    rest = old[old.index(marker):] if marker in old else ""
    OUT.write_text(head + body + "\n" + rest)
    print(f"{len(BLOCKS)} row types, {len(DIMS)} dimensions, {len(MEASURES)} measures")


if __name__ == "__main__":
    main()
