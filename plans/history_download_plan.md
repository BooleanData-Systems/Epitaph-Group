# History download plan

TapClicks closes on 28 Feb 2027 and there is no Data Exporter, so every month of history we keep must be
downloaded before then. The plan in `history_download_plan.csv` (and `.xlsx`) lists one row per source and month.

## Where history comes from

| Route | Used for | Check |
|---|---|---|
| Fivetran's own historical sync | Google Ads, Meta, Microsoft, LinkedIn, TikTok, Snapchat, Reddit, Pinterest, GA4, CM360, DV360 for Nov 2024 onward | Oct 2026 also downloaded from TapClicks and compared (R02, R03) |
| Original files Epitaph holds | Sonnet files, Direct Buy spend, Goals | Oct 2026 also downloaded from TapClicks and compared |
| TapClicks Data Table download, one file per source per month | Everything else: vendor files, SiriusXM, Adara, Amazon, The Trade Desk, sources that have stopped | Daily totals must match the file exactly (R06) |

## Order

| Priority | What | Due |
|---|---|---|
| P1 | Sources behind the 29 live dashboards, Nov 2025 to Nov 2026 | 20 Nov 2026 |
| P2 | The same sources, Nov 2024 to Oct 2025 | 4 Dec 2026 |
| P4 | Sources with no live route that had data in the last 24 months | 15 Jan 2027 |
| Compare | One all-sources download of the previous week, every Monday from 7 Dec to switch-off | Weekly |
| P5 | Anything before Nov 2024, back to 2020 | Only if Epitaph asks; must finish by 19 Feb 2027 |

`history_download_summary.csv` has the counts. P5 counts assume every source has data from Jan 2020; a month with
no data downloads as an empty file and is marked skipped.

## How a download is done
1. In TapClicks, open the Data Table for the source, set the month, include the columns Date, Data Source Name,
   Campaign Name, Media Buy Name, Creative Name, Conversion Tag Name, Impressions, Clicks, Spend, Starts,
   Completed Plays, Total Conversions.
2. Export to CSV and save it to SharePoint `Epitaph Reporting > Feeds > History > TapClicks` using the file name in
   the plan.
3. The loader picks it up within the hour (feed H01), stages it and loads it with COPY INTO.
4. Mark the row "downloaded" in the workbook. The next morning's history check marks it "matched" or lists the days
   that differ.
5. If a day differs for a known reason (for example the Reddit double count, Q001), record it in
   CONTROL.CTL_HISTORY_CORRECTIONS so the check treats it as expected.
