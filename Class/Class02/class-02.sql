
CREATE DATABASE imdb;


USE imdb;


CREATE TABLE film (
  film_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  release_year INT
);


CREATE TABLE actor (
  actor_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
);

CREATE TABLE film_actor (
  actor_id INT,
  film_id INT,
  PRIMARY KEY (actor_id, film_id)
);


-- Add foreign keys in film_actor table
ALTER TABLE film_actor
ADD CONSTRAINT FK_actor_id
FOREIGN KEY (actor_id)
REFERENCES actor(actor_id);

ALTER TABLE film_actor
ADD CONSTRAINT FK_film_id
FOREIGN KEY (film_id)
REFERENCES film(film_id);



-- Add last_update column to film table
ALTER TABLE film ADD COLUMN last_update DATETIME;

-- Add last_update column to actor table
ALTER TABLE actor ADD COLUMN last_update DATETIME;

-- Insertar 10 películas en la tabla "film"
INSERT INTO film (title, description, release_year, last_update)
VALUES
  ('The Shawshank Redemption', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 1994, NOW()),
  ('The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 1972, NOW()),
  ('The Dark Knight', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', 2008, NOW()),
  ('The Lord of the Rings: The Fellowship of the Ring', 'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.', 2001, NOW()),
  ('Forrest Gump', 'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate and other historical events unfold through the perspective of an Alabama man with an IQ of 75, whose only desire is to be reunited with his childhood sweetheart.', 1994, NOW()),
  ('Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.', 2010, NOW()),
  ('The Matrix', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 1999, NOW()),
  ('Star Wars: Episode IV - A New Hope', 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire''s world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.', 1977, NOW()),
  ('The Silence of the Lambs', 'A young F.B.I. cadet must receive the help of an incarcerated and manipulative cannibal killer to help catch another serial killer, a madman who skins his victims.', 1991, NOW()),
  ('Pulp Fiction', 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', 1994, NOW());


-- Insertar 10 actores en la tabla "actor"
INSERT INTO actor (first_name, last_name, last_update)
VALUES
  ('Tom', 'Hanks', NOW()),
  ('Morgan', 'Freeman', NOW()),
  ('Al', 'Pacino', NOW()),
  ('Marlon', 'Brando', NOW()),
  ('Heath', 'Ledger', NOW()),
  ('Viggo', 'Mortensen', NOW()),
  ('Keanu', 'Reeves', NOW()),
  ('Harrison', 'Ford', NOW()),
  ('Anthony', 'Hopkins', NOW()),
  ('John', 'Travolta', NOW());


-- Insertar las relaciones entre actores y películas en la tabla "film_actor"
INSERT INTO film_actor (actor_id, film_id)
VALUES
  (1, 5),
  (1, 9),
  (2, 1),
  (2, 9),
  (3, 2),
  (3, 6),
  (4, 2),
  (4, 8));