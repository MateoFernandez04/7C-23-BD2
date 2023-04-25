use sakila;
#act1
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE last_name IN (
    SELECT last_name 
    FROM actor 
    GROUP BY last_name 
    HAVING COUNT(*) > 1
) 
ORDER BY last_name, first_name;

#act1.2 with join
SELECT a1.actor_id, a1.first_name, a1.last_name 
FROM actor a1 
JOIN actor a2 ON a1.last_name = a2.last_name AND a1.actor_id <> a2.actor_id 
GROUP BY a1.actor_id 
HAVING COUNT(*) > 1 
ORDER BY a1.last_name, a1.first_name;

#act2
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (SELECT actor_id FROM film_actor);

#act3
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
  SELECT customer_id
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(*) = 1
);

#act4
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
  SELECT customer_id
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(*) > 1
);

#act5
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
  SELECT film_actor.actor_id
  FROM film_actor
  JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);


#act6
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
  SELECT film_actor.actor_id
  FROM film_actor
  JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title = 'BETRAYED REAR'
)
AND actor.actor_id NOT IN (
  SELECT film_actor.actor_id
  FROM film_actor
  JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title = 'CATCH AMISTAD'
);

#act7
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
  SELECT film_actor.actor_id
  FROM film_actor
  JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title = 'BETRAYED REAR'
)
AND actor.actor_id IN (
  SELECT film_actor.actor_id
  FROM film_actor
  JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title = 'CATCH AMISTAD'
)
#act8
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id NOT IN (
  SELECT film_actor.actor_id
  FROM film_actor
  JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title = 'BETRAYED REAR'
  OR film.title = 'CATCH AMISTAD'
);







