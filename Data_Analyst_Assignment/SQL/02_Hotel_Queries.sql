-- Hotel management queries (PostgreSQL-style date handling)
-- Assumptions:
--   * booking_date / bill_date are timestamptz or timestamp
--   * item_rate is the price per unit; item_quantity can be fractional
--   * All dates use UTC; adjust with AT TIME ZONE if needed

-- 1) For every user, latest (most recent) booked room number
SELECT u.user_id,
       b.room_no
FROM users u
LEFT JOIN (
    SELECT user_id,
           room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) b ON u.user_id = b.user_id
WHERE b.rn = 1;

-- 2) booking_id and total billing amount for bookings created in Nov 2021
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON bc.booking_id = b.booking_id
JOIN items i ON i.item_id = bc.item_id
WHERE b.booking_date >= DATE '2021-11-01'
  AND b.booking_date <  DATE '2021-12-01'
GROUP BY bc.booking_id
ORDER BY bc.booking_id;

-- 3) bill_id and bill amount for bills raised in Oct 2021 with bill_amount > 1000
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE bc.bill_date >= DATE '2021-10-01'
  AND bc.bill_date <  DATE '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000
ORDER BY bill_amount DESC;

-- 4) Most ordered and least ordered item (by quantity) for each month of 2021
WITH monthly_item AS (
    SELECT DATE_TRUNC('month', bc.bill_date) AS month_start,
           bc.item_id,
           SUM(bc.item_quantity) AS qty
    FROM booking_commercials bc
    WHERE bc.bill_date >= DATE '2021-01-01'
      AND bc.bill_date <  DATE '2022-01-01'
    GROUP BY DATE_TRUNC('month', bc.bill_date), bc.item_id
),
ranked AS (
    SELECT m.*,
           RANK() OVER (PARTITION BY month_start ORDER BY qty DESC) AS rnk_desc,
           RANK() OVER (PARTITION BY month_start ORDER BY qty ASC)  AS rnk_asc
    FROM monthly_item m
)
SELECT r.month_start,
       CASE WHEN rnk_desc = 1 THEN 'most_ordered' ELSE 'least_ordered' END AS bucket,
       r.item_id,
       i.item_name,
       r.qty
FROM ranked r
JOIN items i ON i.item_id = r.item_id
WHERE rnk_desc = 1 OR rnk_asc = 1
ORDER BY r.month_start, bucket;

-- 5) Customers with the second-highest bill value of each month in 2021
WITH user_month_bill AS (
    SELECT DATE_TRUNC('month', bc.bill_date) AS month_start,
           b.user_id,
           SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN bookings b ON b.booking_id = bc.booking_id
    JOIN items i ON i.item_id = bc.item_id
    WHERE bc.bill_date >= DATE '2021-01-01'
      AND bc.bill_date <  DATE '2022-01-01'
    GROUP BY DATE_TRUNC('month', bc.bill_date), b.user_id
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month_start ORDER BY bill_amount DESC) AS dr
    FROM user_month_bill
)
SELECT month_start,
       user_id,
       bill_amount
FROM ranked
WHERE dr = 2
ORDER BY month_start;
