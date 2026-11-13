"""SharePoint to Snowflake BRONZE loader.

Runs inside Snowflake as a Python stored procedure (BRONZE.LOADER.LOAD_SHAREPOINT), called by a task every hour.
It reads new or changed files from the Epitaph Reporting SharePoint site through Microsoft Graph, checks them,
and writes every row to BRONZE.SHAREPOINT.<table> as it arrived (one VARIANT per row plus file details).

Access: an Entra app with the Sites.Selected permission, granted to this one site only. Its client secret is a
Snowflake secret; network access is limited by an external access integration to login.microsoftonline.com,
graph.microsoft.com and the tenant's SharePoint host (file downloads redirect there).

Rules
- A file is loaded once per version. BRONZE.LOADER.LOAD_LOG holds (drive item id, eTag); a changed file is loaded
  again as a new version and staging keeps the latest version per file.
- A file that fails a check is moved to the Rejected folder, logged with the reason and the owner is emailed.
  Nothing from a rejected file reaches BRONZE.
- Rows are never changed in BRONZE. Clean-up happens in SILVER views.

The core (parsing, checks, decisions) has no Snowflake or Graph imports so it can be tested with synthetic files.
"""
from __future__ import annotations

import csv
import datetime as dt
import fnmatch
import io
import json
import re
from dataclasses import dataclass, field
from typing import Iterable, Protocol

GRAPH = "https://graph.microsoft.com/v1.0"
# Order matters: month-first before day-first (the US-style reports), four-digit years before two-digit years.
DATE_FORMATS = ["%Y-%m-%d", "%m/%d/%Y", "%d/%m/%Y", "%m/%d/%y", "%b %d %Y", "%b %d, %Y", "%B %d, %Y", "%B %d %Y",
                "%Y/%m/%d", "%d-%b-%Y", "%Y-%m", "%b %Y", "%B %Y"]
# Report footers (DV360 and similar): reading stops at the first row that starts with one of these.
FOOTER_MARKERS = ("report time:", "date range:", "group by:", "mrc accredited metrics", "reporting numbers from",
                  "filter by ", "no data returned")
NO_DATA_MARKER = "no data returned"


# ---------------------------------------------------------------- parsing and checks (pure)

def norm_header(h) -> str:
    h = str(h or "").replace("﻿", "").strip().lower()
    h = re.sub(r"[^a-z0-9]+", "_", h).strip("_")
    return h or "unnamed"


def dedupe_headers(headers: list[str]) -> list[str]:
    seen, out = {}, []
    for h in headers:
        n = seen.get(h, 0)
        out.append(h if n == 0 else f"{h}_{n + 1}")
        seen[h] = n + 1
    return out


def parse_date(value) -> dt.date | None:
    if value is None or value == "":
        return None
    if isinstance(value, dt.datetime):
        return value.date()
    if isinstance(value, dt.date):
        return value
    s = str(value).strip()
    if re.fullmatch(r"\d{5}", s):                       # Excel serial date
        return dt.date(1899, 12, 30) + dt.timedelta(days=int(s))
    s = s.split("T")[0].split(" 00:00")[0]
    for f in DATE_FORMATS:
        try:
            return dt.datetime.strptime(s, f).date()
        except ValueError:
            continue
    return None


