"""Check and publish the Omni model files built by omni_build.py.

  python scripts/omni_deploy.py validate     # no network: parses every file and checks every reference resolves
  python scripts/omni_deploy.py publish      # CI only: uploads each file to the Omni model

Publish uses Omni's model YAML API, one call per file:
  POST /v1/models/{modelId}/yaml   {fileName, yaml, mode: "combined", branchId?, commitMessage}
  fileName is "model", "<name>.view" or "<name>.topic". With git pull requests required on the model, set
  OMNI_BRANCH_ID so the change lands on a branch and reaches the shared model only through a reviewed pull request.
Environment: OMNI_BASE_URL (https://<instance>.omniapp.co/api), OMNI_API_KEY (organization API key),
OMNI_MODEL_ID, optional OMNI_BRANCH_ID. Omni allows 60 requests a minute, so calls are spaced 1.1 seconds apart.
Output is the file name and pass or fail only.
"""
import argparse
import os
import re
import sys
import time
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
MODEL = ROOT / "omni" / "model"
REF = re.compile(r"\$\{(\w+)\.(\w+)\}")


def load():
    files = {}
    for f in sorted(MODEL.glob("*.yaml")):
        files[f.name] = (f.read_text(), yaml.safe_load(f.read_text()) or {})
    return files


def check(files):
    """Every ${view.field} points at a field of that view; every grant used is defined; every topic's view exists."""
    problems = []
    model = files.get("model.yaml", ("", {}))[1]
    grants = set((model.get("access_grants") or {}).keys())
    views = {fn[:-len(".view.yaml")]: obj for fn, (_, obj) in files.items() if fn.endswith(".view.yaml")}
    fields = {v: set((o.get("dimensions") or {}).keys()) | set((o.get("measures") or {}).keys()) for v, o in views.items()}
    for v, o in views.items():
        for kind in ("dimensions", "measures"):
            for name, spec in (o.get(kind) or {}).items():
                for rv, rf in REF.findall(str(spec.get("sql", ""))):
                    if rf not in fields.get(rv, set()):
                        problems.append(f"{v}.{name}: unknown reference ${{{rv}.{rf}}}")
                for g in spec.get("required_access_grants") or []:
                    if g not in grants:
                        problems.append(f"{v}.{name}: unknown access grant {g}")
                for fld in (spec.get("filters") or {}):
                    if fld not in fields[v]:
                        problems.append(f"{v}.{name}: filter on unknown field {fld}")
    for fn, (_, o) in files.items():
        if fn.endswith(".topic.yaml"):
            if o.get("base_view") not in views:
                problems.append(f"{fn}: base_view {o.get('base_view')} is not a view")
            for af in o.get("access_filters") or []:
                rv, rf = af["field"].split(".")
                if rf not in fields.get(rv, set()):
                    problems.append(f"{fn}: access filter on unknown field {af['field']}")
            for g in o.get("required_access_grants") or []:
                if g not in grants:
                    problems.append(f"{fn}: unknown access grant {g}")
    return problems


def file_name(fn):
    return "model" if fn == "model.yaml" else fn[:-len(".yaml")]


def publish(files):
    import requests
    base = os.environ["OMNI_BASE_URL"].rstrip("/")
    model_id = os.environ["OMNI_MODEL_ID"]
    s = requests.Session()
    s.headers["Authorization"] = "Bearer " + os.environ["OMNI_API_KEY"]
    sha = os.environ.get("GITHUB_SHA", "local")[:12]
    failed = 0
    for fn, (text, _) in files.items():
        body = {"fileName": file_name(fn), "yaml": text, "mode": "combined",
                "commitMessage": f"Generated from epitaph-reporting {sha}"}
        if os.environ.get("OMNI_BRANCH_ID"):
            body["branchId"] = os.environ["OMNI_BRANCH_ID"]
        r = s.post(f"{base}/v1/models/{model_id}/yaml", json=body, timeout=60)
        print(f"{fn}: {'ok' if r.status_code < 300 else 'FAIL ' + str(r.status_code)}")
        failed += r.status_code >= 300
        time.sleep(1.1)
    return failed


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("action", choices=["validate", "publish"])
    a = ap.parse_args()
    files = load()
    if not files:
        print("no model files; run scripts/omni_build.py")
        return 1
    problems = check(files)
    for p in problems:
        print("FAIL", p)
    print(f"{len(files)} model files checked, {len(problems)} problem(s)")
    if problems or a.action == "validate":
        return 1 if problems else 0
    return 1 if publish(files) else 0


if __name__ == "__main__":
    sys.exit(main())
