SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: age_rating_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.age_rating_type AS ENUM (
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17'
);


--
-- Name: email_type; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.email_type AS character varying(100)
        CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '/^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/'::text));


--
-- Name: http_url_type; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.http_url_type AS character varying(255)
        CONSTRAINT http_url_type_check CHECK (((VALUE)::text ~ 'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,254}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'::text));


--
-- Name: phone_number_type; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.phone_number_type AS character varying(20)
        CONSTRAINT phone_number_type_check CHECK (((VALUE)::text ~ '^(\+\d{1,2}\s)?(\d{3}[\s.-]?){2}\d{4}$'::text));


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cashier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cashier (
    cashier_id integer NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(50) NOT NULL,
    start_work_date date DEFAULT now(),
    CONSTRAINT cashier_first_name_check CHECK ((TRIM(BOTH FROM first_name) <> ''::text)),
    CONSTRAINT cashier_last_name_check CHECK ((TRIM(BOTH FROM last_name) <> ''::text)),
    CONSTRAINT cashier_start_work_date_check CHECK ((start_work_date <= now()))
);


--
-- Name: cashier_cashier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cashier_cashier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cashier_cashier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cashier_cashier_id_seq OWNED BY public.cashier.cashier_id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    registration_date date DEFAULT now(),
    birth_date date,
    phone_number public.phone_number_type,
    CONSTRAINT customer_birth_date_check CHECK ((birth_date <= now())),
    CONSTRAINT customer_first_name_check CHECK ((TRIM(BOTH FROM first_name) <> ''::text)),
    CONSTRAINT customer_last_name_check CHECK ((TRIM(BOTH FROM last_name) <> ''::text)),
    CONSTRAINT customer_registration_date_check CHECK ((registration_date <= now()))
);


--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_customer_id_seq OWNED BY public.customer.customer_id;


--
-- Name: distributor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributor (
    distributor_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    address character varying(255),
    phone_number public.phone_number_type,
    email public.email_type,
    country character varying(30),
    CONSTRAINT distributor_address_check CHECK ((TRIM(BOTH FROM address) <> ''::text)),
    CONSTRAINT distributor_company_name_check CHECK ((TRIM(BOTH FROM company_name) <> ''::text)),
    CONSTRAINT distributor_country_check CHECK ((TRIM(BOTH FROM country) <> ''::text))
);


--
-- Name: distributor_distributor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_distributor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distributor_distributor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_distributor_id_seq OWNED BY public.distributor.distributor_id;


--
-- Name: film_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.film_session (
    session_id integer NOT NULL,
    movie_id integer NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    hall_id integer NOT NULL,
    has_subtitles boolean DEFAULT false
);


--
-- Name: film_session_session_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.film_session_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: film_session_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.film_session_session_id_seq OWNED BY public.film_session.session_id;


--
-- Name: hall; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hall (
    hall_id integer NOT NULL,
    name character varying(10) NOT NULL,
    seat_count integer NOT NULL,
    rows_count integer NOT NULL,
    vip_seats integer DEFAULT 0,
    disabled_seats integer DEFAULT 0,
    CONSTRAINT hall_disabled_seats_check CHECK ((disabled_seats >= 0)),
    CONSTRAINT hall_name_check CHECK ((TRIM(BOTH FROM name) <> ''::text)),
    CONSTRAINT hall_rows_count_check CHECK ((rows_count > 0)),
    CONSTRAINT hall_seat_count_check CHECK ((seat_count > 0)),
    CONSTRAINT hall_vip_seats_check CHECK ((vip_seats >= 0))
);


--
-- Name: hall_hall_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hall_hall_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hall_hall_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hall_hall_id_seq OWNED BY public.hall.hall_id;


