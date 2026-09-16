# End-to-End Business Analytics & KPI Dashboard

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Power BI](https://img.shields.io/badge/Power_BI-Desktop-F2C811?logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![DataGrip](https://img.shields.io/badge/IDE-DataGrip-000000?logo=datagrip&logoColor=white)](https://www.jetbrains.com/datagrip/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end business intelligence solution that normalizes 10,000+ commercial transaction records into a cloud-hosted PostgreSQL Star Schema, paired with an interactive Power BI executive dashboard to analyze margin variances, fulfillment speed, and product profitability.

---

## Dashboard Preview

![Executive Dashboard Preview](dashboard/dashboard_preview.png)

---

## Project Architecture

```text
[Kaggle Superstore Dataset] (Raw CSV ~10K rows)
              │
              ▼
    [Neon Cloud PostgreSQL]
   (Staging Table: raw_superstore)
              │
              ▼
     [SQL ETL Normalization] ──► Kimball Star Schema:
                                   ├── fact_orders (10,194 rows)
                                   ├── dim_channels (4 channels)
                                   ├── dim_customers (804 customers)
                                   └── dim_products (1,862 products)
              │
              ▼
   [Analytical SQL Queries] ──► CTEs, Window Functions (ROW_NUMBER, LAG)
              │
              ▼
    [Power BI Desktop] ───────► Direct Import, Star Schema Model, Custom DAX
