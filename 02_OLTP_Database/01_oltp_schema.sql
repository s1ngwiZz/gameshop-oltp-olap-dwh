CREATE TABLE countries (
    country_code VARCHAR(3) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    category_slug VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_sku VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    base_price NUMERIC(10, 2) NOT NULL,
    category_slug VARCHAR(50) NOT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (category_slug) REFERENCES categories(category_slug)
);

CREATE TABLE warehouses (
    warehouse_code VARCHAR(20) PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(3) NOT NULL,
    CONSTRAINT fk_warehouse_country FOREIGN KEY (country_code) REFERENCES countries(country_code)
);

CREATE TABLE stock (
    product_sku VARCHAR(50),
    warehouse_code VARCHAR(20),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (product_sku, warehouse_code),
    CONSTRAINT fk_stock_product FOREIGN KEY (product_sku) REFERENCES products(product_sku),
    CONSTRAINT fk_stock_warehouse FOREIGN KEY (warehouse_code) REFERENCES warehouses(warehouse_code)
);

CREATE TABLE customers (
    customer_email VARCHAR(100) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL,
    country_code VARCHAR(3) NOT NULL,
    CONSTRAINT fk_customer_country FOREIGN KEY (country_code) REFERENCES countries(country_code)
);

CREATE TABLE orders (
    order_number VARCHAR(50) PRIMARY KEY,
    customer_email VARCHAR(100) NOT NULL,
    order_date TIMESTAMP NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_email) REFERENCES customers(customer_email)
);

CREATE TABLE order_items (
    order_number VARCHAR(50),
    product_sku VARCHAR(50),
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    price_per_item NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (order_number, product_sku),
    CONSTRAINT fk_items_order FOREIGN KEY (order_number) REFERENCES orders(order_number),
    CONSTRAINT fk_items_product FOREIGN KEY (product_sku) REFERENCES products(product_sku)
);