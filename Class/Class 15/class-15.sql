use sakila;

#1
CREATE or REPLACE VIEW list_of_customers AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    ci.city,
    co.country,
    CASE WHEN c.active = 1 THEN 'active' ELSE 'inactive' END AS status,
    c.store_id
FROM 
    customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id;


SELECT * FROM list_of_customers;


#2
CREATE or REPLACE VIEW film_details AS
SELECT
    f.film_id,
    f.title,
    f.description,
    c.name AS category,
    f.rental_rate AS price,
    f.length,
    f.rating,
    GROUP_CONCAT(DISTINCT a.first_name, ' ', a.last_name ORDER BY a.first_name ASC SEPARATOR ', ') AS actors
FROM
    film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY
    f.film_id;

SELECT * FROM film_details;


#3
CREATE or REPLACE VIEW sales_by_film_category AS
SELECT
    c.name AS category,
    SUM(p.amount) AS total_rental
FROM
    film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
GROUP BY
    c.name;

SELECT * FROM sales_by_film_category;


#4
CREATE or REPLACE VIEW actor_information AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS film_count
FROM
    actor a
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY
    a.actor_id, a.first_name, a.last_name;

SELECT * FROM actor_information;


#5
/*
Explicación de la consulta:
CREATE VIEW actor_information AS: Esta línea indica que estamos creando una nueva vista llamada actor_information. 
Una vista es una tabla virtual que almacena el resultado de una consulta y se puede usar para simplificar consultas futuras.

En la siguiente parte, SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count, especificamos las columnas que queremos seleccionar y mostrar en la vista resultante. 
En este caso, estamos eligiendo el ID del actor, su primer nombre, su apellido y el recuento de películas en las que ha actuado.

La tabla de la que obtenemos los datos principales es actor, y usamos el alias a para abreviar el nombre de la tabla.

Luego, usamos LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id. Esto significa que estamos combinando la tabla actor con la tabla film_actor según el ID del actor.
El LEFT JOIN asegura que incluso si un actor no ha actuado en ninguna película, aún aparecerá en la vista con un recuento de películas igual a cero.

Finalmente, utilizamos GROUP BY a.actor_id, a.first_name, a.last_name para agrupar los resultados. Esto asegura que 
el recuento de películas se aplique a cada actor individualmente y no se repita para cada aparición en la tabla. En otras palabras, si un actor ha actuado en varias películas, solo veremos una fila para ese actor con el recuento total de películas en las que ha actuado.

Con esta consulta, obtenemos una vista llamada actor_information que muestra información sobre los actores, como su ID, primer nombre, apellido y la cantidad de películas en las que han actuado. La vista nos permite ver esta información de manera organizada y simplifica nuestras consultas futuras al no tener que escribir la consulta completa cada vez que necesitemos esta información.
*/

#6
/*
**Descripción de las Vistas Materializadas:**
Una vista materializada es un objeto de base de datos que almacena los resultados de una consulta como una tabla física, representando los datos extraídos de una o más tablas fuente. A diferencia de las vistas regulares, que son virtuales y no almacenan datos por sí mismas, las vistas materializadas están precalculadas y se actualizan periódicamente para garantizar que sus datos estén sincronizados con las tablas fuente subyacentes.

**Sintaxis**
CREATE MATERIALIZED VIEW nombre_de_la_vista
AS
SELECT columnas
FROM tablas
WHERE condiciones
[REFRESH {FAST | COMPLETE | FORCE | ON DEMAND | NEVER}];


**Por qué se utilizan:**
Las vistas materializadas se utilizan por varias razones:
1. **Mejora del rendimiento:** Las vistas materializadas pueden mejorar significativamente el rendimiento de las consultas precalculando y almacenando los resultados de consultas complejas o frecuentemente utilizadas. Esto reduce la necesidad de ejecutar repetidamente consultas costosas en conjuntos de datos grandes.
2. **Agregación y resumen de datos:** A menudo se utilizan para agregar, resumir o transformar datos, lo que permite a los usuarios acceder eficientemente a información resumida sin consultar todo el conjunto de datos.
3. **Procesamiento sin conexión:** Las vistas materializadas se pueden utilizar para el procesamiento y reportes sin conexión, lo que permite una recuperación de datos más rápida con fines analíticos.
4. **Reducción de la carga en las tablas fuente:** Al proporcionar una fuente de datos alternativa, las vistas materializadas pueden reducir la carga en las tablas fuente subyacentes, lo que puede ser crucial en sistemas con alta concurrencia y operaciones de lectura frecuentes.
5. **Soporte para datos remotos:** Las vistas materializadas se pueden utilizar para almacenar datos de bases de datos remotas, lo que facilita el trabajo con sistemas distribuidos.

**Alternativas a las Vistas Materializadas:**
Aunque las vistas materializadas ofrecen beneficios significativos, existen enfoques alternativos para lograr resultados similares:
1. **Vistas Regulares:** Las vistas regulares (no materializadas) son tablas virtuales que representan los resultados de una consulta. A diferencia de las vistas materializadas, no almacenan datos, pero proporcionan una vista actualizada de las tablas subyacentes cada vez que se consultan. Las vistas son más adecuadas cuando se requiere acceso a datos en tiempo real y el costo de recomputar los resultados es aceptable.
2. **Caché:** Almacenar en caché los resultados de consultas en memoria puede mejorar el rendimiento de las consultas al reducir la necesidad de volver a calcular las mismas consultas con frecuencia. Sin embargo, este enfoque puede no ser tan eficiente como las vistas materializadas para conjuntos de datos complejos o grandes.
3. **Indexación:** Crear índices apropiados en columnas consultadas con frecuencia puede mejorar el rendimiento de las consultas sin la necesidad de vistas materializadas. Si bien los índices no almacenan resultados precalculados, proporcionan un acceso más rápido a los datos al optimizar la recuperación de datos.

**SGBD donde existen:** 
Las vistas materializadas son compatibles con varios sistemas de gestión de bases de datos relacionales (SGBD). Algunos SGBD populares donde se pueden encontrar vistas materializadas incluyen:
1. **Oracle Database:** Oracle brinda un sólido soporte para vistas materializadas, ofreciendo varias opciones para su actualización y mantenimiento.
2. **PostgreSQL:** A partir de la versión 9.3, PostgreSQL introdujo soporte para vistas materializadas, lo que permite a los usuarios crearlas y utilizarlas como en otros SGBD.
3. **Microsoft SQL Server:** SQL Server también admite vistas materializadas, llamadas "Vistas Indexadas", que se pueden indexar para mejorar aún más el rendimiento.
4. **IBM Db2:** Db2 admite vistas materializadas como "Tablas de Consulta Materializadas (MQTs)", que proporcionan una funcionalidad similar.
5. **MySQL:** Hasta mi última actualización de conocimientos en septiembre de 2021, MySQL no tenía soporte incorporado para vistas materializadas. Sin embargo, es posible que algunas soluciones y extensiones de terceros ofrezcan una funcionalidad similar.
/*



