/*
===============================================================================
01 - Database Exploration
===============================================================================
Question:
    What tables and columns exist in this database?

Why it matters:
    This is the map of the data. Every later query depends on knowing the
    table names, column names, and data types.

SQL used:
    INFORMATION_SCHEMA.TABLES, INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- List all tables in the database
SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- List all columns of the customer dimension with their data types
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

-- List all columns of the sales fact table
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';
