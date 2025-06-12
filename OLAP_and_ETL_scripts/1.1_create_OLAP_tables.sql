-- dim_Date
CREATE TABLE IF NOT EXISTS dim_Date (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE
);

-- dim_Interest
CREATE TABLE IF NOT EXISTS dim_Interest (
    interest_id SERIAL PRIMARY KEY,
    interest_name TEXT NOT NULL UNIQUE
);

-- dim_Box
CREATE TABLE IF NOT EXISTS dim_Box (
    box_id SERIAL PRIMARY KEY,
    interest_id INTEGER REFERENCES dim_Interest(interest_id),
    box_name TEXT NOT NULL UNIQUE,
    price NUMERIC
);

-- dim_Customer (SCD Type 2)
CREATE TABLE IF NOT EXISTS dim_Customer (
    customer_id SERIAL PRIMARY KEY,
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    region TEXT,
    gender TEXT,
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);

-- bridge_Customer_Interest
CREATE TABLE IF NOT EXISTS bridge_Customer_Interest (
    customer_id INTEGER REFERENCES dim_Customer(customer_id),
    interest_id INTEGER REFERENCES dim_Interest(interest_id),
    weight NUMERIC,
    PRIMARY KEY (customer_id, interest_id)
);

-- fact_Subscription
CREATE TABLE IF NOT EXISTS fact_Subscription (
    subscription_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_Customer(customer_id),
    box_id INTEGER REFERENCES dim_Box(box_id),
    date_id INTEGER REFERENCES dim_Date(date_id),
    subscription_count INTEGER,
    total_amount NUMERIC
);

-- fact_Delivery_Performance
CREATE TABLE IF NOT EXISTS fact_Delivery_Performance (
    delivery_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_Customer(customer_id),
    box_id INTEGER REFERENCES dim_Box(box_id),
    date_id INTEGER REFERENCES dim_Date(date_id),
    delivery_count INTEGER,
    delayed_count INTEGER
);
