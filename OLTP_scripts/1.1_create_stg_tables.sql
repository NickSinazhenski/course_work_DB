-- USERS
DROP TABLE IF EXISTS stg_users;

CREATE TABLE stg_users (
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    phone_number TEXT,
    created_date DATE,
    password_hash TEXT,
    gender TEXT,
    region TEXT
);

-- INTERESTS
DROP TABLE IF EXISTS stg_interests;

CREATE TABLE stg_interests (
    interest_name TEXT
);

-- USERS_INTERESTS
DROP TABLE IF EXISTS stg_users_interests;

CREATE TABLE stg_users_interests (
    email TEXT,
    interest_name TEXT,
    weight NUMERIC
);

-- BOXES

DROP TABLE IF EXISTS stg_boxes;

CREATE TABLE stg_boxes (
    box_name TEXT,
    interest_name TEXT,
    description TEXT,
    price NUMERIC,
    is_available BOOLEAN
);

-- ITEMS
DROP TABLE IF EXISTS stg_items;

CREATE TABLE stg_items (
    serial_name TEXT,
    item_name TEXT,
    brand TEXT,
    item_description TEXT
);

-- BOX_ITEMS
DROP TABLE IF EXISTS stg_box_items;

CREATE TABLE stg_box_items (
    box_name TEXT,
    serial_name TEXT
);

-- SUBSCRIPTIONS
DROP TABLE IF EXISTS stg_subscriptions;

CREATE TABLE stg_subscriptions (
    email TEXT,
    box_name TEXT,
    start_date DATE,
    end_date DATE,
    subscription_status TEXT
);

-- PAYMENTS
DROP TABLE IF EXISTS stg_payments;

CREATE TABLE stg_payments (
    email TEXT,
    box_name TEXT,
    start_date DATE,
    payment_date DATE,
    payment_method TEXT,
    amount NUMERIC
);

-- DELIVERS
DROP TABLE IF EXISTS stg_delivers;

CREATE TABLE stg_delivers (
    email TEXT,
    box_name TEXT,
    start_date DATE,
    delivery_date DATE,
    tracking_number TEXT,
    delivery_status TEXT,
    planned_delivery_date DATE
);

-- REVIEWS
DROP TABLE IF EXISTS stg_reviews;

CREATE TABLE stg_reviews (
    email TEXT,
    box_name TEXT,
    review_date DATE,
    rating INTEGER,
    comment TEXT
);