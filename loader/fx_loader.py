"""Bank of Canada exchange rates to BRONZE.REFERENCE.FX_RATES (replaces the exchange-rate Google Sheet, F18 and Q20).

Valet API, public, no key:  https://www.bankofcanada.ca/valet/observations/FXUSDCAD/json?start_date=2024-01-01
Rates are published for business days around 16:30 Eastern. Weekends and holidays have no rate; dim_fx_rate
carries the last published rate forward so every day has one.
"""
from __future__ import annotations

import datetime as dt
import json

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


def main(session, series: str = "FXUSDCAD", days_back: int = 10) -> str:
    """Stored procedure handler: BRONZE.REFERENCE.LOAD_FX_RATES(series, days_back). Re-reads recent days so revisions land."""
    last = session.sql("select max(rate_date) from BRONZE.REFERENCE.FX_RATES where series = ?", params=[series]).collect()[0][0]
    start = (last - dt.timedelta(days=days_back)) if last else dt.date(2020, 1, 1)
    rows = fetch(series, start)
    if not rows:
        return json.dumps({"series": series, "rows": 0})
    df = session.create_dataframe([(s, d, r) for s, d, r in rows], schema=["SERIES", "RATE_DATE", "RATE"])
    # Temporary table (the loader role can create tables, not views, in BRONZE.REFERENCE)
    df.write.mode("overwrite").save_as_table("BRONZE.REFERENCE.FX_NEW", table_type="temporary")
    session.sql("""merge into BRONZE.REFERENCE.FX_RATES t using BRONZE.REFERENCE.FX_NEW n
                   on t.series = n.series and t.rate_date = n.rate_date
                   when matched and t.rate <> n.rate then update set rate = n.rate, loaded_at = current_timestamp()
                   when not matched then insert (series, rate_date, rate) values (n.series, n.rate_date, n.rate)""").collect()
    return json.dumps({"series": series, "rows": len(rows), "from": start.isoformat()})
