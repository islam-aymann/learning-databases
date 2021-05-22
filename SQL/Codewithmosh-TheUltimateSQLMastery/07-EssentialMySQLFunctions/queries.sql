-- ----------------------------------------------------------------------------
-- Numeric functions
SELECT ROUND(5.7345, 1); -- > 5.7
SELECT ROUND(5.7345, 3); -- > 5.73
SELECT TRUNCATE(5.7945, 1); -- > 5.7
SELECT CEILING(5.7945); -- > 6
SELECT FLOOR(5.7945); -- > 5
SELECT ABS(-5.2); -- > 5.2
SELECT RAND();
-- > random float (0 --> 1)

-- ----------------------------------------------------------------------------
-- String functions
SELECT LENGTH('sky'); -- > 3
SELECT LOWER('SkYFalL'); -- > skyfall
SELECT UPPER('SkYFalL'); -- > SKYFALL
SELECT TRIM('  SKY  '); -- > 'SKY'
SELECT LTRIM('  SKY  '); -- > 'SKY  '
SELECT RTRIM('  SKY  '); -- > '  SKY'
SELECT LEFT('abcdefg', 3); -- > 'abc'
SELECT RIGHT('abcdefg', 3); -- > 'efg'
SELECT SUBSTRING('abcdefg', 3, 3); -- > 'cde'
SELECT SUBSTRING('abcdefg', 3); -- > 'cdefg'
SELECT LOCATE('n', 'Kindergarten'); -- > 3
SELECT LOCATE('z', 'Kindergarten'); -- > 0
SELECT LOCATE('garten', 'Kindergarten'); -- > 7
SELECT REPLACE('Kindergarten', 'graten', 'garden'); -- > Kindergarden
SELECT CONCAT('Kinder', 'garten'); -- > Kindergarten

USE sql_store;
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- ----------------------------------------------------------------------------
-- Date functions
SELECT NOW(),
       CURRENT_DATE(),
       CURRENT_TIME(),
       CURTIME(),
       YEAR(CURRENT_DATE()),
       MONTH(CURRENT_DATE()),
       MONTH(CURRENT_TIMESTAMP()),
       DAY(CURRENT_TIME());

SELECT EXTRACT(DAY FROM NOW()),
       EXTRACT(YEAR FROM NOW());

SELECT *
FROM orders
WHERE order_date >= CONCAT(YEAR(NOW()) - 2, '-01', '-01');

SELECT DATE_FORMAT('2020-01-05', '%Y/%m/%d');
SELECT TIME_FORMAT(NOW(), '%H:%i %p');

SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);
SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR);
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);

SELECT DATEDIFF(NOW(), '1995-05-04'); -- > returns difference in days
SELECT DATEDIFF(NOW(), '1995-05-04') / 365.25;

SELECT TIME_TO_SEC('09:00');
-- > seconds past since midnight

-- ----------------------------------------------------------------------------
-- IFNULL: virtually replaces NULL values with a value on SELECT
USE sql_store;
SELECT order_id,
       IFNULL(shipper_id, 'Not assigned') AS shipper
FROM orders;

-- ----------------------------------------------------------------------------
-- COALESCE: returns the first non-null value in a list
SELECT order_id,
       COALESCE(shipper_id, comments, 'Not assigned') AS shipper
FROM orders;

-- ----------------------------------------------------------------------------
-- IF
SELECT order_id,
       order_date,
       IF(
               YEAR(order_date) = YEAR(NOW()),
               'Active',
               'Archived'
           ) AS category
FROM orders;

-- ----------------------------------------------------------------------------
-- CASE
SELECT order_id,
       CASE
           WHEN YEAR(order_date) = YEAR(NOW()) THEN 'Active'
           WHEN YEAR(order_date) = YEAR(NOW()) - 1 THEN 'Last Year'
           WHEN YEAR(order_date) = YEAR(NOW()) - 2 THEN 'Archived'
           ELSE 'Future'
           END AS category
FROM orders;