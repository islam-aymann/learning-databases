USE sql_store;
-- ---------------------------------------------------------------------------
-- INNER JOIN
-- Joins two table based ON a cONditiON
-- Order matters
-- JOIN --> INNER JOIN
-- LEFT JOIN --> LEFT OUTER JOIN
-- RIGHT JOIN --> RIGHT OUTER JOIN
SELECT *
FROM orders
         JOIN customers ON customers.customer_id = orders.customer_id;

SELECT order_id, first_name, last_name
FROM orders
         JOIN customers ON customers.customer_id = orders.customer_id;

-- If same column name exists in the two table specify
SELECT order_id, orders.customer_id, first_name, last_name
FROM orders
         JOIN customers ON customers.customer_id = orders.customer_id;

-- Use abbreviatiON aliases to simplify query
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
         JOIN customers c ON c.customer_id = o.customer_id;

-- Prefix with database name to perform query ON multiple databases
-- You can ONly prefix the nON-USED database
SELECT *
FROM sql_store.order_items ssoi
         JOIN sql_inventory.products sip ON ssoi.product_id = sip.product_id;

-- ----------------------------------------------------------------------------
-- SELF JOIN
USE sql_hr;

SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
         JOIN employees m
              ON e.reports_to = m.employee_id;

-- ----------------------------------------------------------------------------
-- Multiple JOINs
USE sql_store;

SELECT o.order_id,
       o.customer_id,
       c.first_name,
       os.name AS status
FROM orders o
         JOIN customers c ON c.customer_id = o.customer_id
         JOIN order_statuses os ON os.order_status_id = o.status;

-- ----------------------------------------------------------------------------
-- Compound JOINs
SELECT *
FROM order_items oi
         JOIN order_item_notes oin
              ON oi.order_id = oin.order_Id AND oi.product_id = oin.product_id;

-- ----------------------------------------------------------------------------
-- Implicit JOINs
-- Not preferred

SELECT *
FROM orders o,
     customers c
WHERE o.customer_id = c.customer_id;

-- If you forgot the WHERE clause, you will get cross join. i.e. each record
-- in the first table will be joined with all entries ON the other table
SELECT *
FROM orders o,
     customers c
WHERE o.customer_id = c.customer_id;

-- ----------------------------------------------------------------------------
-- Outer JOINs

-- LEFT JOIN
-- Retrieve all records in customers table (left) and join it with the
-- orders table (right) whether the cONditiON is satisfied or not
-- i.e. retrieve all customers who have orders or not
-- customers LEFT JOIN orders or orders RIGHT JOIN customers ==> all customers
-- customers RIGHT JOIN orders or orders RIGHT LEFT customers ==> all orders
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- ----------------------------------------------------------------------------
-- Multi table JOINs
-- customers -> orders -> shippers
-- all customers with orders whether has shipper or not
SELECT c.customer_id,
       c.first_name,
       o.order_id,
       s.name AS shipper_name
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id
         LEFT JOIN shippers s ON o.shipper_id = s.shipper_id
ORDER BY c.customer_id;

SELECT o.order_date,
       o.order_id,
       c.first_name AS customer,
       s.name       AS shipper,
       os.name      AS status
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         LEFT JOIN shippers s ON o.shipper_id = s.shipper_id
         LEFT JOIN order_statuses os ON o.status = os.order_status_id
ORDER BY os.order_status_id;

-- ----------------------------------------------------------------------------
-- self JOINs on outer JOINs
USE sql_hr;
SELECT e.employee_id,
       e.first_name,
       m.first_name AS manager
FROM employees e
         LEFT JOIN employees m ON e.reports_to = m.employee_id
ORDER BY m.employee_id;

-- ----------------------------------------------------------------------------
-- USING keyword
-- Replace ON with using for better clarity, only if column name exists in
-- JOINed tables
USE sql_store;

SELECT o.order_id,
       c.first_name,
       s.name AS shipper
FROM orders o
         JOIN customers c USING (customer_id)
         LEFT JOIN shippers s USING (shipper_id);

-- You can address multiple columns
SELECT *
FROM order_items oi
         JOIN order_item_notes oin
              USING (order_id, product_id);

-- ----------------------------------------------------------------------------
-- NATURAL JOINS: JOIN tables based on common column names
-- Not preferred
SELECT o.order_id,
       c.first_name
FROM orders o
         NATURAL JOIN customers c;

-- ----------------------------------------------------------------------------
-- CROSS JOINs: every record from the first column JOINS every record from the
-- second table

-- Explicit CROSS JOIN
SELECT c.first_name AS customer,
       p.name       AS product
FROM customers c
         CROSS JOIN products p
ORDER BY c.first_name;

-- Implicit CROSS JOIN -- Not preferred
SELECT c.first_name AS customer,
       p.name       AS product
FROM customers c,
     products p
ORDER BY c.first_name;

-- ----------------------------------------------------------------------------
-- UNION: combine two or more queryset
-- Order of queries matter
-- First query column names will be used to annotate the result queryset
-- Column count must match in all queries
SELECT order_id,
       order_date,
       'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT order_id,
       order_date,
       'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';
