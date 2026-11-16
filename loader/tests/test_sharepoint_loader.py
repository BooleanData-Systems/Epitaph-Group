"""Tests for the SharePoint loader on synthetic files only. No client data is used or needed."""
import csv
import datetime as dt
import io
import sys
from pathlib import Path

import openpyxl
import pytest
import yaml

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "loader"))
import sharepoint_loader as sl  # noqa: E402

CONFIG = yaml.safe_load(open(ROOT / "config" / "feeds.yml"))
FEEDS = {f["id"]: f for f in CONFIG["feeds"]}
TODAY = dt.date(2026, 11, 2)


def csv_bytes(text):
    return text.encode("utf-8")


def xlsx_bytes(rows):
    wb = openpyxl.Workbook()
    ws = wb.active
    for r in rows:
        ws.append(r)
    b = io.BytesIO()
    wb.save(b)
    return b.getvalue()


# ---------- parsing

def test_headers_normalised_and_deduped():
    h, rows = sl.read_rows("a.csv", csv_bytes("﻿Date, Spend ($),Spend ($)\n2026-10-01,1,2\n"))
    assert h == ["date", "spend", "spend_2"]
    assert rows == [["2026-10-01", "1", "2"]]


def test_banner_lines_and_total_rows_skipped():
    text = "Report: Vendor X\n\nDate,Impressions\n2026-10-01,10\n2026-10-02,20\nTotal,30\n"
    h, rows = sl.read_rows("v.csv", csv_bytes(text))
    assert h == ["date", "impressions"]
    assert len(rows) == 2


def test_semicolon_delimiter():
    h, rows = sl.read_rows("v.csv", csv_bytes("Date;Impressions\n2026-10-01;10\n"))
    assert h == ["date", "impressions"] and rows[0][1] == "10"


def test_excel_first_sheet():
    content = xlsx_bytes([["Date", "Quotes"], [dt.datetime(2026, 10, 1), 5], [dt.datetime(2026, 10, 2), 7]])
    h, rows = sl.read_rows("Sonnet Raw Data.xlsx", content)
    assert h == ["date", "quotes"] and len(rows) == 2


@pytest.mark.parametrize("value,expected", [
    ("2026-10-14", dt.date(2026, 10, 14)), ("10/14/2026", dt.date(2026, 10, 14)), ("Oct 14 2026", dt.date(2026, 10, 14)),
    ("46309", dt.date(2026, 10, 14)), ("2026-10-14T00:00:00", dt.date(2026, 10, 14)), ("", None), ("n/a", None),
    # formats seen in the real exports: Sonnet emails, Adobe, Google Ads, Jolt, Silverpush, Amazon DSP
    ("Oct 1, 2026", dt.date(2026, 10, 1)), ("October 3, 2026", dt.date(2026, 10, 3)), ("Nov 01, 2026", dt.date(2026, 11, 1)),
    ("9/28/26", dt.date(2026, 9, 28)), ("10/01/26", dt.date(2026, 10, 1)), ("2026/11/01", dt.date(2026, 11, 1)),
    ("2026-09-01 00:00:00", dt.date(2026, 9, 1)),
])
def test_parse_date(value, expected):
    assert sl.parse_date(value) == expected


# ---------- checks

def test_valid_file_passes():
    res = sl.check_file(FEEDS["F01a"], "Sonnet Raw Data 2026-10-21.csv", csv_bytes("Quote Date,Channel Grouping,Product,LOB,Pol Province Cd,utm_source,Quotes,Binds,Q2B\n\"Oct 20, 2026\",Direct,Auto,X,ON,null,4,1,0.25\n\"Oct 21, 2026\",Direct,Auto,X,ON,null,6,0.5,0.08\n"), today=TODAY)
    assert res.ok and len(res.rows) == 2 and res.max_date == dt.date(2026, 10, 21)


def test_missing_required_column_rejected():
    res = sl.check_file(FEEDS["F01a"], "raw data.csv", csv_bytes("Quote Date,Leads,Binds\n2026-10-20,4,1\n"), today=TODAY)
    assert not res.ok and "quotes" in res.reason


