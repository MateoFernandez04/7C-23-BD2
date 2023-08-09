use sakila;
/*
Actividades 

1_Add a new customer
	To store 1
	For address use an existing address. The one that has the biggest address_id in 'United States'
*/
INSERT INTO sakila.customer (store_id, first_name, last_name, email, address_id, active)
SELECT 1, 'Fercho', 'fer', 'ferchofer12@gmail.com', MAX(a.address_id), 1
FROM address a
INNER JOIN city c1 ON a.city_id = c1.city_id
INNER JOIN country c ON c1.country_id = c.country_id
WHERE c.country = 'United States';

select * from customer order by customer_id desc;
DELETE FROM sakila.customer
WHERE customer_id = 600;
/*
2_ Add a rental
	Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
	Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
	Select any staff_id from Store 2.
*/
INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        return_date,
        staff_id
    )
SELECT CURRENT_TIMESTAMP, (
        SELECT
            MAX(i.inventory_id)
        FROM inventory i
            INNER JOIN film f USING(film_id)
        WHERE
            f.title LIKE 'YOUTH KICK'
    ),
    1,
    NULL, (
        SELECT
            manager_staff_id
        FROM store
        WHERE store_id = 2
        ORDER BY RAND()
        LIMIT 1
    );
#select * from rental;
#select * from inventory;
#select * from film order by film_id desc;
/*
3_Update film year based on the rating
	For example if rating is 'G' release date will be '2001'
	You can choose the mapping between rating and year.
	Write as many statements are needed.
*/
UPDATE sakila.film
SET release_year='2001'
WHERE rating = "G";

UPDATE sakila.film
SET release_year='2002'
WHERE rating = "PG";

UPDATE sakila.film
SET release_year='2003'
WHERE rating = "PG-13";

UPDATE sakila.film
SET release_year='2004'
WHERE rating = "R";

UPDATE sakila.film
SET release_year='2005'
WHERE rating = "NC-17";
/*
4_Return a film
	Write the necessary statements and queries for the following steps.
	Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
	Use the id to return the film.
*/
#Rental_id devuelto = 1196
SELECT rental_id
FROM film
INNER JOIN inventory USING(film_id)
INNER JOIN rental USING(inventory_id)
WHERE rental.return_date IS NULL
LIMIT 1;

#Pelicula devuelta
UPDATE sakila.rental
SET  return_date=CURRENT_TIMESTAMP
WHERE rental_id=11496;
/*
5_ Try to delete a film
	Check what happens, describe what to do.
	Write all the necessary delete statements to entirely remove the film from the DB.
*/

select * from film;
delete from film where film_id =1;
# Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE)	
#Muchos registros dependen de la existencia de este por lo que se debe eliminar todas los registros que tienen relacion con Academy Dinousar, por ejemplo en film_actor,inventory, film_category y rental.
DELETE FROM rental
WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 1);

DELETE FROM payment
WHERE rental_id IN (SELECT rental_id FROM rental WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 1));


DELETE FROM film_actor
WHERE film_id = 1;

DELETE FROM film_category
WHERE film_id = 1;

DELETE FROM inventory
WHERE film_id = 1;

DELETE FROM film
WHERE film_id = 1;

select * from film;

/*
6_Rent a film
	Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
	Add a rental entry
	Add a payment entry
	Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
*/
SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (
        SELECT inventory_id
        FROM inventory
            INNER JOIN rental USING (inventory_id)
        WHERE
            return_date IS NULL
    );
#film_id: 3 inventory_id: 15
INSERT INTO sakila.rental
(rental_date, inventory_id, customer_id, staff_id)
VALUES(
	CURRENT_DATE(),
	15,
	(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
	(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory WHERE inventory_id = 15))
);

INSERT INTO sakila.payment
(customer_id, staff_id, rental_id, amount, payment_date)
VALUES(
	(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
	(SELECT staff_id FROM staff LIMIT 1),
	(SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1) ,
	(SELECT rental_rate FROM film WHERE film_id = 3),
	CURRENT_DATE());


