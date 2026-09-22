/*
===============================================================================
06 - Ranking Analysis
===============================================================================
Question:
    Which products and customers are the best and worst performers?

Why it matters:
    The most actionable output: which exact products drive revenue, which
    ones barely sell, and which customers are the most valuable.

Note:
    Window functions are calculated in the SELECT step, after WHERE runs,
    so the ranking is computed in a subquery and filtered outside it.

SQL used:
    TOP, RANK(), DENSE_RANK(), ROW_NUMBER(), PARTITION BY, subqueries
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Top 5 products by revenue (simple version with TOP)
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Top 5 products by revenue (window function version)
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) ranked_products
WHERE rank_products <= 5;

-- 5 worst-performing products by revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Top 3 products within each category (PARTITION BY restarts the rank per category)
SELECT *
FROM (
    SELECT
        p.category,
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(f.sales_amount) DESC
        ) AS rank_in_category
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category, p.product_name
) ranked
WHERE rank_in_category <= 3;

-- Top 10 customers by revenue
SELECT *
FROM (
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS customer_rank
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
) ranked_customers
WHERE customer_rank <= 10;

-- 3 customers with the fewest orders
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders ASC;
