-- Ans1: Create employees table with constraints
CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name TEXT NOT NULL,
    age INT CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL DEFAULT 30000
);

-- Ans2: Explanation of constraints
-- Constraints are rules enforced on data in a database table. They ensure the accuracy and reliability of the data.
-- Examples of common constraints:
-- - NOT NULL: Ensures a column cannot have a NULL value.
-- - UNIQUE: Ensures all values in a column are unique.
-- - PRIMARY KEY: Uniquely identifies each record in a table (implies NOT NULL + UNIQUE).
-- - FOREIGN KEY: Ensures the referential integrity of the data.
-- - CHECK: Ensures the value in a column meets a specific condition.
-- - DEFAULT: Assigns a default value if no value is specified.

-- Ans3: NOT NULL and Primary Key
-- The NOT NULL constraint is used to ensure that a column cannot have a NULL value.
-- A PRIMARY KEY cannot contain NULL values because it is used to uniquely identify each row in a table.
-- Therefore, a primary key must always have a non-null value.

-- Ans4: Adding and Removing Constraints
-- To add a constraint:
ALTER TABLE employees
ADD CONSTRAINT check_salary_positive CHECK (salary > 0);

-- To remove a constraint:
ALTER TABLE employees
DROP CONSTRAINT check_salary_positive;

-- Ans5: Violating Constraints
-- Attempting to insert, update, or delete data that violates constraints will result in an error.
-- Example: Trying to insert a NULL value into emp_id
-- INSERT INTO employees (emp_id, emp_name, age, email) VALUES (NULL, 'John Doe', 25, 'john@example.com');
-- This would result in: ERROR: null value in column "emp_id" violates not-null constraint

-- Ans6: Altering products table to add constraints
ALTER TABLE products
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

ALTER TABLE products
ALTER COLUMN price SET DEFAULT 50.00;



















--
--SQL COMMANDS-
--

-- Ans1: Identify primary and foreign keys
-- PRIMARY KEYS:
-- actor.actor_id
-- customer.customer_id
-- film.film_id
-- rental.rental_id
-- inventory.inventory_id

-- FOREIGN KEYS:
-- film.actor_id (in film_actor table)
-- rental.customer_id REFERENCES customer(customer_id)
-- rental.inventory_id REFERENCES inventory(inventory_id)
-- payment.customer_id REFERENCES customer(customer_id)
-- inventory.film_id REFERENCES film(film_id)
-- inventory.store_id REFERENCES store(store_id)

-- Difference:
-- PRIMARY KEY uniquely identifies each record in a table.
-- FOREIGN KEY is used to link two tables together, enforcing referential integrity.

-- Ans2: List all details of actors
SELECT * FROM actor;

-- Ans3: List all customer information
SELECT * FROM customer;

-- Ans4: List different countries
SELECT DISTINCT country FROM country;

-- Ans5: Display all active customers
SELECT * FROM customer WHERE active = 1;

-- Ans6: List all rental IDs for customer with ID 1
SELECT rental_id FROM rental WHERE customer_id = 1;

-- Ans7: Display all the films whose rental duration is greater than 5
SELECT * FROM film WHERE rental_duration > 5;

-- Ans8: Count of films with replacement cost > 15 and < 20
SELECT COUNT(*) AS total_films
FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- Ans9: Count of unique first names of actors
SELECT COUNT(DISTINCT first_name) AS unique_actor_first_names
FROM actor;

-- Ans10: First 10 records from the customer table
SELECT * FROM customer
LIMIT 10;

-- Ans11: First 3 customers with first name starting with 'b'
SELECT * FROM customer
WHERE first_name LIKE 'B%'
LIMIT 3;

-- Ans12: First 5 movies rated as 'G'
SELECT title FROM film
WHERE rating = 'G'
LIMIT 5;

-- Ans13: Customers whose first name starts with "a"
SELECT * FROM customer
WHERE first_name ILIKE 'a%';

-- Ans14: Customers whose first name ends with "a"
SELECT * FROM customer
WHERE first_name ILIKE '%a';

-- Ans15: First 4 cities starting and ending with 'a'
SELECT * FROM city
WHERE city ILIKE 'a%a'
LIMIT 4;

-- Ans16: Customers whose first name contains "NI"
SELECT * FROM customer
WHERE first_name ILIKE '%ni%';

-- Ans17: Customers with 'r' as second character in first name
SELECT * FROM customer
WHERE first_name ILIKE '_r%';

