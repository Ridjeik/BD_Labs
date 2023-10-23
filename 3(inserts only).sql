TRUNCATE distributor CASCADE;
TRUNCATE customer CASCADE;
TRUNCATE cashier CASCADE;
TRUNCATE hall CASCADE;
TRUNCATE hall_type CASCADE;
TRUNCATE film_session CASCADE;
TRUNCATE vendor CASCADE;
TRUNCATE sale CASCADE;

ALTER SEQUENCE distributor_distributor_id_seq RESTART WITH 1;
ALTER SEQUENCE movie_movie_id_seq RESTART WITH 1;
ALTER SEQUENCE customer_customer_id_seq RESTART WITH 1;
ALTER SEQUENCE cashier_cashier_id_seq RESTART WITH 1;
ALTER SEQUENCE hall_hall_id_seq RESTART WITH 1;
ALTER SEQUENCE vendor_vendor_id_seq RESTART WITH 1;
ALTER SEQUENCE loyalty_card_card_id_seq RESTART WITH 1;
ALTER SEQUENCE sale_sale_id_seq RESTART WITH 1;
ALTER SEQUENCE film_session_session_id_seq RESTART WITH 1;

CREATE OR REPLACE FUNCTION random_phone_number()
RETURNS VARCHAR(20) AS $$
DECLARE
    area_code VARCHAR(3);
    exchange VARCHAR(3);
    subscriber VARCHAR(4);
BEGIN
    -- Generate a random area code (3 digits)
    area_code := LPAD(FLOOR(random() * 1000)::VARCHAR, 3, '0');
    -- Generate a random exchange code (3 digits)
    exchange := LPAD(FLOOR(random() * 1000)::VARCHAR, 3, '0');
    -- Generate a random subscriber number (4 digits)
    subscriber := LPAD(FLOOR(random() * 10000)::VARCHAR, 4, '0');
    -- Format and return the random phone number
    RETURN area_code || '-' || exchange || '-' || subscriber;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_date(start_date date, end_date date)
RETURNS date AS $$
DECLARE
    date_range interval;
BEGIN
    
    date_range := AGE(end_date, start_date);
    RETURN start_date + random() * date_range;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_timestamp(start_date timestamp, end_date timestamp)
RETURNS timestamp AS $$
DECLARE
    date_range interval;
BEGIN
    
    date_range := AGE(end_date, start_date);
    RETURN start_date + random() * date_range;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_first_name()
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT name FROM (
            VALUES
                ('John'),
                ('Jane'),
                ('Michael'),
                ('Emily'),
                ('David'),
                ('Sarah'),
                ('James'),
                ('Emma'),
                ('William'),
                ('Olivia'),
                ('Benjamin'),
                ('Ava'),
                ('Matthew'),
                ('Sophia'),
                ('Daniel'),
                ('Liam'),
                ('Ella'),
                ('Nathan'),
                ('Grace'),
                ('Andrew'),
                ('Mia'),
                ('Ethan'),
                ('Charlotte'),
                ('Daniel'),
                ('Jacob'),
                ('Lucas'),
                ('Oliver'),
                ('Sophia'),
                ('Isabella'),
                ('Alexander'),
                ('Liam'),
                ('Harper'),
                ('Henry'),
                ('Chloe'),
                ('Samuel'),
                ('Ethan'),
                ('Abigail'),
                ('Joseph'),
                ('Amelia'),
                ('Christopher'),
                ('Ella'),
                ('James'),
                ('Lucas'),
                ('Emily')
                -- Add more names as needed
        ) AS first_names(name)
        ORDER BY random()
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_last_name()
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT name FROM (
            VALUES
                ('Smith'),
                ('Johnson'),
                ('Brown'),
                ('Taylor'),
                ('Wilson'),
                ('Martinez'),
                ('Jackson'),
                ('Lee'),
                ('Harris'),
                ('Clark'),
                ('Lewis'),
                ('Young'),
                ('Walker'),
                ('Hall'),
                ('Hernandez'),
                ('King'),
                ('White'),
                ('Lopez'),
                ('Adams'),
                ('Green'),
                ('Turner'),
                ('Baker'),
                ('Parker'),
                ('Evans'),
                ('Collins'),
                ('Stewart'),
                ('Murphy'),
                ('Cook'),
                ('Rogers'),
                ('Morgan'),
                ('Bell'),
                ('Cooper'),
                ('Richardson'),
                ('Reed'),
                ('Bailey'),
                ('Rivera'),
                ('Gonzalez'),
                ('Nelson'),
                ('Hill'),
                ('Ramirez'),
                ('Campbell'),
                ('Mitchell'),
                ('Roberts'),
                ('Carter'),
                ('Phillips'),
                ('Watson'),
                ('Gomez')
                -- Add more last names as needed
        ) AS last_names(name)
        ORDER BY random()
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;

