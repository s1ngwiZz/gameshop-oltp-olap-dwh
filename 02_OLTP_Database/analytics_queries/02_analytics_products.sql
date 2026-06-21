SELECT 
    p.product_sku AS "Артикул",
    p.product_name AS "Название товара",
    c.category_name AS "Категория",
    SUM(oi.quantity_ordered) AS "Продано единиц (шт.)",
    SUM(oi.quantity_ordered * oi.price_per_item) AS "Генерация выручки (€)"
FROM order_items oi
JOIN products p ON oi.product_sku = p.product_sku
JOIN categories c ON p.category_slug = c.category_slug
GROUP BY p.product_sku, p.product_name, c.category_name
ORDER BY "Генерация выручки (€)" DESC;