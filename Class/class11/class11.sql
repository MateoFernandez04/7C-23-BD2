use sakila;
#4)
select f.title from film f 
where f.film_id not in (select f1.film_id from film f1 
inner join inventory i on f1.film_id = i.film_id); 
#5)
SELECT film.title, inventory.inventory_id
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;
#6
SELECT c.first_name, c.last_name, s.store_id, f.title, r.rental_date
FROM rental r
INNER JOIN customer c USING(customer_id)
INNER JOIN store s USING(store_id)
INNER JOIN inventory i USING(inventory_id)
INNER JOIN film f USING(film_id)
ORDER BY s.store_id, c.last_name;

#7
SELECT s.store_id,
        CONCAT(ci.city, ', ', co.country) AS `City and Country`, 
        CONCAT(m.first_name, ' ', m.last_name) AS `First and Last Name`,
        (SELECT SUM(p.amount)
            FROM payment p
            WHERE p.staff_id = s.manager_staff_id) AS `Total money`
FROM staff m
INNER JOIN store s ON m.staff_id = s.manager_staff_id
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci USING(city_id)
INNER JOIN country co USING(country_id);

# 8)
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS `Total films`
FROM actor a
INNER JOIN film_actor fa USING(actor_id)
GROUP BY fa.actor_id
ORDER BY `Total films` DESC
LIMIT 1;