#!/usr/bin/env python3
"""Build an Omni dashboard from a spec file in git (dashboards/specs/*.yml).

What it automates: the dashboard document, one query tab per tile, each tile's fields, sorts, limit, filters and
chart type, created on the shared model through Omni's documents API.
What Omni's API cannot set: tile sizes and positions, pages, dashboard filters and controls (field switcher,
timeframe switcher, period over period), theme. Those are listed under `manual_steps` in the spec and done once in
the Omni UI; then `scripts/omni_dashboard.py export` saves the finished dashboard to git.

  python scripts/omni_dashboard_build.py validate dashboards/specs/cockpit.yml
  python scripts/omni_dashboard_build.py plan     dashboards/specs/cockpit.yml          -> dashboards/build/<id>.json
  python scripts/omni_dashboard_build.py test     dashboards/specs/cockpit.yml          (runs every tile query, limit 5)
  python scripts/omni_dashboard_build.py create   dashboards/specs/cockpit.yml --version v1 [--dry-run]
  python scripts/omni_dashboard_build.py capture  <document identifier>                 -> dashboards/templates/

Env (test / create / capture): OMNI_BASE_URL, OMNI_API_KEY (Organization API key), OMNI_MODEL_ID (shared model).
Options: --model-file (default omni/model/media_performance_daily.view.yaml).

capture: build one tile of each chart type in the Omni UI, then capture that document. The visConfig Omni saved
for each chart type is written to dashboards/templates/<chartType>.json and reused by `plan` / `create`, so charts
render exactly as configured in the UI. Without templates the chart type alone is sent and Omni uses its defaults.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

try:
    import yaml
except ImportError:  # pragma: no cover
    sys.exit("PyYAML is required: pip install pyyaml")

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / "dashboards" / "build"
TEMPLATES = ROOT / "dashboards" / "templates"
DEFAULT_MODEL_FILE = ROOT / "omni" / "model" / "media_performance_daily.view.yaml"

# From Omni's create-document API (chartType enum).
CHART_TYPES = {
    "auto", "area", "areaStacked", "areaStackedPercentage", "bar", "barLine", "barGrouped", "barStacked",
    "barStackedPercentage", "boxplot", "code", "column", "columnGrouped", "columnStacked", "columnStackedPercentage",
    "heatmap", "kpi", "line", "lineColor", "map", "regionMap", "markdown", "omni-ai-summary-markdown", "pie", "funnel",
    "sankey", "point", "pointColor", "pointSize", "pointSizeColor", "singleRecord", "omni-spreadsheet",
    "summaryValue", "svgMap", "table", "treemap",
}
TIMEFRAMES = {"raw", "date", "week", "month", "quarter", "year", "day_of_week_name", "day_of_week_num",
              "day_of_month", "month_name", "hour", "minute"}
FIELD_RE = re.compile(r"^(?P<name>[a-z0-9_]+)(\[(?P<tf>[a-z_]+)\])?$")


# ----------------------------------------------------------------------------- spec + model
def load_spec(path: str) -> dict:
    spec = yaml.safe_load(Path(path).read_text(encoding="utf-8"))
    for key in ("id", "name", "model", "tiles"):
        if key not in spec:
            sys.exit(f"{path}: missing '{key}'")
    return spec


def load_model(path: Path) -> tuple[set, set, set]:
    if not path.exists():
        sys.exit(f"Model file not found: {path} (pass --model-file)")
    view = yaml.safe_load(path.read_text(encoding="utf-8"))
    dims = set((view.get("dimensions") or {}).keys())
    measures = {k for k, m in (view.get("measures") or {}).items() if not (m or {}).get("hidden")}
    hidden = {k for k, m in (view.get("measures") or {}).items() if (m or {}).get("hidden")}
    return dims, measures, hidden


def qualify(view: str, field: str) -> str:
    return field if "." in field else f"{view}.{field}"


def validate(spec: dict, model_file: Path) -> list[str]:
    dims, measures, hidden = load_model(model_file)
    view = spec["model"]["view"]
    errors, keys = [], set()
    for i, t in enumerate(spec["tiles"]):
        where = f"tile {i + 1} ({t.get('key', '?')})"
        for req in ("key", "title", "chart", "fields"):
            if req not in t:
                errors.append(f"{where}: missing '{req}'")
        if t.get("key") in keys:
            errors.append(f"{where}: duplicate key")
        keys.add(t.get("key"))
        if t.get("chart") not in CHART_TYPES:
            errors.append(f"{where}: chart '{t.get('chart')}' is not an Omni chart type")
        has_measure = False
        names = list(t.get("fields", [])) + [s["field"] for s in t.get("sorts", [])] + list((t.get("filters") or {}))
        for f in names:
            bare = f.split(".", 1)[1] if f.startswith(view + ".") else f
            m = FIELD_RE.match(bare)
            if not m:
                errors.append(f"{where}: bad field name '{f}'")
                continue
            name, tf = m.group("name"), m.group("tf")
            if name in measures:
                has_measure = has_measure or f in t.get("fields", [])
                if tf:
                    errors.append(f"{where}: measure '{name}' cannot take a timeframe")
            elif name in dims:
                if tf and tf not in TIMEFRAMES:
                    errors.append(f"{where}: unknown timeframe '[{tf}]' on '{name}'")
            elif name in hidden:
                errors.append(f"{where}: '{name}' is a hidden building block; use the visible KPI instead")
            else:
                errors.append(f"{where}: '{name}' is not a field of view '{view}'")
        if t.get("chart") != "markdown" and not has_measure:
            errors.append(f"{where}: needs at least one measure (Omni renders dimension-only tiles empty)")
    return errors


# ----------------------------------------------------------------------------- payload
def omni_filter(values) -> dict:
    """Equality filter in the shape Omni's query objects use. Confirm against a `capture` of a UI-built filter."""
    vals = values if isinstance(values, list) else [values]
    return {"kind": "EQUALS", "type": "string", "values": [str(v) for v in vals], "is_negative": False}


