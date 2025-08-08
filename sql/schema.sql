--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: star; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA star;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_app; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_app (
    app_id integer NOT NULL,
    app_package text NOT NULL,
    app_name text NOT NULL,
    description text,
    price_clean numeric(10,2),
    price_type text NOT NULL,
    price_range text,
    avg_rating numeric(3,2),
    app_age_days integer,
    developer_id integer NOT NULL,
    category_id integer NOT NULL,
    content_rating_id integer NOT NULL,
    CONSTRAINT dim_app_app_age_days_check CHECK ((app_age_days >= 0)),
    CONSTRAINT dim_app_avg_rating_check CHECK (((avg_rating >= (0)::numeric) AND (avg_rating <= (5)::numeric))),
    CONSTRAINT dim_app_check CHECK ((((price_type = 'Free'::text) AND (price_clean = (0)::numeric)) OR ((price_type = 'Paid'::text) AND (price_clean > (0)::numeric)))),
    CONSTRAINT dim_app_price_clean_check CHECK ((price_clean >= (0)::numeric))
);


--
-- Name: dim_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_category (
    category_id integer NOT NULL,
    app_category text NOT NULL
);


--
-- Name: dim_content_rating; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_content_rating (
    content_rating_id integer NOT NULL,
    content_rating text NOT NULL
);


--
-- Name: dim_developer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_developer (
    developer_id integer NOT NULL,
    developer_name text NOT NULL
);


--
-- Name: dim_language; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_language (
    language_id integer NOT NULL,
    review_lang text NOT NULL,
    language_name text NOT NULL
);


--
-- Name: dim_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_user (
    user_id integer NOT NULL,
    uid text NOT NULL
);


--
-- Name: fact_interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fact_interactions (
    interaction_id integer NOT NULL,
    user_id integer NOT NULL,
    app_id integer NOT NULL,
    language_id integer NOT NULL,
    rating smallint NOT NULL,
    votes integer,
    review_length integer,
    review_date date NOT NULL,
    CONSTRAINT fact_interactions_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
    CONSTRAINT fact_interactions_votes_check CHECK ((votes >= 0))
);


--
-- Name: dim_app dim_app_app_package_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_app
    ADD CONSTRAINT dim_app_app_package_key UNIQUE (app_package);


--
-- Name: dim_app dim_app_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_app
    ADD CONSTRAINT dim_app_pkey PRIMARY KEY (app_id);


--
-- Name: dim_category dim_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_category
    ADD CONSTRAINT dim_category_pkey PRIMARY KEY (category_id);


--
-- Name: dim_content_rating dim_content_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_content_rating
    ADD CONSTRAINT dim_content_rating_pkey PRIMARY KEY (content_rating_id);


--
-- Name: dim_developer dim_developer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_developer
    ADD CONSTRAINT dim_developer_pkey PRIMARY KEY (developer_id);


--
-- Name: dim_language dim_language_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_language
    ADD CONSTRAINT dim_language_pkey PRIMARY KEY (language_id);


--
-- Name: dim_language dim_language_review_lang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_language
    ADD CONSTRAINT dim_language_review_lang_key UNIQUE (review_lang);


--
-- Name: dim_user dim_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_user
    ADD CONSTRAINT dim_user_pkey PRIMARY KEY (user_id);


--
-- Name: dim_user dim_user_uid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_user
    ADD CONSTRAINT dim_user_uid_key UNIQUE (uid);


--
-- Name: fact_interactions fact_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_interactions
    ADD CONSTRAINT fact_interactions_pkey PRIMARY KEY (interaction_id);


--
-- Name: dim_app dim_app_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_app
    ADD CONSTRAINT dim_app_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.dim_category(category_id);


--
-- Name: dim_app dim_app_content_rating_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_app
    ADD CONSTRAINT dim_app_content_rating_id_fkey FOREIGN KEY (content_rating_id) REFERENCES public.dim_content_rating(content_rating_id);


--
-- Name: dim_app dim_app_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_app
    ADD CONSTRAINT dim_app_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.dim_developer(developer_id);


--
-- Name: fact_interactions fact_interactions_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_interactions
    ADD CONSTRAINT fact_interactions_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.dim_app(app_id);


--
-- Name: fact_interactions fact_interactions_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_interactions
    ADD CONSTRAINT fact_interactions_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.dim_language(language_id);


--
-- Name: fact_interactions fact_interactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_interactions
    ADD CONSTRAINT fact_interactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.dim_user(user_id);


--
-- PostgreSQL database dump complete
--

