--
-- PostgreSQL database dump
--

-- Dumped from database version 15.12
-- Dumped by pg_dump version 15.12

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
-- Name: aborozi; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA aborozi;


ALTER SCHEMA aborozi OWNER TO postgres;

--
-- Name: amatungo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA amatungo;


ALTER SCHEMA amatungo OWNER TO postgres;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: abashumba; Type: TABLE; Schema: aborozi; Owner: postgres
--

CREATE TABLE aborozi.abashumba (
    abshuui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    izina_ryababyeyi character varying(255),
    izina_rindi character varying(255),
    igitsina character varying(255),
    irangamimerere character varying(255),
    nid character varying(255),
    tel1 character varying(255),
    tel2 character varying(255),
    icyo_akora character varying(255),
    icyo_ashinzwe character varying(255),
    ahoatuye character varying(255),
    ifoto_url character varying,
    amasezerano_url text[],
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE aborozi.abashumba OWNER TO postgres;

--
-- Name: abashumba_id_seq; Type: SEQUENCE; Schema: aborozi; Owner: postgres
--

CREATE SEQUENCE aborozi.abashumba_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aborozi.abashumba_id_seq OWNER TO postgres;

--
-- Name: abashumba_id_seq; Type: SEQUENCE OWNED BY; Schema: aborozi; Owner: postgres
--

ALTER SEQUENCE aborozi.abashumba_id_seq OWNED BY aborozi.abashumba.id;


--
-- Name: icyiciro; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.icyiciro (
    icyuui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    izina character varying(255) NOT NULL,
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.icyiciro OWNER TO postgres;

--
-- Name: icyiciro_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.icyiciro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.icyiciro_id_seq OWNER TO postgres;

--
-- Name: icyiciro_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.icyiciro_id_seq OWNED BY amatungo.icyiciro.id;


--
-- Name: imyororokere; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.imyororokere (
    imyruui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    imyruui_icyuui uuid NOT NULL,
    imyakayokororoka integer NOT NULL,
    ameziibyarira integer NOT NULL,
    ubwokobwitungo character varying(255) NOT NULL,
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.imyororokere OWNER TO postgres;

--
-- Name: imyororokere_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.imyororokere_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.imyororokere_id_seq OWNER TO postgres;

--
-- Name: imyororokere_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.imyororokere_id_seq OWNED BY amatungo.imyororokere.id;


--
-- Name: isokoryaryo; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.isokoryaryo (
    iskuui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    isoko character varying(255),
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.isokoryaryo OWNER TO postgres;

--
-- Name: isokoryaryo_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.isokoryaryo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.isokoryaryo_id_seq OWNER TO postgres;

--
-- Name: isokoryaryo_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.isokoryaryo_id_seq OWNED BY amatungo.isokoryaryo.id;


--
-- Name: itungo; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.itungo (
    itunguui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    itunguui_imyruui uuid NOT NULL,
    igitsina character varying(255),
    ifoto_url character varying(255),
    ubukure double precision,
    itngcode character varying(255),
    ibara character varying(100),
    ibiro character varying(100),
    ahoryavuye character varying(255),
    igihe timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.itungo OWNER TO postgres;

--
-- Name: itungo_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.itungo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.itungo_id_seq OWNER TO postgres;

--
-- Name: itungo_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.itungo_id_seq OWNED BY amatungo.itungo.id;


--
-- Name: itungo_isokoryaryo; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.itungo_isokoryaryo (
    id integer NOT NULL,
    itunguui uuid NOT NULL,
    iskuui uuid NOT NULL,
    seqno integer DEFAULT 1,
    amafaranga_yarigiyeho character varying(255),
    amafaranga_ryagurishijwe character varying(255),
    amafaranga_rihagaze character varying(255),
    ibisobanuro character varying(255),
    itariki_byabereyeho date,
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.itungo_isokoryaryo OWNER TO postgres;

--
-- Name: itungo_isokoryaryo_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.itungo_isokoryaryo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.itungo_isokoryaryo_id_seq OWNER TO postgres;

--
-- Name: itungo_isokoryaryo_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.itungo_isokoryaryo_id_seq OWNED BY amatungo.itungo_isokoryaryo.id;


--
-- Name: itungo_ubuzimabwaryo; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.itungo_ubuzimabwaryo (
    id integer NOT NULL,
    itunguui uuid NOT NULL,
    uzmuui uuid NOT NULL,
    seqno integer DEFAULT 1,
    amafaranga_yarigiyeho character varying(255),
    amafaranga_ryinjije character varying(255),
    dokima_url character varying(255),
    ibisobanuro character varying(255),
    itariki_byabereyeho date,
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.itungo_ubuzimabwaryo OWNER TO postgres;

--
-- Name: itungo_ubuzimabwaryo_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.itungo_ubuzimabwaryo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.itungo_ubuzimabwaryo_id_seq OWNER TO postgres;

--
-- Name: itungo_ubuzimabwaryo_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.itungo_ubuzimabwaryo_id_seq OWNED BY amatungo.itungo_ubuzimabwaryo.id;


--
-- Name: itungo_ukozororoka_abashumba; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.itungo_ukozororoka_abashumba (
    id integer NOT NULL,
    itunguui uuid NOT NULL,
    ukozruui uuid NOT NULL,
    abshuui_uhagariy uuid,
    abshuui_umworoz uuid,
    seqno integer DEFAULT 1,
    incuro_ibyaye integer,
    amezi_rihaka double precision,
    itariki_ryimiye date,
    itariki_ribyariye date,
    itariki_ariherewe date,
    itariki_aryakiwe date,
    riraragijwe_yo character varying(25) DEFAULT 'OYA'::character varying,
    igitsina_cyavutse character varying(255),
    igihe timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    itariki_rivukiye date
);


ALTER TABLE amatungo.itungo_ukozororoka_abashumba OWNER TO postgres;

--
-- Name: itungo_ukozororoka_abashumba_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.itungo_ukozororoka_abashumba_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.itungo_ukozororoka_abashumba_id_seq OWNER TO postgres;

--
-- Name: itungo_ukozororoka_abashumba_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.itungo_ukozororoka_abashumba_id_seq OWNED BY amatungo.itungo_ukozororoka_abashumba.id;


--
-- Name: ubuzimabwaryo; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.ubuzimabwaryo (
    uzmuui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    ubuzima character varying(255),
    igihe timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.ubuzimabwaryo OWNER TO postgres;

--
-- Name: ubuzimabwaryo_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.ubuzimabwaryo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.ubuzimabwaryo_id_seq OWNER TO postgres;

--
-- Name: ubuzimabwaryo_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.ubuzimabwaryo_id_seq OWNED BY amatungo.ubuzimabwaryo.id;


--
-- Name: ukozororoka; Type: TABLE; Schema: amatungo; Owner: postgres
--

CREATE TABLE amatungo.ukozororoka (
    ukozruui uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id integer NOT NULL,
    kororoka character varying(255),
    igihe timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE amatungo.ukozororoka OWNER TO postgres;

--
-- Name: ukozororoka_id_seq; Type: SEQUENCE; Schema: amatungo; Owner: postgres
--

CREATE SEQUENCE amatungo.ukozororoka_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE amatungo.ukozororoka_id_seq OWNER TO postgres;

--
-- Name: ukozororoka_id_seq; Type: SEQUENCE OWNED BY; Schema: amatungo; Owner: postgres
--

ALTER SEQUENCE amatungo.ukozororoka_id_seq OWNED BY amatungo.ukozororoka.id;


--
-- Name: abashumba id; Type: DEFAULT; Schema: aborozi; Owner: postgres
--

ALTER TABLE ONLY aborozi.abashumba ALTER COLUMN id SET DEFAULT nextval('aborozi.abashumba_id_seq'::regclass);


--
-- Name: icyiciro id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.icyiciro ALTER COLUMN id SET DEFAULT nextval('amatungo.icyiciro_id_seq'::regclass);


--
-- Name: imyororokere id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.imyororokere ALTER COLUMN id SET DEFAULT nextval('amatungo.imyororokere_id_seq'::regclass);


--
-- Name: isokoryaryo id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.isokoryaryo ALTER COLUMN id SET DEFAULT nextval('amatungo.isokoryaryo_id_seq'::regclass);


--
-- Name: itungo id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo ALTER COLUMN id SET DEFAULT nextval('amatungo.itungo_id_seq'::regclass);


--
-- Name: itungo_isokoryaryo id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_isokoryaryo ALTER COLUMN id SET DEFAULT nextval('amatungo.itungo_isokoryaryo_id_seq'::regclass);


--
-- Name: itungo_ubuzimabwaryo id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ubuzimabwaryo ALTER COLUMN id SET DEFAULT nextval('amatungo.itungo_ubuzimabwaryo_id_seq'::regclass);


--
-- Name: itungo_ukozororoka_abashumba id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ukozororoka_abashumba ALTER COLUMN id SET DEFAULT nextval('amatungo.itungo_ukozororoka_abashumba_id_seq'::regclass);


--
-- Name: ubuzimabwaryo id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.ubuzimabwaryo ALTER COLUMN id SET DEFAULT nextval('amatungo.ubuzimabwaryo_id_seq'::regclass);


--
-- Name: ukozororoka id; Type: DEFAULT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.ukozororoka ALTER COLUMN id SET DEFAULT nextval('amatungo.ukozororoka_id_seq'::regclass);


--
-- Data for Name: abashumba; Type: TABLE DATA; Schema: aborozi; Owner: postgres
--

COPY aborozi.abashumba (abshuui, id, izina_ryababyeyi, izina_rindi, igitsina, irangamimerere, nid, tel1, tel2, icyo_akora, icyo_ashinzwe, ahoatuye, ifoto_url, amasezerano_url, igihe) FROM stdin;
9e701f00-0dd5-4e7a-b412-d065ae35e9b0	24	sam	habana	Male	\N	1198480012785271	0788881819		arahinga	Uhagarariye itungo	ruhango/bunyogombe/buhoro	C:/MyFlutterUIdartFrogBknd/uploads/aborozi/images/noza_2025613161154.png	{"C:/MyFlutterUIdartFrogBknd/uploads/aborozi/docs/bid validity comment_2025613161154.docx"}	2025-06-13 14:11:54.443406
02ef296f-4bbf-4577-ba54-b4cbf9d717e1	26	Rutagengwa	Jean paul	Male	\N	1198089191191	0729393939		umwubatsi	Uhagarariye itungo	Nyarugenge/Kigali/kigali/Murama	C:/MyFlutterUIdartFrogBknd/uploads/aborozi/images/billy_202592216146.jpeg	{"C:/MyFlutterUIdartFrogBknd/uploads/aborozi/docs/bid validity comment_20256131611ccc54.docx"}	2025-09-22 14:01:46.916723
a9a7e6d5-59ba-4cbb-bdb0-f8ca01a7351a	25	Bosco	Habyarimana	Male	\N	1198983030033	0789584834		umuhinzi	Umworozi	Kicukiro/Kagarama/kimicanga/nyacyonga	C:/MyFlutterUIdartFrogBknd/uploads/aborozi/images/download_202592215590.jpeg	{"C:/MyFlutterUIdartFrogBknd/uploads/aborozi/docs/bid validity comment_20256131611ccc4.docx"}	2025-09-22 13:59:00.41366
27563e8b-afce-41a3-bfb0-7144456be4a1	23	Karangwa	Jean	Male	\N	1289732666666666	0785984593	0734567463	Umuhinzi	Umworozi	Nyarugenge/Kigali/Kacyiru/Kimisogi	C:/MyFlutterUIdartFrogBknd/uploads/aborozi/images/Her DL_2025611233552.jpg	{"C:/MyFlutterUIdartFrogBknd/uploads/aborozi/docs/Validity extension_info (1)_2025611233552.docx","C:/MyFlutterUIdartFrogBknd/uploads/aborozi/docs/ID (1)_2025611233552.pdf"}	2025-06-11 21:35:52.485006
\.


--
-- Data for Name: icyiciro; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.icyiciro (icyuui, id, izina, igihe) FROM stdin;
0ba8c4b3-72fc-4181-900b-148cb5791a50	2	Ihene	2025-04-09 20:06:54.355048
3f494b55-6e63-48e0-b3af-082b8eda040c	1	Inka	2025-04-09 20:06:54.355048
\.


--
-- Data for Name: imyororokere; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.imyororokere (imyruui, id, imyruui_icyuui, imyakayokororoka, ameziibyarira, ubwokobwitungo, igihe) FROM stdin;
326e4d8e-1ba5-49e6-b672-4bf919d06d6f	2	0ba8c4b3-72fc-4181-900b-148cb5791a50	1	5	Inyarwanda	2025-04-09 20:10:03.722201
\.


--
-- Data for Name: isokoryaryo; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.isokoryaryo (iskuui, id, isoko, igihe) FROM stdin;
8c36f2cd-085e-4f91-b313-038123201200	1	Ryagurishijwe kubushake	2025-04-09 19:50:36.307083
4ed35d0b-16a1-4c36-b80d-fce807b9c373	2	Ryagurishijwe kuko rirwaye	2025-04-09 19:50:36.307083
9cb305d2-04b1-46b8-bc22-c0c60f031c72	3	Ryaguzwe	2025-04-09 19:50:36.307083
6612bf0f-fd79-4763-819a-4bdf774afd65	4	Ryagurishijwe kuko ryavunitse	2025-04-09 19:50:36.307083
99933a07-27b6-4a10-978a-785c146eff75	6	Ni impano	2025-04-09 19:50:36.307083
872543fb-6bec-4123-bd17-78c35d1eefaa	5	Ni iryavutse	2025-04-09 19:50:36.307083
\.


--
-- Data for Name: itungo; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.itungo (itunguui, id, itunguui_imyruui, igitsina, ifoto_url, ubukure, itngcode, ibara, ibiro, ahoryavuye, igihe) FROM stdin;
883af8f9-e83c-4c04-8f92-220c9d27841d	47	326e4d8e-1ba5-49e6-b672-4bf919d06d6f	Ijigija	202624165439.jpg	35	IHE00008	Musheru	\N	\N	2026-02-04 16:54:39.887362+02
\.


--
-- Data for Name: itungo_isokoryaryo; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.itungo_isokoryaryo (id, itunguui, iskuui, seqno, amafaranga_yarigiyeho, amafaranga_ryagurishijwe, amafaranga_rihagaze, ibisobanuro, itariki_byabereyeho, igihe) FROM stdin;
25	883af8f9-e83c-4c04-8f92-220c9d27841d	9cb305d2-04b1-46b8-bc22-c0c60f031c72	1	\N	\N	78000	\N	\N	2026-02-04 14:54:39.887362
\.


--
-- Data for Name: itungo_ubuzimabwaryo; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.itungo_ubuzimabwaryo (id, itunguui, uzmuui, seqno, amafaranga_yarigiyeho, amafaranga_ryinjije, dokima_url, ibisobanuro, itariki_byabereyeho, igihe) FROM stdin;
25	883af8f9-e83c-4c04-8f92-220c9d27841d	5080e476-58d9-432a-8613-5b9f36d50336	1	\N	\N	\N		\N	2026-02-04 14:54:39.887362
\.


--
-- Data for Name: itungo_ukozororoka_abashumba; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.itungo_ukozororoka_abashumba (id, itunguui, ukozruui, abshuui_uhagariy, abshuui_umworoz, seqno, incuro_ibyaye, amezi_rihaka, itariki_ryimiye, itariki_ribyariye, itariki_ariherewe, itariki_aryakiwe, riraragijwe_yo, igitsina_cyavutse, igihe, itariki_rivukiye) FROM stdin;
37	883af8f9-e83c-4c04-8f92-220c9d27841d	0106f36e-1bf1-45fd-ac0c-6ba5f047d02a	02ef296f-4bbf-4577-ba54-b4cbf9d717e1	a9a7e6d5-59ba-4cbb-bdb0-f8ca01a7351a	1	\N	\N	2025-09-30	\N	2026-02-04	\N	YEGO	\N	2026-02-04 14:54:39.887362	\N
\.


--
-- Data for Name: ubuzimabwaryo; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.ubuzimabwaryo (uzmuui, id, ubuzima, igihe) FROM stdin;
980b5126-b508-4a2c-bfb8-9d1f2e8063f3	1	Ryimije	2025-04-09 19:31:23.229236+02
0fa5a93e-4d4c-4ae6-9d76-97b82c323781	2	Ryapfuye	2025-04-09 19:31:23.229236+02
faef7ea6-6fed-4ec6-a565-356a34163896	3	Ryavunitse	2025-04-09 19:31:23.229236+02
a0e1d3c1-f3d0-4d74-abe4-91ab685f7bb2	4	Ryabyaraga	2025-04-09 19:31:23.229236+02
83e47b57-3adc-4efa-9c40-ec853f349408	5	Ryaronaga	2025-04-09 19:31:23.229236+02
9b56ccb7-ed14-4169-8a8a-8a777f6f32ad	6	Rirarwaye	2025-04-09 19:31:23.229236+02
5080e476-58d9-432a-8613-5b9f36d50336	7	Ni rizima	2025-04-09 19:31:23.229236+02
97533234-a165-4140-a7c8-e81bfcad3811	8	Ryangije ibintu	2025-04-09 19:31:23.229236+02
\.


--
-- Data for Name: ukozororoka; Type: TABLE DATA; Schema: amatungo; Owner: postgres
--

COPY amatungo.ukozororoka (ukozruui, id, kororoka, igihe) FROM stdin;
ce4f7c4e-592c-4f69-97cb-f4816762974d	1	Ryimye	2025-04-09 19:05:42.028331+02
0106f36e-1bf1-45fd-ac0c-6ba5f047d02a	2	Rirahaka	2025-04-09 19:05:42.028331+02
24973468-0005-4de0-906f-57287780e082	3	Riragumbye	2025-04-09 19:05:42.028331+02
e3e5dfcf-522e-48ed-908e-08048cb7e233	4	Ryabyaye	2025-04-09 19:05:42.028331+02
72aa80ad-c26a-4d23-a64d-7c531687e70c	5	Ryaramburuye	2025-04-09 19:05:42.028331+02
7264bcad-4ae5-4eda-9c31-427fbc76b466	6	Ntirirakura	2025-04-09 19:05:42.028331+02
bc99510f-be2d-4451-8d9d-badec75a02c2	7	Ni impfizi	2025-04-09 19:05:42.028331+02
51265335-8cc5-433d-b024-14bf1e51fb68	8	Ni isekurume	2025-04-09 19:20:17.988156+02
43b4e57f-af2d-42d4-a997-8e1a76ad8753	9	Rirashaje	2025-04-09 19:32:34.467175+02
ff746fdc-723e-4269-8986-f9c564a28113	10	Rironsa	2026-01-31 16:15:27.282029+02
\.


--
-- Name: abashumba_id_seq; Type: SEQUENCE SET; Schema: aborozi; Owner: postgres
--

SELECT pg_catalog.setval('aborozi.abashumba_id_seq', 26, true);


--
-- Name: icyiciro_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.icyiciro_id_seq', 4, true);


--
-- Name: imyororokere_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.imyororokere_id_seq', 2, true);


--
-- Name: isokoryaryo_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.isokoryaryo_id_seq', 6, true);


--
-- Name: itungo_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.itungo_id_seq', 47, true);


--
-- Name: itungo_isokoryaryo_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.itungo_isokoryaryo_id_seq', 25, true);


--
-- Name: itungo_ubuzimabwaryo_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.itungo_ubuzimabwaryo_id_seq', 25, true);


--
-- Name: itungo_ukozororoka_abashumba_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.itungo_ukozororoka_abashumba_id_seq', 37, true);


--
-- Name: ubuzimabwaryo_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.ubuzimabwaryo_id_seq', 8, true);


--
-- Name: ukozororoka_id_seq; Type: SEQUENCE SET; Schema: amatungo; Owner: postgres
--

SELECT pg_catalog.setval('amatungo.ukozororoka_id_seq', 10, true);


--
-- Name: abashumba abashumba_id_key; Type: CONSTRAINT; Schema: aborozi; Owner: postgres
--

ALTER TABLE ONLY aborozi.abashumba
    ADD CONSTRAINT abashumba_id_key UNIQUE (id);


--
-- Name: abashumba abashumba_pkey; Type: CONSTRAINT; Schema: aborozi; Owner: postgres
--

ALTER TABLE ONLY aborozi.abashumba
    ADD CONSTRAINT abashumba_pkey PRIMARY KEY (abshuui);


--
-- Name: icyiciro icyiciro_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.icyiciro
    ADD CONSTRAINT icyiciro_id_key UNIQUE (id);


--
-- Name: icyiciro icyiciro_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.icyiciro
    ADD CONSTRAINT icyiciro_pkey PRIMARY KEY (icyuui);


--
-- Name: imyororokere imyororokere_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.imyororokere
    ADD CONSTRAINT imyororokere_id_key UNIQUE (id);


--
-- Name: imyororokere imyororokere_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.imyororokere
    ADD CONSTRAINT imyororokere_pkey PRIMARY KEY (imyruui);


--
-- Name: isokoryaryo isokoryaryo_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.isokoryaryo
    ADD CONSTRAINT isokoryaryo_id_key UNIQUE (id);


--
-- Name: isokoryaryo isokoryaryo_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.isokoryaryo
    ADD CONSTRAINT isokoryaryo_pkey PRIMARY KEY (iskuui);


--
-- Name: itungo itngcode_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo
    ADD CONSTRAINT itngcode_key UNIQUE (itngcode);


--
-- Name: itungo itungo_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo
    ADD CONSTRAINT itungo_id_key UNIQUE (id);


--
-- Name: itungo_isokoryaryo itungo_isokoryaryo_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_isokoryaryo
    ADD CONSTRAINT itungo_isokoryaryo_id_key UNIQUE (id);


--
-- Name: itungo_isokoryaryo itungo_isokoryaryo_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_isokoryaryo
    ADD CONSTRAINT itungo_isokoryaryo_pkey PRIMARY KEY (itunguui, iskuui);


--
-- Name: itungo itungo_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo
    ADD CONSTRAINT itungo_pkey PRIMARY KEY (itunguui);


--
-- Name: itungo_ubuzimabwaryo itungo_ubuzimabwaryo_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ubuzimabwaryo
    ADD CONSTRAINT itungo_ubuzimabwaryo_id_key UNIQUE (id);


--
-- Name: itungo_ubuzimabwaryo itungo_ubuzimabwaryo_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ubuzimabwaryo
    ADD CONSTRAINT itungo_ubuzimabwaryo_pkey PRIMARY KEY (itunguui, uzmuui);


--
-- Name: itungo_ukozororoka_abashumba itungo_ukozororoka_abashumba_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ukozororoka_abashumba
    ADD CONSTRAINT itungo_ukozororoka_abashumba_pkey PRIMARY KEY (id);


--
-- Name: ubuzimabwaryo ubuzimabwaryo_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.ubuzimabwaryo
    ADD CONSTRAINT ubuzimabwaryo_id_key UNIQUE (id);


--
-- Name: ubuzimabwaryo ubuzimabwaryo_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.ubuzimabwaryo
    ADD CONSTRAINT ubuzimabwaryo_pkey PRIMARY KEY (uzmuui);


--
-- Name: ukozororoka ukozororoka_id_key; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.ukozororoka
    ADD CONSTRAINT ukozororoka_id_key UNIQUE (id);


--
-- Name: ukozororoka ukozororoka_pkey; Type: CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.ukozororoka
    ADD CONSTRAINT ukozororoka_pkey PRIMARY KEY (ukozruui);


--
-- Name: imyororokere fk_imyororokere_cyicro; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.imyororokere
    ADD CONSTRAINT fk_imyororokere_cyicro FOREIGN KEY (imyruui_icyuui) REFERENCES amatungo.icyiciro(icyuui) ON DELETE CASCADE;


--
-- Name: itungo fk_itungo_imyororokere; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo
    ADD CONSTRAINT fk_itungo_imyororokere FOREIGN KEY (itunguui_imyruui) REFERENCES amatungo.imyororokere(imyruui) ON DELETE CASCADE;


--
-- Name: itungo_isokoryaryo itungo_isokoryaryo_iskuui_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_isokoryaryo
    ADD CONSTRAINT itungo_isokoryaryo_iskuui_fkey FOREIGN KEY (iskuui) REFERENCES amatungo.isokoryaryo(iskuui) ON DELETE CASCADE;


--
-- Name: itungo_isokoryaryo itungo_isokoryaryo_itunguui_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_isokoryaryo
    ADD CONSTRAINT itungo_isokoryaryo_itunguui_fkey FOREIGN KEY (itunguui) REFERENCES amatungo.itungo(itunguui) ON DELETE CASCADE;


--
-- Name: itungo_ubuzimabwaryo itungo_ubuzimabwaryo_itunguui_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ubuzimabwaryo
    ADD CONSTRAINT itungo_ubuzimabwaryo_itunguui_fkey FOREIGN KEY (itunguui) REFERENCES amatungo.itungo(itunguui) ON DELETE CASCADE;


--
-- Name: itungo_ubuzimabwaryo itungo_ubuzimabwaryo_uzmuui_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ubuzimabwaryo
    ADD CONSTRAINT itungo_ubuzimabwaryo_uzmuui_fkey FOREIGN KEY (uzmuui) REFERENCES amatungo.ubuzimabwaryo(uzmuui) ON DELETE CASCADE;


--
-- Name: itungo_ukozororoka_abashumba itungo_ukozororoka_abashumba_abshuui_uhagariy_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ukozororoka_abashumba
    ADD CONSTRAINT itungo_ukozororoka_abashumba_abshuui_uhagariy_fkey FOREIGN KEY (abshuui_uhagariy) REFERENCES aborozi.abashumba(abshuui) ON DELETE SET NULL;


--
-- Name: itungo_ukozororoka_abashumba itungo_ukozororoka_abashumba_abshuui_umworoz_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ukozororoka_abashumba
    ADD CONSTRAINT itungo_ukozororoka_abashumba_abshuui_umworoz_fkey FOREIGN KEY (abshuui_umworoz) REFERENCES aborozi.abashumba(abshuui) ON DELETE SET NULL;


--
-- Name: itungo_ukozororoka_abashumba itungo_ukozororoka_abashumba_itunguui_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ukozororoka_abashumba
    ADD CONSTRAINT itungo_ukozororoka_abashumba_itunguui_fkey FOREIGN KEY (itunguui) REFERENCES amatungo.itungo(itunguui) ON DELETE CASCADE;


--
-- Name: itungo_ukozororoka_abashumba itungo_ukozororoka_abashumba_ukozruui_fkey; Type: FK CONSTRAINT; Schema: amatungo; Owner: postgres
--

ALTER TABLE ONLY amatungo.itungo_ukozororoka_abashumba
    ADD CONSTRAINT itungo_ukozororoka_abashumba_ukozruui_fkey FOREIGN KEY (ukozruui) REFERENCES amatungo.ukozororoka(ukozruui) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

