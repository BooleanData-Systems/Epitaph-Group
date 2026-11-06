"""Writes specs/data_mapping.csv: every source field through Raw/Bronze, Silver, Gold and the semantic layer.

One row per source field. The definitions below follow the SQL in snowflake/ (staging views, INT_ tables, facts);
tests/test_data_mapping.py checks that every Silver and Gold column named here exists in that SQL, so the mapping
cannot drift from the code without a test failing.

    python scripts/build_data_mapping.py
"""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "specs" / "data_mapping.csv"
COLS = ["map_id", "source", "route", "client_from", "source_object", "source_field", "bronze_object", "bronze_field",
        "silver_object", "silver_field", "gold_object", "gold_field", "semantic_field", "data_type", "rule", "status"]

# Silver ad delivery column -> (gold object, gold field, semantic field, type, rule)
AD_GOLD = {
    "activity_date": ("FCT_AD_DELIVERY_DAILY", "date_key", "date_day", "date", "YYYYMMDD key to DIM_DATE (week starts Monday)"),
    "source_name": ("FCT_AD_DELIVERY_DAILY", "source_key", "source_name", "varchar", "sha2 key to DIM_SOURCE; cut-over and precedence applied in INT_AD_DELIVERY"),
    "platform": ("FCT_AD_DELIVERY_DAILY", "platform", "platform", "varchar", "as is"),
    "account_id": ("FCT_AD_DELIVERY_DAILY", "client_code", "client_code", "varchar", "Master Client Index rank 10 (MAP_PLATFORM_ACCOUNT); also picks the account currency"),
    "account_currency": ("FCT_AD_DELIVERY_DAILY", "account_currency", "currency_code", "varchar(3)", "MAP_PLATFORM_ACCOUNT first, then the source; CAD if neither"),
    "campaign_id": ("", "", "", "varchar", "lineage only; Gold keys on the campaign name so history and live rows join the same way"),
    "campaign_name": ("FCT_AD_DELIVERY_DAILY", "campaign_key", "campaign_name", "varchar", "sha2 key to DIM_CAMPAIGN; parts 1 to 5 of Client_Campaign_Job_Lang_Country parsed; client part feeds the MCI (rank 40)"),
    "media_buy_id": ("", "", "", "varchar", "lineage only"),
    "media_buy_name": ("FCT_AD_DELIVERY_DAILY", "media_buy_key", "media_buy_name", "varchar", "key to DIM_MEDIA_BUY; part 4 = media type via MAP_MEDIA_TYPE, part 5 = tactic, part 8 = audience"),
    "creative_id": ("", "", "", "varchar", "lineage only"),
    "creative_name": ("FCT_AD_DELIVERY_DAILY", "creative_key", "creative_name", "varchar", "key to DIM_CREATIVE; part 7 = format, part 9 = call to action"),
    "impressions": ("FCT_AD_DELIVERY_DAILY", "impressions", "impressions", "number", "sum"),
    "clicks": ("FCT_AD_DELIVERY_DAILY", "clicks", "clicks", "number", "sum"),
    "spend": ("FCT_AD_DELIVERY_DAILY", "spend", "spend", "number(18,4)", "sum; spend_account_currency kept; USD accounts marked convert_to CAD multiplied by DIM_FX_RATE (live rows only)"),
    "video_starts": ("FCT_AD_DELIVERY_DAILY", "video_starts", "video_starts", "number", "sum"),
    "completed_plays": ("FCT_AD_DELIVERY_DAILY", "completed_plays", "completed_plays", "number", "sum"),
    "post_shares": ("FCT_AD_DELIVERY_DAILY", "post_shares", "post_shares", "number", "sum"),
    "spots": ("FCT_AD_DELIVERY_DAILY", "spots", "spots", "number", "sum"),
    "client_hint": ("FCT_AD_DELIVERY_DAILY", "client_code", "client_code", "varchar", "Master Client Index rank 20: the feed's client, or the client named in a shared vendor file"),
}
CONV_GOLD = {
    "activity_date": ("FCT_CONVERSIONS_DAILY", "date_key", "date_day", "date", "YYYYMMDD key"),
    "account_id": ("FCT_CONVERSIONS_DAILY", "client_code", "client_code", "varchar", "Master Client Index; campaign's client if the campaign has no delivery"),
    "campaign_name": ("FCT_CONVERSIONS_DAILY", "campaign_key", "campaign_name", "varchar", "sha2 key to DIM_CAMPAIGN"),
    "campaign_type": ("FCT_CONVERSIONS_DAILY", "campaign_type", "campaign_type", "varchar", "as is"),
    "conversion_tag_name": ("FCT_CONVERSIONS_DAILY", "conversion_tag_name", "conversion_tag", "varchar", "matched to MAP_CONVERSION_TAG (client, platform or *, tag with * wildcards; most specific wins; dated) for kpi_group and counts_toward_kpi"),
    "conversions": ("FCT_CONVERSIONS_DAILY", "platform_conversions", "platform_conversions", "number", "sum; Total Conversions and CPA count only counts_toward_kpi rows"),
    "all_conversions": ("FCT_CONVERSIONS_DAILY", "platform_all_conversions", "platform_all_conversions", "number", "sum"),
    "conversion_value": ("FCT_CONVERSIONS_DAILY", "revenue", "revenue", "number", "sum"),
    "view_through_conversions": ("FCT_CONVERSIONS_DAILY", "view_through_conversions", "view_through_conversions", "number", "sum; click-through = conversions minus view-through"),
}