def test_unreadable_dates_rejected():
    body = "Quote Date,Quotes,Binds\n" + "\n".join("someday,1,0" for _ in range(10))
    res = sl.check_file(FEEDS["F01a"], "raw data.csv", csv_bytes(body), today=TODAY)
    assert not res.ok and "readable date" in res.reason


def test_wrong_file_name_rejected():
    res = sl.check_file(FEEDS["F01a"], "holiday photo.csv", csv_bytes("Quote Date,Quotes,Binds\n2026-10-20,4,1\n"), today=TODAY)
    assert not res.ok and "does not match" in res.reason


def test_empty_file_rejected():
    res = sl.check_file(FEEDS["F11"], "hivestack.csv", csv_bytes("Date,Campaign,Impressions\n"), today=TODAY)
    assert not res.ok and "no data rows" in res.reason


def test_far_future_dates_rejected_except_goals():
    far = "Date,Campaign,Impressions\n2028-06-01,c,10\n"
    assert not sl.check_file(FEEDS["F11"], "h.csv", csv_bytes(far), today=TODAY).ok
    goals = 'Date,Campaign Name,Impressions Goal\n6/01/28,Client A - Camp - Meta Impression Goal,"1,000.50"\n'
    assert sl.check_file(FEEDS["F16"], "goals.csv", csv_bytes(goals), today=TODAY).ok


# ---------- file shapes seen in the real exports (synthetic values only)

def test_every_live_feed_names_its_date_column_in_required():
    for f in CONFIG["feeds"]:
        if f.get("mode") == "stage":
            continue
        assert sl.norm_header(f["date_column"]["name"]) in [sl.norm_header(c) for c in f["required"]], f["id"]


def test_dv360_no_data_report_loads_empty():
    rows = [["Date", "Insertion Order", "Line Item", "Impressions"], ["", "", "", ""],
            ["No data returned by the reporting service.", "", "", ""], ["Report Time:", "2026/11/02 08:42 GMT", "", ""],
            ["Group By:", "Date", "", ""], ["Filter by Partner ID:", "Partner (1)", "", ""]]
    res = sl.check_file(FEEDS["F03"], "Sonnet - DV360 Creative.xlsx", xlsx_bytes(rows), today=TODAY)
    assert res.ok and res.rows == [] and "no data" in res.reason


def test_dv360_footer_is_not_data():
    rows = [["Date", "Insertion Order", "Line Item", "Impressions"], ["2026/11/01", "IO", "LI", 10],
            ["", "", "", ""], ["Report Time:", "2026/11/02 08:42 GMT", "", ""], ["Date Range:", "2026/11/01 to 2026/11/01", "", ""]]
    res = sl.check_file(FEEDS["F03"], "Sonnet - DV360 Creative.xlsx", xlsx_bytes(rows), today=TODAY)
    assert res.ok and len(res.rows) == 1


def test_unlabelled_totals_row_dropped():
    rows = [["Date", "Advertiser", "Impressions", "Starts (Video)"], ["2026/11/01", "Adv_A", 10, 9], ["2026/11/01", "Adv_B", 5, 4],
            ["", "", 15, 13]]
    res = sl.check_file(FEEDS["F09"], "Silverpush - Automated Report.xlsx", xlsx_bytes(rows), today=TODAY)
    assert res.ok and len(res.rows) == 2


def test_excel_text_guard_on_ids_removed():
    text = 'Date,Campaign ID,Campaign Name,User Reach\n"Nov 01, 2026",="1234567890123",Camp,100\n'
    res = sl.check_file(FEEDS["F06"], "Amazon DSP - Reach.csv", csv_bytes(text), today=TODAY)
    assert res.ok and res.rows[0]["campaign_id"] == "1234567890123"


