-- ====================================================================
-- Project: End-to-End Business Analytics & KPI Dashboard
-- File: sql/02_load_data.sql
-- Description: Baseline sample data for testing schema functionality
-- ====================================================================

-- 1. Seed Channels
INSERT INTO dim_channels (channel_name, channel_type, platform_fee_pct) VALUES
('Direct Website', 'Direct', 0.0000),
('Amazon Marketplace', 'Marketplace', 0.1500),
('B2B Wholesale', 'Wholesale', 0.0500),
('TikTok Shop', 'Social Commerce', 0.0800)
ON CONFLICT DO NOTHING;

-- 2. Seed Products
INSERT INTO dim_products (product_id, product_name, category, sub_category, unit_cost, standard_price) VALUES
('PROD-001', 'Wireless Noise-Cancelling Headphones', 'Electronics', 'Audio', 65.00, 149.99),
('PROD-002', 'Mechanical RGB Gaming Keyboard', 'Electronics', 'Peripherals', 38.00, 89.99),
('PROD-003', 'Ergonomic Mesh Office Chair', 'Furniture', 'Chairs', 110.00, 249.99),
('PROD-004', 'Dual Motor Standing Desk (60-inch)', 'Furniture', 'Desks', 185.00, 399.99),
('PROD-005', 'USB-C 10-in-1 Aluminum Docking Station', 'Electronics', 'Accessories', 22.00, 59.99),
('PROD-006', 'Ultra-Wide Desk Mat (900x400mm)', 'Office Supplies', 'Desk Accessories', 6.50, 24.99)
ON CONFLICT DO NOTHING;

-- 3. Seed Customers
INSERT INTO dim_customers (customer_id, customer_name, segment, country, state, city, postal_code, region) VALUES
('CUST-1001', 'Marcus Vance', 'Consumer', 'United States', 'Texas', 'Plano', '75024', 'Central'),
('CUST-1002', 'Elena Rostova', 'Corporate', 'United States', 'California', 'San Jose', '95112', 'West'),
('CUST-1003', 'David Chen', 'Home Office', 'United States', 'Washington', 'Seattle', '98101', 'West'),
('CUST-1004', 'Apex Systems LLC', 'B2B Wholesale', 'United States', 'Texas', 'Dallas', '75201', 'Central'),
('CUST-1005', 'Sarah Jenkins', 'Consumer', 'United States', 'New York', 'New York', '10001', 'East')
ON CONFLICT DO NOTHING;

-- 4. Seed Orders
INSERT INTO fact_orders (
    order_id, order_date, ship_date, customer_id, product_id, channel_id,
    quantity, gross_sales, discount_amount, cogs, shipping_cost
) VALUES
('ORD-2026-001', '2026-01-05', '2026-01-07', 'CUST-1001', 'PROD-001', 1, 1, 149.99, 0.00, 65.00, 8.50),
('ORD-2026-002', '2026-01-06', '2026-01-08', 'CUST-1003', 'PROD-002', 2, 1, 89.99, 10.00, 38.00, 12.00),
('ORD-2026-003', '2026-01-08', '2026-01-12', 'CUST-1002', 'PROD-003', 1, 1, 249.99, 25.00, 110.00, 24.00),
('ORD-2026-004', '2026-01-10', '2026-01-11', 'CUST-1001', 'PROD-005', 1, 2, 119.98, 0.00, 44.00, 6.00),
('ORD-2026-005', '2026-01-15', '2026-01-19', 'CUST-1004', 'PROD-004', 3, 5, 1999.50, 200.00, 925.00, 85.00),
('ORD-2026-006', '2026-01-20', '2026-01-23', 'CUST-1005', 'PROD-006', 4, 1, 24.99, 5.00, 6.50, 4.00),
('ORD-2026-007', '2026-02-02', '2026-02-04', 'CUST-1001', 'PROD-002', 1, 1, 89.99, 0.00, 38.00, 7.50),
('ORD-2026-008', '2026-02-10', '2026-02-14', 'CUST-1002', 'PROD-004', 2, 1, 399.99, 40.00, 185.00, 32.00),
('ORD-2026-009', '2026-02-14', '2026-02-16', 'CUST-1003', 'PROD-001', 1, 1, 149.99, 15.00, 65.00, 9.00),
('ORD-2026-010', '2026-02-18', '2026-02-22', 'CUST-1005', 'PROD-003', 4, 1, 249.99, 30.00, 110.00, 22.00);