-- Ans18: Customers with first name starting with 'a' and at least 5 characters
SELECT * FROM customer
WHERE first_name ILIKE 'a%' AND LENGTH(first_name) >= 5;

-- Ans19: Customers with first name starting with 'a' and ending with 'o'
SELECT * FROM customer
WHERE first_name ILIKE 'a%o';

-- Ans20: Films rated 'PG' or 'PG-13'
SELECT * FROM film
WHERE rating IN ('PG', 'PG-13');

-- Ans21: Films with length between 50 and 100 minutes
SELECT * FROM film
WHERE length BETWEEN 50 AND 100;

-- Ans22: Top 50 actors
SELECT * FROM actor
LIMIT 50;

-- Ans23: Distinct film IDs from inventory
SELECT DISTINCT film_id FROM inventory;

--
--FUNCTIONS
--

--Basic Aggregate Functions
-- Ans1:
-- Retrieve the total number of rentals made
SELECT COUNT(*) AS total_rentals
FROM rental;

-- Ans2:
-- Find the average rental duration (in days) of movies
SELECT AVG(rental_duration) AS avg_rental_duration
FROM film;

-- Ans3:
-- Display customer first and last names in uppercase
SELECT UPPER(first_name) AS upper_first_name,
       UPPER(last_name) AS upper_last_name
FROM customer;

-- Ans4:
-- Extract the month from the rental date and display it with rental ID
SELECT rental_id,
       MONTH(rental_date) AS rental_month
FROM rental;

-- Ans5:
-- Retrieve the count of rentals for each customer (customer_id and rental count)
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Ans6:
-- Find the total revenue generated by each store
-- Note: Join payment and staff tables to get store_id from staff
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id;

-- Ans7:
-- Determine the total number of rentals for each category
-- Join rental → inventory → film → film_category → category
SELECT c.name AS category, COUNT(*) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- Ans8:
-- Find average rental rate of movies in each language
SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- Ans9:
-- Display the title of the movie, and the customer's first and last name who rented it
SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Ans10:
-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind"
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- Ans11:
-- Retrieve customer names along with the total amount they've spent on rentals
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Ans12:
-- List movie titles rented by each customer in a particular city (e.g., 'London')
SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
ORDER BY c.customer_id, f.title;

-- Ans13: 
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 5;

-- Ans14:
SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

