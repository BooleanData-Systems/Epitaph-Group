"""Swap real client, campaign and Smart Campaign names for codes, and back.

Used so automated code work can happen on a masked copy of the repo: the copy has C01, SC014, CMP0007 instead of
names. The mapping file lives outside the repo (for example in the team's password manager or a locked folder) and
is never given to the automated tools.

  python scripts/mask.py build-map --out /secure/mask_map.csv            # from seeds (run by an engineer)
  python scripts/mask.py mask   --map /secure/mask_map.csv --src . --dst ../epitaph-masked
  python scripts/mask.py unmask --map /secure/mask_map.csv --src ../epitaph-masked --dst .   --paths scripts snowflake

Masking is plain text replacement, longest name first, whole-word where the name allows it.
"""
import argparse
import csv
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEXT = {".py", ".sql", ".yml", ".yaml", ".md", ".csv", ".json", ".txt", ".toml", ".cfg", ".sh"}
SKIP_DIRS = {".git", "__pycache__", ".venv", "review", ".pytest_cache"}
SKIP_FILES = {"mask.py"}   # holds the alias list itself; never copied into the masked tree


# Short names and abbreviations used inside source, file and KPI names
ALIASES = {"Sonnet Insurance": ["Sonnet"], "SiriusXM": ["SXM", "Sirius XM"], "Kids Help Phone": ["KHP"],
           "Cobs Bread": ["Cobs", "COBS"], "Ottawa Tourism": ["Ottawa"], "Kicking Horse Coffee": ["Kicking Horse", "KHC"],
           "Wurth Canada": ["Wurth"], "Conexus": [], "Nulo": [], "Aquamar": [], "BDO": [], "Embark": [], "Sysco": []}


def slug(s):
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def build_map(out):
    pairs = {}
    for r in csv.DictReader(open(ROOT / "seeds" / "map_client_account.csv")):
        code = "MASK" + r["client_code"]           # MASKC08: cannot clash with real values such as C08
        pairs.setdefault(r["client_name"], code)
        if r["tapclicks_client_account"] != r["client_name"]:
            k = sum(1 for v in pairs.values() if v.startswith(code + "ACCOUNT")) + 1
            pairs.setdefault(r["tapclicks_client_account"], f"{code}ACCOUNT{k}")
        # Every other spelling gets its own code so unmasking is exact
        n = 1
        for name in [r["client_name"]] + ALIASES.get(r["client_name"], []):
            for variant in (name, slug(name), name.lower().replace(" ", "_"), name.upper().replace(" ", "_")):
                if variant not in pairs:
                    pairs[variant] = f"{code}V{n}"
                    n += 1
    sc = sorted({r["smart_campaign"] for r in csv.DictReader(open(ROOT / "seeds" / "dashboard_smart_campaigns.csv"))})
    for i, name in enumerate(sc, 1):
        pairs.setdefault(name, f"MASKSC{i:03d}")
    with open(out, "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["real", "code"])
        for k, v in sorted(pairs.items(), key=lambda kv: -len(kv[0])):
            w.writerow([k, v])
    print(f"{len(pairs)} names in the map")


def load(path, reverse=False):
    rows = list(csv.DictReader(open(path)))
    pairs = [(r["code"], r["real"]) if reverse else (r["real"], r["code"]) for r in rows]
    return sorted(pairs, key=lambda p: -len(p[0]))


def swap(text, pairs):
    for a, b in pairs:
        pat = re.escape(a)
        if a[0].isalnum() and a[-1].isalnum():
            pat = r"(?<![A-Za-z0-9])" + pat + r"(?![A-Za-z0-9])"
        text = re.sub(pat, b, text)
    return text


def copy_tree(src, dst, pairs, paths=None):
    src, dst = Path(src), Path(dst)
    n = 0
    roots = [src / p for p in paths] if paths else [src]
    for root in roots:
        for f in ([root] if root.is_file() else root.rglob("*")):
            if f.is_dir() or any(part in SKIP_DIRS for part in f.parts) or f.name in SKIP_FILES:
                continue
            rel = f.relative_to(src)
            out = dst / swap(str(rel), pairs)
            out.parent.mkdir(parents=True, exist_ok=True)
            if f.suffix.lower() in TEXT:
                out.write_bytes(swap(f.read_bytes().decode("utf-8", errors="surrogateescape"), pairs)
                                .encode("utf-8", errors="surrogateescape"))
            else:
                shutil.copy2(f, out)
            n += 1
    print(f"{n} files written to {dst}")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    b = sub.add_parser("build-map")
    b.add_argument("--out", required=True)
    for name in ("mask", "unmask"):
        p = sub.add_parser(name)
        p.add_argument("--map", required=True)
        p.add_argument("--src", required=True)
        p.add_argument("--dst", required=True)
        p.add_argument("--paths", nargs="*")
    a = ap.parse_args()
    if a.cmd == "build-map":
        build_map(a.out)
    else:
        copy_tree(a.src, a.dst, load(a.map, reverse=(a.cmd == "unmask")), a.paths)
