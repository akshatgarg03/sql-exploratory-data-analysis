# SQL Exploratory Data Analysis (EDA) Project

An exploratory data analysis of a retail sales data warehouse using **SQL Server (T-SQL)**. The project follows a structured six-step approach to understand the data, then uncover business insights about revenue, products, and customers.

## Project Overview

The dataset belongs to a company that sells bikes, accessories, clothing, and components across six countries. The data is modeled as a **star schema**: one fact table of sales transactions connected to two dimension tables describing customers and products.

The core idea behind every analysis in this project:

> **Aggregate a measure, grouped by a dimension.**

- **Measures** are numeric values that make sense to aggregate (sales amount, quantity, price).
- **Dimensions** are descriptive attributes used to group and filter (country, category, product name).

## Data Model

```
                 ┌──────────────────┐
                 │  dim_customers   │
                 │  (who bought)    │
                 └────────┬─────────┘
                          │ customer_key
                 ┌────────┴─────────┐
                 │    fact_sales    │
                 │ (every sale line)│
                 └────────┬─────────┘
                          │ product_key
                 ┌────────┴─────────┐
                 │   dim_products   │
                 │  (what was sold) │
                 └──────────────────┘
```

| Table | Grain (one row = ) | Key columns |
|---|---|---|
| `gold.fact_sales` | one product line within an order | order_number, product_key, customer_key, order_date, sales_amount, quantity, price |
| `gold.dim_customers` | one customer | customer_key, first_name, last_name, country, gender, birthdate |
| `gold.dim_products` | one product | product_key, product_name, category, subcategory, cost |

## Analysis Roadmap

| # | Step | Question it answers | Script |
|---|---|---|---|
| 1 | Database Exploration | What tables and columns exist? | `01_database_exploration.sql` |
| 2 | Dimensions Exploration | What categories can the data be sliced by? | `02_dimensions_exploration.sql` |
| 3 | Date Range Exploration | What time period does the data cover? | `03_date_range_exploration.sql` |
| 4 | Measures Exploration | What are the headline business numbers? | `04_measures_exploration.sql` |
| 5 | Magnitude Analysis | How do the numbers break down by category, country, customer? | `05_magnitude_analysis.sql` |
| 6 | Ranking Analysis | Who and what are the top and bottom performers? | `06_ranking_analysis.sql` |

Steps 1–4 build an understanding of the data. Steps 5–6 turn that understanding into business insights.

## SQL Concepts Used

- Metadata exploration with `INFORMATION_SCHEMA`
- `DISTINCT`, `GROUP BY`, `ORDER BY`
- Aggregate functions: `SUM`, `AVG`, `COUNT`, `COUNT(DISTINCT)`, `MIN`, `MAX`
- Date functions: `DATEDIFF`, `GETDATE`
- `LEFT JOIN` between fact and dimension tables
- `UNION ALL` to combine KPIs into a single report
- Window functions: `RANK`, `DENSE_RANK`, `ROW_NUMBER`, with `PARTITION BY`
- Subqueries to filter on window function results

## Key Insights

- **Bikes dominate revenue.** The Bikes category generates the vast majority of total revenue, even though accessories and clothing sell a large number of low-priced units. The business is heavily dependent on a single category.
- **Revenue is concentrated in a few markets.** The United States and Australia lead in revenue among the six countries.
- **Top products are almost all bikes.** The highest-revenue products are road and mountain bike models, while the lowest performers are low-priced accessories and clothing items.
- **Data quality note.** Some customers have an unknown (`n/a`) country, which should be handled before building country-level reports.

## How to Run

1. Install **SQL Server** (Express edition is free) and **SQL Server Management Studio (SSMS)**.
2. Download the three CSV files (`gold.dim_customers.csv`, `gold.dim_products.csv`, `gold.fact_sales.csv`) from the original course repository linked below.
3. Open `scripts/00_init_database.sql`, update the file paths in the `BULK INSERT` statements, and run it.
4. Run scripts `01` to `06` in order.

## Repository Structure

```
sql-exploratory-data-analysis/
│
├── scripts/
│   ├── 00_init_database.sql
│   ├── 01_database_exploration.sql
│   ├── 02_dimensions_exploration.sql
│   ├── 03_date_range_exploration.sql
│   ├── 04_measures_exploration.sql
│   ├── 05_magnitude_analysis.sql
│   └── 06_ranking_analysis.sql
│
└── README.md
```

## Future Improvements

- Change-over-time analysis (monthly and yearly sales trends)
- Cumulative analysis (running totals and moving averages)
- Customer segmentation (VIP, regular, and new customers by spending and history)
- A Power BI dashboard built on top of these queries

## Credits

This project was built by following the **SQL Exploratory Data Analysis** course by [Data With Baraa](https://www.youtube.com/@DataWithBaraa). The dataset and project structure come from that course; the scripts were written and run by me as part of learning structured EDA in SQL.