ROWS = []


def add(source, route, client_from, src_obj, src_field, bronze_obj, bronze_field, silver_obj, silver_field,
        gold=None, typ="", rule="", status="built"):
    g = gold or ("", "", "", typ, rule)
    ROWS.append({"source": source, "route": route, "client_from": client_from, "source_object": src_obj,
                 "source_field": src_field, "bronze_object": bronze_obj, "bronze_field": bronze_field,
                 "silver_object": silver_obj, "silver_field": silver_field, "gold_object": g[0], "gold_field": g[1],
                 "semantic_field": g[2], "data_type": typ or g[3], "rule": "; ".join(x for x in (rule, g[4]) if x) or "as is",
                 "status": status})


def ad_source(source, route, client_from, stg, fields):
    """fields: list of (source object, source field, bronze field, silver field, rule)"""
    for src_obj, src_field, bronze_field, silver_field, rule in fields:
        bronze_obj = "" if src_obj == "constant" else src_obj
        add(source, route, client_from, src_obj, src_field, bronze_obj, bronze_field, f"SILVER.STG.{stg} > INT_AD_DELIVERY",
            silver_field, AD_GOLD.get(silver_field), rule=rule)


def conv_source(source, client_from, stg, fields):
    for src_obj, src_field, silver_field, rule in fields:
        add(source, "Fivetran", client_from, src_obj, src_field, src_obj, src_field, f"SILVER.STG.{stg} > INT_CONVERSIONS",
            silver_field, CONV_GOLD.get(silver_field), rule=rule)


def sp(table, field):
    return f"BRONZE.SHAREPOINT.{table}", f"RECORD:{field}"


# ------------------------------------------------------------------ Fivetran: Google Ads
G = "BRONZE.FIVETRAN_GOOGLE_ADS."
ACC = "MCI rank 10 ad account (MAP_PLATFORM_ACCOUNT), else campaign name (rank 40 to 60)"
ad_source("Google Ads", "Fivetran", ACC, "STG_GOOGLE_ADS", [
    (G + "AD_STATS", "date", "date", "activity_date", "cast to date"),
    ("constant", "'Google Ads'", "", "source_name", "set in staging"),
    ("constant", "'Google Ads'", "", "platform", "set in staging"),
    (G + "AD_STATS", "customer_id", "customer_id", "account_id", "cast to text"),
    (G + "ACCOUNT_HISTORY", "currency_code", "currency_code", "account_currency", "latest row per account (updated_at)"),
    (G + "AD_STATS", "campaign_id", "campaign_id", "campaign_id", "cast to text"),
    (G + "CAMPAIGN_HISTORY", "name", "name", "campaign_name", "latest row per campaign (updated_at)"),
    (G + "AD_STATS", "ad_group_id", "ad_group_id", "media_buy_id", "cast to text"),
    (G + "AD_GROUP_HISTORY", "name", "name", "media_buy_name", "latest row per ad group"),
    (G + "AD_STATS", "ad_id", "ad_id", "creative_id", "cast to text"),
    (G + "AD_HISTORY", "name", "name", "creative_name", "latest row per ad; ad id when the ad has no name"),
    (G + "AD_STATS", "impressions", "impressions", "impressions", ""),
    (G + "AD_STATS", "clicks", "clicks", "clicks", ""),
    (G + "AD_STATS", "cost_micros", "cost_micros", "spend", "divided by 1,000,000"),
    (G + "AD_STATS", "video_views", "video_views", "video_starts", "null as 0"),
    (G + "AD_STATS", "video_quartile_p_100_rate", "video_quartile_p_100_rate", "completed_plays", "rate x impressions; null as 0"),
])
conv_source("Google Ads", ACC, "STG_GOOGLE_ADS_CONVERSIONS", [
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "date", "activity_date", "cast to date"),
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "customer_id", "account_id", "cast to text"),
    (G + "CAMPAIGN_HISTORY", "name", "campaign_name", "latest row per campaign"),
    (G + "CAMPAIGN_HISTORY", "advertising_channel_type", "campaign_type", "latest row per campaign"),
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "conversion_action_name", "conversion_tag_name", ""),
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "conversions", "conversions", ""),
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "all_conversions", "all_conversions", ""),
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "conversions_value", "conversion_value", ""),
    (G + "CAMPAIGN_CONVERSION_ACTION_STATS", "view_through_conversions", "view_through_conversions", ""),
])

