use sakila;
show tables;
CREATE TABLE employees (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');


CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

#1- Insert a new employee to , but with an null email. Explain what happens.
INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES 
(99,'Fernandez','Mateo','x0404',NULL,'2',1076,'Marketing employee');
# Tira "Error Code: 1048. Column "email" cannot be null". Esto es debido a que cuando se crea la tabla se colocó "`email` varchar(100) NOT NULL" es decir no puede ser nula.
delete from employees where employeeNumber = 99;  
#2- Run the first the query

UPDATE employees SET employeeNumber = employeeNumber - 20;
select * from employees;
#Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect. Me tiro este error al principio, ya lo solucioné.
#Respuesta: Me tira "3 row(s) affected Rows matched: 3 Changed: 3 Warnings: 3. Esto quiere decir que se actualizó bien debido a que es secuencial y nunca quedan en el mismo punto las 2 con las mismas id. Ahora si el 3° insert estuviera segundo si me tiraría error porque chocaría"
#What did happen? Explain. Then run this other

UPDATE employees SET employeeNumber = employeeNumber + 20;
#Explain this case also.
-- Tira: Error Code: 1062. Duplicate entry '1056' for key 'employees PRIMARY. Acá a diferencia de la otra al primero estar la de 1056 y ejecutarse secuencialmente choca con el insert 3'
#3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
ALTER TABLE employees
ADD age TINYINT UNSIGNED;
ALTER TABLE employees
   ADD CONSTRAINT age CHECK(age between 16 and 70);
#4- Describe the referential integrity between tables film, actor and film_actor in sakila db.
/*
La integridad referencial entre estas tablas se mantiene a través de relaciones de clave externa (foreign key):
	En la tabla film, hay una clave primaria llamada film_id.
	En la tabla actor, hay una clave primaria llamada actor_id.
	En la tabla film_actor, hay dos claves externas:
		film_id hace referencia a la clave primaria film_id de la tabla film.
		actor_id hace referencia a la clave primaria actor_id de la tabla actor.
Estas relaciones de clave externa aseguran la integridad referencial al aplicar las siguientes reglas:
	Existencia de Datos Relacionados: Antes de insertar un registro en la tabla film_actor, los valores correspondientes de film_id y actor_id deben existir en las tablas film y actor, respectivamente.
	Eliminación y Actualizaciones: Si se elimina o actualiza un registro en la tabla film o actor (lo que incluye cambiar el valor de la clave primaria), el sistema de gestión de bases de datos se asegura de que los registros relacionados en la tabla film_actor también se actualicen o eliminen para mantener la consistencia.
	Prevención de Registros Huérfanos: Las relaciones de clave externa previenen la creación de registros huérfanos en la tabla film_actor. Los registros huérfanos son registros en la tabla de referencia (film_actor) que no tienen un registro correspondiente en la tabla referenciada (film o actor).
*/
#5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).
ALTER TABLE employees
	ADD COLUMN lastUpdate DATETIME;
ALTER TABLE employees
	ADD COLUMN lastUpdateUser VARCHAR(255);	

DELIMITER //
CREATE TRIGGER update_employee
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = CURRENT_USER;
END;
//
DELIMITER ;
update employees set lastName = 'Fercho' where employeeNumber = 1056;
select * from employees;
/*
6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.
DELIMITER //
ins_film Inserta una nueva entrada film_text, con los mismos valores que la película añadida.

BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
END

upd_film Actualiza la entrada film_text existente correspondiente para la película actualizada.

BEGIN
	IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
	THEN
	    UPDATE film_text
	        SET title=new.title,
	            description=new.description,
	            film_id=new.film_id
	    WHERE film_id=old.film_id;
	END IF;
END

del_film Elimina la entrada film_text existente correspondiente a la película eliminada.

BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END
//
DELIMITER ;
*/
