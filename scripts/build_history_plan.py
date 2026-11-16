"""History download plan and cut-over seed, from the source register.

There is no TapClicks Data Exporter, so history comes from three places:
  1. Fivetran's own historical sync, for platforms that keep history (checked against TapClicks for one month).
  2. The original files Epitaph uploaded (Sonnet, SiriusXM, vendors), where Epitaph still has them.
  3. TapClicks Data Table CSV downloads: one file per source per month, saved to SharePoint History/TapClicks.
This script writes one row per source and month that must come from TapClicks downloads (3), in priority order,
plus the weekly comparison downloads needed during the parallel run, and seeds/ctl_cutover.csv.

    python scripts/build_history_plan.py --register /secure/source_register.csv

Priority (24 months of full detail first, as recommended):
  P1  sources behind the 29 live dashboards, Nov 2025 to Nov 2026 (this year and the year-over-year month)
  P2  the same sources, Nov 2024 to Oct 2025
  P3  other connected sources, Nov 2024 to Nov 2026
  P4  history-only sources with data in the last 24 months
  P5  everything before Nov 2024 (2020 onward): only if Epitaph asks; must be done before TapClicks closes on 28 Feb 2027
"""
import argparse
import csv
import datetime as dt
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CUTOVER = dt.date(2026, 12, 7)   # Phase 1 week 6 (7 to 11 Dec); confirm per source
WINDOW_START = dt.date(2024, 11, 1)
YOY_START = dt.date(2025, 11, 1)
HISTORY_START = dt.date(2020, 1, 1)
SWITCH_OFF = dt.date(2027, 2, 28)
DUE = {"P1": dt.date(2026, 11, 20), "P2": dt.date(2026, 12, 4), "P3": dt.date(2026, 12, 18),
       "P4": dt.date(2027, 1, 15), "P5": dt.date(2027, 2, 19)}
# Sources whose history Fivetran can pull itself; TapClicks downloads are then only for the check month.
FIVETRAN_HISTORY = {"Google Ads", "Facebook Ads", "Microsoft Advertising", "LinkedIn Ads", "TikTok Ads", "SnapChat",
                    "Reddit Ads", "Pinterest Ads", "Google Analytics 4", "Campaign Manager 360", "Display & Video 360 IO",
                    "Amazon Ads"}
# Original files Epitaph still holds (Uploaded files sheet, question 6 = "Yes; all past files")
FILES_HELD = {"Sonnet - Raw Data", "Sonnet - Quote Quality Data", "Sonnet - Group Breakdown Data", "Sonnet - Multiline Data",
              "Sonnet - Direct Buy Offline Spend", "Goal Smart Connector"}
NOT_NEEDED = {"Google Trends", "TapOrders"}
# Feeds that have stopped (F04): history only, no live route
STOPPED_PREFIX = ("Sonnet - Google CDI Data",)


def months(start, end):
    m = dt.date(start.year, start.month, 1)
    while m <= end:
        yield m
        m = dt.date(m.year + (m.month == 12), m.month % 12 + 1, 1)


