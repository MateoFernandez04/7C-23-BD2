use sakila;
/*
1) Write a query that gets all the customers that live in Argentina. 
Show the first and last name in one column, the address and the city.
*/
SELECT CONCAT_WS(" ", c.first_name, c.last_name) AS full_name, 
       a.address, 
       ci.city
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ci ON a.city_id = ci.city_id
JOIN country AS co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

/*
2) Write a query that shows the film title, language and rating. 
Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.
*/
SELECT title,
       (SELECT name FROM language WHERE language_id = film.language_id) AS language_name,
       CASE rating
           WHEN 'G' THEN 'All Ages Are Admitted.'
           WHEN 'PG' THEN 'Some Material May Not Be Suitable For Children.'
           WHEN 'PG-13' THEN 'Some Material May Be Inappropriate For Children Under 13.'
           WHEN 'R' THEN 'Under 17 Requires Accompanying Parent Or Adult Guardian.'
           WHEN 'NC-17' THEN 'No One 17 and Under Admitted.'
       END AS descripción_Permiso
FROM film;

/*
3) Write a search query that shows all the films (title and release year) an actor was part of. 
Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
*/
SELECT
    CONCAT(ac.first_name, ' ', ac.last_name) AS actor,
    f.title AS film,
    f.release_year AS release_year
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor ac ON fa.actor_id = ac.actor_id
WHERE CONCAT(ac.first_name, ' ', ac.last_name) LIKE CONCAT('%', UPPER(TRIM('KIRSTEN AKROYD')), '%');
/*
4) Find all the rentals done in the months of May and June. 
Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.
*/
SELECT film.title,
	   CONCAT_WS(" ", customer.first_name, customer.last_name) as full_name,
	   CASE WHEN rental.return_date IS NOT NULL THEN 'Yes'
	   ELSE 'No' END AS was_returned,
	   MONTHNAME(rental.rental_date) as month
  FROM film
  	INNER JOIN inventory USING(film_id)
  	INNER JOIN rental USING(inventory_id)
  	INNER JOIN customer USING(customer_id)
WHERE MONTHNAME(rental.rental_date) LIKE 'May'
   OR MONTHNAME(rental.rental_date) LIKE 'June';
/*
5) Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.
*/
/*
Las funciones CAST y CONVERT son utilizadas en SQL para cambiar el tipo de datos de una columna o expresión a otro tipo de datos. 
Aunque en muchos sistemas de gestión de bases de datos (DBMS) estas dos funciones son intercambiables, es importante tener en cuenta que su comportamiento podría variar en algunos casos.

CAST: La función CAST convierte un valor en un tipo de datos específico. La sintaxis general es: 
CAST(expresión AS tipo_de_dato_deseado). Example:
*/
SELECT title, CAST(release_year AS CHAR) AS release_year_str
FROM film;
/*
CONVERT: La función CONVERT también cambia un valor a un tipo de datos específico, 
pero su sintaxis puede variar dependiendo del DBMS que estés utilizando. 
En algunos sistemas, es similar a CAST, pero en otros sistemas tiene una sintaxis más específica.
Example:
*/
SELECT title, CONVERT(release_year, CHAR) AS release_year_str
FROM film;
/*
6) Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function.
 Explain what they do. Which ones are not in MySql and write usage examples.
 */
 
 #NVL (Oracle function): toma dos argumentos y devuelve el primer argumento si no es nulo; de lo contrario, devuelve el segundo argumento. Actúa de forma igual al ifnull
 
 #La función IFNULL toma dos argumentos y devuelve el primer argumento si no es nulo; de lo contrario, devuelve el segundo argumento.
 SELECT first_name, IFNULL(last_name, 'N/A') AS last_name
FROM customer;
 #Todos tienen last_name así que no devuelve n/a
 
 #La función ISNULL toma el argumento y devuelve 1 si es nulo; de lo contrario, devuelve 0.
 SELECT first_name, ISNULL(last_name) AS last_name
FROM customer;
#Todos tienen last_name

#COALESCE: La función COALESCE toma múltiples argumentos y devuelve el primer argumento no nulo de la lista. Puede aceptar más de dos argumentos y devuelve el primer valor no nulo encontrado de izquierda a derecha.
SELECT first_name, COALESCE(last_name, email, 'N/A') AS identifier
FROM customer;
  