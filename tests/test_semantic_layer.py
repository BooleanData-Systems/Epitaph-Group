"""The semantic layer and KPI definitions, run in DuckDB on made-up gold rows (no client data).

Uses the production view SQL and the production KPI expressions, so a change to either is tested here."""
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import semantic_harness as h  # noqa: E402


@pytest.fixture(scope="module")
def con():
    c = h.connect()
    c.execute("insert into DIM_SOURCE values ('s1', 'Google Ads'), ('s2', 'Facebook Ads')")
    c.execute("""insert into DIM_CAMPAIGN (campaign_key, campaign_name, client_code, smart_campaign) values
                 ('c1', 'Nulo_Brand_2026-001_En_US', 'C08', 'Nulo: Brand'),
                 ('c2', 'Sonnet_Search_2026-002_En_CA', 'C11', 'Sonnet: Search')""")
    c.execute("insert into DIM_MEDIA_BUY (media_buy_key, media_type, tactic) values ('m1', 'Search', 'PT'), ('m2', 'Social', 'RT')")
    c.execute("insert into DIM_CREATIVE (creative_key, creative_name) values ('r1', 'ad one')")
    # Two delivery rows with very different CPMs: 1,000 impressions for $1 and 9,000 impressions for $90
    c.execute("""insert into FCT_AD_DELIVERY_DAILY (date_key, source_key, campaign_key, media_buy_key, creative_key, media_type,
                 impressions, clicks, spend, video_starts, completed_plays, post_shares, spots) values
                 (20261001, 's1', 'c1', 'm1', 'r1', 'Search', 1000, 10, 1, 0, 0, 0, 0),
                 (20261001, 's2', 'c1', 'm2', 'r1', 'Social', 9000, 90, 90, 100, 25, 0, 0),
                 (20261001, 's1', 'c2', 'm1', 'r1', 'Search', 5000, 50, 200, 0, 0, 0, 0)""")
    # Conversion rows carry no spend; one tag counts, one does not; one is a lead
    c.execute("""insert into FCT_CONVERSIONS_DAILY (date_key, source_key, campaign_key, conversion_tag_name, kpi_group,
                 counts_toward_kpi, conversions, platform_conversions) values
                 (20261001, 's1', 'c1', 'purchase', 'order', true, 7, 7),
                 (20261001, 's1', 'c1', 'page view', 'landing_page_view', false, 50, 50),
                 (20261001, 's2', 'c1', 'lead form', 'lead', true, 3, 3)""")
    c.execute("""insert into FCT_SONNET_QUOTES_DAILY (date_key, client_code, quality_band, file_type, quotes, quality_quotes, binds, customers) values
                 (20261001, 'C11', null, 'raw_data', 40, 0, 10, 0),
                 (20261001, 'C11', 'Green', 'quote_quality', 0, 25, 0, 0),
                 (20261001, 'C11', 'Red', 'quote_quality', 0, 15, 0, 0)""")
    c.execute("""insert into FCT_SXM_SCORECARD (date_key, client_code, performance_trials, organic_trials, performance_flow_starts, organic_flow_starts)
                 values (20261001, 'C10', 30, 10, 100, 100)""")
    c.execute("insert into FCT_GOALS values ('2026-10-01', 'C08', 'Nulo: Brand', 'impressions', 50000)")
    return c


def test_rates_come_from_totals_not_averages(con):
    k = h.evaluate(con, "client_code = 'C08'")
    assert k["Impressions"] == 10000 and k["Spend"] == 91
    assert k["CPM"] == pytest.approx(9.1)            # 91 / 10,000 x 1,000; the average of row CPMs would be 5.5
    assert k["CTR"] == pytest.approx(0.01)


def test_conversion_rows_do_not_change_spend_and_cpa_counts_only_agreed_tags(con):
    k = h.evaluate(con, "client_code = 'C08'")
    assert k["Total Conversions"] == 10             # 7 + 3; the 50 page views do not count
    assert k["CPA"] == pytest.approx(9.1)            # 91 / 10
    assert k["Orders"] == 7 and k["Leads"] == 3 and k["LPV"] == 50
    assert k["Conversions"] == 60                    # platform-reported, every tag


def test_media_type_filter_keeps_outcome_rows(con):
    k = h.evaluate(con, "client_code = 'C08' and (media_type = 'Social' or row_type <> 'delivery')")
    assert k["Spend"] == 90 and k["Total Conversions"] == 10


def test_cross_fact_kpis(con):
    sonnet = h.evaluate(con, "client_code = 'C11'")
    assert sonnet["Quotes"] == 40                    # quality file never adds to quotes (K22)
    assert sonnet["CPQ"] == pytest.approx(5.0)       # 200 / 40
    assert sonnet["QTB"] == pytest.approx(0.25)
    assert sonnet["Green"] == 25 and sonnet["Red"] == 15
    sxm = h.evaluate(con, "client_code = 'C10'")
    assert sxm["Total Trials"] == 40
    assert sxm["Throughput Percentage"] == pytest.approx(0.2)


def test_goals_sit_beside_actuals(con):
    k = h.evaluate(con, "client_code = 'C08'")
    assert k["Impressions Goal"] == 50000 and k["Impressions"] == 10000


def test_zero_denominator_is_null_not_an_error(con):
    k = h.evaluate(con, "client_code = 'C08' and row_type = 'conversion'")
    assert k["CPM"] is None


def test_semantic_view_covers_every_summable_kpi(con):
    ready, other = h.coverage(con)
    as_reported = {x["name"] for x in h.kpis() if x["type"] == "as_reported"}
    assert set(other) <= as_reported, set(other) - as_reported


def test_delivery_filters_keep_outcome_rows():
    """A media type / tactic / creative filter must not drop conversions, quotes or trials (stacked view rule)."""
    import omni_build
    assert {"media_type", "tactic", "audience", "creative_name"} <= set(omni_build.DELIVERY_ONLY)
    assert not {"client_code", "smart_campaign", "campaign_name", "date_day"} & set(omni_build.DELIVERY_ONLY)
    spec = {"id": "DX", "title": "t", "client": "c", "build_type": "Custom", "priority": "High", "target_live_date": "",
            "sections": [{"name": "s", "rebuild": True, "widgets": [{"element": "kpi", "title": "x", "metrics": ["Spend"],
                          "tapclicks_widget_id": 1, "filters": [{"field": "media_type", "op": "in", "values": ["CTV"]}]}]}]}
    assert "filter_media_type in [CTV, All outcomes]" in omni_build.build_sheet(spec, {"Spend": "spend"})
