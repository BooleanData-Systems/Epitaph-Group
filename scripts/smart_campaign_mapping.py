"""Smart Campaign mapping: which campaigns belong to which Smart Campaign.

TapClicks groups campaigns into Smart Campaigns ("Nulo: Gently Cooked") and nearly every widget filters on them.
In Snowflake the grouping lives in two tables:
  CONTROL.map_smart_campaign_rule      one rule per Smart Campaign (pattern on the campaign name or job number)
  CONTROL.map_smart_campaign_override  exact campaign -> Smart Campaign rows that beat any rule
dim_smart_campaign applies them (override first, then rules by priority, else "Unmapped" and a DQ row).

Commands (run by an engineer; the export holds real names, so never inside the automated code tools):

  seed      Read the dashboard specs and write seeds/dashboard_smart_campaigns.csv:
            every Smart Campaign each dashboard includes or excludes, plus seeds/filter_rules.csv for wildcards.
  propose   Read a TapClicks campaign export (CSV with a "Campaign Name" column, any date range) and the seed,
            and write a proposed rule and override file with a confidence score for review.
  check     Read the approved rule and override files and the export; report campaigns that map to none
            or to more than one Smart Campaign. Exit code 1 if any live-dashboard campaign is unmapped.

  python scripts/smart_campaign_mapping.py seed
  python scripts/smart_campaign_mapping.py propose --export /secure/tapclicks_campaigns.csv
  python scripts/smart_campaign_mapping.py check --export /secure/tapclicks_campaigns.csv
"""
import argparse
import csv
import fnmatch
import re
import sys
from collections import defaultdict
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
SEEDS = ROOT / "seeds"
SPECS = ROOT / "specs" / "dashboards"

STOP = {"the", "and", "of", "a", "to", "for", "in", "on", "q1", "q2", "q3", "q4", "2024", "2025", "2026", "2027"}


def parse_campaign(name):
    """Client_Campaign_Job_Lang_Country -> dict. Returns parts that exist; never fails."""
    parts = (name or "").split("_")
    out = {"client": parts[0] if parts else "", "campaign": parts[1] if len(parts) > 1 else name or "",
           "job": parts[2] if len(parts) > 2 else "", "language": parts[3] if len(parts) > 3 else "",
           "country": parts[4] if len(parts) > 4 else ""}
    out["follows_convention"] = len(parts) == 5 and bool(re.match(r"^\d{4}-\d+$", out["job"]))
    return out


def tokens(s):
    return {t for t in re.findall(r"[a-z0-9]+", (s or "").lower()) if t not in STOP and len(t) > 1}


def cmd_seed(_):
    rows, wild = [], []
    for f in sorted(SPECS.glob("D*.yml")):
        spec = yaml.safe_load(open(f))
        seen = set()
        for sec in spec["sections"]:
            for w in sec["widgets"]:
                for flt in w.get("filters", []):
                    if flt.get("field") == "smart_campaign":
                        mode = "include" if flt["op"] == "in" else "exclude"
                        for v in flt["values"]:
                            if (mode, v) not in seen:
                                seen.add((mode, v))
                                rows.append({"dashboard_id": spec["id"], "client": spec["client"], "mode": mode,
                                             "smart_campaign": v, "wildcard": "*" in v})
                    if flt.get("wildcard"):
                        for v in flt["values"]:
                            if "*" in v:
                                wild.append({"dashboard_id": spec["id"], "field": flt["field"], "pattern": v,
                                             "sql_like": v.replace("*", "%"), "decision": "Q009",
                                             "resolution": "pattern kept as a rule; review matches in the check report"})
    SEEDS.mkdir(exist_ok=True)
    _write(SEEDS / "dashboard_smart_campaigns.csv", rows)
    uniq = {(r["dashboard_id"], r["field"], r["pattern"]): r for r in wild}
    _write(SEEDS / "filter_rules.csv", list(uniq.values()))
    print(f"{len(rows)} dashboard Smart Campaign rows, {len(uniq)} wildcard filter rules")


