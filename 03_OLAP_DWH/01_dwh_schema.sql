DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS fact_inventory CASCADE;
DROP TABLE IF EXISTS bridge_product_category CASCADE;
DROP TABLE IF EXISTS dim_categories CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;
DROP TABLE IF EXISTS dim_warehouses CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_calendar CASCADE;

CREATE TABLE dim_calendar (
    date_key DATE PRIMARY KEY,
    year_number INT,
    quarter_number INT,
    month_number INT,
    month_name VARCHAR(20),
    day_of_week INT
);

CREATE TABLE dim_warehouses (
    warehouse_code VARCHAR(50) PRIMARY KEY,
    warehouse_name VARCHAR(150),
    country_name VARCHAR(100)
);

CREATE TABLE dim_customers (
    customer_email VARCHAR(100) PRIMARY KEY,
    full_name VARCHAR(250),
    country_name VARCHAR(100)
);

CREATE TABLE dim_products (
    product_sk SERIAL PRIMARY KEY,
    product_sku VARCHAR(50),
    product_name VARCHAR(150),
    base_price NUMERIC(10, 2),
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);

CREATE TABLE dim_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE bridge_product_category (
    product_sk INT REFERENCES dim_products(product_sk),
    category_id INT REFERENCES dim_categories(category_id),
    PRIMARY KEY (product_sk, category_id)
);

CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    order_number VARCHAR(50),
    date_key DATE REFERENCES dim_calendar(date_key),
    customer_email VARCHAR(100) REFERENCES dim_customers(customer_email),
    product_sk INT REFERENCES dim_products(product_sk),
    warehouse_code VARCHAR(50) REFERENCES dim_warehouses(warehouse_code),
    quantity_sold INT,
    price_per_item NUMERIC(10, 2),
    total_revenue NUMERIC(10, 2)
);

CREATE TABLE fact_inventory (
    inventory_id SERIAL PRIMARY KEY,
    date_key DATE REFERENCES dim_calendar(date_key),
    warehouse_code VARCHAR(50) REFERENCES dim_warehouses(warehouse_code),
    product_sk INT REFERENCES dim_products(product_sk),
    quantity_on_hand INT
);