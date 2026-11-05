"""Per-client access in Omni: which user group sees which dashboards, which rows and which column groups.

  python scripts/omni_access.py matrix     # writes omni/access_matrix.csv (review it in the pull request)
  python scripts/omni_access.py apply      # CI only: sets each user's client_code and cg_* attributes in Omni

Three layers, all driven by the seeds:
  1. Dashboards: each client's user group ("Client - Nulo") gets view access to its own dashboards only
     (seeds/map_client_account.csv). Shared once per dashboard in Omni, listed in the matrix.
  2. Rows: the Omni model filters every query on the viewer's client_code user attribute (access_filters in
     omni/model/media_performance.topic.yaml). Epitaph staff carry ALL.
  3. Columns: each column group is an access grant in omni/model/model.yaml on user attribute cg_<group>.
     A user sees a group when that attribute is "yes" (seeds/client_column_access.csv decides per client).

`apply` reads omni/users.yml, which lists Omni user ids per client code (kept in Epitaph's repo, ids only, no
emails), and sets the attributes through Omni's SCIM API:
  GET /scim/v2/users/{userId}    read the user (PUT replaces the whole user, so the rest is kept)
  PUT /scim/v2/users/{userId}    with "urn:omni:params:1.0:UserAttribute": {client_code, cg_spend, ...}
Environment: OMNI_BASE_URL (https://<instance>.omniapp.co/api), OMNI_API_KEY (organization API key).
Output is counts and pass or fail only, never names or emails.
"""
import csv
import os
import sys
import time
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
ATTR = "urn:omni:params:1.0:UserAttribute"


def load():
    clients = {}
    for r in csv.DictReader(open(ROOT / "seeds" / "map_client_account.csv")):
        c = clients.setdefault(r["client_code"], {"name": r["client_name"], "dashboards": []})
        c["dashboards"] += r["dashboards"].split()
    groups = [g["column_group"] for g in csv.DictReader(open(ROOT / "seeds" / "column_groups.csv"))]
    rules = {(r["client_code"], r["column_group"]): r["access"] for r in csv.DictReader(open(ROOT / "seeds" / "client_column_access.csv"))}
    return clients, groups, rules


def access(rules, code, group):
    if group == "identity":
        return "show"
    return rules.get((code, group)) or rules.get(("*", group)) or "hide"


def attributes(rules, groups, code):
    """The Omni user attributes for a user of this client (ALL = Epitaph staff: every row and column)."""
    out = {"client_code": code}
    for g in groups:
        if g != "identity":
            out[f"cg_{g}"] = "yes" if code == "ALL" or access(rules, code, g) == "show" else "no"
    return out


def matrix():
    clients, groups, rules = load()
    out = ROOT / "omni" / "access_matrix.csv"
    out.parent.mkdir(exist_ok=True)
    with open(out, "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["client_code", "omni_user_group", "user_attribute_client_code", "dashboards"] + groups)
        for code, c in sorted(clients.items()):
            w.writerow([code, f"Client - {c['name']}", code, " ".join(sorted(set(c["dashboards"])))]
                       + [access(rules, code, g) for g in groups])
        w.writerow(["ALL", "Epitaph", "ALL", "all"] + ["show"] * len(groups))
    print(f"{len(clients)} client user groups written to {out.relative_to(ROOT)}")


def apply():
    import requests
    base = os.environ["OMNI_BASE_URL"].rstrip("/")
    s = requests.Session()
    s.headers["Authorization"] = "Bearer " + os.environ["OMNI_API_KEY"]
    users = yaml.safe_load((ROOT / "omni" / "users.yml").read_text()) or {}
    _, groups, rules = load()
    ok = failed = 0
    for code, ids in sorted(users.items()):
        want = attributes(rules, groups, code)
        for uid in ids or []:
            r = s.get(f"{base}/scim/v2/users/{uid}", timeout=30)
            if r.status_code >= 300:
                failed += 1
                continue
            user = r.json()
            body = {k: user[k] for k in ("userName", "displayName", "active") if k in user}
            body[ATTR] = {**(user.get(ATTR) or {}), **want}
            for k, v in user.items():
                if k.startswith("urn:omni:params:scim:schemas:extension:user"):
                    body[k] = v
            r = s.put(f"{base}/scim/v2/users/{uid}", json=body, timeout=30)
            ok += r.status_code < 300
            failed += r.status_code >= 300
            time.sleep(2.1)   # two calls per user; Omni allows 60 requests a minute
        print(f"{code}: {len(ids or [])} users")
    print(f"{ok} users updated, {failed} failed")
    return 1 if failed else 0


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "matrix"
    sys.exit(apply() if cmd == "apply" else (matrix() or 0))