def build_query(spec: dict, tile: dict, model_id: str | None) -> dict:
    view, topic = spec["model"]["view"], spec["model"].get("topic")
    q = {
        "table": view,
        "fields": [qualify(view, f) for f in tile["fields"]],
        "sorts": [{"column_name": qualify(view, s["field"]), "sort_descending": bool(s.get("desc"))}
                  for s in tile.get("sorts", [])],
        "filters": {qualify(view, k): omni_filter(v) for k, v in (tile.get("filters") or {}).items()},
        "limit": int(tile.get("limit", 1000)),
    }
    if topic:
        q["join_paths_from_topic_name"] = topic
    if model_id:
        q["modelId"] = model_id
    return q


def vis_template(chart: str) -> dict:
    p = TEMPLATES / f"{chart}.json"
    return json.loads(p.read_text(encoding="utf-8")) if p.exists() else {}


def build_payload(spec: dict, model_id: str | None, version: str | None) -> dict:
    ident = spec["id"] + (f"-{version}" if version else "")
    if not re.match(r"^[a-z0-9](?:[a-z0-9_-]*[a-z0-9])?$", ident):
        sys.exit(f"Identifier '{ident}' must be lowercase letters, digits, - and _ (Omni rule)")
    qps = []
    for t in spec["tiles"]:
        qp = {
            "name": t["title"] if t.get("page", "Overview") == "Overview" else f'{t["page"]} | {t["title"]}',
            "description": t.get("description", f'{t["key"]} ({t.get("page", "Overview")})'),
            "chartType": t["chart"],
            "query": build_query(spec, t, model_id),
        }
        vis = vis_template(t["chart"])
        if vis:
            qp["visConfig"] = vis
        qps.append(qp)
    return {"modelId": model_id or "<OMNI_MODEL_ID>", "name": spec["name"],
            "description": spec.get("description", "")[:1024], "identifier": ident, "queryPresentations": qps}


