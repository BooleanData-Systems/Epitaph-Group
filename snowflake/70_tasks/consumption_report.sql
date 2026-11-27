-- Daily consumption report (Kickstart Checklist 3, "Create consumption report"), adapted from the Boolean kickstart
-- template (consumption_report.sql). The email layout is the template's, unchanged.
-- Differences from the template, all to fit this account:
--   * lives in GOLD.ADMIN with the other monitoring objects (no separate ADMIN database); runs as EPITAPH_TRANSFORMER
--   * sends through EPITAPH_EMAIL; recipients are GOLD.CONTROL.ALERT_RECIPIENTS rows named 'consumption_report'
--   * Toronto time; 3.50 per credit and 25 per TB of storage, the rates in this account's rate sheet
--   * daily limits are filled in below from the monthly monitor quotas in 04_monitoring.sql; a warehouse added later
--     appears as "Not Configured" until someone sets its limit
-- Edit a limit:  update GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG set daily_credit_limit = <n> where warehouse_name = '<WH>';
-- Stop reporting on a dropped warehouse:  update GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG set is_active = false where warehouse_name = '<WH>';
-- Test (sends the real email):  call GOLD.ADMIN.SP_CONSUMPTION_REPORT('Epitaph');
use role EPITAPH_TRANSFORMER;
use warehouse WH_TRANSFORMATION;

create table if not exists GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG (
    WAREHOUSE_NAME      VARCHAR(255)    NOT NULL PRIMARY KEY   COMMENT 'Warehouse name from Snowflake',
    ENVIRONMENT         VARCHAR(100)    DEFAULT 'UNKNOWN'      COMMENT 'PROD, DEV, QA etc.',
    DAILY_CREDIT_LIMIT  NUMBER(38,2)    DEFAULT 0              COMMENT 'Credits per day. 0 = not yet configured.',
    CREDIT_PRICE_USD    NUMBER(10,2)    DEFAULT 3.50           COMMENT 'Price per credit in USD',
    IS_ACTIVE           BOOLEAN         DEFAULT TRUE           COMMENT 'Set FALSE to stop reporting on this warehouse',
    AUTO_DISCOVERED     BOOLEAN         DEFAULT TRUE           COMMENT 'TRUE = inserted automatically by the sync procedure',
    FIRST_SEEN_DATE     DATE                                   COMMENT 'Date the warehouse first appeared in metering history',
    CREATED_AT          TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP()
);

create table if not exists GOLD.ADMIN.WH_ALERT_HISTORY (
    REPORT_TIMESTAMP    TIMESTAMP_NTZ   NOT NULL    COMMENT 'When the report was generated (Toronto time)',
    REPORT_DATE         DATE            NOT NULL    COMMENT 'Date of the report run',
    WAREHOUSE_NAME      VARCHAR(255)    NOT NULL    COMMENT 'Warehouse reported on',
    ENVIRONMENT         VARCHAR(100)                COMMENT 'Environment tag',
    CREDITS_USED        NUMBER(38,2)                COMMENT 'Credits used in the last 24 hours',
    DAILY_CREDIT_LIMIT  NUMBER(38,2)                COMMENT 'Daily limit at the time',
    PERCENT_USED        NUMBER(38,2)                COMMENT 'Percent of the daily limit used',
    EMAIL_SENT_TO       VARCHAR(2000)               COMMENT 'Recipients emailed',
    ALERT_STATUS        VARCHAR(50)                 COMMENT 'EXCEEDED_LIMIT / WITHIN_LIMIT / NOT_CONFIGURED'
);

-- Daily limits: monthly monitor quota / 30, rounded (04_monitoring.sql: LOAD 100, TRANSFORMATION 120, REPORTING 160,
-- ADHOC 20). WH_HISTORY has one 150-credit allowance for the whole history load; 25 a day is a placeholder to confirm.
-- Only adds missing rows, so limits edited later are kept.
merge into GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG t
using (select column1 as warehouse_name, column2 as daily_limit from values
         ('WH_LOAD', 3.50), ('WH_TRANSFORMATION', 4.00), ('WH_REPORTING', 5.50), ('WH_ADHOC', 1.00), ('WH_HISTORY', 25.00)) s
on t.warehouse_name = s.warehouse_name
when not matched then insert (warehouse_name, environment, daily_credit_limit, auto_discovered, first_seen_date)
  values (s.warehouse_name, 'PROD', s.daily_limit, false, current_date());