def test_adobe_organic_header_override():
    text = "Segment X,Day,Starts,123\nSegment X,\"November 1, 2026\",4,2\n"
    res = sl.check_file(FEEDS["F07e"], "Adobe Organic - Streaming.csv", csv_bytes(text), today=TODAY)
    assert res.ok and res.rows[0]["day"] == "November 1, 2026" and res.rows[0]["trials"] == "2"


def test_google_ads_bounded_shares_load_as_text():
    text = "Account name,Customer ID,Month,Search impr. share,Click share,Impr. (Abs. Top) %\nRegion,000-000-0000,10/01/26,< 10%,> 90%,0\n"
    res = sl.check_file(FEEDS["F05d"], "Visibility - Monthly.csv", csv_bytes(text), today=TODAY)
    assert res.ok and res.rows[0]["search_impr_share"] == "< 10%" and res.min_date == dt.date(2026, 10, 1)


def test_tapclicks_history_file():
    text = ('Date,"Data Source Name","Campaign Name","Media Buy Name","Creative Name","Conversion Tag Name",Impressions,Clicks,'
            'Spend,Starts,"Completed Plays","Total Conversions",CPM,CTR,CPC,CPCV\n'
            '"Oct 14 2026","Facebook Ads","C01_Camp A_2026-001_En_CA","mb","cr",,100,2,1.50,0,0,0,15.00,2.00%,0.75,\n')
    res = sl.check_file(FEEDS["H01"], "facebook_ads_2026-10.csv", csv_bytes(text), today=TODAY)
    assert res.ok and res.rows[0]["date"] == "Oct 14 2026" and res.rows[0]["spend"] == "1.50"


def test_feed_for_picks_deepest_folder():
    f = sl.feed_for("Sonnet/Auction/Visibility Weekly/x.csv", CONFIG["feeds"])
    assert f["id"] == "F05c"


# ---------- run: loads once per version, rejects bad files, emails the owner

class FakeGraph:
    def __init__(self, files):
        self.files = files          # folder -> list of (item, content)
        self.moved = []

    def list_files(self, folder):
        return [i for i, _ in self.files.get(folder, [])]

    def download(self, item_id):
        for items in self.files.values():
            for i, c in items:
                if i["id"] == item_id:
                    return c
        raise KeyError(item_id)

    def move(self, item_id, folder, new_name):
        self.moved.append((item_id, folder, new_name))


class MemStore:
    def __init__(self):
        self.tables, self.logs = {}, []

    def already_loaded(self, item_id, etag):
        return any(l["item_id"] == item_id and l["etag"] == etag and l["status"] == "loaded" for l in self.logs)

    def write_rows(self, table, rows, meta):
        self.tables.setdefault(table, []).extend(rows)
        return len(rows)

    def stage_file(self, stage, name, content, rows):
        self.tables.setdefault(stage, []).append(name)
        self.staged = getattr(self, "staged", {})
        self.staged[name] = content
        return rows

    def log(self, entry):
        self.logs.append(entry)


class MemNotifier:
    def __init__(self):
        self.sent = []

    def send(self, owner, subject, body):
        self.sent.append((owner, subject))


def item(i, name, folder, etag="v1"):
    return {"id": i, "name": name, "path": f"{folder}/{name}", "etag": etag, "size": 10, "modified": "2026-10-21T10:00:00Z"}