# ------------------------------------------------------------------ Fivetran: Facebook Ads (Meta)
F = "BRONZE.FIVETRAN_FACEBOOK_ADS."
ad_source("Facebook Ads", "Fivetran", ACC, "STG_FACEBOOK_ADS", [
    (F + "BASIC_AD", "date", "date", "activity_date", "cast to date"),
    ("constant", "'Facebook Ads'", "", "source_name", "set in staging"),
    ("constant", "'Meta'", "", "platform", "set in staging"),
    (F + "BASIC_AD", "account_id", "account_id", "account_id", "cast to text"),
    (F + "ACCOUNT_HISTORY", "currency", "currency", "account_currency", "latest row per account (_fivetran_synced)"),
    (F + "AD_HISTORY", "campaign_id", "campaign_id", "campaign_id", "latest row per ad (updated_time)"),
    (F + "CAMPAIGN_HISTORY", "name", "name", "campaign_name", "latest row per campaign"),
    (F + "AD_HISTORY", "ad_set_id", "ad_set_id", "media_buy_id", "latest row per ad"),
    (F + "AD_SET_HISTORY", "name", "name", "media_buy_name", "latest row per ad set"),
    (F + "BASIC_AD", "ad_id", "ad_id", "creative_id", "cast to text"),
    (F + "AD_HISTORY", "name", "name", "creative_name", "latest row per ad"),
    (F + "BASIC_AD", "impressions", "impressions", "impressions", ""),
    (F + "BASIC_AD", "inline_link_clicks", "inline_link_clicks", "clicks", "link clicks, as TapClicks showed"),
    (F + "BASIC_AD", "spend", "spend", "spend", ""),
    (F + "BASIC_AD_VIDEO_ACTIONS", "value (action_type video_view)", "value", "video_starts", "video ads only (creative object_type VIDEO or a video id), K06"),
    (F + "BASIC_AD_VIDEO_ACTIONS", "value (action_type video_p100_watched_actions)", "value", "completed_plays", "video ads only, K06"),
    (F + "BASIC_AD_ACTIONS", "value (action_type post)", "value", "post_shares", "sum per ad and day"),
])
conv_source("Facebook Ads", ACC, "STG_FACEBOOK_ADS_CONVERSIONS", [
    (F + "BASIC_AD_ACTIONS", "date", "activity_date", "cast to date"),
    (F + "BASIC_AD", "account_id", "account_id", "joined on ad and day"),
    (F + "CAMPAIGN_HISTORY", "name", "campaign_name", "latest row per campaign"),
    (F + "BASIC_AD_ACTIONS", "action_type", "conversion_tag_name", "every action type; MAP_CONVERSION_TAG decides which count"),
    (F + "BASIC_AD_ACTIONS", "value", "conversions", "also all_conversions"),
    (F + "BASIC_AD_ACTIONS", "_1_d_view", "view_through_conversions", "null as 0"),
])
add("Facebook Ads", "Fivetran", ACC, F + "BASIC_AD", "reach", F + "BASIC_AD", "reach", "SILVER.STG.STG_FACEBOOK_REACH", "reach",
    ("FCT_REACH_FREQUENCY", "reach", "reach", "number", "never summed across platforms or periods (K09 open); frequency = impressions / reach"))

