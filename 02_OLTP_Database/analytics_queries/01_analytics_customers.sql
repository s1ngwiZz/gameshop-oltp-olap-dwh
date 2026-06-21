SELECT 
    c.customer_email AS "Email Покупателя",
    c.first_name || ' ' || c.last_name AS "ФИО Клиента",
    co.country_name AS "Страна проживания",
    COUNT(DISTINCT o.order_number) AS "Всего заказов (шт.)",
    SUM(oi.quantity_ordered * oi.price_per_item) AS "Общая сумма покупок (€)",
    ROUND(AVG(oi.quantity_ordered * oi.price_per_item), 2) AS "Средний чек (€)"
FROM customers c
JOIN countries co ON c.country_code = co.country_code
JOIN orders o ON c.customer_email = o.customer_email
JOIN order_items oi ON o.order_number = oi.order_number
GROUP BY c.customer_email, c.first_name, c.last_name, co.country_name
ORDER BY "Общая сумма покупок (€)" DESC;