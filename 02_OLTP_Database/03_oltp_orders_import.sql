DROP TABLE IF EXISTS stage_orders_file;
CREATE TEMP TABLE stage_orders_file (
    order_number VARCHAR(50),
    customer_email VARCHAR(100),
    order_date TIMESTAMP,
    order_status VARCHAR(30)
);

COPY stage_orders_file FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/orders.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS stage_order_items_file;
CREATE TEMP TABLE stage_order_items_file (
    order_number VARCHAR(50),
    product_sku VARCHAR(50),
    quantity_ordered INT,
    price_per_item NUMERIC(10, 2)
);

COPY stage_order_items_file FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/order_items.csv' DELIMITER ',' CSV HEADER;

INSERT INTO orders (order_number, customer_email, order_date, order_status)
SELECT DISTINCT sof.order_number, sof.customer_email, sof.order_date, sof.order_status
FROM stage_orders_file sof
JOIN stage_order_items_file soif ON sof.order_number = soif.order_number
WHERE soif.product_sku != 'SKU-MON-ASUS-32'
ON CONFLICT (order_number) DO NOTHING;

INSERT INTO order_items (order_number, product_sku, quantity_ordered, price_per_item)
SELECT soif.order_number, soif.product_sku, soif.quantity_ordered, soif.price_per_item
FROM stage_order_items_file soif
JOIN products p ON soif.product_sku = p.product_sku
WHERE soif.product_sku != 'SKU-MON-ASUS-32'
ON CONFLICT (order_number, product_sku) DO NOTHING;

DROP TABLE IF EXISTS stage_orders_file;
DROP TABLE IF EXISTS stage_order_items_file;