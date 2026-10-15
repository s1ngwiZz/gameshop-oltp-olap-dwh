SELECT 
    co.country_name AS "Страна",
    COUNT(DISTINCT o.order_number) AS "Количество заказов (шт.)",
    COUNT(DISTINCT c.customer_email) AS "Количество клиентов"
FROM countries co
JOIN customers c ON co.country_code = c.country_code
JOIN orders o ON c.customer_email = o.customer_email
GROUP BY co.country_name
ORDER BY "Количество заказов (шт.)" DESC;