def test_run_loads_skips_and_rejects():
    good = csv_bytes("Quote Date,Quotes,Binds\n\"Oct 20, 2026\",4,1\n")
    bad = csv_bytes("Quote Date,Leads\n2026-10-20,4\n")
    g = FakeGraph({"Sonnet/Raw Data": [(item("1", "raw data a.csv", "Sonnet/Raw Data"), good),
                                       (item("2", "raw data b.csv", "Sonnet/Raw Data"), bad)]})
    store, note = MemStore(), MemNotifier()
    s1 = sl.run(g, store, note, CONFIG, feed_id="F01a", today=TODAY)
    assert s1 == {"loaded": 1, "rows": 1, "rejected": 1, "skipped": 0}
    assert g.moved[0][1].startswith("Rejected/Sonnet/Raw Data")
    assert note.sent and note.sent[0][0] == "sonnet_files"
    # Second run: the loaded file is skipped; nothing new written.
    g.files["Sonnet/Raw Data"] = g.files["Sonnet/Raw Data"][:1]
    s2 = sl.run(g, store, note, CONFIG, feed_id="F01a", today=TODAY)
    assert s2["skipped"] == 1 and s2["loaded"] == 0
    # A new version of the same file loads again.
    g.files["Sonnet/Raw Data"] = [(item("1", "raw data a.csv", "Sonnet/Raw Data", etag="v2"), good)]
    s3 = sl.run(g, store, note, CONFIG, feed_id="F01a", today=TODAY)
    assert s3["loaded"] == 1 and len(store.tables["SONNET_RAW_DATA"]) == 2


def test_history_files_go_to_stage():
    text = ('Date,"Data Source Name","Campaign Name","Media Buy Name","Creative Name","Conversion Tag Name",Impressions,Clicks,'
            'Spend,Starts,"Completed Plays","Total Conversions"\n"Oct 14 2026","Google Ads","c","m","cr",,10,1,2.00,0,0,0\n')
    g = FakeGraph({"History/TapClicks": [(item("9", "google_ads_2026-10.csv", "History/TapClicks"), csv_bytes(text))]})
    store = MemStore()
    s = sl.run(g, store, MemNotifier(), CONFIG, feed_id="H01", today=TODAY)
    assert s["loaded"] == 1 and store.tables["BRONZE.TAPCLICKS.HISTORY_STAGE"] == ["google_ads_2026-10.csv"]


def test_history_file_is_staged_in_the_copy_column_order():
    """COPY INTO reads by position: extra rate columns and a different order must not shift any value."""
    text = ('Impressions,Date,CPM,"Data Source Name","Campaign Name","Media Buy Name","Creative Name","Conversion Tag Name",'
            'Clicks,CTR,Spend,Starts,"Completed Plays","Total Conversions",CPC\n'
            '10,"Oct 14 2026",200.00,"Google Ads","c, with comma","m","cr",,1,10%,2.00,0,0,3,2.00\n'
            'Total,,,,,,,,1,,2.00,,,,\n')
    g = FakeGraph({"History/TapClicks": [(item("9", "google_ads_2026-10.csv", "History/TapClicks"), csv_bytes(text))]})
    store = MemStore()
    sl.run(g, store, MemNotifier(), CONFIG, feed_id="H01", today=TODAY)
    staged = list(csv.reader(io.StringIO(store.staged["google_ads_2026-10.csv"].decode("utf-8"))))
    assert staged[0] == ["date", "data_source_name", "campaign_name", "media_buy_name", "creative_name", "conversion_tag_name",
                         "impressions", "clicks", "spend", "starts", "completed_plays", "total_conversions"]
    assert staged[1:] == [["Oct 14 2026", "Google Ads", "c, with comma", "m", "cr", "", "10", "1", "2.00", "0", "0", "3"]]


def test_one_failing_file_does_not_stop_the_run():
    class BrokenGraph(FakeGraph):
        def download(self, item_id):
            if item_id == "1":
                raise ConnectionError("timeout")
            return super().download(item_id)
    good = csv_bytes("Quote Date,Quotes,Binds\n2026-10-20,4,1\n")
    g = BrokenGraph({"Sonnet/Raw Data": [(item("1", "raw data a.csv", "Sonnet/Raw Data"), good),
                                         (item("2", "raw data b.csv", "Sonnet/Raw Data"), good)]})
    store = MemStore()
    s = sl.run(g, store, MemNotifier(), CONFIG, feed_id="F01a", today=TODAY)
    assert s["loaded"] == 1 and s["errors"] == 1
    assert [l["status"] for l in store.logs] == ["error", "loaded"]
    # the failed file is tried again next run (only 'loaded' counts as done)
    assert not store.already_loaded("1", "v1")
