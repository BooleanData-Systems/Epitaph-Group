"""The generated Omni model: it parses, carries every KPI, protects every restricted column and filters every client."""
import csv
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import omni_build  # noqa: E402
import omni_deploy  # noqa: E402

omni_build.write_model()
FILES = omni_deploy.load()
VIEW = FILES["media_performance_daily.view.yaml"][1]
TOPIC = FILES["media_performance.topic.yaml"][1]
MODEL = FILES["model.yaml"][1]
KPIS = yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]


def test_every_file_parses():
    assert set(FILES) == {"model.yaml", "media_performance_daily.view.yaml", "media_performance.topic.yaml",
                          "data_checks.view.yaml", "data_checks.topic.yaml"}
    assert all(isinstance(obj, dict) and obj for _, obj in FILES.values())


def test_every_computable_kpi_is_a_measure():
    labels = {m.get("label") for m in VIEW["measures"].values() if not m.get("hidden")}
    computable = [k["name"] for k in KPIS if "expr" in k]
    assert len(computable) == 77
    assert set(computable) <= labels


def test_no_reference_is_broken():
    assert omni_deploy.check(FILES) == []


def test_every_restricted_column_needs_its_grant():
    groups_of, _ = omni_build.column_groups()
    for name, d in VIEW["dimensions"].items():
        if name in groups_of and groups_of[name] != "identity":
            assert f"cg_{groups_of[name]}" in d.get("required_access_grants", []), name
    spend_kpis = [m for m in VIEW["measures"].values() if "total_spend}" in str(m.get("sql", ""))]
    assert spend_kpis and all("cg_spend" in m["required_access_grants"] for m in spend_kpis)
    internal = {g["column_group"]: g for g in csv.DictReader(open(ROOT / "seeds" / "column_groups.csv"))}["internal"]
    assert "source_name" in internal["columns"] and VIEW["dimensions"]["source_name"]["required_access_grants"] == ["cg_internal"]


def test_rows_are_filtered_to_the_viewer_client():
    want = {"field": "media_performance_daily.client_code", "user_attribute": "client_code", "values_for_unfiltered": ["ALL"]}
    assert want in TOPIC["access_filters"]
    assert want in MODEL["default_topic_access_filters"]
    assert FILES["data_checks.topic.yaml"][1]["required_access_grants"] == ["cg_internal"]


def test_filtered_kpis_keep_their_filter():
    tc = next(m for m in VIEW["measures"].values() if m.get("label") == "Total Conversions")
    assert tc["filters"] == {"counts_toward_kpi": {"is": True}}
    cpm = next(m for m in VIEW["measures"].values() if m.get("label") == "CPM")
    assert cpm["sql"] == "${media_performance_daily.total_spend} / NULLIF(${media_performance_daily.total_impressions}, 0) * 1000"


def test_sign_off_k12_cpq_goal_is_never_summed():
    g = next(m for m in VIEW["measures"].values() if m.get("label") == "CPQ Goal")
    assert g["aggregate_type"] == "average" and g["filters"] == {"goal_metric": {"is": "cpq"}}


def test_sign_off_k07_vcr_is_blank_when_platforms_are_blended():
    vcr = next(m for m in VIEW["measures"].values() if m.get("label") == "VCR")
    assert vcr["sql"].startswith("CASE WHEN ${media_performance_daily.platforms_in_view} = 1 THEN")
    assert VIEW["measures"]["platforms_in_view"]["aggregate_type"] == "count_distinct"


def test_sign_off_k17_label_is_hidden_not_dashed():
    spec = yaml.safe_load(open(ROOT / "specs" / "dashboards" / "D093_sonnet-insurance-2026.yml"))
    ws = [w for s in spec["sections"] for w in s["widgets"] if "Search Impr. share (Auction Insights)" in w["metrics"]]
    assert ws and not any(str(v).strip() == "-" for w in ws for v in (w.get("labels") or {}).values())


def test_cobs_bread_money_tiles_split_by_currency():
    spec = yaml.safe_load(open(ROOT / "specs" / "dashboards" / "D005_cobs-bread-evergreen.yml"))
    sheet = omni_build.build_sheet(spec, {})
    money_rows = [l for l in sheet.splitlines() if l.startswith("| [ ]") and (" Spend" in l or " CPM" in l or " CPC" in l or " CPA" in l)]
    assert money_rows and all("currency_code" in l.split("|")[5] for l in money_rows)
