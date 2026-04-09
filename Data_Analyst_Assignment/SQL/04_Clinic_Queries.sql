-- Clinic management queries (PostgreSQL style)
-- Parameters:
--   :year  - reporting year (e.g., 2021)
--   :month - reporting month number (1-12) where noted

-- 1) Revenue by sales channel for a given year
SELECT sales_channel,
       SUM(amount) AS revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = :year
GROUP BY sales_channel
ORDER BY revenue DESC;

-- 2) Top 10 most valuable customers for a given year (by revenue)
SELECT cs.uid,
       c.name,
       SUM(cs.amount) AS revenue
FROM clinic_sales cs
JOIN customer c ON c.uid = cs.uid
WHERE EXTRACT(YEAR FROM cs.datetime) = :year
GROUP BY cs.uid, c.name
ORDER BY revenue DESC
LIMIT 10;

-- 3) Month-wise revenue, expense, profit, and profitability flag for a given year
WITH months AS (
    SELECT DATE_TRUNC('month', DATE_TRUNC('year', DATE ':year-01-01') + (n || ' months')::interval) AS month_start
    FROM generate_series(0, 11) AS g(n)
),
rev AS (
    SELECT DATE_TRUNC('month', datetime) AS month_start,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = :year
    GROUP BY DATE_TRUNC('month', datetime)
),
exp AS (
    SELECT DATE_TRUNC('month', datetime) AS month_start,
           SUM(amount) AS expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = :year
    GROUP BY DATE_TRUNC('month', datetime)
)
SELECT m.month_start,
       COALESCE(r.revenue, 0) AS revenue,
       COALESCE(e.expense, 0) AS expense,
       COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
       CASE WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) >= 0
            THEN 'profitable'
            ELSE 'not-profitable'
       END AS status
FROM months m
LEFT JOIN rev r ON r.month_start = m.month_start
LEFT JOIN exp e ON e.month_start = m.month_start
ORDER BY m.month_start;

-- 4) Most profitable clinic per city for a given month
WITH revenue AS (
    SELECT cid,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = :year
      AND EXTRACT(MONTH FROM datetime) = :month
    GROUP BY cid
),
expense AS (
    SELECT cid,
           SUM(amount) AS expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = :year
      AND EXTRACT(MONTH FROM datetime) = :month
    GROUP BY cid
),
profit AS (
    SELECT c.cid,
           c.city,
           COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit_amount
    FROM clinics c
    LEFT JOIN revenue r ON r.cid = c.cid
    LEFT JOIN expense e ON e.cid = c.cid
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit_amount DESC) AS rnk
    FROM profit
)
SELECT city,
       cid,
       profit_amount
FROM ranked
WHERE rnk = 1
ORDER BY city;

-- 5) Second least profitable clinic per state for a given month
WITH revenue AS (
    SELECT cid,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = :year
      AND EXTRACT(MONTH FROM datetime) = :month
    GROUP BY cid
),
expense AS (
    SELECT cid,
           SUM(amount) AS expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = :year
      AND EXTRACT(MONTH FROM datetime) = :month
    GROUP BY cid
),
profit AS (
    SELECT c.cid,
           c.state,
           COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit_amount
    FROM clinics c
    LEFT JOIN revenue r ON r.cid = c.cid
    LEFT JOIN expense e ON e.cid = c.cid
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY state ORDER BY profit_amount ASC) AS rnk
    FROM profit
)
SELECT state,
       cid,
       profit_amount
FROM ranked
WHERE rnk = 2
ORDER BY state;
