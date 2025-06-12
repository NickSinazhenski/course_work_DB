-- USERS
COPY stg_users(email, first_name, last_name, phone_number, created_date, password_hash, gender, region)
FROM '/Library/PostgreSQL/17/data/import/users.csv'
DELIMITER ',' CSV HEADER;

-- INTERESTS
COPY stg_interests(interest_name)
FROM '/Library/PostgreSQL/17/data/import/interests.csv'
DELIMITER ',' CSV HEADER;

-- USERS_INTERESTS
COPY stg_users_interests(email, interest_name, weight)
FROM '/Library/PostgreSQL/17/data/import/users_interests.csv'
DELIMITER ',' CSV HEADER;

-- BOXES
COPY stg_boxes(box_name, interest_name, description, price, is_available)
FROM '/Library/PostgreSQL/17/data/import/boxes.csv'
DELIMITER ',' CSV HEADER;

-- ITEMS
COPY stg_items(serial_name, item_name, brand, item_description)
FROM '/Library/PostgreSQL/17/data/import/items.csv'
DELIMITER ',' CSV HEADER;

-- BOX_ITEMS
COPY stg_box_items(box_name, serial_name)
FROM '/Library/PostgreSQL/17/data/import/box_items.csv'
DELIMITER ',' CSV HEADER;

-- SUBSCRIPTIONS
COPY stg_subscriptions(email, box_name, start_date, end_date, subscription_status)
FROM '/Library/PostgreSQL/17/data/import/subscriptions.csv'
DELIMITER ',' CSV HEADER;

-- PAYMENTS
COPY stg_payments(email, box_name, start_date, payment_date, payment_method, amount)
FROM '/Library/PostgreSQL/17/data/import/payments.csv'
DELIMITER ',' CSV HEADER;

-- DELIVERS
COPY stg_delivers(email, box_name, start_date, delivery_date, tracking_number, delivery_status, planned_delivery_date)
FROM '/Library/PostgreSQL/17/data/import/delivers.csv'
DELIMITER ',' CSV HEADER;

-- REVIEWS
COPY stg_reviews(email, box_name, review_date, rating, comment)
FROM '/Library/PostgreSQL/17/data/import/reviews.csv'
DELIMITER ',' CSV HEADER;
