USE sql_store;

SELECT *
FROM customers
-- WHERE customer_id = 1
ORDER BY first_name;

SELECT first_name, last_name
FROM customers;

SELECT first_name,
       last_name,
       points,
       points * 10 + 100 AS 'special discount'
FROM customers;

-- Comparison operations
SELECT *
FROM customers
WHERE birth_date > '1990-01-01';

-- Logical operations
SELECT *
FROM customers
WHERE birth_date > '1990-01-01' OR
      NOT (points > 1000 AND state = 'VA');

-- IN operator
SELECT *
FROM customers
WHERE state = 'VA'
   OR state = 'GA'
   or state = 'FL';

SELECT *
FROM customers
WHERE state IN ('VA', 'GA', 'FL');

SELECT *
FROM customers
WHERE state NOT IN ('VA', 'GA', 'FL');