# ------------------------------------------------------------------ Fivetran: Microsoft Advertising
M = "BRONZE.FIVETRAN_MICROSOFT_ADS.AD_PERFORMANCE_DAILY_REPORT"
ad_source("Microsoft Advertising", "Fivetran", ACC, "STG_MICROSOFT_ADS", [
    (M, "date", "date", "activity_date", "cast to date"),
    ("constant", "'Microsoft Advertising'", "", "source_name", "set in staging"),
    ("constant", "'Microsoft Ads'", "", "platform", "set in staging"),
    (M, "account_id", "account_id", "account_id", "cast to text"),
    (M, "currency_code", "currency_code", "account_currency", ""),
    (M, "campaign_id", "campaign_id", "campaign_id", ""),
    (M, "campaign_name", "campaign_name", "campaign_name", ""),
    (M, "ad_group_id", "ad_group_id", "media_buy_id", ""),
    (M, "ad_group_name", "ad_group_name", "media_buy_name", ""),
    (M, "ad_id", "ad_id", "creative_id", ""),
    (M, "ad_title", "ad_title", "creative_name", "ad id when the ad has no title"),
    (M, "impressions", "impressions", "impressions", ""),
    (M, "clicks", "clicks", "clicks", ""),
    (M, "spend", "spend", "spend", ""),
])

# ------------------------------------------------------------------ Fivetran: GA4
GA = "BRONZE.FIVETRAN_GA4.TRAFFIC_ACQUISITION_SESSION_SOURCE_MEDIUM_REPORT"
for f, s, g, rule in (("date", "activity_date", "date_key", "cast to date; YYYYMMDD key"),
                      ("property", "property_id", "client_code", "MCI rank 10: GA4 property in MAP_PLATFORM_ACCOUNT (platform GA4); GA4 Test property excluded (Q22)"),
                      ("session_source", "ga4_session_source", "ga4_session_source", ""),
                      ("session_medium", "ga4_session_medium", "ga4_session_medium", ""),
                      ("session_campaign_name", "ga4_session_campaign", "ga4_session_campaign", ""),
                      ("session_manual_ad_content", "ga4_manual_ad_content", "ga4_manual_ad_content", ""),
                      ("sessions", "sessions", "sessions", "sum (K11)")):
    add("Google Analytics 4", "Fivetran", "MCI rank 10 GA4 property", GA, f, GA, f, "SILVER.STG.STG_GA4_SESSIONS", s,
        ("FCT_WEB_SESSIONS_DAILY", g, g if g != "date_key" else "date_day", "", ""), rule=rule)

# ------------------------------------------------------------------ TapClicks history (H01)
T = "BRONZE.TAPCLICKS.TAPCLICKS_HISTORY"
TC = "MCI rank 40 to 60 on the campaign name (TapClicks rows carry no ad account)"
for f, b, s, rule in (("Date", "activity_date_text", "activity_date", "text kept in Bronze; parsed as MON DD YYYY or YYYY-MM-DD"),
                      ("Data Source Name", "data_source_name", "source_name", "trimmed; decides the cut-over date (CTL_CUTOVER)"),
                      ("Campaign Name", "campaign_name", "campaign_name", "trimmed"),
                      ("Media Buy Name", "media_buy_name", "media_buy_name", "blank as null"),
                      ("Creative Name", "creative_name", "creative_name", "blank as null"),
                      ("Impressions", "impressions", "impressions", "commas removed; text to number; blank as 0"),
                      ("Clicks", "clicks", "clicks", "commas removed"),
                      ("Spend", "spend", "spend", "commas and $ removed; already in the reporting currency, never converted again"),
                      ("Starts", "starts", "video_starts", "commas removed"),
                      ("Completed Plays", "completed_plays", "completed_plays", "commas removed")):
    add("TapClicks history", "SharePoint History folder (COPY INTO)", TC, "Data_Table_Export.csv", f, T, b,
        "SILVER.STG.STG_TAPCLICKS_HISTORY > INT_AD_DELIVERY", s, AD_GOLD.get(s),
        rule=rule + "; delivery rows only (no conversion tag); latest download per source and month; days before the source's cut-over")
