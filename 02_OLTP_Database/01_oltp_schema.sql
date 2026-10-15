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