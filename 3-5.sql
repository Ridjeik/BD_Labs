SELECT * FROM movie;

SELECT * FROM customer
WHERE customer.registration_date > '2023-05-01';

SELECT * FROM film_session
WHERE film_session.hall_id = 1
ORDER BY movie_id;

--------------------------------------------------------------------------------------

WITH sessions_with_duration AS (
	SELECT session_id, hall_id, start_datetime, duration
	FROM film_session
	JOIN movie USING (movie_id)
)
SELECT * FROM sessions_with_duration s1
JOIN sessions_with_duration s2
ON s1.session_id < s2.session_id
AND s1.hall_id = s2.hall_id
AND (s1.start_datetime, (s1.duration::text || ' minutes'::text)::interval) OVERLAPS
	(s2.start_datetime, (s2.duration::text || ' minutes'::text)::interval);

SELECT title, sum(price) AS revenue FROM movie
JOIN film_session USING (movie_id)
JOIN ticket USING (session_id)
GROUP BY (movie.title)
ORDER BY revenue DESC
LIMIT 10;

--------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW most_popular_films AS (
	SELECT title, count(*) AS tickets_count FROM movie
	JOIN film_session USING (movie_id)
	JOIN ticket USING (session_id)
	GROUP BY (movie.title)
	ORDER BY tickets_count DESC
);

SELECT * FROM most_popular_films;

DO $$
DECLARE
    customer_cursor CURSOR FOR
    SELECT customer_id, first_name, last_name, phone_number
    FROM public.customer
    WHERE registration_date >= '2023-01-01';
    customer_record RECORD;
BEGIN
    OPEN customer_cursor;
    LOOP
        FETCH customer_cursor INTO customer_record;
        EXIT WHEN NOT FOUND;
        
        RAISE NOTICE 'Customer ID: %, Name: % %, Phone: %',
                     customer_record.customer_id, customer_record.first_name,
                     customer_record.last_name, customer_record.phone_number;
    END LOOP;
    CLOSE customer_cursor;
END;
$$;

DO $$
DECLARE
    cashier_sales_cursor CURSOR FOR
    SELECT cashier_id, SUM(sale_amount) AS total_sales
    FROM (
        SELECT s.cashier_id, s.sale_id, SUM(t.price) AS sale_amount
        FROM public.sale AS s
        JOIN public.ticket AS t ON s.sale_id = t.sale_id
		WHERE s.cashier_id IS NOT NULL
        GROUP BY s.cashier_id, s.sale_id
    ) AS cashier_sales
    GROUP BY cashier_id;
    cashier_sales_record RECORD;
BEGIN
    OPEN cashier_sales_cursor;
    LOOP
        FETCH cashier_sales_cursor INTO cashier_sales_record;
        EXIT WHEN NOT FOUND;

        -- Your business logic here
        RAISE NOTICE 'Cashier ID: %, Total Sales: $%', cashier_sales_record.cashier_id, cashier_sales_record.total_sales;
    END LOOP;
    CLOSE cashier_sales_cursor;
END;
$$;