INSERT INTO vendor (name, url)
VALUES
  ('Cineplex', 'https://www.cineplex.com'),
  ('AMC Theatres', 'https://www.amctheatres.com'),
  ('Regal Cinemas', 'https://www.regmovies.com'),
  ('Cineworld', 'https://www.cineworld.com'),
  ('Vue Cinemas', 'https://www.myvue.com'),
  ('Odeon Cinemas', 'https://www.odeon.co.uk'),
  ('Landmark Theatres', 'https://www.landmarktheatres.com'),
  ('Alamo Drafthouse', 'https://drafthouse.com'),
  ('Showcase Cinemas', 'https://www.showcasecinemas.com'),
  ('Cinépolis', 'https://www.cinepolis.com');

INSERT INTO distributor (company_name, address, phone_number, email, country)
VALUES
    ('CineMax Distributors', '123 Main St', random_phone_number(), 'cinemax@example.com', 'USA'),
    ('FilmHub Ltd.', '456 Elm St', random_phone_number(), 'filmhub@example.com', 'UK'),
    ('Global Pictures Inc.', '789 Oak St', random_phone_number(), 'globalpictures@example.com', 'USA'),
    ('SilverScreen Distribution', '101 Pine St', random_phone_number(), 'silverscreen@example.com', 'UK'),
    ('EuroCinema Distributors', '456 Maple St', random_phone_number(), 'eurocinema@example.com', 'France'),
    ('MegaMovies Corp.', '789 Birch St', random_phone_number(), 'megamovies@example.com', 'USA'),
    ('UK Film Distribution', '101 Spruce St', random_phone_number(), 'ukfilm@example.com', 'UK'),
    ('French Cinema Enterprises', '456 Cedar St', random_phone_number(), 'frenchcinema@example.com', 'France'),
    ('German Films Ltd.', '123 Redwood St', random_phone_number(), 'germanfilms@example.com', 'Germany'),
    ('Japan Movie Distributors', '789 Pine St', random_phone_number(), 'japanmovies@example.com', 'Japan'),
    ('Great Wall Films', '101 Oak St', random_phone_number(), 'greatwallfilms@example.com', 'China');

