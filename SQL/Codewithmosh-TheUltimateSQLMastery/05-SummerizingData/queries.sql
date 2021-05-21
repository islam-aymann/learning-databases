-- ----------------------------------------------------------------------------
-- Aggregate functions: performs operations on a set of data
-- MAX(), MIN(), SUM(), AVG(), COUNT()
-- operates on non NULL values, NULL values will be skipped
-- You can do COUNT(*) to count all values including NULL values
USE sql_invoicing;

SELECT MAX(invoice_total)        AS hights,
       MIN(invoice_total)        AS lowest,
       AVG(invoice_total)        AS average,
       SUM(invoice_total)        As total,
       COUNT(invoice_total)      AS total_invoices,
       COUNT(*)                  AS total_records,
       MAX(payment_date)         AS latest_payment,
       SUM(invoice_total * 1.1)  AS sum_total_after_tax,
       COUNT(DISTINCT client_id) AS total_clients
FROM invoices
WHERE invoice_date > '2019-07-01';

SELECT 'First half of 2019'               AS date_range,
       SUM(invoice_total)                 AS total_sales,
       SUM(payment_total)                 AS total_payments,
       SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'

UNION

SELECT 'Second half of 2019'                   AS date_range,
       SUM(invoice_total)                      AS total_sales,
       SUM(payment_total)                      AS total_payments,
       SUM(invoice_total) - SUM(payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'

UNION

SELECT 'Total'                                 AS date_range,
       SUM(invoice_total)                      AS total_sales,
       SUM(payment_total)                      AS total_payments,
       SUM(invoice_total) - SUM(payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';

-- ----------------------------------------------------------------------------
-- GROUP BY: groups records with a specific condition
SELECT client_id, SUM(invoice_total) As total_sales
FROM invoices
GROUP BY client_id;

-- Pay attention to order of clauses
SELECT client_id, SUM(invoice_total) As total_sales
FROM invoices
WHERE invoice_date >= '2019-07-01'
GROUP BY client_id
ORDER BY total_sales DESC;

-- Using JOIN
SELECT state,
       city,
       SUM(invoice_total) As total_sales
FROM invoices
         JOIN clients USING (client_id)
WHERE invoice_date >= '2019-07-01'
GROUP BY state, city
ORDER BY total_sales DESC;

-- Use HAVING clause to filter data after GROUP BY
-- Use only column names or aliases that are listed after SELECT statement
SELECT client_id,
       SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
HAVING total_sales > 500;

-- Compound condition
SELECT client_id,
       SUM(invoice_total) AS total_sales,
       COUNT(*)           AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500
   AND number_of_invoices > 5;

-- Example: get all customers who are located in Virginia and have spent more
-- than $100
USE sql_store;
SELECT c.customer_id,
       c.first_name                     AS customer_name,
       SUM(oi.unit_price * oi.quantity) AS total

FROM customers c
         JOIN orders o USING (customer_id)
         JOIN order_items oi USING (order_id)
WHERE state = 'VA'
GROUP BY c.customer_id
HAVING total > 100;

-- ----------------------------------------------------------------------------
-- WITH ROLLUP: aggregates the aggregated values
-- Applies to MySQL only
USE sql_invoicing;

SELECT client_id,
       SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
WITH ROLLUP;


-- It gets the summary for each GROUP BY field
SELECT state,
       city,
       SUM(invoice_total) AS total_sales
FROM invoices i
         JOIN clients c USING (client_id)
GROUP BY state, city
WITH ROLLUP;

-- You have to use actual column names when using the ROLLUP
SELECT pm.name     AS payment_method,
       SUM(amount) AS total
FROM payments p
         JOIN payment_methods pm on pm.payment_method_id = p.payment_method
GROUP BY pm.name
WITH ROLLUP;