-- Task 1: Create a new user "rentaluser" with limited permissions
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
GRANT CONNECT ON DATABASE dvd_rental TO rentaluser;

-- Task 2: Grant SELECT permission for "rentaluser" on the "customer" table
GRANT SELECT ON TABLE customer TO rentaluser;

-- Check SELECT permission
SELECT * FROM customer;

-- Task 3: Create a new user group "rental" and add "rentaluser" to the group
CREATE GROUP rental;
ALTER USER rentaluser IN GROUP rental;

-- Task 4: Grant INSERT and UPDATE permissions for "rental" group on "rental" table
GRANT INSERT, UPDATE ON TABLE rental TO rental;

-- Insert a new row
INSERT INTO rental (inventory_id, customer_id,staff_id, rental_date)
VALUES (1525, 459, 1, '2023-05-24 15:54:33-04');

-- Update an existing row
UPDATE rental SET staff_id = 1 WHERE rental_id = 6475;

-- Task 5: Revoke INSERT permission for "rental" group on "rental" table
REVOKE INSERT ON TABLE rental FROM rental;

-- Try to insert new rows (should result in an error)
INSERT INTO rental (inventory_id, customer_id,staff_id, rental_date)
VALUES (1525, 459, 1, '2023-05-24 15:54:33-04');

-- Task 6: Create a personalized role for an existing customer
DO $$ 
DECLARE
    role_name VARCHAR;
BEGIN
    role_name := 'client_feruz_farxodov';
    CREATE ROLE client_feruz_farxodov LOGIN;
    GRANT USAGE ON SCHEMA public TO client_feruz_farxodov;
    GRANT SELECT ON TABLE rental TO client_feruz_farxodov;
    GRANT SELECT ON TABLE payment TO client_feruz_farxodov;

    EXECUTE GRANT SELECT ON TABLE rental, payment TO client_feruz_farxodov WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = ''Ff'' AND last_name = ''fF'');
END $$;

SET ROLE client_feruz_farxodov;

-- Check personalized role's access to own data
SET ROLE client_feruz_farxodov;


SELECT * FROM rental;
SELECT * FROM payment;
RESET ROLE;

-- EACH ENTER SPACE MEANTS EXECUTE ONE BY ONE EACH ENTER
