SELECT 
    c.category_name AS "Категория",
    SUM(f.quantity_sold) AS "Продано штук",
    SUM(f.total_revenue) AS "Общая выручка (€)"
FROM fact_sales f
JOIN dim_products p ON f.product_sk = p.product_sk
JOIN bridge_product_category bpc ON p.product_sk = bpc.product_sk
JOIN dim_categories c ON bpc.category_id = c.category_id
GROUP BY c.category_name
ORDER BY "Общая выручка (€)" DESC;