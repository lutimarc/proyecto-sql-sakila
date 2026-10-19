-- Ejercicio 1
CREATE SCHEMA IF NOT EXISTS public;

-- Ejercicio 2
SELECT title
FROM film
WHERE rating = 'R';

-- Ejercicio 3
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- Ejercicio 4
SELECT title
FROM film
WHERE original_language_id = language_id;

-- Ejercicio 5
SELECT title, length
FROM film
ORDER BY length ASC;

-- Ejercicio 6
SELECT first_name, last_name
FROM actor
WHERE last_name ILIKE '%Allen%';

-- Ejercicio 7
SELECT rating, COUNT(*) AS cantidad_peliculas
FROM film
GROUP BY rating
ORDER BY rating;

-- Ejercicio 8
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13'
   OR length > 180;

-- Ejercicio 9
SELECT
    VAR_SAMP(replacement_cost) AS varianza_coste_reemplazo,
    STDDEV_SAMP(replacement_cost) AS desviacion_coste_reemplazo
FROM film;

-- Ejercicio 10
SELECT MIN(length) AS duracion_minima, MAX(length) AS duracion_maxima
FROM film;

-- Ejercicio 11
SELECT amount, payment_date
FROM payment
ORDER BY payment_date DESC, payment_id DESC
OFFSET 2 LIMIT 1;

-- Ejercicio 12
SELECT title, rating
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- Ejercicio 13
SELECT rating, ROUND(AVG(length), 2) AS duracion_media
FROM film
GROUP BY rating
ORDER BY rating;

-- Ejercicio 14
SELECT title, length
FROM film
WHERE length > 180
ORDER BY length DESC;

-- Ejercicio 15
SELECT SUM(amount) AS ingresos_totales
FROM payment;

-- Ejercicio 16
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- Ejercicio 17
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film AS f ON f.film_id = fa.film_id
WHERE f.title = 'Egg Igby'
ORDER BY a.last_name, a.first_name;

-- Ejercicio 18
SELECT DISTINCT title
FROM film
ORDER BY title;

-- Ejercicio 19
SELECT f.title, f.length
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180
ORDER BY f.length DESC;

-- Ejercicio 20
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_media DESC;

-- Ejercicio 21
SELECT ROUND(AVG(rental_duration), 2) AS duracion_media_dias
FROM film;

-- Ejercicio 22
SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor
ORDER BY last_name, first_name;

-- Ejercicio 23
SELECT rental_date::date AS dia, COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY rental_date::date
ORDER BY cantidad_alquileres DESC, dia;

-- Ejercicio 24
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

-- Ejercicio 25
SELECT DATE_TRUNC('month', rental_date)::date AS mes,
       COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY DATE_TRUNC('month', rental_date)::date
ORDER BY mes;

-- Ejercicio 26
SELECT
    ROUND(AVG(amount), 2) AS promedio_pagado,
    ROUND(STDDEV_SAMP(amount)::numeric, 2) AS desviacion_estandar,
    ROUND(VAR_SAMP(amount)::numeric, 2) AS varianza
FROM payment;

-- Ejercicio 27
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC, title;

-- Ejercicio 28
SELECT actor_id, COUNT(DISTINCT film_id) AS cantidad_peliculas
FROM film_actor
GROUP BY actor_id
HAVING COUNT(DISTINCT film_id) > 40
ORDER BY cantidad_peliculas DESC;

-- Ejercicio 29
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
SELECT a.actor_id, a.first_name, a.last_name,
       COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY a.last_name, a.first_name;

-- Ejercicio 31
SELECT f.title, a.first_name, a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa ON fa.film_id = f.film_id
LEFT JOIN actor AS a ON a.actor_id = fa.actor_id
ORDER BY f.title, a.last_name, a.first_name;

-- Ejercicio 32
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
LEFT JOIN film AS f ON f.film_id = fa.film_id
ORDER BY a.last_name, a.first_name, f.title;

-- Ejercicio 33
SELECT f.title, r.rental_id, r.rental_date, r.return_date
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
LEFT JOIN rental AS r ON r.inventory_id = i.inventory_id
ORDER BY f.title, r.rental_date;

-- Ejercicio 34
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(p.amount) AS total_gastado
FROM customer AS c
JOIN payment AS p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

-- Ejercicio 35
SELECT first_name, last_name
FROM actor
WHERE first_name = 'Johnny'
ORDER BY last_name;

-- Ejercicio 36
SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor;

-- Ejercicio 37
SELECT MIN(actor_id) AS id_mas_bajo, MAX(actor_id) AS id_mas_alto
FROM actor;

-- Ejercicio 38
SELECT COUNT(*) AS cantidad_actores
FROM actor;

-- Ejercicio 39
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name ASC, first_name ASC;

-- Ejercicio 40
SELECT film_id, title
FROM film
ORDER BY film_id
LIMIT 5;

-- Ejercicio 41
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
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental AS r
JOIN customer AS c ON c.customer_id = r.customer_id
ORDER BY r.rental_date;

-- Ejercicio 43
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
ORDER BY c.last_name, c.first_name, r.rental_date;

-- Ejercicio 44
SELECT f.title, c.name AS categoria
FROM film AS f
CROSS JOIN category AS c
ORDER BY f.title, c.name;
-- No aporta valor para conocer la categoría real de cada película: genera todas
-- las combinaciones posibles entre películas y categorías.

-- Ejercicio 45
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;

-- Ejercicio 46
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor AS fa
    WHERE fa.actor_id = a.actor_id
)
ORDER BY a.last_name, a.first_name;

-- Ejercicio 47
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY a.last_name, a.first_name;

-- Ejercicio 48
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name, a.last_name,
       COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Ejercicio 49
SELECT c.customer_id, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- Ejercicio 50
SELECT SUM(f.length) AS duracion_total_minutos
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Action';

-- Ejercicio 51
DROP TABLE IF EXISTS cliente_rentas_temporal;
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

-- Ejercicio 52
DROP TABLE IF EXISTS peliculas_alquiladas;
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS cantidad_alquileres
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Ejercicio 53
SELECT DISTINCT f.title
FROM customer AS c
JOIN rental AS r ON r.customer_id = c.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id
WHERE c.first_name = 'Tammy'
  AND c.last_name = 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;

-- Ejercicio 54
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;

-- Ejercicio 55
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
    WHERE f2.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name, a.first_name;

-- Ejercicio 56
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
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;

-- Ejercicio 58
SELECT f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;

-- Ejercicio 59
SELECT title, length
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'Dancing Fever'
)
ORDER BY title;

-- Ejercicio 60
SELECT c.first_name, c.last_name
FROM customer AS c
JOIN rental AS r ON r.customer_id = c.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;

-- Ejercicio 61
SELECT c.name AS categoria, COUNT(r.rental_id) AS cantidad_alquileres
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN inventory AS i ON i.film_id = fc.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY c.name
ORDER BY cantidad_alquileres DESC, c.name;

-- Ejercicio 62
SELECT c.name AS categoria, COUNT(f.film_id) AS cantidad_peliculas
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f ON f.film_id = fc.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY c.name;

-- Ejercicio 63
SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff AS s
CROSS JOIN store AS st
ORDER BY s.staff_id, st.store_id;

-- Ejercicio 64
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;

-- Ejercicio 65
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(DISTINCT i.film_id) AS peliculas_distintas_alquiladas
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
LEFT JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;
