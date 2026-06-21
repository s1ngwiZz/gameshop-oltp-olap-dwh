SELECT 
    dc.category_name AS "Категория",
    p.product_name AS "Товар",
    SUM(f.quantity_sold) AS "Продано (шт)",
    SUM(f.total_revenue) AS "Выручка (€)",
    RANK() OVER(PARTITION BY dc.category_name ORDER BY SUM(f.total_revenue) DESC) AS "Ранг в категории"
FROM fact_sales f
JOIN dim_products p ON f.product_sk = p.product_sk
JOIN bridge_product_category bpc ON p.product_sk = bpc.product_sk
JOIN dim_categories dc ON bpc.category_id = dc.category_id
GROUP BY dc.category_name, p.product_name
ORDER BY "Категория", "Ранг в категории";