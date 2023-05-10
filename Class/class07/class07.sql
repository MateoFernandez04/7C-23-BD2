use sakila;

#ejercicio 1
SELECT title, rating, length
FROM film
WHERE length <= (
  SELECT length
  FROM film
  ORDER BY length ASC
  LIMIT 1
);

#ejercicio 2
SELECT title, rating, length
FROM film AS f1
WHERE length <= (SELECT MIN(length) FROM film)
  AND NOT EXISTS(SELECT * FROM film AS f2 WHERE f2.film_id <> f1.film_id AND f2.length <= f1.length);

#ejercicio 3
SELECT first_name, last_name, a.address, MIN(p.amount) AS lowest_payment
FROM customer
         INNER JOIN payment as p ON customer.customer_id = p.customer_id
         INNER JOIN address a on customer.address_id = a.address_id
GROUP BY first_name, last_name, a.address;

#ejercicio 4
SELECT c.first_name, c.last_name, a.address, 
    (SELECT MAX(p.amount) FROM payment p WHERE p.customer_id = c.customer_id) AS highest_payment, 
    (SELECT MIN(p.amount) FROM payment p WHERE p.customer_id = c.customer_id) AS lowest_payment
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id;