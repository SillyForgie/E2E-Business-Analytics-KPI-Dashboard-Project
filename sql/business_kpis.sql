-- ====================================================================
-- Project: End-to-End Business Analytics & KPI Dashboard
-- File: sql/03_business_kpis.sql
-- Description: Core business queries (CTEs, Window Functions, Variances)
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. EXECUTIVE KPI OVERVIEW
-- Financial summary: Net Revenue, Profit, Margin %, AOV, Order Count
-- --------------------------------------------------------------------
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(gross_sales), 2) AS total_gross_sales,
    ROUND(SUM(discount_amount), 2) AS total_discounts_given,
    ROUND(SUM(net_sales), 2) AS total_net_revenue,
    ROUND(SUM(cogs), 2) AS total_cogs,
    ROUND(SUM(gross_profit), 2) AS total_gross_profit,
    ROUND((SUM(gross_profit) / NULLIF(SUM(net_sales), 0)) * 100, 2) AS blended_gross_margin_pct,
    ROUND(SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value
FROM fact_orders;


-- --------------------------------------------------------------------
-- 2. OPERATIONAL FULFILLMENT VELOCITY
-- Turnaround lead time and average shipping expense by channel
-- --------------------------------------------------------------------
SELECT
    c.channel_name,
    c.channel_type,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(AVG(f.ship_date - f.order_date), 2) AS avg_fulfillment_days,
    MIN(f.ship_date - f.order_date) AS fastest_ship_days,
    MAX(f.ship_date - f.order_date) AS slowest_ship_days,
    ROUND(SUM(f.shipping_cost) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS avg_shipping_cost_per_order
FROM fact_orders f
JOIN dim_channels c ON f.channel_id = c.channel_id
WHERE f.ship_date IS NOT NULL
GROUP BY c.channel_name, c.channel_type
ORDER BY avg_fulfillment_days ASC;


-- --------------------------------------------------------------------
-- 3. MARGIN VARIANCE & DISCOUNT EROSION (CTEs)
-- Evaluates gross margins and net operating margins after channel fees
-- --------------------------------------------------------------------
WITH ChannelProfitability AS (
    SELECT
        c.channel_name,
        p.category,
        SUM(f.gross_sales) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales) AS net_sales,
        SUM(f.cogs) AS total_cogs,
        SUM(f.gross_profit) AS standard_gross_profit,
        ROUND(SUM(f.net_sales * c.platform_fee_pct), 2) AS total_channel_fees,
        ROUND(SUM(f.gross_profit - (f.net_sales * c.platform_fee_pct)), 2) AS net_operating_margin
    FROM fact_orders f
    JOIN dim_channels c ON f.channel_id = c.channel_id
    JOIN dim_products p ON f.product_id = p.product_id
    GROUP BY c.channel_name, p.category, c.platform_fee_pct
)
SELECT
    channel_name,
    category,
    net_sales,
    standard_gross_profit,
    total_channel_fees,
    net_operating_margin,
    ROUND((standard_gross_profit / NULLIF(net_sales, 0)) * 100, 2) AS gross_margin_pct,
    ROUND((net_operating_margin / NULLIF(net_sales, 0)) * 100, 2) AS net_margin_after_fees_pct,
    ROUND((total_discounts / NULLIF(gross_sales, 0)) * 100, 2) AS discount_rate_pct
FROM ChannelProfitability
ORDER BY net_margin_after_fees_pct DESC;


-- --------------------------------------------------------------------
-- 4. CUSTOMER REPURCHASE BEHAVIOR (Window Functions: ROW_NUMBER, LAG)
-- Identifies multi-order customer frequency and days between purchases
-- --------------------------------------------------------------------
WITH CustomerOrderSequence AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS purchase_sequence,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prior_order_date
    FROM (
        SELECT DISTINCT customer_id, order_id, order_date
        FROM fact_orders
    ) unique_orders
)
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    MAX(s.purchase_sequence) AS total_orders,
    ROUND(AVG(s.order_date - s.prior_order_date), 1) AS avg_days_between_orders
FROM CustomerOrderSequence s
JOIN dim_customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment, c.region
ORDER BY total_orders DESC, avg_days_between_orders ASC;