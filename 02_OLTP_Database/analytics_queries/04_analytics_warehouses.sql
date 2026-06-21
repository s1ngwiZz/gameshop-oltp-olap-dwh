SELECT 
    w.warehouse_code AS "Код склада",
    w.warehouse_name AS "Название склада",
    co.country_name AS "Страна",
    COUNT(s.product_sku) AS "Уникальных товаров (видов)",
    SUM(s.quantity) AS "Всего единиц на складе (шт.)",
    SUM(s.quantity * p.base_price) AS "Общая ценность запасов (€)"
FROM stock s
JOIN warehouses w ON s.warehouse_code = w.warehouse_code
JOIN countries co ON w.country_code = co.country_code
JOIN products p ON s.product_sku = p.product_sku
GROUP BY w.warehouse_code, w.warehouse_name, co.country_name
ORDER BY "Общая ценность запасов (€)" DESC;