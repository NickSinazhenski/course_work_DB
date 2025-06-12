-- USERS
CREATE TABLE IF NOT EXISTS Users (
    email TEXT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    phone_number TEXT,
    created_date DATE,
    password_hash TEXT,
    gender TEXT,
    region TEXT
);	


-- INTERESTS
CREATE TABLE IF NOT EXISTS Interests (
    interest_name TEXT PRIMARY KEY
);


-- USERS_INTERESTS
CREATE TABLE IF NOT EXISTS Users_Interests (
    email TEXT,
    interest_name TEXT,
    weight NUMERIC NOT NULL,
    PRIMARY KEY (email, interest_name),
    FOREIGN KEY (email) REFERENCES Users(email),
    FOREIGN KEY (interest_name) REFERENCES Interests(interest_name)
);


-- BOXES
CREATE TABLE IF NOT EXISTS Boxes (
    box_name TEXT PRIMARY KEY,
    interest_name TEXT,
    description TEXT,
    price NUMERIC,
    is_available BOOLEAN,
    FOREIGN KEY (interest_name) REFERENCES Interests(interest_name)
);


-- ITEMS
CREATE TABLE IF NOT EXISTS Items (
    serial_name TEXT PRIMARY KEY,
    item_name TEXT,
    brand TEXT,
    item_description TEXT
);


-- BOX_ITEMS
CREATE TABLE IF NOT EXISTS Box_Items (
    box_name TEXT,
    serial_name TEXT,
    PRIMARY KEY (box_name, serial_name),
    FOREIGN KEY (box_name) REFERENCES Boxes(box_name),
    FOREIGN KEY (serial_name) REFERENCES Items(serial_name)
);


-- SUBSCRIPTIONS
CREATE TABLE IF NOT EXISTS Subscriptions (
    email TEXT,
    box_name TEXT,
    start_date DATE,
    end_date DATE,
    subscription_status TEXT,
    PRIMARY KEY (email, box_name, start_date),
    FOREIGN KEY (email) REFERENCES Users(email),
    FOREIGN KEY (box_name) REFERENCES Boxes(box_name)
);


-- PAYMENTS
CREATE TABLE IF NOT EXISTS Payments (
    email TEXT,
    box_name TEXT,
    start_date DATE,
    payment_date DATE,
    payment_method TEXT,
    amount NUMERIC,
    PRIMARY KEY (email, box_name, start_date, payment_date),
    FOREIGN KEY (email, box_name, start_date) REFERENCES Subscriptions(email, box_name, start_date)
);


-- DELIVERS
CREATE TABLE IF NOT EXISTS Delivers (
    email TEXT,
    box_name TEXT,
    start_date DATE,
    delivery_date DATE,
    tracking_number TEXT,
    delivery_status TEXT,
    planned_delivery_date DATE,
    PRIMARY KEY (email, box_name, start_date, delivery_date),
    FOREIGN KEY (email, box_name, start_date) REFERENCES Subscriptions(email, box_name, start_date)
);


-- REVIEWS
CREATE TABLE IF NOT EXISTS Reviews (
    email TEXT,
    box_name TEXT,
    review_date DATE,
    rating INTEGER,
    comment TEXT,
    PRIMARY KEY (email, box_name, review_date),
    FOREIGN KEY (email) REFERENCES Users(email),
    FOREIGN KEY (box_name) REFERENCES Boxes(box_name)
);