for f, b, s, rule in (("Conversion Tag Name", "conversion_tag_name", "conversion_tag_name", "rows with a tag go to INT_CONVERSIONS"),
                      ("Total Conversions", "total_conversions", "conversions", "commas removed")):
    add("TapClicks history", "SharePoint History folder (COPY INTO)", TC, "Data_Table_Export.csv", f, T, b,
        "SILVER.STG.STG_TAPCLICKS_HISTORY > INT_CONVERSIONS", s, CONV_GOLD.get(s), rule=rule)
add("TapClicks history", "SharePoint History folder (COPY INTO)", TC, "Data_Table_Export.csv", "CPM, CTR, CPC and other rates", T,
    "not loaded", "", "", None, typ="", rule="rates are never loaded; every rate is recalculated from totals (K02)")

# ------------------------------------------------------------------ SharePoint vendor delivery files
SHARED = "MCI rank 50: client name or short name as a whole word in the campaign (vendor files are shared)"


def vendor(source, feed, table, client_from, fields, where=""):
    for src_field, silver_field, rule in fields:
        bo, bf = sp(table, src_field)
        add(f"{source} ({feed})", "SharePoint loader", client_from, f"SharePoint file, feed {feed}{where}", src_field, bo,
            bf if src_field != "-" else "", "SILVER.STG.STG_VENDOR_DELIVERY > INT_AD_DELIVERY", silver_field,
            AD_GOLD.get(silver_field), rule=rule)


COMMON = "newest file per feed and day wins; latest version of each file"
vendor("Silverpush Automated Report", "F09", "SILVERPUSH", SHARED, [
    ("date", "activity_date", "dates in any of 9 formats (MM/DD/YY checked first); " + COMMON),
    ("advertiser", "campaign_name", "text; US_ prefix = USD buy"),
    ("line_item", "media_buy_name", ""), ("line_item_id", "media_buy_id", ""),
    ("impressions", "impressions", "commas, $ and % removed"), ("clicks", "clicks", ""),
    ("-", "spend", "no spend in the file: 0, flagged spend_missing"),
    ("starts_video", "video_starts", ""), ("complete_views_video", "completed_plays", "")])
vendor("Silverpush CTV", "F10", "SILVERPUSH", SHARED, [
    ("date", "activity_date", COMMON), ("advertiser", "campaign_name", ""), ("creative", "creative_name", ""),
    ("impressions", "impressions", ""), ("player_starts", "video_starts", ""), ("player_completed_views", "completed_plays", "")])
vendor("HiveStack", "F11", "HIVESTACK", SHARED, [
    ("date", "activity_date", COMMON), ("campaign", "campaign_name", ""), ("line_item", "media_buy_name", ""),
    ("creative", "creative_name", ""), ("impressions", "impressions", ""), ("spend", "spend", ""), ("plays", "spots", "DOOH plays")])
vendor("Netflix Pause Ads", "F12", "NETFLIX_PAUSE_ADS", SHARED, [
    ("date", "activity_date", COMMON), ("line_item", "campaign_name", "also the media buy name"),
    ("creative", "creative_name", ""), ("ad_server_impressions", "impressions", ""), ("ad_server_clicks", "clicks", ""),
    ("ad_server_cpm_and_cpc_revenue", "spend", "")])
vendor("Jolt Media", "F13", "JOLT_MEDIA", SHARED, [
    ("day", "activity_date", COMMON), ("order_name", "campaign_name", ""), ("venue_name", "media_buy_name", ""),
    ("venue_id", "media_buy_id", ""), ("creative", "creative_name", ""), ("impressions", "impressions", ""),
    ("spots", "spots", ""), ("-", "spend", "no spend in the file: 0, flagged spend_missing")])
FEED = "MCI rank 20: single-client feed ({})"
vendor("Spotify Cobs Bread", "F15", "SPOTIFY_FILES", FEED.format("Cobs Bread"), [
    ("date", "activity_date", COMMON), ("campaign_name", "campaign_name", "US_ prefix = USD"),
    ("ad_set_name", "media_buy_name", ""), ("ad_set_id", "media_buy_id", ""), ("impressions", "impressions", ""),
    ("clicks", "clicks", ""), ("spend", "spend", "")])