# ----------------------------------------------------------------------------- API
def api(method: str, path: str, body: dict | None = None) -> dict:
    base, key = os.environ.get("OMNI_BASE_URL"), os.environ.get("OMNI_API_KEY")
    if not base or not key:
        sys.exit("Set OMNI_BASE_URL and OMNI_API_KEY (Organization API key)")
    req = urllib.request.Request(base.rstrip("/") + path, method=method,
                                 data=json.dumps(body).encode() if body is not None else None,
                                 headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            txt = r.read().decode()
            return json.loads(txt) if txt else {}
    except urllib.error.HTTPError as e:
        sys.exit(f"{method} {path} -> HTTP {e.code}: {e.read().decode()[:800]}")


def model_id() -> str:
    mid = os.environ.get("OMNI_MODEL_ID")
    if not mid:
        sys.exit("Set OMNI_MODEL_ID (shared model id, not a branch id)")
    return mid


# ----------------------------------------------------------------------------- commands
def cmd_validate(a):
    spec = load_spec(a.spec)
    errs = validate(spec, Path(a.model_file))
    exp = [t["key"] for t in spec["tiles"] if t.get("experimental")]
    for e in errs:
        print("ERROR", e)
    print(f"{a.spec}: {len(spec['tiles'])} tiles, {len(errs)} error(s)"
          + (f"; experimental (confirm in Omni): {', '.join(exp)}" if exp else ""))
    if errs:
        sys.exit(1)


def cmd_plan(a):
    cmd_validate(a)
    spec = load_spec(a.spec)
    payload = build_payload(spec, os.environ.get("OMNI_MODEL_ID"), a.version)
    BUILD.mkdir(parents=True, exist_ok=True)
    out = BUILD / f"{payload['identifier']}.json"
    out.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    missing = sorted({t["chart"] for t in spec["tiles"]} - {p.stem for p in TEMPLATES.glob("*.json")})
    print(f"Wrote {out}")
    if missing:
        print(f"No visConfig template yet for: {', '.join(missing)} (Omni defaults will be used; see `capture`)")


def cmd_test(a):
    cmd_validate(a)
    spec, mid = load_spec(a.spec), model_id()
    bad = 0
    for t in spec["tiles"]:
        q = build_query(spec, t, mid)
        q["limit"] = 5
        res = api("POST", "/api/v1/query/run", {"query": q})
        ok = not (isinstance(res, dict) and res.get("error"))
        bad += not ok
        print(("OK   " if ok else "FAIL ") + t["key"] + ("" if ok else f": {str(res.get('error'))[:300]}"))
    if bad:
        sys.exit(f"{bad} tile query(ies) failed")


def cmd_create(a):
    cmd_validate(a)
    spec = load_spec(a.spec)
    payload = build_payload(spec, None if a.dry_run else model_id(), a.version)
    if a.dry_run:
        print(json.dumps(payload, indent=2)[:4000])
        print(f"\nDry run: would create '{payload['name']}' ({payload['identifier']}) "
              f"with {len(payload['queryPresentations'])} tiles")
        return
    res = api("POST", "/api/v1/documents", payload)
    wb = res.get("workbook") or {}
    ident = wb.get("identifier") or payload["identifier"]
    base = os.environ["OMNI_BASE_URL"].rstrip("/")
    print(f"Created '{payload['name']}'\n  workbook:  {base}/w/{ident}\n  dashboard: {base}/dashboards/{ident}")
    print("Next: do the manual_steps from the spec in the Omni UI, then export the dashboard to git.")


def cmd_capture(a):
    res = api("GET", f"/api/v1/documents/{a.identifier}/queries")
    TEMPLATES.mkdir(parents=True, exist_ok=True)
    raw = TEMPLATES / f"_capture_{a.identifier}.json"
    raw.write_text(json.dumps(res, indent=2), encoding="utf-8")
    items = res.get("queries") or res.get("queryPresentations") or (res if isinstance(res, list) else [])
    saved = 0
    for qp in items:
        chart = qp.get("chartType") or (qp.get("visConfig") or {}).get("chartType")
        vis = qp.get("visConfig")
        if chart and vis and not (TEMPLATES / f"{chart}.json").exists():
            (TEMPLATES / f"{chart}.json").write_text(json.dumps(vis, indent=2), encoding="utf-8")
            saved += 1
            print(f"template {chart}.json")
    print(f"Raw capture: {raw}. Saved {saved} new visConfig template(s). Check the raw file for the exact filter shape.")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model-file", default=str(DEFAULT_MODEL_FILE))
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name in ("validate", "plan", "test", "create"):
        p = sub.add_parser(name)
        p.add_argument("spec")
        p.add_argument("--version", help="suffix for the document identifier, e.g. v1")
        p.add_argument("--dry-run", action="store_true")
    p = sub.add_parser("capture")
    p.add_argument("identifier")
    a = ap.parse_args()
    {"validate": cmd_validate, "plan": cmd_plan, "test": cmd_test, "create": cmd_create,
     "capture": cmd_capture}[a.cmd](a)


if __name__ == "__main__":
    main()
