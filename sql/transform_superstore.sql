-- ====================================================================
-- Project: End-to-End Business Analytics & KPI Dashboard
-- File: sql/04_transform_superstore.sql
-- Description: Normalizes raw staging data from raw_superstore
--              into the Kimball Star Schema.
-- ====================================================================

-- 1. Reset tables and identity counters
TRUNCATE TABLE fact_orders, dim_customers, dim_products, dim_channels RESTART IDENTITY CASCADE;

-- 2. Populate Channels Dimension
INSERT INTO dim_channels (channel_name, channel_type, platform_fee_pct)
SELECT DISTINCT
    "Ship Mode" AS channel_name,
    CASE
        WHEN "Ship Mode" = 'Same Day' THEN 'Express'
        WHEN "Ship Mode" = 'First Class' THEN 'Priority'
        WHEN "Ship Mode" = 'Second Class' THEN 'Expedited'
        ELSE 'Standard Ground'
    END AS channel_type,
    CASE
        WHEN "Ship Mode" = 'Same Day' THEN 0.1000
        WHEN "Ship Mode" = 'First Class' THEN 0.0600
        WHEN "Ship Mode" = 'Second Class' THEN 0.0300
        ELSE 0.0000
    END AS platform_fee_pct
FROM raw_superstore
WHERE "Ship Mode" IS NOT NULL;

-- 3. Populate Customers Dimension (Deduplicated)
INSERT INTO dim_customers (customer_id, customer_name, segment, country, state, city, postal_code, region)
SELECT
    "Customer ID",
    MAX("Customer Name") AS customer_name,
    MAX(segment) AS segment,
    MAX("Country/Region") AS country,
    MAX("State/Province") AS state,
    MAX(city) AS city,
    COALESCE(MAX("Postal Code"::TEXT), 'N/A') AS postal_code,
    MAX(region) AS region
FROM raw_superstore
WHERE "Customer ID" IS NOT NULL
GROUP BY "Customer ID"
ON CONFLICT (customer_id) DO NOTHING;

-- 4. Populate Products Dimension (Deduplicated)
INSERT INTO dim_products (product_id, product_name, category, sub_category, unit_cost, standard_price)
SELECT
    "Product ID",
    MAX("Product Name") AS product_name,
    MAX(category) AS category,
    MAX("Sub-Category") AS sub_category,
    COALESCE(ROUND(AVG((sales::NUMERIC - profit::NUMERIC) / NULLIF(quantity::NUMERIC, 0)), 2), 10.00) AS unit_cost,
    COALESCE(ROUND(AVG(sales::NUMERIC / NULLIF(quantity::NUMERIC,