-- WINDOWS FUNCTIONS
--Ans1: 
SELECT customer_id, first_name, last_name, 
       SUM(amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer_id, first_name, last_name;

-- Ans2:
SELECT f.title, p.payment_date, SUM(p.amount) AS revenue,
       SUM(SUM(p.amount)) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title, f.film_id, p.payment_date;

-- Ans3:
SELECT title, length, rental_duration,
       AVG(rental_duration) OVER (PARTITION BY length) AS avg_rental_duration_for_length
FROM film;

-- Ans4:
SELECT category_name, title, rental_count, 
       RANK() OVER (PARTITION BY category_name ORDER BY rental_count DESC) AS film_rank
FROM (
    SELECT c.name AS category_name, f.title, COUNT(r.rental_id) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
) AS category_rentals
WHERE RANK() OVER (PARTITION BY category_name ORDER BY rental_count DESC) <= 3;

-- Ans5:
SELECT customer_id, COUNT(rental_id) AS total_rentals,
       AVG(COUNT(rental_id)) OVER () AS avg_rentals,
       COUNT(rental_id) - AVG(COUNT(rental_id)) OVER () AS diff_from_avg
FROM rental
GROUP BY customer_id;

-- Ans6:
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
       SUM(amount) AS monthly_revenue,
       SUM(SUM(amount)) OVER (ORDER BY DATE_FORMAT(payment_date, '%Y-%m')) AS cumulative_revenue
FROM payment
GROUP BY month
ORDER BY month;

-- Ans7:
WITH customer_spending AS (
    SELECT customer_id, SUM(amount) AS total_spent,
           NTILE(5) OVER (ORDER BY SUM(amount) DESC) AS spending_percentile
    FROM payment
    GROUP BY customer_id
)
SELECT * FROM customer_spending
WHERE spending_percentile = 1;

-- Ans8:
SELECT category_name, title, rental_count,
       SUM(rental_count) OVER (PARTITION BY category_name ORDER BY rental_count DESC) AS running_total
FROM (
    SELECT c.name AS category_name, f.title, COUNT(r.rental_id) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
) AS category_rental_data;

-- Ans9:
WITH category_avg AS (
    SELECT c.name AS category_name, AVG(film_rental_count) AS avg_rental
    FROM (
        SELECT fc.category_id, f.film_id, COUNT(r.rental_id) AS film_rental_count
        FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        JOIN film_category fc ON f.film_id = fc.film_id
        GROUP BY fc.category_id, f.film_id
    ) AS rentals
    JOIN category c ON rentals.category_id = c.category_id
    GROUP BY c.name
)
SELECT f.title, c.name AS category, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY f.title, c.name
HAVING COUNT(r.rental_id) < (
    SELECT avg_rental FROM category_avg WHERE category_avg.category_name = c.name
);

-- Ans10:
SELECT month, monthly_revenue
FROM (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
           SUM(amount) AS monthly_revenue,
           RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
    FROM payment
    GROUP BY month
) AS ranked_months
WHERE revenue_rank <= 5;

--NORMALIZATION & CTE

-- Ans1:
--CREATE TABLE customer_orders (
--  customer_id INT,
--  order_items TEXT -- e.g., 'item1, item2, item3'
--);

--Solution (Normalize to 1NF):
CREATE TABLE order_item (
  customer_id INT,
  item_name TEXT
);

-- Ans2:
--Violation:
--If there were an extra column like category_name, it would depend only on category_id (part of the key), violating 2NF.

--Fix (2NF):
--Remove category_name into a separate category table and reference it via category_id only.

-- Ans3:
address → city_id → country_id

-- Ans4:
-- Unnormalized Table
-- CREATE TABLE rental_info (
--  customer_id INT,
--  customer_name TEXT,
--  rental_ids TEXT -- e.g., '1,2,3',
--  store_location TEXT
--);

--Step 1: First Normal Form (1NF)
--The rental_ids column violates 1NF because it contains multiple values in a single column.
--To normalize it to 1NF, we split the multiple rental IDs into separate rows.

--Normalized table (1NF):
--CREATE TABLE rentals (
--  customer_id INT,
--  rental_id INT
--);

--Step 2: Second Normal Form (2NF)
--Suppose store_location depends only on the store, not the entire primary key.
--This violates 2NF, which requires that all non-key attributes must be fully functionally dependent on the entire primary key.

--Normalization to 2NF:
CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  customer_name TEXT
);

CREATE TABLE store (
  store_id INT PRIMARY KEY,
  store_location TEXT
);

CREATE TABLE rental (
  rental_id INT PRIMARY KEY,
  customer_id INT,
  store_id INT,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- Ans5: 
WITH actor_film_count AS (
  SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT * FROM actor_film_count;

-- Ans6:
WITH film_lang AS (
  SELECT f.title, l.name AS language, f.rental_rate
  FROM film f
  JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM film_lang;

-- Ans7:
WITH customer_revenue AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM payment
  GROUP BY customer_id
)
SELECT * FROM customer_revenue;

-- Ans8:
WITH film_ranking AS (
  SELECT title, rental_duration,
         RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
  FROM film
)
SELECT * FROM film_ranking;

-- Ans9:
WITH frequent_customers AS (
  SELECT customer_id, COUNT(*) AS rental_count
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(*) > 2
)
SELECT fc.customer_id, c.first_name, c.last_name, fc.rental_count
FROM frequent_customers fc
JOIN customer c ON fc.customer_id = c.customer_id;

-- Ans10:
WITH monthly_rentals AS (
  SELECT DATE_FORMAT(rental_date, '%Y-%m') AS month, COUNT(*) AS rentals
  FROM rental
  GROUP BY month
)
SELECT * FROM monthly_rentals;

-- Ans11:
WITH actor_pairs AS (
  SELECT fa1.film_id, fa1.actor_id AS actor1, fa2.actor_id AS actor2
  FROM film_actor fa1
  JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
  WHERE fa1.actor_id < fa2.actor_id
)
SELECT ap.film_id, a1.first_name AS actor1_first, a2.first_name AS actor2_first
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1 = a1.actor_id
JOIN actor a2 ON ap.actor2 = a2.actor_id;

-- Ans12:
WITH RECURSIVE staff_hierarchy AS (
  SELECT staff_id, first_name, last_name, reports_to
  FROM staff
  WHERE reports_to IS NULL -- start from top manager (or WHERE reports_to = <ID>)

  UNION ALL

  SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
  FROM staff s
  INNER JOIN staff_hierarchy sh ON s.reports_to = sh.staff_id
)
SELECT * FROM staff_hierarchy;


