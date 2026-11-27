# History download plan

TapClicks closes on 28 Feb 2027 and there is no Data Exporter, so every month of history to be kept must be
downloaded before then. **Epitaph downloads the files**: Boolean has no download access to TapClicks. The files
Epitaph is asked for are listed in `Epitaph_TapClicks_History_Files.xlsx`, which was shared with Epitaph and
replaces the earlier dates in this plan. `history_download_plan.csv` (and `.xlsx`) is the source list it was built
from: one row per source and month.

## Where history comes from

| Route | Used for | Check |
|---|---|---|
| Fivetran's own historical sync | Google Ads, Meta, Microsoft, LinkedIn, TikTok, Snapchat, Reddit, Pinterest, Spotify, GA4, CM360, DV360, as far back as each connector holds | Compared with the TapClicks history files for the overlapping months |
| Original files Epitaph holds | Sonnet files, Direct Buy spend, Goals | Compared with the TapClicks history files for the overlapping months |
| TapClicks history files downloaded by Epitaph, one file per source per month | Everything else: vendor files, SiriusXM, Adara, Amazon, The Trade Desk, sources that have stopped | Daily totals must match the file exactly (R06) |

## Order

| Priority | What |
|---|---|
| P1 | Sources behind the live dashboards, Nov 2025 to Nov 2026 |
| P2 | The same sources, Nov 2024 to Oct 2025 |
| P4 | Sources with no live route that had data in the last 24 months |
| Compare | One all-sources download of the previous week, every Monday until switch-off |
| P5 | Anything before Nov 2024, back to 2020, only if Epitaph asks; must finish before TapClicks closes |

`history_download_summary.csv` has the counts. P5 counts assume every source has data from Jan 2020; a month with
no data downloads as an empty file and is marked skipped.

## How a download is done (Epitaph)
1. In TapClicks, open the Data Table for the source, set the month, include the columns Date, Data Source Name,
   Campaign Name, Media Buy Name, Creative Name, Conversion Tag Name, Impressions, Clicks, Spend, Starts,
   Completed Plays, Total Conversions.
2. Export to CSV and save it to SharePoint `Epitaph Reporting > Feeds > History > TapClicks` using the file name in
   the list.
3. The loader picks it up within the hour (feed H01), stages it and loads it with COPY INTO.
4. The next morning's history check marks the month "matched" or lists the days that differ.
5. If a day differs for a known reason (for example the Reddit double count, Q001), it is recorded in
   CONTROL.CTL_HISTORY_CORRECTIONS so the check treats it as expected.
