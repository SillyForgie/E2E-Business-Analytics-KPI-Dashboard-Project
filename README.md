\# End-to-End Business Analytics \& KPI Dashboard



\[!\[PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql\&logoColor=white)](https://www.postgresql.org/)

\[!\[Power BI](https://img.shields.io/badge/Power\_BI-Desktop-F2C811?logo=powerbi\&logoColor=black)](https://powerbi.microsoft.com/)

\[!\[DataGrip](https://img.shields.io/badge/IDE-DataGrip-000000?logo=datagrip\&logoColor=white)](https://www.jetbrains.com/datagrip/)

\[!\[License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)



An end-to-end business intelligence solution that normalizes 10,000+ commercial transaction records into a cloud-hosted PostgreSQL Star Schema, paired with an interactive Power BI executive dashboard to analyze margin variances, fulfillment speed, and product profitability.



\---



\## Dashboard Preview



!\[Executive Dashboard Preview](dashboard/dashboard\_preview.png)





\---



\## Project Architecture



```text

\[Kaggle Superstore Dataset] (Raw CSV \~10K rows)

&#x20;             │

&#x20;             ▼

&#x20;   \[Neon Cloud PostgreSQL]

&#x20;  (Staging Table: raw\_superstore)

&#x20;             │

&#x20;             ▼

&#x20;    \[SQL ETL Normalization] ──► Kimball Star Schema:

&#x20;                                  ├── fact\_orders (10,194 rows)

&#x20;                                  ├── dim\_channels (4 channels)

&#x20;                                  ├── dim\_customers (804 customers)

&#x20;                                  └── dim\_products (1,862 products)

&#x20;             │

&#x20;             ▼

&#x20;  \[Analytical SQL Queries] ──► CTEs, Window Functions (ROW\_NUMBER, LAG)

&#x20;             │

&#x20;             ▼

&#x20;   \[Power BI Desktop] ───────► Direct Import, Star Schema Model, Custom DAX



```



\## Dataset Overview



\* \*\*Source:\*\* \[Sample Superstore Dataset on Kaggle](https://www.kaggle.com/datasets/himanshuuike/superstore-sales-dataset)

\* \*\*Dataset Scope:\*\* 10,194 transactional order records across 4 years of multi-channel commercial sales.

\* \*\*Domain:\*\* Commercial retail and e-commerce across Technology, Furniture, and Office Supplies.



\### Raw Data Attributes:

| Category | Attributes Included |

| :--- | :--- |

| \*\*Order \& Logistics\*\* | Order ID, Order Date, Ship Date, Ship Mode (Shipping Channel) |

| \*\*Customer Profile\*\* | Customer ID, Customer Name, Segment (Consumer, Corporate, Home Office), Geography (City, State, Region, Postal Code) |

| \*\*Product Hierarchy\*\* | Product ID, Product Name, Category, Sub-Category |

| \*\*Financial Metrics\*\* | Gross Sales, Quantity, Discount Rate, Profit (COGS derived) |



\### Data Transformation \& Staging:

The raw dataset was ingested into an unnormalized staging table (`raw\_superstore`) and programmatically transformed via SQL into a 3rd Normal Form / Kimball dimensional model:

\* \*\*`fact\_orders`\*\*: 10,194 line items with reconstructed gross revenue, dollar discounts, COGS, and gross profit.

\* \*\*`dim\_channels`\*\*: 4 fulfillment methods with assigned platform/logistics fee rates.

\* \*\*`dim\_customers`\*\*: 804 deduplicated customer records across 4 US regions.

\* \*\*`dim\_products`\*\*: 1,862 distinct SKUs categorized across 17 sub-categories.