def route_of(r):
    route = r["route"]
    if r["source"].startswith(STOPPED_PREFIX):
        return "history_only"
    if r["source"] in NOT_NEEDED:
        return "out_of_scope"
    if route.startswith("SharePoint"):
        return "sharepoint"
    if route.startswith("Fivetran"):
        return "fivetran"
    if route == "Budget table":
        return "out_of_scope"
    return "history_only"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--register", required=True)
    a = ap.parse_args()
    reg = list(csv.DictReader(open(a.register)))
    live_accounts = {r["tapclicks_client_account"] for r in csv.DictReader(open(ROOT / "seeds" / "map_client_account.csv"))}

    plan, cut = [], []
    for r in reg:
        src = r["source"]
        route = route_of(r)
        last = dt.date.fromisoformat(r["last_data_date"]) if r["last_data_date"] else None
        clients = {c.strip() for c in (r["in_scope_clients"] or "").split(";") if c.strip()}
        live = bool(clients & live_accounts) or any(acc.split(" - ")[0] in r["in_scope_clients"] for acc in live_accounts)
        if route != "history_only" and route != "out_of_scope":
            cut.append({"source_name": src, "route": route, "cutover_date": CUTOVER.isoformat(),
                        "status": "planned", "owner": "", "notes": r["route"].replace("SharePoint (Fivetran)", "SharePoint loader")})
        else:
            cut.append({"source_name": src, "route": route, "cutover_date": "", "status": "history_only" if route == "history_only" else "out_of_scope",
                        "owner": "", "notes": r["status_2026_10_25"]})
        if src in NOT_NEEDED or route == "out_of_scope" or last is None:
            continue
        end = min(last, CUTOVER - dt.timedelta(days=1))
        for m in months(HISTORY_START, end):
            if m >= YOY_START and live and route != "history_only":
                p = "P1"
            elif m >= WINDOW_START and live and route != "history_only":
                p = "P2"
            elif m >= WINDOW_START and route != "history_only":
                p = "P3"
            elif m >= WINDOW_START:
                p = "P4"
            else:
                p = "P5"
            method = "TapClicks download"
            if src in FIVETRAN_HISTORY and p in ("P1", "P2", "P3"):
                method = "Fivetran history sync (TapClicks download for Oct 2026 only, as the check month)"
                if m != dt.date(2026, 10, 1):
                    method = "Fivetran history sync"
            elif src in FILES_HELD:
                method = "Original files from Epitaph (TapClicks download for Oct 2026 as the check month)"
            plan.append({"priority": p, "source_name": src, "month": m.isoformat()[:7], "route_after_cutover": route,
                         "used_by_live_dashboard": "yes" if live else "no", "method": method,
                         "file_name": f"{src.lower().replace(' ', '_').replace('/', '-')}_{m.isoformat()[:7]}.csv"
                         if method.startswith("TapClicks") else "",
                         "due": DUE[p].isoformat(), "status": "to download" if method.startswith("TapClicks") else "via other route"})
    # Parallel run: one all-sources Data Table download per week for the comparison check, Dec 2026 to switch-off
    wk = dt.date(2026, 12, 7)
    while wk <= SWITCH_OFF:
        plan.append({"priority": "Compare", "source_name": "All connected sources", "month": f"week of {wk.isoformat()}",
                     "route_after_cutover": "fivetran and sharepoint", "used_by_live_dashboard": "yes",
                     "method": "TapClicks download of the previous week, all sources in one file, for the comparison check",
                     "file_name": f"compare_all_sources_wk_{wk.isoformat()}.csv", "due": wk.isoformat(), "status": "to download"})
        wk += dt.timedelta(days=7)

    order = {"P1": 1, "P2": 2, "P3": 3, "P4": 4, "Compare": 5, "P5": 6}
    plan.sort(key=lambda x: (order[x["priority"]], x["source_name"], x["month"]))
    out = ROOT / "plans"
    out.mkdir(exist_ok=True)
    with open(out / "history_download_plan.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(plan[0].keys()))
        w.writeheader()
        w.writerows(plan)
    with open(ROOT / "seeds" / "ctl_cutover.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(cut[0].keys()))
        w.writeheader()
        w.writerows(cut)

    summary = {}
    for p in plan:
        k = (p["priority"], p["method"].split(" (")[0])
        summary[k] = summary.get(k, 0) + 1
    with open(out / "history_download_summary.csv", "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["priority", "method", "rows", "due"])
        for (p, m), n in sorted(summary.items(), key=lambda kv: order[kv[0][0]]):
            w.writerow([p, m, n, DUE.get(p, "weekly").isoformat() if p in DUE else "weekly"])
    write_xlsx(out / "history_download_plan.xlsx", plan, summary, cut, order)
    print(f"{len(plan)} plan rows; {sum(1 for p in plan if p['status'] == 'to download')} TapClicks downloads; "
          f"{len(cut)} cut-over rows")


def write_xlsx(path, plan, summary, cut, order):
    """Same content as the CSVs, as a workbook the team can filter and tick off."""
    from openpyxl import Workbook
    from openpyxl.styles import Font, PatternFill, Alignment
    from openpyxl.worksheet.datavalidation import DataValidation
    head = Font(bold=True, color="FFFFFF")
    fill = PatternFill("solid", fgColor="1F2937")
    wb = Workbook()
    ws = wb.active
    ws.title = "Summary"
    ws.append(["History download plan"])
    ws["A1"].font = Font(bold=True, size=14)
    ws.append(["24 months of full detail first. P5 (before Nov 2024) only if Epitaph asks, and before TapClicks closes on 28 Feb 2027."])
    ws.append([])
    ws.append(["Priority", "Method", "Rows", "Due"])
    for c in ws[4]:
        c.font, c.fill = head, fill
    for (p, m), n in sorted(summary.items(), key=lambda kv: order[kv[0][0]]):
        ws.append([p, m, n, DUE[p].isoformat() if p in DUE else "weekly"])
    ws.column_dimensions["A"].width = 10
    ws.column_dimensions["B"].width = 70
    for name, rows in (("Plan", plan), ("Cut-over", cut)):
        w = wb.create_sheet(name)
        cols = list(rows[0].keys())
        w.append(cols)
        for c in w[1]:
            c.font, c.fill = head, fill
            c.alignment = Alignment(vertical="center")
        for r in rows:
            w.append([r[k] for k in cols])
        w.freeze_panes = "A2"
        w.auto_filter.ref = w.dimensions
        for i, k in enumerate(cols, start=1):
            w.column_dimensions[w.cell(1, i).column_letter].width = min(60, max(12, len(k) + 4))
        if name == "Plan":
            dv = DataValidation(type="list", formula1='"to download,downloaded,loaded,matched,corrected,skipped,via other route"')
            w.add_data_validation(dv)
            dv.add(f"I2:I{len(rows) + 1}")
    wb.save(path)


if __name__ == "__main__":
    main()
