with balance_sheet_filtered as (
    select
        ticker,
        report_date,
        frequency,
        ordinary_shares_number,
        share_issued,
        total_assets,
        lead(ordinary_shares_number) over (partition by ticker order by report_date desc) as next_ordinary_shares_number,
        lead(share_issued) over (partition by ticker order by report_date desc) as next_share_issued,
        lead(total_assets) over (partition by ticker order by report_date desc) as next_total_assets
    from stocks.balance_sheet
),
cashflow_filtered as (
    select
        ticker,
        report_date,
        frequency,
        free_cash_flow,
        lead(free_cash_flow) over (partition by ticker order by report_date desc) as next_free_cash_flow
    from stocks.cashflow
),
income_stmt_filtered as (
    select
        ticker,
        report_date,
        frequency,
        total_revenue,
        net_income_common_stockholders,
        net_income,
        basic_eps,
        lead(total_revenue) over (partition by ticker order by report_date desc) as next_total_revenue,
        lead(net_income_common_stockholders) over (partition by ticker order by report_date desc) as next_net_income_common_stockholders,
        lead(net_income) over (partition by ticker order by report_date desc) as next_net_income,
        lead(basic_eps) over (partition by ticker order by report_date desc) as next_basic_eps
    from stocks.income_stmt
),
filtered_data as (
    select
        bs.ticker,
        bs.report_date,
        bs.frequency,
        bs.ordinary_shares_number,
        bs.share_issued,
        bs.total_assets,
        cf.free_cash_flow,
        isf.total_revenue,
        isf.net_income_common_stockholders,
        isf.net_income,
        isf.basic_eps
    from balance_sheet_filtered bs
    join cashflow_filtered cf on bs.ticker = cf.ticker and bs.report_date = cf.report_date and bs.frequency = cf.frequency
    join income_stmt_filtered isf on bs.ticker = isf.ticker and bs.report_date = isf.report_date and bs.frequency = isf.frequency
    where 
        (bs.next_ordinary_shares_number is null or bs.ordinary_shares_number < bs.next_ordinary_shares_number) and
        (bs.next_share_issued is null or bs.share_issued < bs.next_share_issued) and
        (bs.next_total_assets is null or bs.total_assets > bs.next_total_assets) and
        (cf.next_free_cash_flow is null or cf.free_cash_flow > cf.next_free_cash_flow) and
        (isf.next_total_revenue is null or isf.total_revenue > isf.next_total_revenue) and
        (isf.next_net_income_common_stockholders is null or isf.net_income_common_stockholders > isf.next_net_income_common_stockholders) and
        (isf.next_net_income is null or isf.net_income > isf.next_net_income) and
        (isf.next_basic_eps is null or isf.basic_eps > isf.next_basic_eps)
)
select * from filtered_data
