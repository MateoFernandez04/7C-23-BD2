use sakila;
#act1
SELECT title, special_features
FROM film
WHERE rating = 'PG-13';

#act2
SELECT DISTINCT length
FROM film;

#act3
SELECT title, rental_rate, replacement_cost
FROM film
WHERE replacement_cost BETWEEN 20.00 AND 24.00;


#act4
SELECT title, category.name, rating
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE special_features LIKE '%Behind the Scenes%';

#act5
SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'ZOOLANDER FICTION';

#act6
SELECT address.address, city.city, country.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE store.store_id = 1;

#act7
SELECT f1.title, f2.title, f1.rating
FROM film f1, film f2
WHERE f1.rating = f2.rating AND f1.film_id < f2.film_id;

#act8
SELECT film.title, staff.first_name, staff.last_name
FROM inventory
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN store ON inventory.store_id = store.store_id
INNER JOIN staff ON store.manager_staff_id = staff.staff_id
WHERE inventory.store_id = 2;