def read_rows(name: str, content: bytes, headers_override: list[str] | None = None) -> tuple[list[str], list[list]]:
    """Return (headers, rows) from a CSV or the first sheet of an Excel file.

    headers_override replaces the file's header row (for exports whose header row holds labels or totals,
    such as the Adobe organic export: "9 CA Organic, Day, Starts, 1575")."""
    lower = name.lower()
    if lower.endswith((".xlsx", ".xlsm")):
        import openpyxl
        wb = openpyxl.load_workbook(io.BytesIO(content), read_only=True, data_only=True)
        ws = wb.worksheets[0]
        it = ws.iter_rows(values_only=True)
        rows = [list(r) for r in it]
    else:
        text = None
        for enc in ("utf-8-sig", "cp1252", "latin-1"):
            try:
                text = content.decode(enc)
                break
            except UnicodeDecodeError:
                continue
        sample = text[:4096]
        try:
            dialect = csv.Sniffer().sniff(sample, delimiters=",;\t|")
        except csv.Error:
            dialect = csv.excel
        rows = list(csv.reader(io.StringIO(text), dialect))
    # Skip report banner lines: the header is the first row with at least two non-empty cells.
    while rows and sum(1 for c in rows[0] if str(c or "").strip()) < 2:
        rows.pop(0)
    if not rows:
        return [], []
    headers = dedupe_headers([norm_header(h) for h in (headers_override or rows[0])])
    body = []
    for r in rows[1:]:
        first = str(r[0] if r else "").strip().lower()
        if first.startswith(FOOTER_MARKERS):
            break
        if any(str(c or "").strip() for c in r):
            body.append(r)
    # Drop "Total" footer rows that some vendor reports add.
    body = [r for r in body if not str(r[0] or "").strip().lower().startswith(("total", "grand total"))]
    # Drop unlabelled totals rows (Silverpush ends with a row of sums and no date or names).
    body = [r for r in body if not _is_unlabelled_total(r)]
    return headers, body


def _is_number(v) -> bool:
    if isinstance(v, (int, float)):
        return True
    try:
        float(str(v).replace(",", ""))
        return True
    except ValueError:
        return False


def _is_unlabelled_total(r) -> bool:
    if r and str(r[0] if r[0] is not None else "").strip():
        return False
    filled = [c for c in r if str(c if c is not None else "").strip()]
    return bool(filled) and all(_is_number(c) for c in filled)


@dataclass
class CheckResult:
    ok: bool
    reason: str = ""
    rows: list[dict] = field(default_factory=list)
    min_date: dt.date | None = None
    max_date: dt.date | None = None


def check_file(feed: dict, name: str, content: bytes, max_mb: int = 200, today: dt.date | None = None) -> CheckResult:
    today = today or dt.date.today()
    if len(content) > max_mb * 1024 * 1024:
        return CheckResult(False, f"file is larger than {max_mb} MB")
    if not any(fnmatch.fnmatch(name.lower(), p.strip().lower()) for p in feed["match"].split("|")):
        return CheckResult(False, f"file name does not match {feed['match']}")
    try:
        headers, body = read_rows(name, content, feed.get("headers"))
    except Exception as e:  # unreadable file
        return CheckResult(False, f"file could not be read ({type(e).__name__})")
    if not body and _says_no_data(name, content):
        return CheckResult(True, reason="report says no data for the period")    # loaded and logged with 0 rows
    if not body:
        return CheckResult(False, "file has no data rows")
    missing = [c for c in feed.get("required", []) if norm_header(c) not in headers]
    if missing:
        return CheckResult(False, "missing columns: " + ", ".join(missing))
    dcol = norm_header(feed["date_column"]["name"])
    idx = headers.index(dcol)
    dates, bad = [], 0
    for r in body:
        d = parse_date(r[idx] if idx < len(r) else None)
        if d is None:
            bad += 1
        else:
            dates.append(d)
    if bad and bad / len(body) > 0.01:
        return CheckResult(False, f"{bad} of {len(body)} rows have no readable date in '{dcol}'")
    if dates and max(dates) > today + dt.timedelta(days=400) and feed["id"] != "F16":
        return CheckResult(False, "dates more than a year in the future")
    rows = []
    for i, r in enumerate(body, start=1):
        rec = {h: (_jsonable(r[j]) if j < len(r) else None) for j, h in enumerate(headers)}
        rec["_row_number"] = i
        rows.append(rec)
    return CheckResult(True, rows=rows, min_date=min(dates) if dates else None, max_date=max(dates) if dates else None)


def _says_no_data(name: str, content: bytes) -> bool:
    try:
        _, raw = _raw_first_cells(name, content)
    except Exception:
        return False
    return any(c.startswith(NO_DATA_MARKER) for c in raw)