def cmd_propose(a):
    seed = list(csv.DictReader(open(SEEDS / "dashboard_smart_campaigns.csv")))
    smart = sorted({r["smart_campaign"] for r in seed if "*" not in r["smart_campaign"]})
    campaigns = sorted({r["Campaign Name"] for r in csv.DictReader(open(a.export, encoding="utf-8-sig")) if r.get("Campaign Name")})
    rules, overrides = [], []
    for sc in smart:
        client, _, label = sc.partition(":")
        label = label.strip() or client
        rules.append({"smart_campaign": sc, "client": client.replace("NOT ", "").strip(), "rule_type": "campaign_contains",
                      "pattern": label, "priority": 100, "approved": "no"})
    for c in campaigns:
        p = parse_campaign(c)
        ct = tokens(p["campaign"])
        best, score = None, 0.0
        for sc in smart:
            client, _, label = sc.partition(":")
            if tokens(client) and not (tokens(client) & tokens(p["client"])):
                continue
            lt = tokens(label)
            if not lt:
                continue
            s = len(lt & ct) / len(lt)
            if s > score:
                best, score = sc, s
        overrides.append({"campaign_name": c, "client_part": p["client"], "follows_convention": p["follows_convention"],
                          "proposed_smart_campaign": best or "", "confidence": round(score, 2),
                          "approved_smart_campaign": best if score >= 0.99 else "", "reviewer": ""})
    _write(Path(a.out_dir) / "proposed_smart_campaign_rules.csv", rules)
    _write(Path(a.out_dir) / "proposed_smart_campaign_overrides.csv", overrides)
    hi = sum(1 for o in overrides if o["confidence"] >= 0.99)
    print(f"{len(campaigns)} campaigns: {hi} matched with full confidence, {len(campaigns) - hi} need review")


def assign(campaign, rules, overrides):
    if campaign in overrides:
        return [overrides[campaign]]
    hits = []
    for r in sorted(rules, key=lambda r: int(r["priority"])):
        pat = r["pattern"]
        if r["rule_type"] == "campaign_contains" and pat.lower() in campaign.lower():
            hits.append(r["smart_campaign"])
        elif r["rule_type"] == "campaign_like" and fnmatch.fnmatch(campaign.lower(), pat.lower().replace("%", "*")):
            hits.append(r["smart_campaign"])
        elif r["rule_type"] == "job_number" and parse_campaign(campaign)["job"] == pat:
            hits.append(r["smart_campaign"])
    return hits


def cmd_check(a):
    rules = [r for r in csv.DictReader(open(SEEDS / "map_smart_campaign_rule.csv")) if r.get("approved", "yes") == "yes"]
    ovr = {r["campaign_name"]: r["smart_campaign"] for r in csv.DictReader(open(SEEDS / "map_smart_campaign_override.csv"))}
    campaigns = sorted({r["Campaign Name"] for r in csv.DictReader(open(a.export, encoding="utf-8-sig")) if r.get("Campaign Name")})
    unmapped, multi = [], []
    for c in campaigns:
        h = assign(c, rules, ovr)
        if not h:
            unmapped.append(c)
        elif len(set(h)) > 1 and int(next(r["priority"] for r in rules if r["smart_campaign"] == h[0])) == \
                int(next(r["priority"] for r in rules if r["smart_campaign"] == h[1])):
            multi.append((c, h))
    print(f"campaigns {len(campaigns)}, unmapped {len(unmapped)}, ambiguous {len(multi)}")
    # Print counts only so the output can be shared without names.
    sys.exit(1 if unmapped and a.strict else 0)


def _write(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        path.write_text("")
        return
    with open(path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("seed")
    p = sub.add_parser("propose")
    p.add_argument("--export", required=True)
    p.add_argument("--out-dir", default="review")
    c = sub.add_parser("check")
    c.add_argument("--export", required=True)
    c.add_argument("--strict", action="store_true")
    a = ap.parse_args()
    {"seed": cmd_seed, "propose": cmd_propose, "check": cmd_check}[a.cmd](a)
