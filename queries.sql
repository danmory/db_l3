-- Order countries by id asc, then show the 12th to 17th rows.
SELECT * FROM country ORDER BY country_id OFFSET 11 LIMIT 6;

-- List all addresses in a city whose name starts with 'A’.
SELECT address 
FROM address 
WHERE (city_id IN 
	   (SELECT city_id FROM city WHERE city LIKE 'A%')
);

-- List all customers' first name, last name and the city they live in.
SELECT first_name, last_name, city.city
FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id;

-- Find all customers with at least one payment whose amount is greater than 11 dollars.
SELECT * 
FROM customer
WHERE (customer_id 
		IN (SELECT customer_id 
			FROM payment 
		    WHERE amount > 11
		)
);

-- Find all duplicated first names in the customer table.
SELECT first_name
FROM customer 
GROUP BY first_name
HAVING COUNT(*) > 1;

-- Long film (length > 60)
CREATE VIEW long_film AS
SELECT film_id, title 
FROM film
WHERE length > 60;

-- Сities with the name of the country in which they are located
CREATE VIEW country_of_city AS
SELECT city.city, country.country
FROM city
LEFT JOIN country 
ON city.country_id = country.country_id;

-- Categories of long films
SELECT long_film.title, category.name
FROM long_film 
LEFT JOIN film_category ON long_film.film_id = film_category.film_id
LEFT JOIN category ON film_category.category_id = category.category_id;

-- Function and trigger to notify about film release
CREATE FUNCTION notify_about_film_release()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $$
BEGIN
	RAISE NOTICE 'New film has been released';
	RETURN NULL;
END
$$;

CREATE TRIGGER new_film_notification
AFTER INSERT ON film
FOR EACH ROW 
EXECUTE PROCEDURE notify_about_film_release();

-- Test trigger
INSERT INTO film(title, language_id, fulltext) VALUES ('test', 1, 'test');