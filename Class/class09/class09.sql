



USE sakila;
#1
SELECT c.country_id, c.country, COUNT(ci.city_id) AS city_count
FROM country AS c
LEFT JOIN city AS ci ON c.country_id = ci.country_id
GROUP BY c.country_id, c.country
ORDER BY c.country, c.country_id;

#2
SELECT c.country_id, c.country, COUNT(ci.city_id) AS mount
FROM country AS c
INNER JOIN city AS ci ON c.country_id = ci.country_id
GROUP BY c.country_id, c.country
HAVING mount > 10
ORDER BY mount DESC;

#3
SELECT c.first_name, c.last_name, a.address,
       COUNT(r.rental_id) AS total_films_rented,
       SUM(p.amount) AS total_money_spent
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY total_money_spent DESC;

#4
SELECT c.category_id, c.name AS category_name, AVG(f.length) AS average_duration
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
HAVING AVG(f.length) > (
  SELECT AVG(length)
  FROM film
)
ORDER BY average_duration DESC;

#5
SELECT f.rating, SUM(p.amount) AS total_sales
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_sales DESC;

