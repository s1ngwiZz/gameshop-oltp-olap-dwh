SELECT 
    co.country_name AS "Страна",
    COUNT(DISTINCT o.order_number) AS "Количество заказов (шт.)",
    SUM(oi.quantity_ordered) AS "Продано товаров (шт.)",
    SUM(oi.quantity_ordered * oi.price_per_item) AS "Общая выручка (€)"
FROM order_items oi
JOIN orders o ON oi.order_number = o.order_number
JOIN customers c ON o.customer_email = c.customer_email
JOIN countries co ON c.country_code = co.country_code
GROUP BY co.country_name
ORDER BY "Общая выручка (€)" DESC;