-- 1. Сколько активных подписок на каждую коробку
SELECT box_name, COUNT(*) AS active_subs
FROM Subscriptions
WHERE subscription_status = 'active'
GROUP BY box_name
ORDER BY active_subs DESC;

-- 2. Средний рейтинг по коробкам
SELECT box_name, AVG(rating) AS avg_rating
FROM Reviews
GROUP BY box_name
ORDER BY avg_rating DESC;

-- 3. ТОП-5 пользователей по сумме платежей
SELECT s.email, SUM(p.amount) AS total_paid
FROM Payments p
JOIN Subscriptions s ON p.email = s.email AND p.box_name = s.box_name AND p.start_date = s.start_date
GROUP BY s.email
ORDER BY total_paid DESC
LIMIT 5;