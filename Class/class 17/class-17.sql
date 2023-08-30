use sakila;
/*
1)Create two or three queries using address table in sakila db:
	- include postal_code in where (try with in/not it operator)
	- eventually join the table with city/country tables.
	- measure execution time.
	- Then create an index for postal_code on address table.
	 - measure execution time again and compare with the previous ones.
	Explain the results
*/
-- query include postal_code with in
SELECT * FROM address
WHERE postal_code IN ('1001', '1002', '1003'); -- 0,062 sec

-- query include postal_code with not in
SELECT * FROM address
WHERE postal_code NOT IN ('1001', '1002', '1003'); -- 0,016 sec

-- query include join with the table with city/country tables
SELECT a.address_id, a.address, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('1001', '1002', '1003');  -- 0,047 sec

-- create an index for postal_code on address table
CREATE INDEX idx_postal_code ON address (postal_code);
-- measure execution time      -- measure execution time after create index  
 -- query 1: 0,062 sec              -- query 1: 0,015 sec
 -- query 2: 0,016 sec              -- query 2: 0,001 sec
 -- query 3: 0,047 sec              -- query 3: 0,016 sec   
      -- Los resultados tardan menos sec en comparación de antes debido al index. Este desempeña la misma función que el índice de un libro: 
      -- permite encontrar datos rápidamente; en el caso de las tablas, localiza registros. Una tabla se indexa por un campo (o varios).
/*
Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
*/

SELECT * FROM actor
WHERE first_name = 'John'; -- 0,013 sec
SELECT * FROM actor
WHERE last_name = 'Smith'; -- 0,005 sec

/*
La razón por la que estas dos consultas pueden tener diferentes tiempos de ejecución es que los mecanismos internos de optimización 
de consultas del motor de base de datos pueden manejar estas búsquedas de manera diferente. En este caso en específico uno se encuentra 
con indez (last_name) y la otra no (first_name).
*/

/*
Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
*/
SELECT * FROM film
WHERE description LIKE '%action%'; 
-- Tardó aprox. 0,054 sec
SELECT * FROM film
WHERE MATCH(description) AGAINST('action');
-- Tardó aprox. 0,015 sec
# Al principio me tira "Error Code: 1191. Can´t find FULLTEXT index matching the column list" entonces: 
CREATE FULLTEXT INDEX FullText_index ON film(description); -- ahora sí funciona la query de arriba y de manera más rápida que la anterior
/*
Explanation (búsqueda en la web):
LIKE Operador: Se utiliza para hacer coincidir patrones con cadenas. Cuando se utiliza %acción% como patrón, encontrará filas donde 
la palabra "acción" aparece en cualquier lugar dentro de la columna de descripción. Sin embargo, este tipo de búsqueda no es muy eficiente, 
especialmente cuando se trata de conjuntos de datos grandes, porque necesita escanear cada fila y verificar el patrón, lo que resulta en un tiempo de ejecución potencialmente más lento.

MATCH... AGAINST Operador: Se utiliza para la búsqueda de texto completo. Está diseñado específicamente para 
buscar de manera eficiente grandes cantidades de texto en busca de relevancia. La función MATCH utiliza un índice de 
texto completo (si está disponible) para localizar rápidamente filas que contienen las palabras especificadas. 
La cláusula AGAINST toma una cadena de búsqueda, en este caso, 'acción'.
*/