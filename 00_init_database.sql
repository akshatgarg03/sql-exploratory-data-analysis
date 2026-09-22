/*
===============================================================================
00 - Initialize Database
===============================================================================
Purpose:
    Creates the 'DataWarehouseAnalytics' database, the 'gold' schema, and the
    three star-schema tables, then loads them from CSV files.

Tables:
    gold.dim_customers  -> one row per customer
    gold.dim_products   -> one row per product
    gold.fact_sales     -> one row per product line in an order

WARNING:
    Running this script drops and recreates the database.
    Update the file paths in the BULK INSERT statements to match where the
    CSV files are saved on your computer.
===============================================================================
*/

USE master;
GO

-- Drop and recreate the database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

CREATE SCHEMA gold;
GO

-- Customer dimension
CREATE TABLE gold.dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  NVARCHAR(50),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    country          NVARCHAR(50),
    marital_status   NVARCHAR(50),
    gender           NVARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);
GO

-- Product dimension
CREATE TABLE gold.dim_products (
    product_key      INT,
    product_id       INT,
    product_number   NVARCHAR(50),
    product_name     NVARCHAR(50),
    category_id      NVARCHAR(50),
    category         NVARCHAR(50),
    subcategory      NVARCHAR(50),
    maintenance      NVARCHAR(50),
    cost             INT,
    product_line     NVARCHAR(50),
    start_date       DATE
);
GO

-- Sales fact table
CREATE TABLE gold.fact_sales (
    order_number     NVARCHAR(50),
    product_key      INT,
    customer_key     INT,
    order_date       DATE,
    shipping_date    DATE,
    due_date         DATE,
    sales_amount     INT,
    quantity         TINYINT,
    price            INT
);
GO

-- Load data (change these paths to your own CSV locations)
TRUNCATE TABLE gold.dim_customers;
BULK INSERT gold.dim_customers
FROM 'C:\sql\datasets\gold.dim_customers.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
GO

TRUNCATE TABLE gold.dim_products;
BULK INSERT gold.dim_products
FROM 'C:\sql\datasets\gold.dim_products.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
GO

TRUNCATE TABLE gold.fact_sales;
BULK INSERT gold.fact_sales
FROM 'C:\sql\datasets\gold.fact_sales.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
GO