def _raw_first_cells(name: str, content: bytes):
    if name.lower().endswith((".xlsx", ".xlsm")):
        import openpyxl
        ws = openpyxl.load_workbook(io.BytesIO(content), read_only=True, data_only=True).worksheets[0]
        return None, [str((r or [""])[0] or "").strip().lower() for r in ws.iter_rows(values_only=True, max_row=60)]
    text = content.decode("utf-8-sig", errors="replace")
    return None, [line.split(",")[0].strip().strip('"').lower() for line in text.splitlines()[:60]]


def _jsonable(v):
    if isinstance(v, (dt.date, dt.datetime)):
        return v.isoformat()
    if isinstance(v, str):
        v = v.strip()
        m = re.fullmatch(r'="(.*)"', v)          # Excel text guard used by Amazon DSP for long ids: ="5894..."
        return m.group(1) if m else v
    return v


def feed_for(path: str, feeds: list[dict]) -> dict | None:
    """Pick the feed whose folder is the longest prefix of the file's folder."""
    best = None
    for f in feeds:
        if path.lower().startswith(f["folder"].lower().rstrip("/") + "/"):
            if best is None or len(f["folder"]) > len(best["folder"]):
                best = f
    return best


# ---------------------------------------------------------------- interfaces

class Graph(Protocol):
    def list_files(self, folder: str) -> Iterable[dict]: ...      # {id, name, path, etag, size, modified}
    def download(self, item_id: str) -> bytes: ...
    def move(self, item_id: str, folder: str, new_name: str) -> None: ...


class Store(Protocol):
    def already_loaded(self, item_id: str, etag: str) -> bool: ...
    def write_rows(self, table: str, rows: list[dict], meta: dict) -> int: ...
    def stage_file(self, stage: str, name: str, content: bytes, rows: int) -> int: ...
    def log(self, entry: dict) -> None: ...


class Notifier(Protocol):
    def send(self, owner: str, subject: str, body: str) -> None: ...


# ---------------------------------------------------------------- run

def staged_csv(feed: dict, rows: list[dict]) -> bytes:
    """The checked rows as CSV with only the feed's required columns, in the order listed in feeds.yml.

    Used for staged feeds (TapClicks history), whose COPY INTO reads columns by position: extra export columns
    (CPM, CTR, CPC), a different column order, banner lines and totals rows can then never shift a value into the
    wrong column."""
    cols = [norm_header(c) for c in feed["required"]]
    out = io.StringIO()
    w = csv.writer(out, quoting=csv.QUOTE_MINIMAL, lineterminator="\n")
    w.writerow(cols)
    for r in rows:
        w.writerow(["" if r.get(c) is None else r.get(c) for c in cols])
    return out.getvalue().encode("utf-8")