-- Insert data into the movie table with realistic titles, directors, and random distributor IDs (duplicates manually removed)
INSERT INTO movie (title, director, genre, duration, release_date, age_rating, distributor_id)
VALUES
    ('The Shawshank Redemption', 'Frank Darabont', 'Drama', 142, '1994-09-23', 'R', 8),
    ('The Godfather', 'Francis Ford Coppola', 'Crime', 175, '1972-03-24', 'R', 4),
    ('The Dark Knight', 'Christopher Nolan', 'Action', 152, '2008-07-18', 'PG-13', 11),
    ('Pulp Fiction', 'Quentin Tarantino', 'Crime', 154, '1994-10-14', 'R', 7),
    ('The Lord of the Rings: The Return of the King', 'Peter Jackson', 'Adventure', 201, '2003-12-17', 'PG-13', 9),
    ('Forrest Gump', 'Robert Zemeckis', 'Drama', 142, '1994-07-06', 'PG-13', 3),
    ('Inception', 'Christopher Nolan', 'Sci-Fi', 148, '2010-07-16', 'PG-13', 6),
    ('Fight Club', 'David Fincher', 'Drama', 139, '1999-10-15', 'R', 1),
    ('The Matrix', 'Lana Wachowski', 'Sci-Fi', 136, '1999-03-31', 'R', 10),
    ('The Silence of the Lambs', 'Jonathan Demme', 'Crime', 118, '1991-02-14', 'R', 5),
    ('Gladiator', 'Ridley Scott', 'Action', 155, '2000-05-05', 'R', 2),
    ('The Lord of the Rings: The Fellowship of the Ring', 'Peter Jackson', 'Adventure', 178, '2001-12-19', 'PG-13', 8),
    ('Saving Private Ryan', 'Steven Spielberg', 'War', 169, '1998-07-24', 'R', 7),
    ('The Green Mile', 'Frank Darabont', 'Crime', 189, '1999-12-10', 'R', 11),
    ('The Godfather: Part II', 'Francis Ford Coppola', 'Crime', 202, '1974-12-20', 'R', 3),
    ('The Dark Knight Rises', 'Christopher Nolan', 'Action', 164, '2012-07-20', 'PG-13', 1),
    ('Django Unchained', 'Quentin Tarantino', 'Western', 165, '2012-12-25', 'R', 10),
    ('The Lord of the Rings: The Two Towers', 'Peter Jackson', 'Adventure', 179, '2002-12-18', 'PG-13', 5),
    ('The Godfather: Part III', 'Francis Ford Coppola', 'Crime', 162, '1990-12-25', 'R', 7),
    ('The Prestige', 'Christopher Nolan', 'Mystery', 130, '2006-10-20', 'PG-13', 2),
    ('Se7en', 'David Fincher', 'Crime', 127, '1995-09-22', 'R', 8),
    ('The Matrix Reloaded', 'Lana Wachowski', 'Sci-Fi', 138, '2003-05-15', 'R', 4),
    ('The Matrix Revolutions', 'Lana Wachowski', 'Sci-Fi', 129, '2003-11-05', 'R', 9),
    ('Jurassic Park', 'Steven Spielberg', 'Adventure', 127, '1993-06-11', 'PG-13', 10),
    ('Titanic', 'James Cameron', 'Drama', 195, '1997-12-19', 'PG-13', 1),
    ('Back to the Future', 'Robert Zemeckis', 'Adventure', 116, '1985-07-03', 'PG', 2),
    ('Raiders of the Lost Ark', 'Steven Spielberg', 'Action', 115, '1981-06-12', 'PG', 3),
    ('The Shining', 'Stanley Kubrick', 'Horror', 144, '1980-05-23', 'R', 4),
    ('Goodfellas', 'Martin Scorsese', 'Crime', 146, '1990-09-21', 'R', 5),
    ('The Sixth Sense', 'M. Night Shyamalan', 'Drama', 107, '1999-08-06', 'PG-13', 11),
    ('The Lion King', 'Roger Allers', 'Animation', 88, '1994-06-24', 'G', 6);

INSERT INTO customer (first_name, last_name, registration_date, birth_date, phone_number)
  SELECT  random_first_name(),
      random_last_name(),
      random_date('2023-01-01', '2023-10-01'),
      random_date('1950-01-01', '2010-12-30'),
      random_phone_number()
  FROM (SELECT generate_series(1, 300)) AS series; 

INSERT INTO cashier (first_name, last_name, start_work_date)
  SELECT random_first_name(),
       random_last_name(),
       random_date('2023-01-01', '2023-10-01')
  FROM  
    (SELECT generate_series(1, 5)) AS series;

INSERT INTO hall_type (hall_type, description)
  VALUES
    ('Standart', 'Standard Hall with regular seating'),
    ('VIP', 'VIP Hall with premium seating and services'),
    ('IMAX', 'IMAX Hall with large screens and advanced sound'),
    ('3D', '3D Hall with immersive 3D technology');

