SELECT 
    w.warehouse_name AS "Склад",
    p.product_name AS "Товар",
    i.quantity_on_hand AS "Остаток на складе",
    p.base_price AS "Базовая цена",
    (i.quantity_on_hand * p.base_price) AS "Оценка стоимости остатков"
FROM fact_inventory i
JOIN dim_warehouses w ON i.warehouse_code = w.warehouse_code
JOIN dim_products p ON i.product_sk = p.product_sk
WHERE p.is_current = TRUE
ORDER BY "Оценка стоимости остатков" DESC;