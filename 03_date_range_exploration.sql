/*
===============================================================================
03 - Date Range Exploration
===============================================================================
Question:
    What time period does the data cover, and how old are the customers?

Why it matters:
    Gives context to every number. Revenue over 3 years means something very
    different from revenue over 3 months.

SQL used:
    MIN(), MAX(), DATEDIFF(), GETDATE()
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- First and last order date, and how many months of sales we have
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Youngest and oldest customers
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
