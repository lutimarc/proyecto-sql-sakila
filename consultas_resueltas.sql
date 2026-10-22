-- Ejercicio 1
-- Crea el esquema de la base de datos.
-- El diagrama de tablas y relaciones está en esquema_bbdd.png.

-- Ejercicio 2
-- Muestra los títulos de las películas con clasificación R.
SELECT title
FROM film
WHERE rating = 'R';

-- Ejercicio 3
-- Encuentra los nombres de los actores con actor_id entre 30 y 40.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- Ejercicio 4
-- Obtén las películas cuyo idioma coincide con el idioma original.
-- No devuelve filas: el idioma original está vacío (NULL) en todas las películas.
SELECT title
FROM film
WHERE original_language_id = language_id;

-- Ejercicio 5
-- Ordena las películas por duración de forma ascendente.
SELECT title, length
FROM film
ORDER BY length ASC;

-- Ejercicio 6
-- Encuentra el nombre y apellido de los actores que tengan Allen en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name ILIKE '%Allen%';

-- Ejercicio 7
-- Muestra cada clasificación y su cantidad total de películas.
SELECT rating, COUNT(*) AS cantidad_peliculas
FROM film
GROUP BY rating
ORDER BY rating;

-- Ejercicio 8
-- Encuentra las películas con clasificación PG-13 o duración mayor a tres horas.
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13'
   OR length > 180;

-- Ejercicio 9
-- Calcula la variabilidad del coste de reemplazo de las películas.
SELECT
    VAR_SAMP(replacement_cost) AS varianza_coste_reemplazo,
    STDDEV_SAMP(replacement_cost) AS desviacion_coste_reemplazo
FROM film;

-- Ejercicio 10
-- Encuentra la mayor y la menor duración de las películas.
SELECT MIN(length) AS duracion_minima, MAX(length) AS duracion_maxima
FROM film;

-- Ejercicio 11
-- Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
-- Se ordenan los alquileres y se suman sus pagos. El ID resuelve empates de fecha.
SELECT r.rental_id, r.rental_date, SUM(p.amount) AS coste_alquiler
FROM rental AS r
LEFT JOIN payment AS p ON p.rental_id = r.rental_id
GROUP BY r.rental_id, r.rental_date
ORDER BY r.rental_date DESC, r.rental_id DESC
OFFSET 2 LIMIT 1;

-- Ejercicio 12
-- Encuentra los títulos de las películas cuya clasificación no sea NC-17 ni G.
SELECT title, rating
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- Ejercicio 13
-- Muestra cada clasificación y el promedio de duración de sus películas.
SELECT rating, ROUND(AVG(length), 2) AS duracion_media
FROM film
GROUP BY rating
ORDER BY rating;

-- Ejercicio 14
-- Encuentra los títulos de las películas que duran más de 180 minutos.
SELECT title, length
FROM film
WHERE length > 180
ORDER BY length DESC;

-- Ejercicio 15
-- Calcula cuánto dinero ha generado en total la empresa.
SELECT SUM(amount) AS ingresos_totales
FROM payment;

-- Ejercicio 16
-- Muestra los diez clientes con mayor identificador.
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- Ejercicio 17
-- Encuentra el nombre y apellido de los actores de Egg Igby.
-- ILIKE permite buscar sin distinguir mayúsculas y minúsculas.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film AS f ON f.film_id = fa.film_id
WHERE f.title ILIKE 'Egg Igby'
ORDER BY a.last_name, a.first_name;

-- Ejercicio 18
-- Selecciona los títulos únicos de las películas.
SELECT DISTINCT title
FROM film
ORDER BY title;

-- Ejercicio 19
-- Encuentra las películas de comedia con duración mayor a 180 minutos.
SELECT f.title, f.length
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180
ORDER BY f.length DESC;

-- Ejercicio 20
-- Muestra las categorías con duración media superior a 110 minutos y su promedio.
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_media DESC;

-- Ejercicio 21
-- Calcula la duración media del alquiler de las películas.
-- Se usa el plazo de alquiler indicado en el catálogo, en días.
SELECT ROUND(AVG(rental_duration), 2) AS duracion_media_dias
FROM film;

-- Ejercicio 22
-- Crea una columna con el nombre y apellido de todos los actores y actrices.
SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor
ORDER BY last_name, first_name;

-- Ejercicio 23
-- Cuenta los alquileres por día y ordénalos de mayor a menor cantidad.
SELECT rental_date::date AS dia, COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY rental_date::date
ORDER BY cantidad_alquileres DESC, dia;

-- Ejercicio 24
-- Encuentra las películas con duración superior al promedio.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