INSERT INTO hall ("name", seat_count, rows_count, vip_seats, disabled_seats)
  VALUES
    ('Hall 1', 150, 15, 10, 5),
    ('Hall 2', 120, 12, 8, 0),
    ('Hall 3', 180, 18, 12, 0),
    ('Hall 4', 60, 10, 20, 0),
    ('Hall 5', 72, 12, 16, 0);

     
INSERT INTO hall_type_relation (hall_id, hall_type)
VALUES
    (1, '3D'),
    (1, 'IMAX'),
    (2, 'VIP'),
  (3, 'Standart'),
    (3, '3D'),
  (4, 'VIP'),
    (4, '3D'),
    (5, 'Standart');
  

WITH movie_sessions AS (
    SELECT
        movie_id,
        random_between(1, 10) AS session_count  -- Random count of sessions (between 1 and 5)
    FROM movie
),
series AS (
    SELECT ms.movie_id, 
     timestamp_series(
       random_timestamp(
        '2023-01-01'::timestamp,
          '2023-10-01'::timestamp
       ),
       ms.session_count,
       '1 day'::interval) AS ts
  FROM movie_sessions ms
)
INSERT INTO film_session(movie_id, start_datetime, hall_id, has_subtitles)
  SELECT
    series.movie_id,
    series.ts,
    random_between(1, (SELECT COUNT(*) FROM hall)),
    random() < 0.2  -- 20% chance of having subtitles
  FROM series;

-- Insert data into the poster table for each movie with unique titles and URLs
INSERT INTO poster (movie_id, title, image_url)
VALUES
    (1, 'The Shawshank Redemption Poster', 'https://example.com/poster_shawshank.jpg'),
    (2, 'The Godfather Poster', 'https://example.com/poster_godfather.jpg'),
    (3, 'The Dark Knight Poster', 'https://example.com/poster_dark_knight.jpg'),
    (4, 'Pulp Fiction Poster', 'https://example.com/poster_pulp_fiction.jpg'),
    (5, 'The Lord of the Rings: The Return of the King Poster', 'https://example.com/poster_lotR_return.jpg'),
    (6, 'Forrest Gump Poster', 'https://example.com/poster_forrest_gump.jpg'),
    (7, 'Inception Poster', 'https://example.com/poster_inception.jpg'),
    (8, 'Fight Club Poster', 'https://example.com/poster_fight_club.jpg'),
    (9, 'The Matrix Poster', 'https://example.com/poster_matrix.jpg'),
    (10, 'The Silence of the Lambs Poster', 'https://example.com/poster_silence_of_lambs.jpg'),
    (11, 'Gladiator Poster', 'https://example.com/poster_gladiator.jpg'),
    (12, 'The Lord of the Rings: The Fellowship of the Ring Poster', 'https://example.com/poster_lotR_fellowship.jpg'),
    (13, 'Saving Private Ryan Poster', 'https://example.com/poster_saving_private_ryan.jpg'),
    (14, 'The Green Mile Poster', 'https://example.com/poster_green_mile.jpg'),
    (15, 'The Godfather: Part II Poster', 'https://example.com/poster_godfather_part_2.jpg'),
    (16, 'The Dark Knight Rises Poster', 'https://example.com/poster_dark_knight_rises.jpg'),
    (17, 'Django Unchained Poster', 'https://example.com/poster_django_unchained.jpg'),
    (18, 'The Lord of the Rings: The Two Towers Poster', 'https://example.com/poster_lotR_two_towers.jpg'),
    (19, 'The Godfather: Part III Poster', 'https://example.com/poster_godfather_part_3.jpg'),
    (20, 'The Prestige Poster', 'https://example.com/poster_prestige.jpg'),
    (21, 'Se7en Poster', 'https://example.com/poster_se7en.jpg'),
    (22, 'The Matrix Reloaded Poster', 'https://example.com/poster_matrix_reloaded.jpg'),
    (23, 'The Matrix Revolutions Poster', 'https://example.com/poster_matrix_revolutions.jpg'),
    (24, 'Jurassic Park Poster', 'https://example.com/poster_jurassic_park.jpg'),
    (25, 'Titanic Poster', 'https://example.com/poster_titanic.jpg'),
    (26, 'Back to the Future Poster', 'https://example.com/poster_back_to_the_future.jpg'),
    (27, 'Raiders of the Lost Ark Poster', 'https://example.com/poster_raiders_of_the_lost_ark.jpg'),
    (28, 'The Shining Poster', 'https://example.com/poster_the_shining.jpg'),
    (29, 'Goodfellas Poster', 'https://example.com/poster_goodfellas.jpg'),
    (30, 'The Sixth Sense Poster', 'https://example.com/poster_sixth_sense.jpg'),
    (31, 'The Lion King Poster', 'https://example.com/poster_lion_king.jpg');

