-- USERS
INSERT INTO Users (
    email, first_name, last_name, phone_number, created_date, password_hash, gender, region
)
SELECT DISTINCT ON (email)
    email, first_name, last_name, phone_number, created_date, password_hash, gender, region
FROM stg_users
ORDER BY email, created_date DESC
ON CONFLICT (email) DO UPDATE
SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    phone_number = EXCLUDED.phone_number,
    created_date = EXCLUDED.created_date,
    password_hash = EXCLUDED.password_hash,
    gender = EXCLUDED.gender,
    region = EXCLUDED.region
WHERE
    Users.first_name IS DISTINCT FROM EXCLUDED.first_name OR
    Users.last_name IS DISTINCT FROM EXCLUDED.last_name OR
    Users.phone_number IS DISTINCT FROM EXCLUDED.phone_number OR
    Users.created_date IS DISTINCT FROM EXCLUDED.created_date OR
    Users.password_hash IS DISTINCT FROM EXCLUDED.password_hash OR
    Users.gender IS DISTINCT FROM EXCLUDED.gender OR
    Users.region IS DISTINCT FROM EXCLUDED.region;

-- INTERESTS
INSERT INTO Interests (interest_name)
SELECT interest_name
FROM stg_interests
ON CONFLICT (interest_name) DO NOTHING;

-- USERS_INTERESTS
INSERT INTO Users_Interests (email, interest_name, weight)
SELECT email, interest_name, weight
FROM stg_users_interests
ON CONFLICT (email, interest_name) DO UPDATE
SET weight = EXCLUDED.weight
WHERE Users_Interests.weight IS DISTINCT FROM EXCLUDED.weight;

-- BOXES
INSERT INTO Boxes (box_name, interest_name, description, price, is_available)
SELECT box_name, interest_name, description, price, is_available
FROM stg_boxes
ON CONFLICT (box_name) DO UPDATE
SET
    interest_name = EXCLUDED.interest_name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    is_available = EXCLUDED.is_available
WHERE
    Boxes.interest_name IS DISTINCT FROM EXCLUDED.interest_name OR
    Boxes.description IS DISTINCT FROM EXCLUDED.description OR
    Boxes.price IS DISTINCT FROM EXCLUDED.price OR
    Boxes.is_available IS DISTINCT FROM EXCLUDED.is_available;

-- ITEMS
INSERT INTO Items (serial_name, item_name, brand, item_description)
SELECT serial_name, item_name, brand, item_description
FROM stg_items
ON CONFLICT (serial_name) DO UPDATE
SET
    item_name = EXCLUDED.item_name,
    brand = EXCLUDED.brand,
    item_description = EXCLUDED.item_description
WHERE
    Items.item_name IS DISTINCT FROM EXCLUDED.item_name OR
    Items.brand IS DISTINCT FROM EXCLUDED.brand OR
    Items.item_description IS DISTINCT FROM EXCLUDED.item_description;

-- BOX_ITEMS
INSERT INTO Box_Items (box_name, serial_name)
SELECT box_name, serial_name
FROM stg_box_items
ON CONFLICT (box_name, serial_name) DO NOTHING;

-- SUBSCRIPTIONS
INSERT INTO Subscriptions (email, box_name, start_date, end_date, subscription_status)
SELECT email, box_name, start_date, end_date, subscription_status
FROM stg_subscriptions
ON CONFLICT (email, box_name, start_date) DO UPDATE
SET
    end_date = EXCLUDED.end_date,
    subscription_status = EXCLUDED.subscription_status
WHERE
    Subscriptions.end_date IS DISTINCT FROM EXCLUDED.end_date OR
    Subscriptions.subscription_status IS DISTINCT FROM EXCLUDED.subscription_status;

-- PAYMENTS
INSERT INTO Payments (email, box_name, start_date, payment_date, payment_method, amount)
SELECT email, box_name, start_date, payment_date, payment_method, amount
FROM stg_payments
ON CONFLICT (email, box_name, start_date, payment_date) DO UPDATE
SET
    payment_method = EXCLUDED.payment_method,
    amount = EXCLUDED.amount
WHERE
    Payments.payment_method IS DISTINCT FROM EXCLUDED.payment_method OR
    Payments.amount IS DISTINCT FROM EXCLUDED.amount;

-- DELIVERS
INSERT INTO Delivers (email, box_name, start_date, delivery_date, tracking_number, delivery_status, planned_delivery_date)
SELECT email, box_name, start_date, delivery_date, tracking_number, delivery_status, planned_delivery_date
FROM stg_delivers
ON CONFLICT (email, box_name, start_date, delivery_date) DO UPDATE
SET
    tracking_number = EXCLUDED.tracking_number,
    delivery_status = EXCLUDED.delivery_status,
    planned_delivery_date = EXCLUDED.planned_delivery_date
WHERE
    Delivers.tracking_number IS DISTINCT FROM EXCLUDED.tracking_number OR
    Delivers.delivery_status IS DISTINCT FROM EXCLUDED.delivery_status OR
    Delivers.planned_delivery_date IS DISTINCT FROM EXCLUDED.planned_delivery_date;

-- REVIEWS
INSERT INTO Reviews (email, box_name, review_date, rating, comment)
SELECT email, box_name, review_date, rating, comment
FROM stg_reviews
ON CONFLICT (email, box_name, review_date) DO UPDATE
SET
    rating = EXCLUDED.rating,
    comment = EXCLUDED.comment
WHERE
    Reviews.rating IS DISTINCT FROM EXCLUDED.rating OR
    Reviews.comment IS DISTINCT FROM EXCLUDED.comment;