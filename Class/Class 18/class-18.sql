use sakila;

/*
Escribe una función que devuelva la cantidad de copias de una película en una tienda en sakila-db. 
Pase la identificación de la película o el nombre de la película y la identificación de la tienda.
*/
DELIMITER //

DELIMITER //

CREATE FUNCTION obtener_cantidad_copias(pelicula_id INT, tienda_id INT) RETURNS INT
BEGIN
    DECLARE copias INT;
    SELECT COUNT(*) INTO copias
    FROM inventory
    WHERE film_id = pelicula_id AND store_id = tienda_id;
    RETURN copias;
END//

DELIMITER ;
SELECT obtener_cantidad_copias(1, 1); -- Probamos

/*
Escriba un procedimiento almacenado con un parámetro de salida que contenga una lista de nombres y apellidos de clientes separados por ";",
que viven en un país determinado. Pasas el país y te da la lista de personas que viven allí. USE UN CURSOR , no utilice ninguna función de agregación (como CONTCAT_WS.
*/
DELIMITER //
CREATE PROCEDURE get_customers_in_country(IN country_name VARCHAR(255), OUT customer_list VARCHAR(255))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE first_name, last_name VARCHAR(255);
    DECLARE cur CURSOR FOR 
	    SELECT first_name, last_name
        FROM customer cu
        JOIN address ad ON cu.address_id = ad.address_id
        JOIN city ci ON ad.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = country_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SET customer_list = '';
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO first_name, last_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET customer_list = CONCAT(customer_list, first_name, ' ', last_name, ';');
    END LOOP;
    CLOSE cur;
    SET customer_list = LEFT(customer_list, LENGTH(customer_list) - 1);
END //

DELIMITER ;
CALL get_customers_in_country('United States', @customer_list);
SELECT @customer_list;

/*
Revise la función inventario_en_stock y el procedimiento film_in_stock , explique el código y escriba ejemplos de uso.
*/

-- Procedimiento film_in_stock
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END //
DELIMITER ;
/*
film_in_stock que has creado parece estar diseñado para determinar si hay copias de una película específica disponible en una tienda determinada.
CREATE DEFINER=root@localhostPROCEDUREfilm_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT): Este es el encabezado del procedimiento almacenado. Estás creando un procedimiento llamado film_in_stock que toma tres parámetros: p_film_id (el ID de la película), p_store_id (el ID de la tienda) y p_film_count (la cantidad de copias disponibles).
READS SQL DATA: Indica que este procedimiento realiza operaciones de lectura en la base de datos.
BEGIN ... END: Todo el código del procedimiento está dentro de este bloque.
La primera consulta SELECT inventory_id FROM inventory WHERE film_id = p_film_id AND store_id = p_store_id AND inventory_in_stock(inventory_id); busca los inventory_id de las copias de la película específica en la tienda específica que están en stock. Sin embargo, esta consulta no está asignando los resultados a ninguna variable o devolviéndolos.
La segunda consulta SELECT COUNT(*) FROM inventory WHERE film_id = p_film_id AND store_id = p_store_id AND inventory_in_stock(inventory_id) INTO p_film_count; realiza la misma búsqueda, pero esta vez cuenta el número de resultados y lo asigna a la variable p_film_count.
*/

CALL film_in_stock(1, 1, @film_count);
SELECT @film_count;

-- En este ejemplo, se llama al procedimiento film_in_stock con los parámetros p_film_id = 1 y p_store_id = 1. El resultado se almacena en la variable @film_count, que luego se selecciona para mostrar el número de copias disponibles.
-- FUNCIÓN inventory_in_stock
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
DELIMITER ;
/*
inventory_in_stock que determina si un artículo de inventario está en stock o no. La función toma el ID del inventario (p_inventory_id) como entrada y devuelve un valor booleano (1 si está en stock, 0 si no lo está).

La lógica de la función es la siguiente:
    -Se declara dos variables locales (v_rentals y v_out) que se utilizarán para contar y almacenar resultados.
    -Se verifica si hay alquileres asociados al artículo de inventario. Si no hay alquileres, se asume que el artículo está en stock.
    -Si hay alquileres, se verifica si todos los alquileres han sido devueltos. Si hay algún alquiler pendiente, se asume que el artículo no está en stock.
*/
SELECT inventory_in_stock(1); -- El resultado será 1 si el inventario está en stock y 0 si no lo está.
