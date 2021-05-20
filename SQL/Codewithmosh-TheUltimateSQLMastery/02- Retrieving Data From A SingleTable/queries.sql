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

