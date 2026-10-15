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
INSERT INTO products SELECT * FROM stage_products ON CONFLICT (product_sku) DO NOTHING;

DROP TABLE IF EXISTS stage_customers;
CREATE TEMP TABLE stage_customers AS SELECT * FROM customers WITH NO DATA;
COPY stage_customers FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/customers.csv' DELIMITER ',' CSV HEADER;
INSERT INTO customers SELECT * FROM stage_customers ON CONFLICT (customer_email) DO NOTHING;

DROP TABLE IF EXISTS stage_orders;
CREATE TEMP TABLE stage_orders AS SELECT * FROM orders WITH NO DATA;
COPY stage_orders FROM 'C:/Database_Coursework_GameShop/01_Initial_Data_CSV/orders.csv' DELIMITER ',' CSV HEADER;
INSERT INTO orders SELECT * FROM stage_orders ON CONFLICT (order_number) DO NOTHING;