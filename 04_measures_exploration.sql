/*
===============================================================================
04 - Measures Exploration (Key Metrics)
===============================================================================
Question:
    What are the headline numbers for the whole business?

Why it matters:
    These are the measures that later steps break down by dimension.
    They also act as totals to sanity-check later results.

Note:
    fact_sales has one row per product per order, so orders are counted
    with COUNT(DISTINCT order_number) to avoid double counting.

SQL used:
    SUM(), AVG(), COUNT(), COUNT(DISTINCT), UNION ALL
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Total revenue
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Total items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Total number of orders (distinct, because one order can have many rows)
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Total number of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products;

-- Total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Customers who have placed at least one order
SELECT COUNT(DISTINCT customer_key) AS customers_with_orders FROM gold.fact_sales;

-- One combined report of all key metrics
SELECT 'Total Sales'          AS measure_name, SUM(sales_amount)            AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',       SUM(quantity)                                FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',        AVG(price)                                   FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders',         COUNT(DISTINCT order_number)                 FROM gold.fact_sales
UNION ALL
SELECT 'Total Products',       COUNT(product_key)                           FROM gold.dim_products
UNION ALL
SELECT 'Total Customers',      COUNT(customer_key)                          FROM gold.dim_customers
UNION ALL
SELECT 'Customers With Orders', COUNT(DISTINCT customer_key)                FROM gold.fact_sales;
