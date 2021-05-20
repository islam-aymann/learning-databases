USE
sql_store;

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
WHERE birth_date > '1990-01-01'
   OR NOT (points > 1000 AND state = 'VA');

-- IN operator
SELECT *
FROM customers
WHERE state = 'VA'
   OR state = 'GA'
   OR state = 'FL';

SELECT *
FROM customers
WHERE state IN ('VA', 'GA', 'FL');

SELECT *
FROM customers
WHERE state NOT IN ('VA', 'GA', 'FL');

-- BETWEEN operator
-- Defines a range
SELECT *
FROM customers
WHERE points >= 1000
  AND points <= 3000;

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- LIKE
-- Finds a row with a pattern
SELECT *
FROM customers
WHERE last_name LIKE '%f%'; -- find entry that contains letter 'b'
-- %: any number of characters
-- _: single character
-- '%f%': contains 'f'
-- '%f': endswith 'f'
-- 'f%': startswith 'f'
-- '_f': exactly two letters and endswith f