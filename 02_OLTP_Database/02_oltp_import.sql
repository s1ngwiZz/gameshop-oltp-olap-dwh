DROP TABLE IF EXISTS stage_countries;
CREATE TEMP TABLE stage_countries AS SELECT * FROM countries WITH NO DATA;
COPY stage_countries FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/countries.csv' DELIMITER ',' CSV HEADER;
INSERT INTO countries SELECT * FROM stage_countries ON CONFLICT (country_code) DO NOTHING;

DROP TABLE IF EXISTS stage_categories;
CREATE TEMP TABLE stage_categories AS SELECT * FROM categories WITH NO DATA;
COPY stage_categories FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/categories.csv' DELIMITER ',' CSV HEADER;
INSERT INTO categories SELECT * FROM stage_categories ON CONFLICT (category_slug) DO NOTHING;

DROP TABLE IF EXISTS stage_products;
CREATE TEMP TABLE stage_products AS SELECT * FROM products WITH NO DATA;
COPY stage_products FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/products.csv' DELIMITER ',' CSV HEADER QUOTE '"' ESCAPE '\';
INSERT INTO products SELECT * FROM stage_products WHERE product_sku != 'SKU-MON-ASUS-32' ON CONFLICT (product_sku) DO NOTHING;

DROP TABLE IF EXISTS stage_warehouses;
CREATE TEMP TABLE stage_warehouses AS SELECT * FROM warehouses WITH NO DATA;
COPY stage_warehouses FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/warehouses.csv' DELIMITER ',' CSV HEADER;
INSERT INTO warehouses SELECT * FROM stage_warehouses ON CONFLICT (warehouse_code) DO NOTHING;

DROP TABLE IF EXISTS stage_stock;
CREATE TEMP TABLE stage_stock AS SELECT * FROM stock WITH NO DATA;
COPY stage_stock FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/stock.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock 
SELECT ss.* FROM stage_stock ss
JOIN products p ON ss.product_sku = p.product_sku
WHERE ss.product_sku != 'SKU-MON-ASUS-32'
ON CONFLICT (product_sku, warehouse_code) DO NOTHING;

DROP TABLE IF EXISTS stage_customers;
CREATE TEMP TABLE stage_customers AS SELECT * FROM customers WITH NO DATA;
COPY stage_customers FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/customers.csv' DELIMITER ',' CSV HEADER;
INSERT INTO customers SELECT * FROM stage_customers ON CONFLICT (customer_email) DO NOTHING;