def run(graph: Graph, store: Store, notifier: Notifier, config: dict, feed_id: str | None = None,
        today: dt.date | None = None) -> dict:
    feeds = [f for f in config["feeds"] if f.get("status") != "retired" and (feed_id is None or f["id"] == feed_id)]
    summary = {"loaded": 0, "rows": 0, "rejected": 0, "skipped": 0}
    folders = sorted({f["folder"] for f in feeds})
    for folder in folders:
        for item in graph.list_files(folder):
            feed = feed_for(item["path"], feeds) or next(f for f in feeds if f["folder"] == folder)
            if store.already_loaded(item["id"], item["etag"]):
                summary["skipped"] += 1
                continue
            try:
                content = graph.download(item["id"])
                res = check_file(feed, item["name"], content, config.get("max_file_mb", 200), today)
                entry = {"item_id": item["id"], "etag": item["etag"], "feed_id": feed["id"], "file_name": item["name"],
                         "file_path": item["path"], "file_modified": item.get("modified"), "bytes": len(content)}
                if not res.ok:
                    stamp = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%d%H%M")
                    graph.move(item["id"], f"{config['rejected_folder']}/{feed['folder']}", f"{stamp}_{item['name']}")
                    store.log({**entry, "status": "rejected", "reason": res.reason, "rows": 0})
                    notifier.send(feed["owner"], f"File not loaded: {item['name']}",
                                  f"The file {item['name']} in {feed['folder']} was not loaded because: {res.reason}.\n"
                                  f"It has been moved to {config['rejected_folder']}/{feed['folder']}. "
                                  f"Fix the file and save it back to {feed['folder']} to load it.")
                    summary["rejected"] += 1
                    continue
                if feed.get("mode") == "stage":
                    # Large history files: stage the checked rows and bulk-load them with COPY INTO. COPY maps columns
                    # by position, so the file is rewritten with only the required columns, in their listed order.
                    n = store.stage_file(feed["stage"], item["name"], staged_csv(feed, res.rows), len(res.rows))
                else:
                    n = store.write_rows(feed["table"], res.rows, {**entry, "report": feed.get("report"), "grain": feed.get("grain", "day")})
                store.log({**entry, "status": "loaded", "reason": "", "rows": n,
                           "min_date": res.min_date.isoformat() if res.min_date else None,
                           "max_date": res.max_date.isoformat() if res.max_date else None})
                summary["loaded"] += 1
                summary["rows"] += n
            except Exception as e:  # one bad file must not stop the other feeds
                store.log({"item_id": item["id"], "etag": item["etag"], "feed_id": feed["id"], "file_name": item["name"],
                           "file_path": item["path"], "file_modified": item.get("modified"), "bytes": 0,
                           "status": "error", "reason": f"{type(e).__name__}: {str(e)[:300]}", "rows": 0})
                summary["errors"] = summary.get("errors", 0) + 1
    return summary


# ---------------------------------------------------------------- Snowflake and Graph implementations

class GraphClient:
    """Microsoft Graph with app-only (client credentials) access to one site."""

    def __init__(self, tenant_id: str, client_id: str, client_secret: str, site_id: str, library: str):
        import requests
        self._s = requests.Session()
        tok = self._s.post(f"https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token", data={
            "client_id": client_id, "client_secret": client_secret, "grant_type": "client_credentials",
            "scope": "https://graph.microsoft.com/.default"}, timeout=30)
        tok.raise_for_status()
        self._s.headers["Authorization"] = "Bearer " + tok.json()["access_token"]
        drives = self._get(f"{GRAPH}/sites/{site_id}/drives")["value"]
        self.drive = next(d["id"] for d in drives if d["name"] == library)

    def _get(self, url):
        r = self._s.get(url, timeout=60)
        r.raise_for_status()
        return r.json()

    def list_files(self, folder):
        url = f"{GRAPH}/drives/{self.drive}/root:/{folder}:/children?$top=200"
        while url:
            page = self._get(url)
            for it in page.get("value", []):
                if "file" in it:
                    yield {"id": it["id"], "name": it["name"], "path": f"{folder}/{it['name']}", "etag": it["eTag"],
                           "size": it["size"], "modified": it["lastModifiedDateTime"]}
            url = page.get("@odata.nextLink")

    def download(self, item_id):
        r = self._s.get(f"{GRAPH}/drives/{self.drive}/items/{item_id}/content", timeout=300)
        r.raise_for_status()
        return r.content

    def ensure_folder(self, folder):
        """Create each part of the folder path if it is missing (Rejected/<feed folder> is made on first use)."""
        path = ""
        for part in folder.strip("/").split("/"):
            parent = f"{GRAPH}/drives/{self.drive}/root:/{path}:/children" if path else f"{GRAPH}/drives/{self.drive}/root/children"
            path = f"{path}/{part}" if path else part
            r = self._s.get(f"{GRAPH}/drives/{self.drive}/root:/{path}", timeout=60)
            if r.status_code == 404:
                self._s.post(parent, json={"name": part, "folder": {}, "@microsoft.graph.conflictBehavior": "fail"},
                             timeout=60).raise_for_status()
            else:
                r.raise_for_status()
        return self._get(f"{GRAPH}/drives/{self.drive}/root:/{folder}")

    def move(self, item_id, folder, new_name):
        parent = self.ensure_folder(folder)
        r = self._s.patch(f"{GRAPH}/drives/{self.drive}/items/{item_id}",
                          json={"parentReference": {"id": parent["id"]}, "name": new_name}, timeout=60)
        r.raise_for_status()


