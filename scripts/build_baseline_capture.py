"""TapClicks baseline capture list: which widget values to read before switch-off, so every KPI is checked.

Picks, from the 29 dashboard specs, the fewest widgets that cover:
  - every KPI at least once (preferring a single-number widget on a High-priority dashboard),
  - the core delivery totals (Impressions, Clicks, Spend) on every dashboard, from its first rebuilt section.
Each row is read in TapClicks for October 2026 (1 to 31 Oct) and the value typed into the sheet; the values then load
into GOLD.CONTROL.REF_TAPCLICKS_BASELINE and are compared with the semantic layer for the same filters.

    python scripts/build_baseline_capture.py      -> plans/tapclicks_baseline_capture.csv and .xlsx
"""
import csv
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
PRIORITY = {"High": 0, "Medium": 1}
CORE = ["Impressions", "Clicks", "Spend"]   # rates are recomputed from these, so one check of each rate is enough


def filters_text(w):
    out = []
    for f in w.get("filters", []):
        if "metric_at_least" in f:
            out.append(f"{f['metric_at_least']['metric']} >= {f['metric_at_least']['value']}")
        elif "field" in f:
            vals = "; ".join(f["values"][:4]) + (" ..." if len(f["values"]) > 4 else "")
            out.append(f"{f['field']} {f['op']} [{vals}]")
    return " AND ".join(out)


def main():
    specs = [yaml.safe_load(open(f)) for f in sorted((ROOT / "specs" / "dashboards").glob("D*.yml"))]
    specs.sort(key=lambda s: (PRIORITY.get(s["priority"], 2), s["target_live_date"], s["id"]))
    kpi_names = [k["name"] for k in yaml.safe_load(open(ROOT / "config" / "kpis.yml"))["kpis"]]
    rows, covered, seen = [], set(), set()

    def add(spec, sec, w, metric, why):
        key = (spec["id"], w["tapclicks_widget_id"], metric)
        if key in seen:
            return
        seen.add(key)
        rows.append({"dashboard_id": spec["id"], "dashboard": spec["title"], "priority": spec["priority"],
                     "section": sec["name"], "widget_id": w["tapclicks_widget_id"], "widget_title": w["title"],
                     "element": w["element"], "kpi": metric,
                     "label_in_tapclicks": (w.get("labels") or {}).get(metric, metric),
                     "filters": filters_text(w), "period": "2026-10-01 to 2026-10-31",
                     "why": why, "tapclicks_value": "", "captured_by": "", "captured_on": ""})
        covered.add(metric)

    def widgets(spec):
        for sec in spec["sections"]:
            if sec["rebuild"]:
                for w in sec["widgets"]:
                    yield sec, w

    # 1. every KPI once, single-number widgets first, High-priority dashboards first
    for kpi in kpi_names:
        best = None
        for spec in specs:
            for sec, w in widgets(spec):
                if kpi in w["metrics"] and not w.get("group_by"):
                    best = best or (spec, sec, w)
        if not best:
            for spec in specs:
                for sec, w in widgets(spec):
                    if kpi in w["metrics"]:
                        best = best or (spec, sec, w)
        if best:
            add(*best, kpi, "covers this KPI")
    # 2. core delivery KPIs on every dashboard
    for spec in specs:
        for kpi in CORE:
            hit = next(((sec, w) for sec, w in widgets(spec) if kpi in w["metrics"] and not w.get("group_by")), None)
            if hit:
                add(spec, *hit, kpi, "core KPI on this dashboard")

    out = ROOT / "plans" / "tapclicks_baseline_capture.csv"
    with open(out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    missing = [k for k in kpi_names if k not in covered]
    print(f"{len(rows)} values to capture; {len(covered)} KPIs covered; not on any live widget: {missing}")

    from openpyxl import Workbook
    from openpyxl.styles import Font, PatternFill
    wb = Workbook()
    ws = wb.active
    ws.title = "Capture"
    ws.append(list(rows[0].keys()))
    for c in ws[1]:
        c.font, c.fill = Font(bold=True, color="FFFFFF"), PatternFill("solid", fgColor="1F2937")
    for r in rows:
        ws.append(list(r.values()))
    ws.freeze_panes = "A2"
    ws.auto_filter.ref = ws.dimensions
    for col, width in zip("ABCDEFGHIJKLMNO", (10, 34, 9, 22, 11, 28, 14, 24, 24, 60, 22, 24, 16, 14, 12)):
        ws.column_dimensions[col].width = width
    wb.save(out.with_suffix(".xlsx"))


if __name__ == "__main__":
    main()