vendor("Sonnet Direct Buy Offline Spend", "F02", "DIRECT_BUY_SPEND", FEED.format("Sonnet Insurance"), [
    ("date", "activity_date", COMMON), ("channel", "campaign_name", "'Sonnet Direct Buy ' + channel"),
    ("province", "media_buy_name", ""), ("grouped_spend", "spend", "spend column when grouped_spend is absent")])
vendor("Sonnet DV360 Creative", "F03", "SONNET_DV360_CREATIVE", FEED.format("Sonnet Insurance"), [
    ("date", "activity_date", COMMON), ("insertion_order", "campaign_name", ""), ("line_item", "media_buy_name", ""),
    ("line_item_id", "media_buy_id", ""), ("youtube_ad", "creative_name", ""), ("impressions", "impressions", ""),
    ("clicks", "clicks", ""), ("media_cost_advertiser_currency", "spend", ""), ("complete_views_video", "completed_plays", ""),
    ("advertiser_currency", "account_currency", "")])
vendor("WildBrain", "F19", "WILDBRAIN", SHARED, [
    ("date", "activity_date", COMMON + "; no sample file yet"), ("campaign_name", "campaign_name", "or campaign"),
    ("line_item", "media_buy_name", ""), ("creative_name", "creative_name", "or creative"), ("impressions", "impressions", ""),
    ("clicks", "clicks", ""), ("spend", "spend", ""), ("starts", "video_starts", ""), ("completed_plays", "completed_plays", "")])

# ------------------------------------------------------------------ Sonnet outcome files (K20, K22)
SON = FEED.format("Sonnet Insurance")


def outcome(source, feed, table, client_from, silver, gold_obj, fields):
    for src_field, silver_field, gold_field, typ, rule in fields:
        bo, bf = sp(table, src_field)
        add(f"{source} ({feed})", "SharePoint loader", client_from, f"SharePoint file, feed {feed}", src_field, bo,
            bf if src_field != "-" else "", f"SILVER.STG.{silver}", silver_field,
            (gold_obj, gold_field, gold_field if gold_field not in ("date_key",) else "date_day", typ, "") if gold_field else None,
            typ=typ, rule=rule)


outcome("Sonnet Raw Data", "F01a", "SONNET_RAW_DATA", SON, "STG_SONNET_QUOTES", "FCT_SONNET_QUOTES_DAILY", [
    ("quote_date", "activity_date", "date_key", "date", "newest file per file type and day"),
    ("pol_province_cd", "province", "province", "varchar", ""), ("product", "product", "product", "varchar", ""),
    ("lob", "lob", "", "varchar", "kept in Silver"), ("channel_grouping", "channel", "channel", "varchar", ""),
    ("utm_source", "utm_source", "utm_source", "varchar", ""),
    ("quotes", "quotes", "quotes", "number", "source of truth for Quotes (K22); can be fractional"),
    ("binds", "binds", "binds", "number", "source of truth for Binds (K22)")])
outcome("Sonnet Quote Quality Data", "F01b", "SONNET_QUOTE_QUALITY", SON, "STG_SONNET_QUOTES", "FCT_SONNET_QUOTES_DAILY", [
    ("quote_date", "activity_date", "date_key", "date", ""), ("pol_province_cd", "province", "province", "varchar", ""),
    ("channel_grouping", "channel", "channel", "varchar", ""), ("utm_source", "utm_source", "utm_source", "varchar", ""),
    ("pvm", "segment", "quality_band", "varchar", "red to Red; Red, Yellow or Green (DQ_SONNET_FILES)"),
    ("quotes", "quotes", "quality_quotes", "number", "own column; never added to quotes (totals differ from Raw Data)")])
outcome("Sonnet Group Breakdown Data", "F01c", "SONNET_GROUP_BREAKDOWN", SON, "STG_SONNET_QUOTES", "FCT_SONNET_QUOTES_DAILY", [
    ("quote_date", "activity_date", "date_key", "date", ""), ("pol_province_cd", "province", "province", "varchar", ""),
    ("utm_source", "utm_source", "utm_source", "varchar", ""), ("segment", "segment", "segment", "varchar", ""),
    ("quotes", "quotes", "segment_quotes", "number", "own column; never added to quotes")])
