"""Bank of Canada exchange rates to BRONZE.REFERENCE.FX_RATES (replaces the exchange-rate Google Sheet, F18 and Q20).

Valet API, public, no key:  https://www.bankofcanada.ca/valet/observations/FXUSDCAD/json?start_date=2024-01-01
Rates are published for business days around 16:30 Eastern. Weekends and holidays have no rate; dim_fx_rate
carries the last published rate forward so every day has one.
"""
from __future__ import annotations

import datetime as dt
import json
import math
import re

VALET = "https://www.bankofcanada.ca/valet/observations/{series}/json"


def parse_observations(payload: dict, series: str) -> list[tuple[str, dt.date, float]]:
    out = []
    for obs in payload.get("observations", []):
        v = (obs.get(series) or {}).get("v")
        if v in (None, ""):
            continue
        out.append((series, dt.date.fromisoformat(obs["d"]), float(v)))
    return out


def fetch(series: str, start: dt.date, get=None) -> list[tuple[str, dt.date, float]]:
    if get is None:
        import requests
        get = lambda url, params: requests.get(url, params=params, timeout=30).json()  # noqa: E731
    payload = get(VALET.format(series=series), {"start_date": start.isoformat()})
    return parse_observations(payload, series)


def merge_statements(rows: list[tuple[str, dt.date, float]], chunk: int = 500) -> list[str]:
    """MERGE statements with the rates inline, `chunk` rows each.

    The procedure runs with owner's rights, which cannot create temporary tables, and Snowpark's create_dataframe
    makes one for more than 512 rows. So the rows go in a VALUES list instead. Every value is built here from a parsed
    date and a float, and the series name is checked, so nothing from outside reaches the SQL as free text.
    """
    out = []
    for i in range(0, len(rows), chunk):
        values = []
        for s, d, r in rows[i:i + chunk]:
            if not re.fullmatch(r"[A-Z0-9_]+", s):
                raise ValueError(f"unexpected series name {s!r}")
            if not math.isfinite(r):
                raise ValueError(f"rate for {d} is not a number")
            values.append(f"('{s}', '{d.isoformat()}'::date, {r!r}::number(18,6))")
        out.append("merge into BRONZE.REFERENCE.FX_RATES t "
                   "using (select column1 as series, column2 as rate_date, column3 as rate from values "
                   + ", ".join(values) + ") n "
                   "on t.series = n.series and t.rate_date = n.rate_date "
                   "when matched and t.rate <> n.rate then update set rate = n.rate, loaded_at = current_timestamp() "
                   "when not matched then insert (series, rate_date, rate) values (n.series, n.rate_date, n.rate)")
    return out


def main(session, series: str = "FXUSDCAD", days_back: int = 10) -> str:
    """Stored procedure handler: BRONZE.REFERENCE.LOAD_FX_RATES(series, days_back). Re-reads recent days so revisions land."""
    last = session.sql("select max(rate_date) from BRONZE.REFERENCE.FX_RATES where series = ?", params=[series]).collect()[0][0]
    start = (last - dt.timedelta(days=days_back)) if last else dt.date(2020, 1, 1)
    rows = fetch(series, start)
    if not rows:
        return json.dumps({"series": series, "rows": 0})
    for stmt in merge_statements(rows):
        session.sql(stmt).collect()
    return json.dumps({"series": series, "rows": len(rows), "from": start.isoformat(),
                       "to": max(d for _, d, _ in rows).isoformat()})
