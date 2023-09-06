
-- Create a user data_analyst
CREATE USER data_analyst@'%'
IDENTIFIED BY 'supervisor1234';
-- Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'%';
FLUSH PRIVILEGES;
-- Login with this user and try to create a table. Show the result of that operation.
use sakila;
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);

-- Para logearme en el workbench tuve que crear una nueva conexión "Mysql@127.0.0.1:3306" y usar ese usuario  
# Error Code: 1142. CREATE command denied to user 'data_analyst'@'localhost' for table 'test_table'

-- Try to update a title of a film. Write the update script.
UPDATE sakila.film
SET title = 'Prueba_usuario'
WHERE film_id = 1;
#1 row(s) affected Rows matched: 1  Changed: 1  Warnings: 0

-- With root or any admin user revoke the UPDATE permission. Write the commando
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'%';
FLUSH PRIVILEGES;
-- Login again with data_analyst and try again the update done in step 4. Show the result.
UPDATE sakila.film
SET title = 'Prueba_usuario'
WHERE film_id = 1;
#Error Code: 1142. UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'