-- Recipients: GOLD.CONTROL.ALERT_RECIPIENTS rows with alert_name 'consumption_report', kept in Snowflake only (a
-- deploy never writes them; see control_tables.sql).

-- Picks up warehouses created after this was deployed, with no limit until one is set. Skips Snowflake's own
-- pseudo-warehouses (CLOUD_SERVICES_ONLY and the SYSTEM$ notebook warehouse).
create or replace procedure GOLD.ADMIN.SP_SYNC_WAREHOUSE_CONFIG()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    V_INSERTED NUMBER DEFAULT 0;
BEGIN
    INSERT INTO GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG (
        WAREHOUSE_NAME, ENVIRONMENT, DAILY_CREDIT_LIMIT, CREDIT_PRICE_USD, IS_ACTIVE, AUTO_DISCOVERED, FIRST_SEEN_DATE, CREATED_AT
    )
    SELECT H.WAREHOUSE_NAME, 'UNKNOWN', 0, 3.50, TRUE, TRUE, MIN(H.START_TIME)::DATE, CURRENT_TIMESTAMP()
    FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY H
    WHERE H.WAREHOUSE_NAME <> 'CLOUD_SERVICES_ONLY'
      AND H.WAREHOUSE_NAME NOT LIKE 'SYSTEM$%'
      AND NOT EXISTS (
        SELECT 1 FROM GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG C WHERE C.WAREHOUSE_NAME = H.WAREHOUSE_NAME
      )
    GROUP BY H.WAREHOUSE_NAME;

    V_INSERTED := SQLROWCOUNT;
    RETURN 'Sync complete. New warehouses discovered: ' || V_INSERTED
        || '. Update DAILY_CREDIT_LIMIT and ENVIRONMENT for any rows where DAILY_CREDIT_LIMIT = 0.';
END;
$$;

CREATE OR REPLACE PROCEDURE GOLD.ADMIN.SP_CONSUMPTION_REPORT(P_CLIENT_NAME VARCHAR)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    V_SUBJECT               STRING;
    V_BODY                  STRING;
    V_ROWS                  STRING DEFAULT '';
    V_COUNT                 NUMBER DEFAULT 0;
    V_OVER_BUDGET_COUNT     NUMBER DEFAULT 0;
    V_NOT_CONFIGURED_COUNT  NUMBER DEFAULT 0;
    V_EMAIL_TO              STRING;
    V_NOW_LOCAL               TIMESTAMP_TZ;
    V_START_LOCAL             TIMESTAMP_TZ;
    V_END_LOCAL               TIMESTAMP_TZ;
    V_EMAIL_INT             STRING DEFAULT 'EPITAPH_EMAIL';
    V_WH_NAME               STRING;
    V_ENVIRONMENT           STRING;
    V_CREDITS_USED          NUMBER(38,2);
    V_DAILY_CREDIT_LIMIT    NUMBER(38,2);
    V_PERCENT_USED          NUMBER(38,2);
    V_IS_OVER_LIMIT         BOOLEAN;
    V_IS_NOT_CONFIGURED     BOOLEAN;
    V_CREDIT_PRICE          NUMBER(10,2);
    V_DOLLAR_COST           NUMBER(38,2);
    V_MTD_CREDITS           NUMBER(38,2);
    V_MTD_DOLLARS           NUMBER(38,2);
    V_YTD_CREDITS           NUMBER(38,2);
    V_YTD_DOLLARS           NUMBER(38,2);
    V_STORAGE_TB            NUMBER(38,4);
    V_STORAGE_COST          NUMBER(38,2);
    RS                      RESULTSET;
