CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_foreign_server WHERE srvname = 'oltp_server') THEN
        CREATE SERVER oltp_server
        FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host 'localhost', dbname 'game_shop_oltp', port '5432');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_user_mappings WHERE srvname = 'oltp_server' AND usename = 'postgres') THEN
        CREATE USER MAPPING FOR postgres
        SERVER oltp_server
        OPTIONS (user 'postgres', password '1234');
    END IF;
END $$;

DROP SCHEMA IF EXISTS oltp_src CASCADE;
CREATE SCHEMA oltp_src;

IMPORT FOREIGN SCHEMA public
FROM SERVER oltp_server
INTO oltp_src;

INSERT INTO dim_calendar (date_key, year_number, quarter_number, month_number, month_name, day_of_week)
SELECT 
    datum AS date_key,
    EXTRACT(YEAR FROM datum) AS year_number,
    EXTRACT(QUARTER FROM datum) AS quarter_number,
    EXTRACT(MONTH FROM datum) AS month_number,
    TO_CHAR(datum, 'Month') AS month_name,
    EXTRACT(ISODOW FROM datum) AS day_of_week
FROM generate_series('2020-01-01'::DATE, '2026-12-31'::DATE, '1 day'::INTERVAL) datum
WHERE NOT EXISTS (SELECT 1 FROM dim_calendar tc WHERE tc.date_key = datum);

INSERT INTO dim_warehouses (warehouse_code, warehouse_name, country_name)
SELECT w.warehouse_code, w.warehouse_name, co.country_name
FROM oltp_src.warehouses w
JOIN oltp_src.countries co ON w.country_code = co.country_code
WHERE NOT EXISTS (SELECT 1 FROM dim_warehouses tw WHERE tw.warehouse_code = w.warehouse_code);

INSERT INTO dim_customers (customer_email, full_name, country_name)
SELECT c.customer_email, c.first_name || ' ' || c.last_name, co.country_name
FROM oltp_src.customers c
JOIN oltp_src.countries co ON c.country_code = co.country_code
WHERE NOT EXISTS (SELECT 1 FROM dim_customers tc WHERE tc.customer_email = c.customer_email);

INSERT INTO dim_categories (category_name)
SELECT DISTINCT category_name 
FROM oltp_src.categories src
WHERE NOT EXISTS (SELECT 1 FROM dim_categories tc WHERE tc.category_name = src.category_name);

INSERT INTO dim_products (product_sku, product_name, base_price, start_date, end_date, is_current)
SELECT 
    src.product_sku, 
    src.product_name, 
    src.base_price, 
    '2020-01-01'::DATE, 
    '9999-12-31'::DATE, 
    TRUE
FROM oltp_src.products src
WHERE NOT EXISTS (SELECT 1 FROM dim_products target WHERE target.product_sku = src.product_sku);

INSERT INTO bridge_product_category (product_sk, category_id)
SELECT dp.product_sk, dc.category_id
FROM oltp_src.products op
JOIN dim_products dp ON op.product_sku = dp.product_sku
JOIN oltp_src.categories oc ON op.category_slug = oc.category_slug
JOIN dim_categories dc ON oc.category_name = dc.category_name
WHERE NOT EXISTS (
    SELECT 1 FROM bridge_product_category tbc 
    WHERE tbc.product_sk = dp.product_sk AND tbc.category_id = dc.category_id
);

WITH ranked_stock AS (
    SELECT 
        product_sku, 
        warehouse_code,
        ROW_NUMBER() OVER(PARTITION BY product_sku ORDER BY quantity DESC) as rn
    FROM oltp_src.stock
)
INSERT INTO fact_sales (order_number, date_key, customer_email, product_sk, warehouse_code, quantity_sold, price_per_item, total_revenue)
SELECT 
    o.order_number,
    o.order_date::DATE,
    o.customer_email,
    dp.product_sk,
    COALESCE(rs.warehouse_code, 'UNKNOWN'),
    oi.quantity_ordered,
    oi.price_per_item,
    (oi.quantity_ordered * oi.price_per_item)
FROM oltp_src.orders o
JOIN oltp_src.order_items oi ON o.order_number = oi.order_number
JOIN dim_products dp ON oi.product_sku = dp.product_sku
LEFT JOIN ranked_stock rs ON oi.product_sku = rs.product_sku AND rs.rn = 1
WHERE NOT EXISTS (
    SELECT 1 FROM fact_sales fs 
    WHERE fs.order_number = o.order_number AND fs.product_sk = dp.product_sk
);

INSERT INTO fact_inventory (date_key, warehouse_code, product_sk, quantity_on_hand)
SELECT 
    CURRENT_DATE AS date_key,
    s.warehouse_code,
    dp.product_sk,
    s.quantity
FROM oltp_src.stock s
JOIN dim_products dp ON s.product_sku = dp.product_sku
WHERE NOT EXISTS (
    SELECT 1 FROM fact_inventory fi 
    WHERE fi.date_key = CURRENT_DATE 
      AND fi.warehouse_code = s.warehouse_code 
      AND fi.product_sk = dp.product_sk
);