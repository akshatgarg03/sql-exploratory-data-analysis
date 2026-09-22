/*
===============================================================================
02 - Dimensions Exploration
===============================================================================
Question:
    What categories can the data be grouped and sliced by?

Why it matters:
    Dimensions (country, category, product) become the "BY X" part of every
    later analysis, e.g. revenue BY country, sales BY category.

SQL used:
    DISTINCT, ORDER BY
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Unique countries customers come from
SELECT DISTINCT
    country
FROM gold.dim_customers
ORDER BY country;

-- Unique genders and marital statuses
SELECT DISTINCT gender FROM gold.dim_customers;
SELECT DISTINCT marital_status FROM gold.dim_customers;

-- Product hierarchy: category -> subcategory -> product
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

-- Data quality check: customers with an unknown country
SELECT COUNT(*) AS customers_with_unknown_country
FROM gold.dim_customers
WHERE country = 'n/a' OR country IS NULL;