BEGIN

    -- Step 1: Auto-sync any new warehouses into config before running report
    CALL GOLD.ADMIN.SP_SYNC_WAREHOUSE_CONFIG();

    -- Step 2: Set time window (last 24 hours, Toronto time)
    V_NOW_LOCAL   := CONVERT_TIMEZONE('America/Toronto', CURRENT_TIMESTAMP()::TIMESTAMP_TZ);
    V_END_LOCAL   := DATE_TRUNC('HOUR', V_NOW_LOCAL);
    V_START_LOCAL := DATEADD('DAY', -1, V_END_LOCAL);

    -- Step 3: Recipients come from GOLD.CONTROL.ALERT_RECIPIENTS (alert_name 'consumption_report'), like every other alert
    SELECT LISTAGG(EMAIL, ',') WITHIN GROUP (ORDER BY EMAIL)
    INTO :V_EMAIL_TO
    FROM (
        SELECT DISTINCT TRIM(EMAIL) AS EMAIL
        FROM GOLD.CONTROL.ALERT_RECIPIENTS
        WHERE ALERT_NAME = 'consumption_report'
          AND TRIM(EMAIL) <> ''
    );

    IF (V_EMAIL_TO IS NULL OR TRIM(V_EMAIL_TO) = '') THEN
        RETURN 'No recipients found. Add rows to GOLD.CONTROL.ALERT_RECIPIENTS for alert_name consumption_report.';
    END IF;

    -- Step 4: Get latest storage usage
    SELECT
        ROUND((STORAGE_BYTES + STAGE_BYTES + FAILSAFE_BYTES) / POWER(1024, 4), 4),
        ROUND((STORAGE_BYTES + STAGE_BYTES + FAILSAFE_BYTES) / POWER(1024, 4) * 25.00, 2)
    INTO :V_STORAGE_TB, :V_STORAGE_COST
    FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE
    WHERE USAGE_DATE = (SELECT MAX(USAGE_DATE) FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE);

    -- Step 5: Build warehouse-level usage result set
    RS := (
        WITH USAGE_TODAY AS (
            SELECT
                WAREHOUSE_NAME,
                SUM(CREDITS_USED) AS CREDITS_USED
            FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
            WHERE START_TIME >= CONVERT_TIMEZONE('America/Toronto', 'UTC', :V_START_LOCAL::TIMESTAMP_NTZ)::TIMESTAMP_LTZ
              AND START_TIME <  CONVERT_TIMEZONE('America/Toronto', 'UTC', :V_END_LOCAL::TIMESTAMP_NTZ)::TIMESTAMP_LTZ
            GROUP BY WAREHOUSE_NAME
        ),
        USAGE_MTD AS (
            SELECT
                WAREHOUSE_NAME,
                SUM(CREDITS_USED) AS CREDITS_USED
            FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
            WHERE START_TIME >= DATE_TRUNC('MONTH', CURRENT_DATE())
            GROUP BY WAREHOUSE_NAME
        ),
        USAGE_YTD AS (
            SELECT
                WAREHOUSE_NAME,
                SUM(CREDITS_USED) AS CREDITS_USED
            FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
            WHERE START_TIME >= DATE_TRUNC('YEAR', CURRENT_DATE())
            GROUP BY WAREHOUSE_NAME
        )
        SELECT
            C.WAREHOUSE_NAME,
            C.ENVIRONMENT,
            COALESCE(U.CREDITS_USED, 0)                                                         AS CREDITS_USED,
            C.DAILY_CREDIT_LIMIT,
            CASE
                WHEN C.DAILY_CREDIT_LIMIT = 0 THEN NULL
                ELSE ROUND(COALESCE(U.CREDITS_USED, 0) / C.DAILY_CREDIT_LIMIT * 100, 2)
            END                                                                                  AS PERCENT_USED,
            CASE
                WHEN C.DAILY_CREDIT_LIMIT = 0 THEN FALSE
                WHEN COALESCE(U.CREDITS_USED, 0) >= C.DAILY_CREDIT_LIMIT THEN TRUE
                ELSE FALSE
            END                                                                                  AS IS_OVER_LIMIT,
            CASE
                WHEN C.DAILY_CREDIT_LIMIT = 0 THEN TRUE
                ELSE FALSE
            END                                                                                  AS IS_NOT_CONFIGURED,
            COALESCE(C.CREDIT_PRICE_USD, 3.50)                                                  AS CREDIT_PRICE,
            ROUND(COALESCE(U.CREDITS_USED, 0) * COALESCE(C.CREDIT_PRICE_USD, 3.50), 2)         AS DOLLAR_COST,
            COALESCE(M.CREDITS_USED, 0)                                                         AS MTD_CREDITS,
            ROUND(COALESCE(M.CREDITS_USED, 0) * COALESCE(C.CREDIT_PRICE_USD, 3.50), 2)         AS MTD_DOLLARS,
            COALESCE(Y.CREDITS_USED, 0)                                                         AS YTD_CREDITS,
            ROUND(COALESCE(Y.CREDITS_USED, 0) * COALESCE(C.CREDIT_PRICE_USD, 3.50), 2)         AS YTD_DOLLARS
        FROM GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG C
        LEFT JOIN USAGE_TODAY U ON C.WAREHOUSE_NAME = U.WAREHOUSE_NAME
        LEFT JOIN USAGE_MTD   M ON C.WAREHOUSE_NAME = M.WAREHOUSE_NAME
        LEFT JOIN USAGE_YTD   Y ON C.WAREHOUSE_NAME = Y.WAREHOUSE_NAME
        WHERE C.IS_ACTIVE = TRUE
        ORDER BY C.ENVIRONMENT, C.WAREHOUSE_NAME
    );

    -- Step 6: Loop through results and build HTML rows
    FOR REC IN RS DO
        V_WH_NAME           := REC.WAREHOUSE_NAME;
        V_ENVIRONMENT       := REC.ENVIRONMENT;
        V_CREDITS_USED      := REC.CREDITS_USED;
        V_DAILY_CREDIT_LIMIT := REC.DAILY_CREDIT_LIMIT;
        V_PERCENT_USED      := REC.PERCENT_USED;
        V_IS_OVER_LIMIT     := REC.IS_OVER_LIMIT;
        V_IS_NOT_CONFIGURED := REC.IS_NOT_CONFIGURED;
        V_CREDIT_PRICE      := REC.CREDIT_PRICE;
        V_DOLLAR_COST       := REC.DOLLAR_COST;
        V_MTD_CREDITS       := REC.MTD_CREDITS;
        V_MTD_DOLLARS       := REC.MTD_DOLLARS;
        V_YTD_CREDITS       := REC.YTD_CREDITS;
        V_YTD_DOLLARS       := REC.YTD_DOLLARS;

        V_COUNT := V_COUNT + 1;

        IF (V_IS_NOT_CONFIGURED) THEN
            V_NOT_CONFIGURED_COUNT := V_NOT_CONFIGURED_COUNT + 1;
        ELSEIF (V_IS_OVER_LIMIT) THEN
            V_OVER_BUDGET_COUNT := V_OVER_BUDGET_COUNT + 1;
        END IF;

        -- Row background: red = over limit, yellow = not configured, green = within limit
        V_ROWS := V_ROWS ||
            '<tr style="background-color:' ||
                CASE
                    WHEN V_IS_NOT_CONFIGURED THEN '#fffbeb'
                    WHEN V_IS_OVER_LIMIT     THEN '#fef2f2'
                    ELSE                          '#f0fdf4'
                END ||
            ';">'
            -- Warehouse name
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;font-weight:700;color:#1e293b;font-size:15px;">'
            ||   COALESCE(V_WH_NAME, '')
            || '</td>'
            -- Environment badge
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:center;">'
            ||   '<span style="background-color:#e0e7ff;color:#3730a3;padding:5px 14px;border-radius:14px;font-size:12px;font-weight:700;">'
            ||     COALESCE(V_ENVIRONMENT, 'UNKNOWN')
            ||   '</span>'
            || '</td>'
            -- Credits used (24h)
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:right;font-weight:700;font-size:15px;">'
            ||   TO_VARCHAR(V_CREDITS_USED)
            || '</td>'
            -- Dollar cost (24h)
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:right;font-weight:700;font-size:15px;">$'
            ||   TO_VARCHAR(V_DOLLAR_COST)
            || '</td>'
            -- Daily limit
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:right;color:#64748b;font-size:15px;">'
            ||   CASE WHEN V_IS_NOT_CONFIGURED THEN '<em style="color:#d97706;">Not Set</em>' ELSE TO_VARCHAR(V_DAILY_CREDIT_LIMIT) END
            || '</td>'
            -- % used
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:right;font-weight:700;color:'
            ||   CASE
                    WHEN V_IS_NOT_CONFIGURED THEN '#d97706'
                    WHEN V_IS_OVER_LIMIT     THEN '#dc2626'
                    WHEN V_PERCENT_USED >= 75 THEN '#d97706'
                    ELSE                          '#16a34a'
                 END ||
            ';">'
            ||   CASE WHEN V_IS_NOT_CONFIGURED THEN '—' ELSE TO_VARCHAR(V_PERCENT_USED) || '%' END
            || '</td>'
            -- MTD
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:right;font-size:14px;">'
            ||   TO_VARCHAR(V_MTD_CREDITS) || ' / <span style="font-weight:700;color:#2563eb;">$' || TO_VARCHAR(V_MTD_DOLLARS) || '</span>'
            || '</td>'
            -- YTD
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:right;font-size:14px;">'
            ||   TO_VARCHAR(V_YTD_CREDITS) || ' / <span style="font-weight:700;color:#7c3aed;">$' || TO_VARCHAR(V_YTD_DOLLARS) || '</span>'
            || '</td>'
            -- Status badge
            || '<td style="padding:14px 18px;border-bottom:1px solid #e2e8f0;text-align:center;">'
            ||   CASE
                    WHEN V_IS_NOT_CONFIGURED THEN
                        '<span style="background-color:#d97706;color:#ffffff;padding:6px 18px;border-radius:14px;font-size:13px;font-weight:700;">&#9888; Not Configured</span>'
                    WHEN V_IS_OVER_LIMIT THEN
                        '<span style="background-color:#dc2626;color:#ffffff;padding:6px 18px;border-radius:14px;font-size:13px;font-weight:700;">&#9888; Exceeded</span>'
                    ELSE
                        '<span style="background-color:#16a34a;color:#ffffff;padding:6px 18px;border-radius:14px;font-size:13px;font-weight:700;">&#10003; Within Limit</span>'
                 END
            || '</td>'
            || '</tr>';

        -- Audit log insert
        INSERT INTO GOLD.ADMIN.WH_ALERT_HISTORY
        SELECT
            :V_NOW_LOCAL::TIMESTAMP_NTZ,
            CAST(:V_NOW_LOCAL AS DATE),
            :V_WH_NAME,
            :V_ENVIRONMENT,
            :V_CREDITS_USED,
            :V_DAILY_CREDIT_LIMIT,
            :V_PERCENT_USED,
            :V_EMAIL_TO,
            CASE
                WHEN :V_IS_NOT_CONFIGURED THEN 'NOT_CONFIGURED'
                WHEN :V_IS_OVER_LIMIT     THEN 'EXCEEDED_LIMIT'
                ELSE                           'WITHIN_LIMIT'
            END;

    END FOR;

    IF (V_COUNT = 0) THEN
        RETURN 'No active warehouses found in config.';
    END IF;

    -- Step 7: Build email subject
    V_SUBJECT := 'Consumption Report — ' || P_CLIENT_NAME || ' — ' || TO_VARCHAR(CAST(V_NOW_LOCAL AS DATE));

    -- Step 8: Build full HTML email
    V_BODY :=
        '<html xmlns="http://www.w3.org/1999/xhtml"><head>'
        || '<meta name="color-scheme" content="light dark">'
        || '<style>.logo-box{background-color:#ffffff !important;}</style>'
        || '</head><body style="margin:0;padding:0;background-color:#eef1f6;font-family:Arial,Helvetica,sans-serif;">'
        || '<table width="100%" cellpadding="0" cellspacing="0" style="background-color:#eef1f6;padding:40px 0;"><tr><td align="center">'
        || '<table width="980" cellpadding="0" cellspacing="0" style="background-color:#ffffff;border-radius:16px;box-shadow:0 4px 24px rgba(0,0,0,0.08);overflow:hidden;">'

        -- Header
        || '<tr><td style="background-color:#0f1b3d;padding:32px 45px;">'
        || '<table width="100%" cellpadding="0" cellspacing="0"><tr>'
        || '<td valign="middle">'
        ||   '<table cellpadding="0" cellspacing="0"><tr>'
        ||     '<td class="logo-box" style="background-color:#ffffff !important;border-radius:10px;padding:10px 18px;">'
        ||       '<img src="https://booleandata.ai/wp-content/uploads/2026/04/Booelan-loh.jpg" alt="Boolean Data Systems" style="height:42px;max-width:180px;display:block;" />'
        ||     '</td>'
        ||   '</tr></table>'
        || '</td>'
        || '<td align="right" valign="middle">'
        ||   '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Snowflake_Logo.svg/200px-Snowflake_Logo.svg.png" alt="Snowflake" style="height:28px;display:block;" />'
        || '</td>'
        || '</tr></table></td></tr>'

        -- Title
        || '<tr><td style="background-color:#0f1b3d;padding:0 45px 32px;">'
        || '<h1 style="margin:0;color:#ffffff;font-size:28px;font-weight:800;">Warehouse Consumption Report</h1>'
        || '<p style="margin:6px 0 0;color:#93b4f5;font-size:15px;font-weight:500;">'
        ||   P_CLIENT_NAME || ' &bull; '
        ||   TO_VARCHAR(CAST(V_NOW_LOCAL AS DATE), 'MON DD, YYYY')
        ||   ' &bull; Reporting Window: Last 24 Hours'
        || '</p>'
        || '</td></tr>'

        -- Summary cards
        || '<tr><td style="padding:28px 45px 20px;">'
        || '<table width="100%" cellpadding="0" cellspacing="0"><tr>'
        -- Total warehouses
        || '<td width="23%" align="center" style="padding:22px 10px;background-color:#eef2ff;border-radius:12px;">'
        ||   '<span style="font-size:38px;font-weight:800;color:#1e293b;">' || TO_VARCHAR(V_COUNT) || '</span><br>'
        ||   '<span style="font-size:11px;color:#7a8599;text-transform:uppercase;font-weight:700;">Total Warehouses</span>'
        || '</td>'
        || '<td width="2%"></td>'
        -- Over budget
        || '<td width="23%" align="center" style="padding:22px 10px;background-color:' || CASE WHEN V_OVER_BUDGET_COUNT > 0 THEN '#fef2f2' ELSE '#f0fdf4' END || ';border-radius:12px;">'
        ||   '<span style="font-size:38px;font-weight:800;color:' || CASE WHEN V_OVER_BUDGET_COUNT > 0 THEN '#dc2626' ELSE '#16a34a' END || ';">' || TO_VARCHAR(V_OVER_BUDGET_COUNT) || '</span><br>'
        ||   '<span style="font-size:11px;color:#7a8599;text-transform:uppercase;font-weight:700;">Over Budget</span>'
        || '</td>'
        || '<td width="2%"></td>'
        -- Within budget
        || '<td width="23%" align="center" style="padding:22px 10px;background-color:#f0fdf4;border-radius:12px;">'
        ||   '<span style="font-size:38px;font-weight:800;color:#16a34a;">' || TO_VARCHAR(V_COUNT - V_OVER_BUDGET_COUNT - V_NOT_CONFIGURED_COUNT) || '</span><br>'
        ||   '<span style="font-size:11px;color:#7a8599;text-transform:uppercase;font-weight:700;">Within Budget</span>'
        || '</td>'
        || '<td width="2%"></td>'
        -- Not configured
        || '<td width="23%" align="center" style="padding:22px 10px;background-color:#fffbeb;border-radius:12px;">'
        ||   '<span style="font-size:38px;font-weight:800;color:#d97706;">' || TO_VARCHAR(V_NOT_CONFIGURED_COUNT) || '</span><br>'
        ||   '<span style="font-size:11px;color:#7a8599;text-transform:uppercase;font-weight:700;">Not Configured</span>'
        || '</td>'
        || '</tr></table></td></tr>'

        -- Storage banner
        || '<tr><td style="padding:0 45px 20px;">'
        || '<table width="100%" cellpadding="0" cellspacing="0"><tr>'
        || '<td align="center" style="padding:16px 10px;background-color:#fffbeb;border-radius:12px;">'
        ||   '<span style="font-size:14px;font-weight:700;color:#d97706;">'
        ||     '&#128200; Total Storage: ' || TO_VARCHAR(V_STORAGE_TB) || ' TB'
        ||     ' &bull; Est. Monthly Storage Cost: $' || TO_VARCHAR(V_STORAGE_COST)
        ||   '</span>'
        || '</td>'
        || '</tr></table></td></tr>'

        -- Warehouse table
        || '<tr><td style="padding:10px 45px 24px;">'
        || '<table width="100%" cellpadding="0" cellspacing="0" style="border-radius:12px;overflow:hidden;border:1px solid #e2e8f0;">'
        || '<tr style="background-color:#0f1b3d;">'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:left;font-weight:700;text-transform:uppercase;">Warehouse</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:center;font-weight:700;text-transform:uppercase;">Env</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:right;font-weight:700;text-transform:uppercase;">Credits (24h)</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:right;font-weight:700;text-transform:uppercase;">Cost (24h)</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:right;font-weight:700;text-transform:uppercase;">Daily Limit</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:right;font-weight:700;text-transform:uppercase;">% Used</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:right;font-weight:700;text-transform:uppercase;">MTD</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:right;font-weight:700;text-transform:uppercase;">YTD</th>'
        || '<th style="padding:14px 12px;color:#ffffff;font-size:12px;text-align:center;font-weight:700;text-transform:uppercase;">Status</th>'
        || '</tr>'
        || V_ROWS
        || '</table></td></tr>'

        -- Not-configured callout (only shown when needed)
        || CASE WHEN V_NOT_CONFIGURED_COUNT > 0 THEN
            '<tr><td style="padding:0 45px 20px;">'
            || '<table width="100%" cellpadding="0" cellspacing="0"><tr>'
            || '<td style="padding:16px 20px;background-color:#fffbeb;border-left:4px solid #d97706;border-radius:8px;">'
            || '<span style="font-size:13px;font-weight:700;color:#92400e;">&#9888; ' || TO_VARCHAR(V_NOT_CONFIGURED_COUNT) || ' warehouse(s) have no daily credit limit set. '
            || 'Update DAILY_CREDIT_LIMIT in GOLD.ADMIN.WAREHOUSE_ALERT_CONFIG to enable budget tracking.</span>'
            || '</td></tr></table></td></tr>'
           ELSE '' END

        -- Footer signature
        || '<tr><td style="padding:28px 45px 18px;border-top:2px solid #f1f5f9;">'
        || '<table width="100%" cellpadding="0" cellspacing="0"><tr>'
        || '<td valign="middle">'
        ||   '<p style="margin:0 0 8px;font-size:15px;color:#64748b;font-weight:600;">Thanks,</p>'
        ||   '<img src="https://booleandata.ai/wp-content/uploads/2026/04/Booelan-loh.jpg" alt="Boolean Data Systems" style="height:36px;max-width:160px;display:block;" />'
        || '</td>'
        || '<td align="right" valign="middle">'
        ||   '<a href="mailto:customeralerts@booleandata.ai" style="background-color:#3b82f6;color:#ffffff;padding:12px 24px;border-radius:8px;font-size:14px;font-weight:700;text-decoration:none;">Contact Us</a>'
        || '</td>'
        || '</tr></table></td></tr>'

        -- Disclaimer
        || '<tr><td style="padding:0 45px 28px;">'
        || '<p style="margin:0;font-size:12px;color:#94a3b8;line-height:1.6;">'
        ||   'Automated report from Snowflake &bull; Boolean Monitoring Suite &bull; '
        ||   '<a href="mailto:customeralerts@booleandata.ai" style="color:#3b82f6;">customeralerts@booleandata.ai</a>'
        || '</p></td></tr>'

        -- Footer bar
        || '<tr><td style="background-color:#0f1b3d;padding:18px 45px;text-align:center;">'
        || '<img src="https://booleandata.ai/wp-content/uploads/2026/04/Booelan-loh.jpg" alt="Boolean Data Systems" style="height:30px;max-width:140px;display:inline-block;margin-bottom:8px;" /><br>'
        || '<span style="font-size:11px;color:rgba(255,255,255,0.5);">&copy; ' || TO_VARCHAR(YEAR(V_NOW_LOCAL)) || ' Boolean Data Systems INC. All rights reserved.</span>'
        || '</td></tr>'
        || '</table></td></tr></table></body></html>';

    -- Step 9: Send email
    CALL SYSTEM$SEND_EMAIL(:V_EMAIL_INT, :V_EMAIL_TO, :V_SUBJECT, :V_BODY, 'text/html');

    RETURN 'Report sent to: ' || V_EMAIL_TO
        || ' | Warehouses: '   || V_COUNT
        || ' | Over budget: '  || V_OVER_BUDGET_COUNT
        || ' | Not configured: ' || V_NOT_CONFIGURED_COUNT;

END;
$$;

-- 09:30 Toronto time every day, after account usage has caught up with the previous day (the sync runs inside the report)
create or replace task GOLD.ADMIN.T_DAILY_CONSUMPTION_REPORT warehouse = WH_TRANSFORMATION
  schedule = 'USING CRON 30 9 * * * America/Toronto'
  comment = 'Daily warehouse consumption email, kickstart checklist 3'
as
  call GOLD.ADMIN.SP_CONSUMPTION_REPORT('Epitaph');

alter task GOLD.ADMIN.T_DAILY_CONSUMPTION_REPORT resume;
