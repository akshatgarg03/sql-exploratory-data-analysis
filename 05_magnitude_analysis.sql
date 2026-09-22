/*
===============================================================================
05 - Magnitude Analysis
===============================================================================
Question:
    How do the key measures break down across dimensions?

Pattern:
    Aggregate a MEASURE, GROUP BY a DIMENSION.

Why it matters:
    Turns "what data do we have" into "where does the business actually make
    its money".

SQL used:
    GROUP BY, SUM(), COUNT(), AVG(), LEFT JOIN
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Total customers by country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average product cost by category
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Total revenue by product category (fact joined to product dimension)
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Total revenue by customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- Items sold by country (fact joined to customer dimension)
SELECT
    c.country,
    SUM(f.quantity) AS total_items_sold
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_items_sold DESC;
