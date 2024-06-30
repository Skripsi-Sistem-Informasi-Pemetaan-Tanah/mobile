--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

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
-- Name: copy_to_verifikasi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.copy_to_verifikasi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Insert a new row into the verifikasi table with the current timestamp for updated_at
  INSERT INTO public.verifikasi (map_id, user_id, nama_lahan, status, progress, komentar, updated_at, created_at)
  VALUES (NEW.map_id, NEW.user_id, NEW.nama_lahan, NEW.status, NEW.progress, NEW.komentar, NOW(), NEW.created_at);

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.copy_to_verifikasi() OWNER TO postgres;

--
-- Name: log_koordinat_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_koordinat_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Insert the old and new coordinates into history table
    INSERT INTO history (map_id, old_coordinate, new_coordinate, status, updated_at)
    VALUES (
        NEW.map_id,
        CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE OLD.koordinat::TEXT END,
        NEW.koordinat::TEXT,
        NEW.status,
        NEW.updated_at
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_koordinat_changes() OWNER TO postgres;

--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.history (
    history_id integer NOT NULL,
    map_id character varying(255) NOT NULL,
    old_coordinate text,
    new_coordinate text,
    status character(25) DEFAULT 'belum tervalidasi'::bpchar,
    updated_at timestamp with time zone
);


ALTER TABLE public.history OWNER TO postgres;

--
-- Name: history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.history_history_id_seq OWNER TO postgres;

--
-- Name: history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.history_history_id_seq OWNED BY public.history.history_id;


--
-- Name: koordinat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.koordinat (
    koordinat_id integer NOT NULL,
    koordinat double precision[],
    status integer DEFAULT 0,
    image character(255),
    map_id character varying(255) NOT NULL,
    updated_at timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.koordinat OWNER TO postgres;

--
-- Name: koordinat_koordinat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.koordinat_koordinat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.koordinat_koordinat_id_seq OWNER TO postgres;

--
-- Name: koordinat_koordinat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.koordinat_koordinat_id_seq OWNED BY public.koordinat.koordinat_id;


--
-- Name: maps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maps (
    map_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    nama_lahan character(30),
    status character(25) DEFAULT 'belum tervalidasi'::bpchar,
    progress integer DEFAULT 0,
    updated_at timestamp with time zone,
    created_at timestamp with time zone,
    koordinat jsonb,
    komentar text
);


ALTER TABLE public.maps OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id character varying(255) NOT NULL,
    username character varying(255),
    nama_lengkap character varying(255),
    email character varying(255),
    password character varying(255),
    role integer DEFAULT 1,
    refresh_token text,
    updated_at timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: verifikasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verifikasi (
    verifikasi_id integer NOT NULL,
    map_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    nama_lahan character(30),
    status character(25) DEFAULT 'belum tervalidasi'::bpchar,
    progress integer DEFAULT 0,
    komentar character(100),
    updated_at timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.verifikasi OWNER TO postgres;

--
-- Name: verifikasi_verifikasi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.verifikasi_verifikasi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.verifikasi_verifikasi_id_seq OWNER TO postgres;

--
-- Name: verifikasi_verifikasi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.verifikasi_verifikasi_id_seq OWNED BY public.verifikasi.verifikasi_id;


--
-- Name: history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history ALTER COLUMN history_id SET DEFAULT nextval('public.history_history_id_seq'::regclass);


--
-- Name: koordinat koordinat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.koordinat ALTER COLUMN koordinat_id SET DEFAULT nextval('public.koordinat_koordinat_id_seq'::regclass);


--
-- Name: verifikasi verifikasi_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verifikasi ALTER COLUMN verifikasi_id SET DEFAULT nextval('public.verifikasi_verifikasi_id_seq'::regclass);


--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.history (history_id, map_id, old_coordinate, new_coordinate, status, updated_at) FROM stdin;
34	CxO9DOGXslEwynB1NSH6	\N	{-6.885765,109.6810267}	0                        	2024-06-07 01:05:55.216+07
35	mRnVDonV9CjPKzl4UPkk	\N	{-6.885765,109.6810267}	0                        	2024-06-07 01:11:14.382+07
36	RFHmkHdGB2Gy06BF11To	\N	{-6.885765,109.6810267}	0                        	2024-06-08 21:52:04.878+07
37	PRQt7ufl8yKLDCPmks2n	\N	{-6.885765,109.6810267}	0                        	2024-06-08 23:08:39.707+07
\.


--
-- Data for Name: koordinat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.koordinat (koordinat_id, koordinat, status, image, map_id, updated_at, created_at) FROM stdin;
48	{-6.885765,109.6810267}	0	https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2F069c61c6-9c05-43b3-9aed-1cd03edc837b4970334687267489971.jpg?alt=media&token=aee91f62-75ec-422f-84af-49c1eccf2616                                                   	CxO9DOGXslEwynB1NSH6	2024-06-07 01:05:55.232549+07	2024-06-07 01:05:55.216+07
50	{-6.885765,109.6810267}	0	https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2Ff2798610-ece1-4168-83b7-e3debffc6d972964353422661482950.jpg?alt=media&token=4a739ea0-fdaf-4d25-8211-35be6d382ab6                                                   	mRnVDonV9CjPKzl4UPkk	2024-06-07 01:11:14.403463+07	2024-06-07 01:11:14.382+07
52	{-6.885765,109.6810267}	0	                                                                                                                                                                                                                                                               	RFHmkHdGB2Gy06BF11To	2024-06-08 21:52:04.94629+07	2024-06-08 21:52:04.878+07
56	{-6.885765,109.6810267}	0	                                                                                                                                                                                                                                                               	PRQt7ufl8yKLDCPmks2n	2024-06-08 23:08:39.732602+07	2024-06-08 23:08:39.707+07
\.


--
-- Data for Name: maps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maps (map_id, user_id, nama_lahan, status, progress, updated_at, created_at, koordinat, komentar) FROM stdin;
CxO9DOGXslEwynB1NSH6	8gEDwHnA4tMtRei31eU1amm39Ll1	Lahan Padi                    	sudah tervalidasi        	100	2024-06-07 01:18:14.07322+07	2024-06-07 01:05:55.216+07	[{"local_path": "", "coordinates": "-6.885765, 109.6810267", "foto_patokan": ""}, {"local_path": "/data/user/0/com.example.dipetakan/cache/069c61c6-9c05-43b3-9aed-1cd03edc837b4970334687267489971.jpg", "coordinates": "-6.885765, 109.6810267", "foto_patokan": "https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2F069c61c6-9c05-43b3-9aed-1cd03edc837b4970334687267489971.jpg?alt=media&token=aee91f62-75ec-422f-84af-49c1eccf2616"}]	\N
mRnVDonV9CjPKzl4UPkk	8gEDwHnA4tMtRei31eU1amm39Ll1	Lahan Cabai                   	sudah tervalidasi        	100	2024-06-07 19:05:28.238537+07	2024-06-07 01:11:14.382+07	[{"local_path": "/data/user/0/com.example.dipetakan/cache/39faed24-511b-45e2-b4cf-15b78acecc221326191709475067429.jpg", "coordinates": "-6.885765, 109.6810267", "foto_patokan": "https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2F39faed24-511b-45e2-b4cf-15b78acecc221326191709475067429.jpg?alt=media&token=7f9832f7-0913-418a-9080-76c993d0aa82"}, {"local_path": "/data/user/0/com.example.dipetakan/cache/f2798610-ece1-4168-83b7-e3debffc6d972964353422661482950.jpg", "coordinates": "-6.885765, 109.6810267", "foto_patokan": "https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2Ff2798610-ece1-4168-83b7-e3debffc6d972964353422661482950.jpg?alt=media&token=4a739ea0-fdaf-4d25-8211-35be6d382ab6"}]	\N
RFHmkHdGB2Gy06BF11To	OAG8mCZoGWgVNWqalmQ2FKEfIpw2	Padi                          	belum tervalidasi        	0	2024-06-08 21:59:34.954463+07	2024-06-08 21:52:04.878+07	[{"local_path": "/data/user/0/com.example.dipetakan/cache/8fa6280d-9729-4aca-938c-129daf0242c03455270191142097593.jpg", "coordinates": "-6.885293, 109.680546", "foto_patokan": "https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2F8fa6280d-9729-4aca-938c-129daf0242c03455270191142097593.jpg?alt=media&token=513c3ccf-4419-47c3-856c-77be659cc14f"}, {"local_path": "", "coordinates": "-6.885351, 109.680754", "foto_patokan": ""}, {"local_path": "/data/user/0/com.example.dipetakan/cache/462db4bc-5775-4fb9-8f25-a60b134c854f353198929362067717.jpg", "coordinates": "-6.885668, 109.680717", "foto_patokan": "https://firebasestorage.googleapis.com/v0/b/dipetakan-57d6b.appspot.com/o/Lahan%2FPatokan%2F462db4bc-5775-4fb9-8f25-a60b134c854f353198929362067717.jpg?alt=media&token=260df718-96ab-4e28-8d2b-b5bc17a28d4e"}, {"local_path": "", "coordinates": "-6.885664, 109.680526", "foto_patokan": ""}]	\N
PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai                         	sudah tervalidasi        	100	2024-06-09 13:45:33.039403+07	2024-06-08 23:08:39.707+07	[{"local_path": "", "coordinates": "-6.885673, 109.680527", "foto_patokan": ""}, {"local_path": "", "coordinates": "-6.885671, 109.680624", "foto_patokan": ""}, {"local_path": "", "coordinates": "-6.885944, 109.680630", "foto_patokan": ""}, {"local_path": "", "coordinates": "-6.885946, 109.680517", "foto_patokan": ""}]	Peta lahan dapat dilihat
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, nama_lengkap, email, password, role, refresh_token, updated_at, created_at) FROM stdin;
8gEDwHnA4tMtRei31eU1amm39Ll1	zizizi	Asru	asriaziziyah123@gmail.com	\N	2	\N	2024-06-07 00:50:01.183+07	2024-06-07 00:50:01.183+07
OAG8mCZoGWgVNWqalmQ2FKEfIpw2	aziziyah	Asri Aziziyah	asriaziziyah@student.uns.ac.id	\N	2	\N	2024-06-08 21:44:26.337+07	2024-06-08 21:44:26.337+07
\.


--
-- Data for Name: verifikasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verifikasi (verifikasi_id, map_id, user_id, nama_lahan, status, progress, komentar, updated_at, created_at) FROM stdin;
36	mRnVDonV9CjPKzl4UPkk	8gEDwHnA4tMtRei31eU1amm39Ll1	Lahan Cabai                   	belum tervalidasi        	0	\N	2024-06-07 01:11:14.382+07	2024-06-07 01:11:14.382+07
35	CxO9DOGXslEwynB1NSH6	8gEDwHnA4tMtRei31eU1amm39Ll1	Lahan Padi                    	sudah tervalidasi        	100	\N	2024-06-07 01:18:14.07322+07	2024-06-07 01:05:55.216+07
39	mRnVDonV9CjPKzl4UPkk	8gEDwHnA4tMtRei31eU1amm39Ll1	Lahan Cabai                   	sudah tervalidasi        	100	\N	2024-06-07 19:05:28.238537+07	2024-06-07 01:11:14.382+07
40	RFHmkHdGB2Gy06BF11To	OAG8mCZoGWgVNWqalmQ2FKEfIpw2	Padi                          	belum tervalidasi        	0	\N	2024-06-08 21:52:04.880342+07	2024-06-08 21:52:04.878+07
41	RFHmkHdGB2Gy06BF11To	OAG8mCZoGWgVNWqalmQ2FKEfIpw2	Padi                          	belum tervalidasi        	0	\N	2024-06-08 21:59:34.954463+07	2024-06-08 21:52:04.878+07
42	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai                         	belum tervalidasi        	0	\N	2024-06-08 23:08:39.708511+07	2024-06-08 23:08:39.707+07
43	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai                         	belum tervalidasi        	0	\N	2024-06-09 00:07:35.838941+07	2024-06-08 23:08:39.707+07
44	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai Hijau                   	belum tervalidasi        	0	\N	2024-06-09 01:11:04.50949+07	2024-06-08 23:08:39.707+07
45	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai Hijau                   	belum tervalidasi        	0	\N	2024-06-09 12:45:47.574133+07	2024-06-08 23:08:39.707+07
46	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai Hijau                   	sudah tervalidasi        	100	\N	2024-06-09 13:06:43.76104+07	2024-06-08 23:08:39.707+07
47	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai Hijau                   	belum tervalidasi        	0	\N	2024-06-09 13:10:09.246855+07	2024-06-08 23:08:39.707+07
48	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai Hijau                   	belum tervalidasi        	0	\N	2024-06-09 13:12:22.724409+07	2024-06-08 23:08:39.707+07
49	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai Hijau                   	sudah tervalidasi        	100	\N	2024-06-09 13:31:20.628204+07	2024-06-08 23:08:39.707+07
50	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai                         	sudah tervalidasi        	100	\N	2024-06-09 13:36:23.184802+07	2024-06-08 23:08:39.707+07
51	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai                         	belum tervalidasi        	0	foto patokan tidak ada                                                                              	2024-06-09 13:39:38.886914+07	2024-06-08 23:08:39.707+07
52	PRQt7ufl8yKLDCPmks2n	8gEDwHnA4tMtRei31eU1amm39Ll1	Cabai                         	sudah tervalidasi        	100	Peta lahan dapat dilihat                                                                            	2024-06-09 13:45:33.039403+07	2024-06-08 23:08:39.707+07
\.


--
-- Name: history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.history_history_id_seq', 37, true);


--
-- Name: koordinat_koordinat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.koordinat_koordinat_id_seq', 59, true);


--
-- Name: verifikasi_verifikasi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.verifikasi_verifikasi_id_seq', 52, true);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (history_id);


--
-- Name: koordinat koordinat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.koordinat
    ADD CONSTRAINT koordinat_pkey PRIMARY KEY (koordinat_id);


--
-- Name: maps maps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maps
    ADD CONSTRAINT maps_pkey PRIMARY KEY (map_id);


--
-- Name: koordinat unique_map_koordinat; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.koordinat
    ADD CONSTRAINT unique_map_koordinat UNIQUE (map_id, koordinat);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: verifikasi verifikasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verifikasi
    ADD CONSTRAINT verifikasi_pkey PRIMARY KEY (verifikasi_id);


--
-- Name: koordinat after_koordinat_insert_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_koordinat_insert_update AFTER INSERT OR UPDATE OF koordinat ON public.koordinat FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.log_koordinat_changes();


--
-- Name: maps after_maps_insert_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_maps_insert_update AFTER INSERT OR UPDATE OF komentar ON public.maps FOR EACH ROW EXECUTE FUNCTION public.copy_to_verifikasi();


--
-- Name: koordinat update_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at_trigger BEFORE UPDATE ON public.koordinat FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: maps update_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at_trigger BEFORE UPDATE ON public.maps FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: users update_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at_trigger BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: history history_map_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_map_id_fkey FOREIGN KEY (map_id) REFERENCES public.maps(map_id);


--
-- Name: koordinat koordinat_map_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.koordinat
    ADD CONSTRAINT koordinat_map_id_fkey FOREIGN KEY (map_id) REFERENCES public.maps(map_id);


--
-- Name: maps maps_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maps
    ADD CONSTRAINT maps_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: verifikasi verifikasi_map_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verifikasi
    ADD CONSTRAINT verifikasi_map_id_fkey FOREIGN KEY (map_id) REFERENCES public.maps(map_id);


--
-- Name: verifikasi verifikasi_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verifikasi
    ADD CONSTRAINT verifikasi_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

