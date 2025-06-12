-- Создаём EXTENSION 
CREATE EXTENSION IF NOT EXISTS dblink;

-- DIMENSIONS

-- dim_Date
INSERT INTO dim_Date (date)
SELECT DISTINCT start_date
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT start_date FROM Subscriptions WHERE start_date IS NOT NULL'
) AS t(start_date DATE)
WHERE start_date NOT IN (SELECT date FROM dim_Date);

-- dim_Interest
INSERT INTO dim_Interest (interest_name)
SELECT DISTINCT interest_name
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT interest_name FROM Interests'
) AS t(interest_name TEXT)
WHERE interest_name NOT IN (SELECT interest_name FROM dim_Interest);

-- dim_Box
INSERT INTO dim_Box (interest_id, box_name, price)
SELECT di.interest_id, b.box_name, b.price
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT box_name, interest_name, price FROM Boxes'
) AS b(box_name TEXT, interest_name TEXT, price NUMERIC)
JOIN dim_Interest di ON b.interest_name = di.interest_name
WHERE b.box_name NOT IN (SELECT box_name FROM dim_Box);

-- SCD Type 2

--dim_Customer 
UPDATE dim_Customer AS target
SET end_date = CURRENT_DATE, is_current = FALSE
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT email, first_name, last_name, region, gender FROM Users'
) AS src(email TEXT, first_name TEXT, last_name TEXT, region TEXT, gender TEXT)
WHERE target.email = src.email AND target.is_current = TRUE
  AND (
    target.first_name IS DISTINCT FROM src.first_name OR
    target.last_name IS DISTINCT FROM src.last_name OR
    target.region IS DISTINCT FROM src.region OR
    target.gender IS DISTINCT FROM src.gender
  );


INSERT INTO dim_Customer (email, first_name, last_name, region, gender, start_date, end_date, is_current)
SELECT src.email, src.first_name, src.last_name, src.region, src.gender, CURRENT_DATE, NULL, TRUE
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT email, first_name, last_name, region, gender FROM Users'
) AS src(email TEXT, first_name TEXT, last_name TEXT, region TEXT, gender TEXT)
WHERE NOT EXISTS (
    SELECT 1 FROM dim_Customer current
    WHERE current.email = src.email AND current.is_current = TRUE
);

-- BRIDGE 

INSERT INTO bridge_Customer_Interest (customer_id, interest_id, weight)
SELECT dc.customer_id, di.interest_id, ui.weight
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT email, interest_name, weight FROM Users_Interests'
) AS ui(email TEXT, interest_name TEXT, weight NUMERIC)
JOIN dim_Customer dc ON ui.email = dc.email AND dc.is_current = TRUE
JOIN dim_Interest di ON ui.interest_name = di.interest_name
WHERE NOT EXISTS (
    SELECT 1 FROM bridge_Customer_Interest bci
    WHERE bci.customer_id = dc.customer_id AND bci.interest_id = di.interest_id
);

-- FACT TABLES 

-- fact_Subscription
INSERT INTO fact_Subscription (customer_id, box_id, date_id, subscription_count, total_amount)
SELECT dc.customer_id, db.box_id, dd.date_id, COUNT(*) AS subscription_count, SUM(db.price) AS total_amount
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT email, box_name, start_date FROM Subscriptions'
) AS s(email TEXT, box_name TEXT, start_date DATE)
JOIN dim_Customer dc ON s.email = dc.email AND dc.is_current = TRUE
JOIN dim_Box db ON s.box_name = db.box_name
JOIN dim_Date dd ON s.start_date = dd.date
GROUP BY dc.customer_id, db.box_id, dd.date_id
HAVING NOT EXISTS (
    SELECT 1 FROM fact_Subscription fs
    WHERE fs.customer_id = dc.customer_id AND fs.box_id = db.box_id AND fs.date_id = dd.date_id
);

-- fact_Delivery_Performance
INSERT INTO fact_Delivery_Performance (customer_id, box_id, date_id, delivery_count, delayed_count)
SELECT dc.customer_id, db.box_id, dd.date_id,
       COUNT(*) AS delivery_count,
       COUNT(*) FILTER (WHERE d.delivery_date > d.planned_delivery_date) AS delayed_count
FROM dblink(
    'dbname=oltp host=localhost user=postgres password=n147',
    'SELECT email, box_name, start_date, delivery_date, planned_delivery_date FROM Delivers'
) AS d(email TEXT, box_name TEXT, start_date DATE, delivery_date DATE, planned_delivery_date DATE)
JOIN dim_Customer dc ON d.email = dc.email AND dc.is_current = TRUE
JOIN dim_Box db ON d.box_name = db.box_name
JOIN dim_Date dd ON d.start_date = dd.date
GROUP BY dc.customer_id, db.box_id, dd.date_id
HAVING NOT EXISTS (
    SELECT 1 FROM fact_Delivery_Performance fdp
    WHERE fdp.customer_id = dc.customer_id AND fdp.box_id = db.box_id AND fdp.date_id = dd.date_id
);
