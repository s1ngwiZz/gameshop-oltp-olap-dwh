SELECT 
    c.year_number AS "Год",
    c.quarter_number AS "Квартал",
    dc.category_name AS "Категория",
    SUM(f.quantity_sold) AS "Продано (шт)",
    SUM(f.total_revenue) AS "Выручка (€)"
FROM fact_sales f
JOIN dim_calendar c ON f.date_key = c.date_key
JOIN dim_products p ON f.product_sk = p.product_sk
JOIN bridge_product_category bpc ON p.product_sk = bpc.product_sk
JOIN dim_categories dc ON bpc.category_id = dc.category_id
GROUP BY ROLLUP(c.year_number, c.quarter_number, dc.category_name)
ORDER BY c.year_number, c.quarter_number NULLS LAST, dc.category_name NULLS LAST;