WITH selected_source AS (
	SELECT customer_id,
	      registration_date,
	       random() < 0.5 AS is_bought_from_vendor
	FROM customer
),
replicated_customer_records AS (
	SELECT customer_id,
		   registration_date,
		   generate_series(1, random_between(1, 20)),
		   is_bought_from_vendor
	FROM selected_source
)
INSERT INTO sale(sale_date, cashier_id, vendor_id, customer_id)
	SELECT 
		random_date(registration_date, '2023-10-01'),
        CASE WHEN NOT is_bought_from_vendor THEN random_between(1, (SELECT COUNT(*) FROM cashier))::int ELSE NULL END,
		CASE WHEN is_bought_from_vendor THEN random_between(1, (SELECT COUNT(*) FROM vendor))::int ELSE NULL END,
		customer_id
	FROM replicated_customer_records;


WITH sale_to_session_relation AS (
	SELECT sale_id,
		   (SELECT session_id
		    FROM film_session
		    WHERE start_datetime > sale_date 
		    ORDER BY random() 
		    LIMIT 1)
	FROM sale
),
duplicated_sale_entries AS (
	SELECT sale_id,
	       session_id,
	       generate_series(1, random_between(1, 10))
	FROM sale_to_session_relation
),
ranked_places AS (
    SELECT sale_id,
	       session_id,
	       ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY sale_id) AS place
	FROM duplicated_sale_entries
),
places_on_seats_in_row AS (
	SELECT sale_id,
	       rp.session_id,
		   place,
		   NTILE(seat_count / rows_count) OVER (PARTITION BY fs.session_id) AS seat_in_row
	FROM ranked_places rp 
	JOIN film_session fs ON rp.session_id = fs.session_id
	JOIN hall h on h.hall_id = fs.hall_id
),
places AS (
     SELECT sale_id,
	       session_id,
		   seat_in_row,
	       ROW_NUMBER() OVER (PARTITION BY session_id, seat_in_row ORDER BY place) AS row_number
	FROM places_on_seats_in_row
)
INSERT INTO public.ticket(row_number, seat_number, session_id, price, sale_id)
	SELECT row_number, seat_in_row, session_id, random_between(50, 100), sale_id FROM places;
		
		

WITH customer_spent AS (
   SELECT 
	customer.customer_id,
    customer.registration_date AS issue_date,
    customer.registration_date + '1 year'::interval AS expiry_date,
    (SELECT
	 	SUM(price)
	 FROM ticket
	 LEFT JOIN sale ON ticket.sale_id = sale.sale_id
	 GROUP BY sale.customer_id
	 HAVING sale.customer_id = customer.customer_id
	) AS spent
  FROM customer
)
INSERT INTO public.loyalty_card(issue_date, expiry_date, total_spent, bonus_balance, customer_id)
	SELECT issue_date, expiry_date, spent, spent * random(), customer_id FROM customer_spent;
 