class SnowflakeStore:
    def __init__(self, session, run_id: str):
        self.s = session
        self.run_id = run_id

    def already_loaded(self, item_id, etag):
        return self.s.sql("select 1 from BRONZE.LOADER.LOAD_LOG where item_id = ? and etag = ? and status = 'loaded' limit 1",
                          params=[item_id, etag]).collect() != []

    def write_rows(self, table, rows, meta):
        if not rows:
            return 0
        from snowflake.snowpark.types import StructType, StructField, StringType, VariantType, IntegerType
        schema = StructType([StructField("ITEM_ID", StringType()), StructField("ETAG", StringType()),
                             StructField("FILE_NAME", StringType()), StructField("FEED_ID", StringType()),
                             StructField("REPORT", StringType()), StructField("GRAIN", StringType()),
                             StructField("ROW_NUMBER", IntegerType()), StructField("RECORD", VariantType()),
                             StructField("RUN_ID", StringType())])
        data = [(meta["item_id"], meta["etag"], meta["file_name"], meta["feed_id"], meta.get("report"), meta.get("grain"),
                 r["_row_number"], {k: v for k, v in r.items() if k != "_row_number"}, self.run_id)   # dict: Snowpark encodes VARIANT itself
                for r in rows]
        df = self.s.create_dataframe(data, schema=schema)
        df.write.mode("append").save_as_table(f"BRONZE.SHAREPOINT.{table}", column_order="name")
        return len(data)

    def stage_file(self, stage, name, content, rows):
        self.s.file.put_stream(io.BytesIO(content), f"@{stage}/{name}", auto_compress=True, overwrite=True)
        self.s.sql("call BRONZE.LOADER.LOAD_TAPCLICKS_HISTORY(?)", params=[".*" + re.escape(name) + ".*"]).collect()
        return rows

    def log(self, e):
        self.s.sql("""insert into BRONZE.LOADER.LOAD_LOG (run_id, item_id, etag, feed_id, file_name, file_path, file_modified,
                      bytes, status, reason, rows_loaded, min_date, max_date)
                      select ?, ?, ?, ?, ?, ?, try_to_timestamp_tz(?), ?, ?, ?, ?, try_to_date(?), try_to_date(?)""",
                   params=[self.run_id, e["item_id"], e["etag"], e["feed_id"], e["file_name"], e["file_path"],
                           e.get("file_modified"), e["bytes"], e["status"], e["reason"], e["rows"],
                           e.get("min_date"), e.get("max_date")]).collect()


class SnowflakeNotifier:
    def __init__(self, session, integration: str = "EPITAPH_EMAIL"):
        self.s = session
        self.integration = integration

    def send(self, owner, subject, body):
        # Owner keys map to mailbox addresses in GOLD.CONTROL.FEED_OWNERS (kept out of the repo).
        self.s.sql("call GOLD.CONTROL.NOTIFY('feed_owner', ?, ?, ?)", params=[owner, subject, body]).collect()


def main(session, feed_id: str = None) -> str:
    """Stored procedure handler: BRONZE.LOADER.LOAD_SHAREPOINT(feed_id)."""
    import _snowflake  # available inside Snowflake only
    import yaml
    import sys
    import uuid
    import_dir = sys._xoptions["snowflake_import_directory"]
    with open(f"{import_dir}/feeds.yml") as fh:
        config = yaml.safe_load(fh)
    secret = json.loads(_snowflake.get_generic_secret_string("graph_app"))
    graph = GraphClient(secret["tenant_id"], secret["client_id"], secret["client_secret"], secret["site_id"], config["library"])
    summary = run(graph, SnowflakeStore(session, str(uuid.uuid4())), SnowflakeNotifier(session), config, feed_id)
    return json.dumps(summary)
