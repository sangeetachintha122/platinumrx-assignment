-- Clinic schema setup (PostgreSQL syntax)
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS customer;

CREATE TABLE clinics (
    cid TEXT PRIMARY KEY,
    clinic_name TEXT NOT NULL,
    city TEXT,
    state TEXT,
    country TEXT
);

CREATE TABLE customer (
    uid TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    mobile TEXT
);

CREATE TABLE clinic_sales (
    oid TEXT PRIMARY KEY,
    uid TEXT NOT NULL REFERENCES customer(uid),
    cid TEXT NOT NULL REFERENCES clinics(cid),
    amount NUMERIC(12,2) NOT NULL,
    datetime TIMESTAMP NOT NULL,
    sales_channel TEXT NOT NULL
);

CREATE TABLE expenses (
    eid TEXT PRIMARY KEY,
    cid TEXT NOT NULL REFERENCES clinics(cid),
    description TEXT,
    amount NUMERIC(12,2) NOT NULL,
    datetime TIMESTAMP NOT NULL
);

-- Seed data for quick validation
INSERT INTO clinics VALUES
('cnc-0100001', 'XYZ clinic', 'Lorem', 'Ipsum', 'Dolor'),
('cnc-0100002', 'ABC clinic', 'Lorem', 'Sit', 'Dolor');

INSERT INTO customer VALUES
('bk-09f3e-95hj', 'Jon Doe', '97XXXXXXXX'),
('bk-00abcd-1234', 'Alice Smith', '98YYYYYYYY');

INSERT INTO clinic_sales VALUES
('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'sodat'),
('ord-00200-00100', 'bk-00abcd-1234', 'cnc-0100002', 18000, '2021-11-10 10:10:00', 'online');

INSERT INTO expenses VALUES
('exp-0100-00100', 'cnc-0100001', 'first-aid supplies', 557, '2021-09-23 07:36:48'),
('exp-0200-00100', 'cnc-0100002', 'rent', 5000, '2021-11-01 09:00:00');
