-- dbt_financials_combined.sql

{{ config(materialized='table') }}

WITH balance_sheet AS (
    SELECT
        ticker,
        report_date,
        frequency,
        total_assets,
        net_debt,
        share_issued
    FROM stocks.balance_sheet
),
income_stmt AS (
    SELECT
        ticker,
        report_date,
        frequency,
        total_revenue,
        net_income_common_stockholders
    FROM stocks.income_stmt
),
cashflow AS (
    SELECT
        ticker,
        report_date,
        frequency,
        free_cash_flow
    FROM stocks.cashflow
)
SELECT
    b.ticker,
    b.report_date,
    b.frequency,
    b.total_assets,
    b.net_debt,
    b.share_issued,
    i.total_revenue,
    i.net_income_common_stockholders,
    c.free_cash_flow
FROM balance_sheet b
JOIN income_stmt i ON b.ticker = i.ticker AND b.report_date = i.report_date AND b.frequency = i.frequency
JOIN cashflow c ON b.ticker = c.ticker AND b.report_date = c.report_date AND b.frequency = c.frequency