outcome("Sonnet Multiline Data", "F01d", "SONNET_MULTILINE", SON, "STG_SONNET_QUOTES", "FCT_SONNET_QUOTES_DAILY", [
    ("month", "activity_date", "date_key", "date", "first day of the month (monthly file)"),
    ("pol_province_cd", "province", "province", "varchar", ""), ("channel", "channel", "channel", "varchar", ""),
    ("utm_source", "utm_source", "utm_source", "varchar", ""),
    ("multiline_customer", "quotes (segment Multiline)", "customers", "number", "line_type Multiline (K20)"),
    ("customer_count", "quotes (segment Monoline)", "customers", "number", "customer_count minus multiline_customer; line_type Monoline")])
AUC = [("week | month | date", "period_start", "period_start", "date", "week or month start, by feed grain"),
       ("account_name", "account_name", "account_name", "varchar", ""), ("customer_id", "customer_id", "customer_id", "varchar", ""),
       ("display_url_domain", "competitor_domain", "competitor_domain", "varchar", "'You' = Sonnet"),
       ("campaign | campaign_name", "campaign_name", "campaign_name", "varchar", ""),
       ("search_impr_share | search_impr_share_auction_insights", "search_impr_share", "search_impr_share", "number",
        "'< 10%' and '> 90%' kept as reported text in *_reported; number left empty for those rows"),
       ("click_share", "click_share", "click_share", "number", "as above"),
       ("impr_abs_top", "impr_abs_top_pct", "impr_abs_top_pct", "number", "as above"),
       ("search_lost_is_budget", "search_lost_is_budget", "search_lost_is_budget", "number", "as above"),
       ("search_lost_is_rank", "search_lost_is_rank", "search_lost_is_rank", "number", "as above")]
for feed, table in (("F05a/F05b", "SONNET_AUCTION_PRESSURE"), ("F05c/F05d", "SONNET_VISIBILITY"), ("F05e/F05f", "SONNET_VS_COMPETITION")):
    outcome(f"Sonnet Auction Insights", feed, table, SON, "STG_SONNET_AUCTION", "FCT_AUCTION_INSIGHTS",
            [a for a in AUC if not (table != "SONNET_VS_COMPETITION" and a[0] == "display_url_domain")])
outcome("Amazon DSP Sonnet Reach and Frequency", "F06", "AMAZON_DSP_REACH", SON, "STG_AMAZON_DSP_REACH", "", [
    ("date", "activity_date", "", "date", "newest file per day"), ("campaign_id", "campaign_id", "", "varchar", ""),
    ("campaign_name", "campaign_name", "", "varchar", ""), ("ad_group_id", "ad_group_id", "", "varchar", ""),
    ("ad_group_name", "ad_group_name", "", "varchar", ""),
    ("user_reach", "reach", "", "number", "kept in Silver until K09 decides how reach is shown; never summed with delivery"),
    ("average_user_impression_frequency", "frequency", "", "number", "as above")])

# ------------------------------------------------------------------ SiriusXM (Adobe, Scorecard)
SXM = FEED.format("SiriusXM")
SXM_COMMON = [("date | day", "activity_date", "date_key", "date", "newest file per report and day (Adobe repeats 30 days)"),
              ("utm_medium_v27_evar27", "channel", "channel", "varchar", "first value when Adobe repeats it"),
              ("online_campaign_code_v70_evar70 | program_code_v98_evar98 | segment", "campaign_name", "campaign_name", "varchar", "first value"),
              ("utm_source_v26_evar26", "utm_source", "", "varchar", "kept in Silver")]
outcome("SXM Commuter Activations", "F07a", "SXM_ADOBE", SXM, "STG_SXM", "FCT_SXM_SCORECARD",
        SXM_COMMON + [("visits", "commuter_activations", "commuter_activations", "number", "report commuter_activations")])
outcome("SXM Commuter Starts", "F07b", "SXM_ADOBE", SXM, "STG_SXM", "FCT_SXM_SCORECARD",
        SXM_COMMON[:3] + [("visits", "commuter_starts", "commuter_starts", "number", "report commuter_starts")])
for feed, name in (("F07c", "SXM Dual Offer Streaming"), ("F07d", "SXM Streaming Starts")):
    outcome(name, feed, "SXM_ADOBE", SXM, "STG_SXM", "FCT_SXM_SCORECARD", SXM_COMMON[:3] + [
        ("visits", "performance_flow_starts", "performance_flow_starts", "number", "Visits = performance flow starts"),
        ("orders", "performance_trials", "performance_trials", "number", "Orders = performance trials")])