-- Ejercicio 25
-- Cuenta los alquileres registrados por mes.
SELECT DATE_TRUNC('month', rental_date)::date AS mes,
       COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY DATE_TRUNC('month', rental_date)::date
ORDER BY mes;

-- Ejercicio 26
-- Calcula el promedio, la desviación estándar y la varianza del importe pagado.
SELECT
    ROUND(AVG(amount), 2) AS promedio_pagado,
    ROUND(STDDEV_SAMP(amount)::numeric, 2) AS desviacion_estandar,
    ROUND(VAR_SAMP(amount)::numeric, 2) AS varianza
FROM payment;

-- Ejercicio 27
-- Encuentra las películas con un precio de alquiler superior a la media.
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC, title;

-- Ejercicio 28
-- Muestra el identificador de los actores que han participado en más de 40 películas.
SELECT actor_id, COUNT(DISTINCT film_id) AS cantidad_peliculas
FROM film_actor
GROUP BY actor_id
HAVING COUNT(DISTINCT film_id) > 40
ORDER BY cantidad_peliculas DESC;

-- Ejercicio 29
-- Muestra todas las películas y la cantidad disponible en el inventario.
-- Una copia está disponible si no tiene un alquiler pendiente de devolución.
SELECT f.title,
       COUNT(i.inventory_id) FILTER (WHERE r.rental_id IS NULL) AS unidades_disponibles
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
LEFT JOIN rental AS r
       ON r.inventory_id = i.inventory_id
      AND r.return_date IS NULL
GROUP BY f.film_id, f.title
ORDER BY f.title;

-- Ejercicio 30
-- Muestra los actores y el número de películas en las que han actuado.
SELECT a.actor_id, a.first_name, a.last_name,
       COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY a.last_name, a.first_name;

-- Ejercicio 31
-- Muestra todas las películas y sus actores, incluidas las películas sin actores.
SELECT f.title, a.first_name, a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa ON fa.film_id = f.film_id
LEFT JOIN actor AS a ON a.actor_id = fa.actor_id
ORDER BY f.title, a.last_name, a.first_name;

-- Ejercicio 32
-- Muestra todos los actores y sus películas, incluidos los actores sin películas.
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
LEFT JOIN film AS f ON f.film_id = fa.film_id
ORDER BY a.last_name, a.first_name, f.title;

-- Ejercicio 33
-- Obtén todas las películas y todos los registros de alquiler.
SELECT f.title, r.rental_id, r.rental_date, r.return_date
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
FULL OUTER JOIN rental AS r ON r.inventory_id = i.inventory_id
ORDER BY f.title, r.rental_date;

-- Ejercicio 34
-- Encuentra los cinco clientes que más dinero han gastado.
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(p.amount) AS total_gastado
FROM customer AS c
JOIN payment AS p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

-- Ejercicio 35
-- Selecciona los actores cuyo nombre es Johnny.
SELECT first_name, last_name
FROM actor
WHERE first_name ILIKE 'Johnny'
ORDER BY last_name;

-- Ejercicio 36
-- Muestra first_name como Nombre y last_name como Apellido.
SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor;

-- Ejercicio 37
-- Encuentra el identificador de actor más bajo y el más alto.
SELECT MIN(actor_id) AS id_mas_bajo, MAX(actor_id) AS id_mas_alto
FROM actor;

-- Ejercicio 38
-- Cuenta cuántos actores hay en la tabla actor.
SELECT COUNT(*) AS cantidad_actores
FROM actor;

-- Ejercicio 39
-- Selecciona todos los actores y ordénalos por apellido ascendente.
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name ASC, first_name ASC;

-- Ejercicio 40
-- Selecciona las primeras cinco películas de la tabla film.
SELECT film_id, title
FROM film
ORDER BY film_id
LIMIT 5;

-- Ejercicio 41
-- Agrupa los actores por nombre, cuenta las coincidencias y encuentra el más repetido.
-- Si varios nombres empatan en la cantidad máxima, se muestran todos.
SELECT first_name, COUNT(*) AS cantidad_actores
FROM actor
GROUP BY first_name
HAVING COUNT(*) = (
    SELECT MAX(cantidad)
    FROM (
        SELECT COUNT(*) AS cantidad
        FROM actor
        GROUP BY first_name
    ) AS recuentos
)
ORDER BY first_name;

-- Ejercicio 42
-- Muestra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental AS r
JOIN customer AS c ON c.customer_id = r.customer_id
ORDER BY r.rental_date;

-- Ejercicio 43
-- Muestra todos los clientes y sus alquileres, incluidos los clientes sin alquileres.
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
ORDER BY c.last_name, c.first_name, r.rental_date;

