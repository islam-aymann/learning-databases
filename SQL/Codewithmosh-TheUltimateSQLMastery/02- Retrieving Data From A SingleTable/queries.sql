USE
sql_store;
-------------------------------------------------------------------------------
-- SELECT clause
-- Retrieves data from tables

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

-------------------------------------------------------------------------------
-- Comparison operations
-- <, <=, >, >=, =, !=(<>)

SELECT *
FROM customers
WHERE birth_date > '1990-01-01';

-------------------------------------------------------------------------------
-- Logical operations
-- AND, OR, NOT

SELECT *
FROM customers
WHERE birth_date > '1990-01-01'
   OR NOT (points > 1000 AND state = 'VA');

-------------------------------------------------------------------------------
-- IN operator
-- Searches for a match in list of values

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

-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- LIKE
-- Finds a row with a pattern

-- find entry that contains letter 'b'
-- '%': any number of characters
-- '_': single character
-- '%f%': contains 'f'
-- '%f': endswith 'f'
-- 'f%': startswith 'f'
-- '_f': exactly two letters and endswith f

SELECT *
FROM customers
WHERE last_name LIKE '%f%';

-------------------------------------------------------------------------------
-- REGEXP
-- Uses regular expression to search in strings
-- '^': startswith
-- '$': end of string
-- '|': ORing for multiple patterns
-- '[abc]': string contains any of 'a' or 'b' or 'c'
-- '[a-h]': string contains any of range from 'a' to 'h'

-- Find all customers whose
-- last_name contains 'field' or 'mac' or startswith 'rose'
SELECT *
FROM customers
WHERE last_name REGEXP 'field|mac|^rose';

SELECT *
FROM customers
WHERE last_name REGEXP '[gim]e';
-- Returns 'Brushfield' and 'Boagey'

-------------------------------------------------------------------------------
-- NULL
-- No value
-- IS NULL: field is empty
-- ISS NOT NULL: field is not empty
SELECT *
FROM orders
WHERE shipped_date IS NULL;

-------------------------------------------------------------------------------
-- ORDER BY
-- Orders the query set by a field
-- DESC: descending order
-- ASC: descending order

SELECT *
FROM customers
ORDER BY state DESC, first_name DESC;

SELECT first_name, last_name, points % 5 AS new_points
FROM customers
ORDER BY new_points, state DESC, first_name DESC;

-- Not preferred
SELECT first_name, last_name
FROM customers
ORDER BY 1, 2; -- column positions

SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;