--
-- Name: hall_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hall_type (
    hall_type character varying(10) NOT NULL,
    description text

...skipping 1 line


--
-- Name: hall_type_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hall_type_relation (
    hall_id integer NOT NULL,
    hall_type character varying(10) NOT NULL
);


--
-- Name: loyalty_card; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loyalty_card (
    card_id integer NOT NULL,
    issue_date date DEFAULT now(),
    expiry_date date NOT NULL,
    total_spent numeric(10,2) DEFAULT 0,
    bonus_balance numeric(10,2) DEFAULT 0,
    customer_id integer NOT NULL,
    CONSTRAINT loyalty_card_bonus_balance_check CHECK ((bonus_balance > (0)::numeric)),
    CONSTRAINT loyalty_card_expiry_date_check CHECK ((expiry_date < now())),
    CONSTRAINT loyalty_card_total_spent_check CHECK ((total_spent > (0)::numeric))
);


--
-- Name: loyalty_card_card_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.loyalty_card_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: loyalty_card_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

...skipping 1 line

ALTER SEQUENCE public.loyalty_card_card_id_seq OWNED BY public.loyalty_card.card_id;


--
-- Name: movie; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movie (
    movie_id integer NOT NULL,
    title character varying(255) NOT NULL,
    director character varying(255),
    genre character varying(255),
    duration integer NOT NULL,
    release_date date,
    age_rating public.age_rating_type,
    distributor_id integer NOT NULL,
    CONSTRAINT movie_director_check CHECK ((TRIM(BOTH FROM director) <> ''::text)),
    CONSTRAINT movie_duration_check CHECK ((duration > 0)),
    CONSTRAINT movie_genre_check CHECK ((TRIM(BOTH FROM genre) <> ''::text)),
    CONSTRAINT movie_title_check CHECK ((TRIM(BOTH FROM title) <> ''::text))
);


--
-- Name: movie_movie_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movie_movie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movie_movie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movie_movie_id_seq OWNED BY public.movie.movie_id;



...skipping 1 line
-- Name: poster; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poster (
    poster_id integer NOT NULL,
    movie_id integer NOT NULL,
    title character varying(255),
    image_url public.http_url_type NOT NULL,
    CONSTRAINT poster_title_check CHECK ((TRIM(BOTH FROM title) <> ''::text))
);


--
-- Name: poster_poster_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.poster_poster_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: poster_poster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poster_poster_id_seq OWNED BY public.poster.poster_id;


--
-- Name: rating; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rating (
    movie_id integer NOT NULL,
    stars integer,
    date date DEFAULT now(),
    customer_id integer NOT NULL,
    comment_text text,
    CONSTRAINT rating_stars_check CHECK (((stars >= 0) AND (stars <= 5)))
);

...skipping 1 line

--
-- Name: sale; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sale (
    sale_id integer NOT NULL,
    sale_date date DEFAULT now(),
    cashier_id integer,
    vendor_id integer,
    customer_id integer NOT NULL,
    CONSTRAINT sale_check CHECK (((cashier_id IS NOT NULL) OR ((vendor_id IS NOT NULL) AND (NOT ((cashier_id IS NOT NULL) AND (vendor_id IS NOT NULL)))))),
    CONSTRAINT sale_sale_date_check CHECK ((sale_date <= now()))
);


--
-- Name: sale_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sale_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sale_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sale_sale_id_seq OWNED BY public.sale.sale_id;


--
-- Name: ticket; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ticket (
    ticket_id integer NOT NULL,
    row_number integer NOT NULL,
    seat_number integer NOT NULL,

...skipping 1 line
    price numeric(10,2) NOT NULL,
    sale_id integer NOT NULL
);


--
-- Name: ticket_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ticket_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ticket_ticket_id_seq OWNED BY public.ticket.ticket_id;


--
-- Name: vendor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendor (
    vendor_id integer NOT NULL,
    name character varying(30),
    url public.http_url_type,
    CONSTRAINT vendor_name_check CHECK ((TRIM(BOTH FROM name) <> ''::text))
);


--
-- Name: vendor_vendor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendor_vendor_id_seq
    AS integer
    START WITH 1

...skipping 1 line
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendor_vendor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendor_vendor_id_seq OWNED BY public.vendor.vendor_id;


--
-- Name: cashier cashier_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cashier ALTER COLUMN cashier_id SET DEFAULT nextval('public.cashier_cashier_id_seq'::regclass);


--
-- Name: customer customer_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_customer_id_seq'::regclass);


--
-- Name: distributor distributor_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor ALTER COLUMN distributor_id SET DEFAULT nextval('public.distributor_distributor_id_seq'::regclass);


--
-- Name: film_session session_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.film_session ALTER COLUMN session_id SET DEFAULT nextval('public.film_session_session_id_seq'::regclass);


--
-- Name: hall hall_id; Type: DEFAULT; Schema: public; Owner: -
--


...skipping 1 line


--
-- Name: loyalty_card card_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loyalty_card ALTER COLUMN card_id SET DEFAULT nextval('public.loyalty_card_card_id_seq'::regclass);


--
-- Name: movie movie_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movie ALTER COLUMN movie_id SET DEFAULT nextval('public.movie_movie_id_seq'::regclass);


--
-- Name: poster poster_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poster ALTER COLUMN poster_id SET DEFAULT nextval('public.poster_poster_id_seq'::regclass);


--
-- Name: sale sale_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale ALTER COLUMN sale_id SET DEFAULT nextval('public.sale_sale_id_seq'::regclass);


--
-- Name: ticket ticket_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_id SET DEFAULT nextval('public.ticket_ticket_id_seq'::regclass);


--
-- Name: vendor vendor_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor ALTER COLUMN vendor_id SET DEFAULT nextval('public.vendor_vendor_id_seq'::regclass);



...skipping 1 line
-- Name: cashier cashier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cashier
    ADD CONSTRAINT cashier_pkey PRIMARY KEY (cashier_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: distributor distributor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor
    ADD CONSTRAINT distributor_pkey PRIMARY KEY (distributor_id);


--
-- Name: film_session film_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.film_session
    ADD CONSTRAINT film_session_pkey PRIMARY KEY (session_id);


--
-- Name: hall hall_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hall
    ADD CONSTRAINT hall_pkey PRIMARY KEY (hall_id);


--
-- Name: hall_type hall_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hall_type

...skipping 1 line


--
-- Name: hall_type_relation hall_type_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hall_type_relation
    ADD CONSTRAINT hall_type_relation_pkey PRIMARY KEY (hall_id, hall_type);


--
-- Name: loyalty_card loyalty_card_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loyalty_card
    ADD CONSTRAINT loyalty_card_pkey PRIMARY KEY (card_id);


--
-- Name: movie movie_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movie
    ADD CONSTRAINT movie_pkey PRIMARY KEY (movie_id);


--
-- Name: poster poster_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poster
    ADD CONSTRAINT poster_pkey PRIMARY KEY (poster_id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (customer_id, movie_id);


--
-- Name: sale sale_pkey; Type: CONSTRAINT; Schema: public; Owner: -

...skipping 1 line

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_pkey PRIMARY KEY (sale_id);


--
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (ticket_id);


--
-- Name: vendor vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor
    ADD CONSTRAINT vendor_pkey PRIMARY KEY (vendor_id);


--
-- Name: film_session film_session_hall_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.film_session
    ADD CONSTRAINT film_session_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES public.hall(hall_id);


--
-- Name: film_session film_session_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.film_session
    ADD CONSTRAINT film_session_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movie(movie_id);


--
-- Name: hall_type_relation hall_type_relation_hall_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hall_type_relation
    ADD CONSTRAINT hall_type_relation_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES public.hall(hall_id);


...skipping 1 line
--
-- Name: hall_type_relation hall_type_relation_hall_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hall_type_relation
    ADD CONSTRAINT hall_type_relation_hall_type_fkey FOREIGN KEY (hall_type) REFERENCES public.hall_type(hall_type);


--
-- Name: loyalty_card loyalty_card_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loyalty_card
    ADD CONSTRAINT loyalty_card_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: movie movie_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movie
    ADD CONSTRAINT movie_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributor(distributor_id);


--
-- Name: poster poster_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poster
    ADD CONSTRAINT poster_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movie(movie_id);


--
-- Name: rating rating_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: rating rating_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--


...skipping 1 line
    ADD CONSTRAINT rating_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movie(movie_id);


--
-- Name: sale sale_cashier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.cashier(cashier_id);


--
-- Name: sale sale_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: sale sale_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendor(vendor_id);


--
-- Name: ticket ticket_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sale(sale_id);


--
-- Name: ticket ticket_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.film_session(session_id);