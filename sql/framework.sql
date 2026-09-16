-- ====================================================================
-- Project: End-to-End Business Analytics & KPI Dashboard
-- File: sql/01_schema.sql
-- Description: DDL defining the relational Star Schema in PostgreSQL
-- ====================================================================

-- Clean slate
DROP TABLE IF EXISTS fact_orders CASCADE;
DROP TABLE IF EXISTS dim_channels CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;

-- 1. Dimension: Sales / Shipping Channels
CREATE TABLE IF NOT EXISTS dim_channels (
    channel_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    channel_name VARCHAR(50) NOT NULL,
    channel_type VARCHAR(30) NOT NULL,
    platform_fee_pct NUMERIC(5, 4) DEFAULT 0.0000
);

-- 2. Dimension: Customers
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(50),
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);

-- 3. Dimension: Products
CREATE TABLE IF NOT EXISTS dim_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    sub_category VARCHAR(50) NOT NULL,
    unit_cost NUMERIC(10, 2) NOT NULL,
    standard_price NUMERIC(10, 2) NOT NULL
);

-- 4. Central Fact Table: Orders
CREATE TABLE IF NOT EXISTS fact_orders (
    order_line_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE,
    customer_id VARCHAR(50) NOT NULL REFERENCES dim_customers(customer_id),
    product_id VARCHAR(50) NOT NULL REFERENCES dim_products(product_id),
    channel_id INT NOT NULL REFERENCES dim_channels(channel_id),
    quantity INT NOT NULL,
    gross_sales NUMERIC(12, 2) NOT NULL,
    discount_amount NUMERIC(10, 2) DEFAULT 0.00,
    -- Auto-computed financial metrics
    net_sales NUMERIC(12, 2) GENERATED ALWAYS AS (gross_sales - discount_amount) STORED,
    cogs NUMERIC(12, 2) NOT NULL,
    shipping_cost NUMERIC(10, 2) DEFAULT 0.00,
    gross_profit NUMERIC(12, 2) GENERATED ALWAYS AS (gross_sales - discount_amount - cogs) STORED
);

-- Performance Indexes for Analytical Queries
CREATE INDEX IF NOT EXISTS idx_orders_date ON fact_orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON fact_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_channel ON fact_orders(channel_id);