-- Ejercicio 44
-- Realiza un CROSS JOIN entre film y category y explica después si aporta valor.
SELECT f.title, c.name AS categoria
FROM film AS f
CROSS JOIN category AS c
ORDER BY f.title, c.name;
-- No aporta valor para conocer la categoría real de cada película: genera todas
-- las combinaciones posibles entre películas y categorías.

-- Ejercicio 45
-- Encuentra los actores que han participado en películas de la categoría Action.
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;

-- Ejercicio 46
-- Encuentra los actores que no han participado en ninguna película.
-- No devuelve filas: todos los actores tienen alguna película asociada.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor AS fa
    WHERE fa.actor_id = a.actor_id
)
ORDER BY a.last_name, a.first_name;

-- Ejercicio 47
-- Muestra los nombres de los actores y la cantidad de películas en las que participaron.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY a.last_name, a.first_name;

-- Ejercicio 48
-- Crea actor_num_peliculas con los nombres de los actores y su número de películas.
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name, a.last_name,
       COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Ejercicio 49
-- Calcula el número total de alquileres realizados por cada cliente.
SELECT c.customer_id, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- Ejercicio 50
-- Calcula la duración total de las películas de la categoría Action.
SELECT SUM(f.length) AS duracion_total_minutos
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Action';

-- Ejercicio 51
-- Crea cliente_rentas_temporal para guardar el total de alquileres por cliente.
-- Las tablas temporales de los ejercicios 51 y 52 duran hasta cerrar la sesión.
DROP TABLE IF EXISTS cliente_rentas_temporal;
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

-- Ejercicio 52
-- Crea peliculas_alquiladas con las películas alquiladas al menos diez veces.
DROP TABLE IF EXISTS peliculas_alquiladas;
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS cantidad_alquileres
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Ejercicio 53
-- Encuentra las películas alquiladas por Tammy Sanders que aún no se han devuelto.
-- Ordena los resultados alfabéticamente por título.
SELECT DISTINCT f.title
FROM customer AS c
JOIN rental AS r ON r.customer_id = c.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id
WHERE c.first_name ILIKE 'Tammy'
  AND c.last_name ILIKE 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;

-- Ejercicio 54
-- Encuentra los actores de películas Sci-Fi y ordénalos alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;

-- Ejercicio 55
-- Encuentra los actores de películas alquiladas después del primer alquiler
-- de Spartacus Cheaper y ordénalos alfabéticamente por apellido.
-- MIN obtiene la fecha del primer alquiler de esa película.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN inventory AS i ON i.film_id = fa.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental AS r2
    JOIN inventory AS i2 ON i2.inventory_id = r2.inventory_id
    JOIN film AS f2 ON f2.film_id = i2.film_id
    WHERE f2.title ILIKE 'Spartacus Cheaper'
)
ORDER BY a.last_name, a.first_name;

-- Ejercicio 56
-- Encuentra los actores que no han actuado en películas de la categoría Music.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor AS fa
    JOIN film_category AS fc ON fc.film_id = fa.film_id
    JOIN category AS c ON c.category_id = fc.category_id
    WHERE fa.actor_id = a.actor_id
      AND c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

-- Ejercicio 57
-- Encuentra los títulos de las películas alquiladas durante más de ocho días.
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;

-- Ejercicio 58
-- Encuentra los títulos de las películas de la categoría Animation.
SELECT f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;

-- Ejercicio 59
-- Encuentra las películas con la misma duración que Dancing Fever.
-- Ordena los resultados alfabéticamente por título.
SELECT title, length
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title ILIKE 'Dancing Fever'
)
ORDER BY title;

-- Ejercicio 60
-- Encuentra los clientes que han alquilado al menos siete películas distintas.
-- Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name, c.last_name
FROM customer AS c
JOIN rental AS r ON r.customer_id = c.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;

-- Ejercicio 61
-- Muestra cada categoría y su cantidad total de alquileres.
SELECT c.name AS categoria, COUNT(r.rental_id) AS cantidad_alquileres
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN inventory AS i ON i.film_id = fc.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY c.name
ORDER BY cantidad_alquileres DESC, c.name;

-- Ejercicio 62
-- Cuenta las películas estrenadas en 2006 por categoría.
SELECT c.name AS categoria, COUNT(f.film_id) AS cantidad_peliculas
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f ON f.film_id = fc.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY c.name;

-- Ejercicio 63
-- Obtén todas las combinaciones posibles de trabajadores y tiendas.
SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff AS s
CROSS JOIN store AS st
ORDER BY s.staff_id, st.store_id;

-- Ejercicio 64
-- Muestra el identificador, nombre y apellido de cada cliente y su total de alquileres.
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;

