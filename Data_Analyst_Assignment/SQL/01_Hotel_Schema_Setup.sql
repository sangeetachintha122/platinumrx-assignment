-- Hotel schema setup (PostgreSQL syntax; adjust types for MySQL if needed)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    phone_number TEXT,
    mail_id TEXT,
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id TEXT PRIMARY KEY,
    booking_date TIMESTAMP NOT NULL,
    room_no TEXT NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id TEXT PRIMARY KEY,
    item_name TEXT NOT NULL,
    item_rate NUMERIC(12,2) NOT NULL
);

CREATE TABLE booking_commercials (
    id TEXT PRIMARY KEY,
    booking_id TEXT NOT NULL REFERENCES bookings(booking_id),
    bill_id TEXT NOT NULL,
    bill_date TIMESTAMP NOT NULL,
    item_id TEXT NOT NULL REFERENCES items(item_id),
    item_quantity NUMERIC(12,2) NOT NULL
);

-- Minimal seed data for testing
INSERT INTO users VALUES
('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX, Street Y, ABC City'),
('21wrcxuy-99test', 'Jane Roe', '98YYYYYYYY', 'jane.roe@example.com', 'ZZ, Street Q, DEF City');

INSERT INTO items VALUES
('itm-a9e8-q8fu', 'Tawa Paratha', 18),
('itm-a07vh-aer8', 'Mix Veg', 89),
('itm-w978-23u4', 'Dal Fry', 75);

INSERT INTO bookings VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-11abc-22def', '2021-11-05 10:15:00', 'rm-123', '21wrcxuy-99test');

INSERT INTO booking_commercials VALUES
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('134lr-oyfo8-3qk4', 'bk-11abc-22def', 'bl-34qhd-r7h8', '2021-11-05 11:00:00', 'itm-w978-23u4', 2.5);