outcome("SXM Organic Streaming", "F07e", "SXM_ADOBE", SXM, "STG_SXM", "FCT_SXM_SCORECARD", [
    ("day", "activity_date", "date_key", "date", "headers set in feeds.yml (the header row holds a total)"),
    ("segment", "campaign_name", "campaign_name", "varchar", ""),
    ("starts", "organic_flow_starts", "organic_flow_starts", "number", ""), ("trials", "organic_trials", "organic_trials", "number", "")])
outcome("SiriusXM Scorecard", "F08", "SXM_SCORECARD", SXM, "STG_SXM", "FCT_SXM_SCORECARD", [
    ("activation_date", "activity_date", "date_key", "date", "newest file per day"),
    ("plan_description", "channel", "channel", "varchar", ""), ("promo_code", "campaign_name", "campaign_name", "varchar", ""),
    ("total_trial_starts", "scorecard_trials", "scorecard_trials", "number", "")])

# ------------------------------------------------------------------ Adara (Ottawa Tourism, K13)
outcome("Adara Ottawa Tourism", "F14", "ADARA", FEED.format("Ottawa Tourism"), "STG_ADARA", "FCT_ADARA_DAILY", [
    ("date", "activity_date", "date_key", "date", "newest file per day"),
    ("attribution_group_name", "campaign_name", "campaign_name", "varchar", ""),
    ("tracker_name", "tracker_name", "tracker_name", "varchar", ""), ("attribution_type", "attribution_type", "attribution_type", "varchar", "cl or imp"),
    ("site_visits", "site_visits", "site_visits", "number", ""), ("flight_searches", "flight_searches", "flight_searches", "number", ""),
    ("flight_bookings", "flight_bookings", "flight_bookings", "number", ""), ("hotel_searches", "hotel_searches", "hotel_searches", "number", ""),
    ("hotel_bookings", "hotel_bookings", "hotel_bookings", "number", ""),
    ("uniques_reached", "uniques_reached", "uniques_reached", "number", "max, never summed"),
    ("impressions_clicks", "impressions_per_clicks", "impressions_per_clicks", "number", "max"),
    ("enriched_flight_searches + enriched_hotel_searches", "travel_search_signals", "travel_search_signals", "number", "K13"),
    ("enriched_flight_bookings + enriched_hotel_bookings", "attributed_books", "attributed_books", "number", "K13")])

# ------------------------------------------------------------------ Goals (K12)
outcome("Goals", "F16", "GOALS", "MCI rank 40 or 50: the client named at the start of the goal line", "STG_GOALS", "FCT_GOALS", [
    ("date", "period_month", "period_month", "date", "daily goals summed to the month"),
    ("campaign_name (part 1)", "client", "client_code", "varchar", "text before the first ' - ', found in the MCI"),
    ("campaign_name (part 2)", "smart_campaign", "smart_campaign", "varchar", ""),
    ("campaign_name (part 3, first word)", "platform", "platform", "varchar", ""),
    ("campaign_name (part 3)", "goal_metric", "goal_metric", "varchar", "impression, click, spend, quote, trial or CPQ goal"),
    ("impressions_goal | goal", "goal_value", "goal_value", "number", "shown beside actuals, never added to them")])

# ------------------------------------------------------------------ Exchange rates
for f, b, s, g, rule in (("FXUSDCAD observation date", "rate_date", "date_day", "date_day", "every day carries the last rate on or before it (weekends, holidays)"),
                         ("FXUSDCAD value", "rate", "rate", "rate", "USD to CAD; applied to live USD spend for accounts marked convert_to CAD (Q20)")):
    add("Bank of Canada Valet", "Exchange-rate loader (daily)", "not client data", "Valet API series FXUSDCAD", f,
        "BRONZE.REFERENCE.FX_RATES", b, "GOLD.MARTS.DIM_FX_RATE", s, ("DIM_FX_RATE", g, "", "number(18,6)", ""), rule=rule)


def main():
    for i, r in enumerate(ROWS, start=1):
        r["map_id"] = f"M{i:03d}"
    with open(OUT, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=COLS)
        w.writeheader()
        w.writerows(ROWS)
    print(f"{len(ROWS)} mapping rows, {len({r['source'] for r in ROWS})} sources -> {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
