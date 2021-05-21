-- ----------------------------------------------------------------------------
-- INSERT clause: inserts data into a table
USE sql_store;

INSERT INTO customers
VALUES (DEFAULT,
        'John',
        'Smith',
        '1990-01-01',
        NULL,
        'address',
        'city',
        'CA',
        DEFAULT);

-- Specified columns with another order
INSERT INTO customers (first_name,
                       last_name,
                       birth_date,
                       state,
                       address,
                       city)
VALUES ('John3',
        'Smith3',
        '1990-01-01',
        'CA',
        'address',
        'city');

-- Multiple INSERTs
INSERT INTO shippers(name)
VALUES ('Shipper1'),
       ('Shipper2'),
       ('Shipper3');


-- INSERT into multiple tables
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 2.95),
       (LAST_INSERT_ID(), 2, 1, 3.95)

-- ----------------------------------------------------------------------------
-- CREATE TABLE AS: creates a copy of a table without enabling primary keys
CREATE TABLE orders_archived AS
SELECT *
FROM orders;

-- ----------------------------------------------------------------------------
-- INSERT data from subquery on another table
INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

-- ----------------------------------------------------------------------------
-- UPDATE clause: updates row(s) on a table based on a selection condition
USE sql_invoicing;

UPDATE invoices
SET payment_total = DEFAULT,
    payment_date  = '2019-03-01'
WHERE invoice_id = 1;

-- You can use values from other columns
UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date  = due_date
WHERE invoice_id = 1;

-- Use more general condition to UPDATE more than one row
UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date  = due_date
WHERE client_id = 3;

-- Use subqueries to update multiple rows
-- Single record
UPDATE invoices
SET payment_total = invoice_total * 0.75,
    payment_date  = due_date
WHERE client_id =
      (SELECT client_id
       FROM clients
       WHERE name = 'Myworks');

-- Multiple records
UPDATE invoices
SET payment_total = invoice_total * 0.75,
    payment_date  = due_date
WHERE client_id IN
      (SELECT client_id
       FROM clients
       WHERE state IN ('CA', 'NY'));

-- ----------------------------------------------------------------------------
-- DELETE clause: deletes row(s) from a given table based on condition
DELETE FROM invoices
WHERE invoice_id = 1;

