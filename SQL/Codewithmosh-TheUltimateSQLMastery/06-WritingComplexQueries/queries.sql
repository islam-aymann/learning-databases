-- ----------------------------------------------------------------------------
-- In sql_store database:
-- 1- Find products that are more expensive than Lettuce (id = 3)
USE sql_store;
SELECT *
FROM products
WHERE unit_price >
      (SELECT unit_price FROM products WHERE name LIKE '%Lettuce%');

-- ----------------------------------------------------------------------------
-- In sql_hr database:
-- 2- Find employees who earn more than average
USE sql_hr;
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees);

-- ----------------------------------------------------------------------------
-- In sql_store database:
-- 3- Find the products that have never been ordered
USE sql_store;
SELECT *
FROM products
         LEFT JOIN order_items oi ON products.product_id = oi.product_id
WHERE order_id IS NULL;

SELECT *
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items);

-- ----------------------------------------------------------------------------
-- In sql_invoicing database:
-- 4- Find clients without invoices
USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN (
    SELECT DISTINCT client_id
    FROM invoices
);

-- ----------------------------------------------------------------------------
-- In sql_store database:
-- 5- Find customers who have ordered lettuce (id = 3)
-- SELECT customer_id, first_name, last_name
USE sql_store;

-- Using JOIN
SELECT DISTINCT c.customer_id, first_name, last_name
FROM customers c
         JOIN orders o ON c.customer_id = o.customer_id
         JOIN order_items oi on o.order_id = oi.order_id
WHERE oi.product_id = 3;

-- Using JOIN and subqueries
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM order_items oi
             JOIN orders o USING (order_id)
    WHERE product_id = 3
);

-- ----------------------------------------------------------------------------
-- In sql_invoicing database:
-- 6- Select invoices larger than all invoices of client 3
USE sql_invoicing;
SELECT *
FROM invoices
where invoice_total >
      (SELECT MAX(invoice_total)
       FROM invoices
       WHERE client_id = 3
       GROUP BY client_id);


-- Using ALL keyword
SELECT *
FROM invoices
where invoice_total >
          ALL (SELECT invoice_total
               FROM invoices
               WHERE client_id = 3);

-- ----------------------------------------------------------------------------
-- In sql_store database:
-- 7- Select products that were sold by the unit (quantity = 1)
USE sql_store;
SELECT *
FROM products
         JOIN order_items oi USING (product_id)
WHERE quantity = 1;

-- ----------------------------------------------------------------------------
-- In sql_invoicing database:
-- 8- Select clients with at least two invoices
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id IN (
    SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2);

-- ----------------------------------------------------------------------------
-- Using ANY keyword
SELECT *
FROM clients
WHERE client_id = ANY (
    SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2);

-- ----------------------------------------------------------------------------
-- In sql_hr database:
-- 9- Select employees whose salary is above average in their office
USE sql_hr;


-- VIP: on using alias in this case you can think it like having a for loop
-- co-related subqueries
-- subquery gets evaluated for each row in the main query
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
);

-- ----------------------------------------------------------------------------
-- In sql_invoicing:
-- 10- Get invoices that are larger than the client's average invoice amount
USE sql_invoicing;

SELECT *
FROM invoices i
WhERE invoice_total < (SELECT AVG(invoice_total)
                       FROM invoices
                       WHERE i.client_id = client_id);

-- ----------------------------------------------------------------------------
-- In sql_invoicing:
-- 10- Select clients that have an invoice
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id IN (
    SELECT DISTINCT client_id
    FROM invoices
);

SELECT *
FROM clients c
WHERE EXISTS(
              SELECT client_id
              FROM invoices
              WHERE client_id = c.client_id
          );

SELECT DISTINCT(c.client_id)
FROM clients c
         JOIN invoices i on c.client_id = i.client_id;


-- ----------------------------------------------------------------------------
-- In sql_store database:
-- 11- Find the products that have never been ordered
USE sql_store;

SELECT *
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM order_items
);

SELECT *
FROM products p
WHERE NOT EXISTS(
        SELECT product_id
        FROM order_items
        WHERE product_id = p.product_id
    );
-- ----------------------------------------------------------------------------
USE sql_invoicing;
SELECT invoice_id,
       invoice_total,
       (SELECT AVG(invoice_total)
        FROM invoices)                 AS invoice_average,
       invoice_total - (SELECT AVG(invoice_total)
                        FROM invoices) AS median
FROM invoices;

SELECT invoice_id,
       invoice_total,
       (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
       invoice_total - (SELECT invoice_average) AS difference
FROM invoices;

SELECT client_id,
       name,
       (SELECT SUM(invoice_total)
        FROM invoices
        WHERE client_id = c.client_id)           AS total_sales,
       (SELECT AVG(invoice_total) FROM invoices) AS average,
       (SELECT total_sales - average)            AS difference
FROM clients c;

-- ----------------------------------------------------------------------------
-- Derived table
SELECT *
FROM (SELECT client_id,
             name,
             (SELECT SUM(invoice_total)
              FROM invoices
              WHERE client_id = c.client_id)           AS total_sales,
             (SELECT AVG(invoice_total) FROM invoices) AS average,
             (SELECT total_sales - average)            AS difference
      FROM clients c) AS VIP

WHERE total_sales IS NOT NULL;