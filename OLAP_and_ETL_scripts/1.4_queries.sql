-- 1. Доход по интересам
SELECT i.interest_name, SUM(fs.total_amount) AS total_revenue
FROM fact_Subscription fs
JOIN dim_Box b ON fs.box_id = b.box_id
JOIN dim_Interest i ON b.interest_id = i.interest_id
GROUP BY i.interest_name
ORDER BY total_revenue DESC;

-- 2. Количество просроченных доставок по регионам
SELECT dc.region, SUM(fdp.delayed_count) AS total_delays
FROM fact_Delivery_Performance fdp
JOIN dim_Customer dc ON fdp.customer_id = dc.customer_id
WHERE dc.is_current = TRUE
GROUP BY dc.region
ORDER BY total_delays DESC;

-- 3.Сколько было подписок на коробки по каждой дате начала подписки?
SELECT dd.date, SUM(fs.subscription_count) AS subs
FROM fact_Subscription fs
JOIN dim_Date dd ON fs.date_id = dd.date_id
GROUP BY dd.date
ORDER BY dd.date;