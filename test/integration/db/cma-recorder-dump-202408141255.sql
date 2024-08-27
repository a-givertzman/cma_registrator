--
-- PostgreSQL database dump
--

-- Dumped from database version 13.15 (Debian 13.15-0+deb11u1)
-- Dumped by pg_dump version 13.15 (Debian 13.15-0+deb11u1)

-- Started on 2024-08-14 12:55:32 MSK

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
-- TOC entry 3130 (class 1262 OID 18439)
-- Name: crane_data_server; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE crane_data_server WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE crane_data_server OWNER TO crane_data_server;

\connect crane_data_server

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 27857)
-- Name: app_user; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TYPE public.user_role_enum AS ENUM('admin','operator');
ALTER TYPE public.user_role_enum OWNER TO crane_data_server;

CREATE TABLE public.app_user (
    id bigint NOT NULL,
    role public.user_role_enum NOT NULL,
    name character varying(255) NOT NULL,
    login character varying(255) NOT NULL,
    pass character varying(2584) NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted timestamp without time zone
);


ALTER TABLE public.app_user OWNER TO crane_data_server;

--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE app_user; Type: COMMENT; Schema: public; Owner: crane_data_server
--

COMMENT ON TABLE public.app_user IS 'Потльзователи';


--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN app_user.role; Type: COMMENT; Schema: public; Owner: crane_data_server
--

COMMENT ON COLUMN public.app_user.role IS 'Признак группировки';


--
-- TOC entry 200 (class 1259 OID 27855)
-- Name: app_user_id_seq; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.app_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_user_id_seq OWNER TO crane_data_server;

--
-- TOC entry 3134 (class 0 OID 0)
-- Dependencies: 200
-- Name: app_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.app_user_id_seq OWNED BY public.app_user.id;


--
-- TOC entry 217 (class 1259 OID 56501)
-- Name: event; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.event (
    uid bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    pid smallint NOT NULL,
    value smallint NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE public.event OWNER TO crane_data_server;

--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE event; Type: COMMENT; Schema: public; Owner: crane_data_server
--

COMMENT ON TABLE public.event IS 'События. Только тэги дискретных значений, регистрируется 0 - как норма, > 0 - как авария.';


--
-- TOC entry 216 (class 1259 OID 56499)
-- Name: event_uid_seq1; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.event_uid_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_uid_seq1 OWNER TO crane_data_server;

--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 216
-- Name: event_uid_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.event_uid_seq1 OWNED BY public.event.uid;


--
-- TOC entry 219 (class 1259 OID 56510)
-- Name: event_utils; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.event_utils (
    id integer NOT NULL,
    row_count bigint,
    row_limit bigint,
    purge_batch_size integer,
    purge_shift_size integer,
    is_purge_running boolean
);


ALTER TABLE public.event_utils OWNER TO crane_data_server;

--
-- TOC entry 218 (class 1259 OID 56508)
-- Name: event_utils_id_seq; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.event_utils_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_utils_id_seq OWNER TO crane_data_server;

--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 218
-- Name: event_utils_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.event_utils_id_seq OWNED BY public.event_utils.id;


CREATE TYPE public.tag_type_enum AS ENUM('Bool','Int','UInt','DInt','Word','LInt','Real','Time','Date_And_Time');
ALTER TYPE public.tag_type_enum OWNER TO crane_data_server;
--
-- TOC entry 203 (class 1259 OID 27891)
-- Name: tags; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    type public.tag_type_enum NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tags OWNER TO crane_data_server;

--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE tags; Type: COMMENT; Schema: public; Owner: crane_data_server
--

COMMENT ON TABLE public.tags IS 'Справочник тэгов проекта.';


--
-- TOC entry 206 (class 1259 OID 27918)
-- Name: rec_operating_cycle; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.rec_operating_cycle (
    id bigint NOT NULL,
    timestamp_start timestamp without time zone NOT NULL,
    timestamp_stop timestamp without time zone NOT NULL,
    alarm_class character(2) NOT NULL
);


ALTER TABLE public.rec_operating_cycle OWNER TO crane_data_server;

--
-- TOC entry 205 (class 1259 OID 27916)
-- Name: operating_cycle_id_seq; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.operating_cycle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.operating_cycle_id_seq OWNER TO crane_data_server;

--
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 205
-- Name: operating_cycle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.operating_cycle_id_seq OWNED BY public.rec_operating_cycle.id;


CREATE TYPE public.metric_data_type_enum as ENUM('bool','int','real','time','date','timestamp','string');
ALTER TYPE public.metric_data_type_enum OWNER TO crane_data_server;

--
-- TOC entry 208 (class 1259 OID 27941)
-- Name: rec_basic_metric; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.rec_basic_metric (
    id character(32) NOT NULL,
    type public.metric_data_type_enum NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.rec_basic_metric OWNER TO crane_data_server;

--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE rec_basic_metric; Type: COMMENT; Schema: public; Owner: crane_data_server
--

COMMENT ON TABLE public.rec_basic_metric IS 'Общие метрики';


--
-- TOC entry 224 (class 1259 OID 74298)
-- Name: rec_name; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.rec_name (
    id character varying(32) NOT NULL,
    type public.tag_type_enum,
    name character varying(255) NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.rec_name OWNER TO crane_data_server;

--
-- TOC entry 223 (class 1259 OID 74296)
-- Name: rec_name_id_seq; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.rec_name_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rec_name_id_seq OWNER TO crane_data_server;

--
-- TOC entry 3141 (class 0 OID 0)
-- Dependencies: 223
-- Name: rec_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.rec_name_id_seq OWNED BY public.rec_name.id;


--
-- TOC entry 222 (class 1259 OID 74242)
-- Name: rec_operating_event; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.rec_operating_event (
    id bigint NOT NULL,
    operating_cycle_id bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    event_id character varying(255) NOT NULL,
    value numeric(16,8) NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE public.rec_operating_event OWNER TO crane_data_server;

--
-- TOC entry 221 (class 1259 OID 74240)
-- Name: rec_operating_event_id_seq; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.rec_operating_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rec_operating_event_id_seq OWNER TO crane_data_server;

--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 221
-- Name: rec_operating_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.rec_operating_event_id_seq OWNED BY public.rec_operating_event.id;


--
-- TOC entry 207 (class 1259 OID 27932)
-- Name: rec_operating_metric; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.rec_operating_metric (
    operating_cycle_id bigint NOT NULL,
    metric_id character(16) NOT NULL,
    value numeric(16,8) NOT NULL
);


ALTER TABLE public.rec_operating_metric OWNER TO crane_data_server;

--
-- TOC entry 209 (class 1259 OID 27951)
-- Name: report; Type: TABLE; Schema: public; Owner: crane_data_server
--

CREATE TABLE public.report (
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    code smallint NOT NULL,
    message character varying(50) NOT NULL,
    stack text NOT NULL
);


ALTER TABLE public.report OWNER TO crane_data_server;

--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE report; Type: COMMENT; Schema: public; Owner: crane_data_server
--

COMMENT ON TABLE public.report IS 'Отчеты об ошибках в работе приложений.';


--
-- TOC entry 202 (class 1259 OID 27889)
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: crane_data_server
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO crane_data_server;

--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 202
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crane_data_server
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;

--
-- TOC entry 2934 (class 2604 OID 27860)
-- Name: app_user id; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.app_user ALTER COLUMN id SET DEFAULT nextval('public.app_user_id_seq'::regclass);


--
-- TOC entry 2941 (class 2604 OID 56504)
-- Name: event uid; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.event ALTER COLUMN uid SET DEFAULT nextval('public.event_uid_seq1'::regclass);


--
-- TOC entry 2942 (class 2604 OID 56513)
-- Name: event_utils id; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.event_utils ALTER COLUMN id SET DEFAULT nextval('public.event_utils_id_seq'::regclass);


--
-- TOC entry 2945 (class 2604 OID 74311)
-- Name: rec_name id; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_name ALTER COLUMN id SET DEFAULT nextval('public.rec_name_id_seq'::regclass);


--
-- TOC entry 2939 (class 2604 OID 27921)
-- Name: rec_operating_cycle id; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_operating_cycle ALTER COLUMN id SET DEFAULT nextval('public.operating_cycle_id_seq'::regclass);


--
-- TOC entry 2943 (class 2604 OID 74245)
-- Name: rec_operating_event id; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_operating_event ALTER COLUMN id SET DEFAULT nextval('public.rec_operating_event_id_seq'::regclass);


--
-- TOC entry 2937 (class 2604 OID 27894)
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- TOC entry 3109 (class 0 OID 27857)
-- Dependencies: 201
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--



--
-- TOC entry 3118 (class 0 OID 56501)
-- Dependencies: 217
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.event VALUES (1212, '2024-04-04 12:45:50.36239', 64, 1, 0);
INSERT INTO public.event VALUES (1213, '2024-04-04 12:45:50.762451', 65, 1, 0);
INSERT INTO public.event VALUES (1214, '2024-04-04 12:45:51.162624', 66, 0, 0);
INSERT INTO public.event VALUES (1215, '2024-04-04 12:45:51.562787', 67, 1, 0);
INSERT INTO public.event VALUES (1216, '2024-04-04 12:45:51.962859', 68, 1, 0);
INSERT INTO public.event VALUES (1217, '2024-04-04 12:45:53.963694', 64, 0, 0);
INSERT INTO public.event VALUES (1218, '2024-04-04 12:45:54.363872', 65, 1, 0);
INSERT INTO public.event VALUES (1219, '2024-04-04 12:45:54.764049', 66, 0, 0);
INSERT INTO public.event VALUES (1220, '2024-04-04 12:45:55.164345', 67, 1, 0);
INSERT INTO public.event VALUES (1221, '2024-04-04 12:45:55.564512', 68, 0, 0);
INSERT INTO public.event VALUES (1222, '2024-04-04 12:45:57.56515', 64, 0, 0);
INSERT INTO public.event VALUES (1223, '2024-04-04 12:45:57.965249', 65, 1, 0);
INSERT INTO public.event VALUES (1224, '2024-04-04 12:45:58.365427', 66, 0, 0);
INSERT INTO public.event VALUES (1225, '2024-04-04 12:45:58.765581', 67, 1, 0);
INSERT INTO public.event VALUES (1226, '2024-04-04 12:45:59.165851', 68, 0, 0);
INSERT INTO public.event VALUES (1227, '2024-04-04 12:46:01.166324', 64, 1, 0);
INSERT INTO public.event VALUES (1228, '2024-04-04 12:46:01.56638', 65, 1, 0);
INSERT INTO public.event VALUES (1229, '2024-04-04 12:46:01.966442', 66, 1, 0);
INSERT INTO public.event VALUES (1230, '2024-04-04 12:46:02.366524', 67, 0, 0);
INSERT INTO public.event VALUES (1231, '2024-04-04 12:46:02.766728', 68, 0, 0);
INSERT INTO public.event VALUES (1232, '2024-04-04 12:46:04.767596', 64, 1, 0);
INSERT INTO public.event VALUES (1233, '2024-04-04 12:46:05.167653', 65, 1, 0);
INSERT INTO public.event VALUES (1234, '2024-04-04 12:46:05.567833', 66, 0, 0);
INSERT INTO public.event VALUES (1235, '2024-04-04 12:46:05.967996', 67, 0, 0);
INSERT INTO public.event VALUES (1236, '2024-04-04 12:46:06.36817', 68, 1, 0);
INSERT INTO public.event VALUES (1237, '2024-04-04 12:46:08.368805', 64, 1, 0);
INSERT INTO public.event VALUES (1238, '2024-04-04 12:46:08.768864', 65, 0, 0);
INSERT INTO public.event VALUES (1239, '2024-04-04 12:46:09.168927', 66, 0, 0);
INSERT INTO public.event VALUES (1240, '2024-04-04 12:46:09.569003', 67, 0, 0);
INSERT INTO public.event VALUES (1241, '2024-04-04 12:46:09.969079', 68, 0, 0);
INSERT INTO public.event VALUES (1242, '2024-04-04 12:46:11.969897', 64, 1, 0);
INSERT INTO public.event VALUES (1243, '2024-04-04 12:46:12.369961', 65, 1, 0);
INSERT INTO public.event VALUES (1244, '2024-04-04 12:46:12.770129', 66, 0, 0);
INSERT INTO public.event VALUES (1245, '2024-04-04 12:46:13.170196', 67, 0, 0);
INSERT INTO public.event VALUES (1246, '2024-04-04 12:46:13.570259', 68, 1, 0);
INSERT INTO public.event VALUES (1247, '2024-04-04 12:46:15.57069', 64, 1, 0);
INSERT INTO public.event VALUES (1248, '2024-04-04 12:46:15.970845', 65, 0, 0);
INSERT INTO public.event VALUES (1249, '2024-04-04 12:46:16.371011', 66, 0, 0);
INSERT INTO public.event VALUES (1250, '2024-04-04 12:46:16.771178', 67, 1, 0);
INSERT INTO public.event VALUES (1251, '2024-04-04 12:46:17.171383', 68, 0, 0);
INSERT INTO public.event VALUES (1252, '2024-04-04 12:46:19.171966', 64, 1, 0);
INSERT INTO public.event VALUES (1253, '2024-04-04 12:46:19.572051', 65, 1, 0);
INSERT INTO public.event VALUES (1254, '2024-04-04 12:46:19.972219', 66, 1, 0);
INSERT INTO public.event VALUES (1255, '2024-04-04 12:46:20.372392', 67, 1, 0);
INSERT INTO public.event VALUES (1256, '2024-04-04 12:46:20.772454', 68, 0, 0);
INSERT INTO public.event VALUES (1257, '2024-04-04 12:46:22.773058', 64, 1, 0);
INSERT INTO public.event VALUES (1258, '2024-04-04 12:46:23.17324', 65, 1, 0);
INSERT INTO public.event VALUES (1259, '2024-04-04 12:46:23.573297', 66, 0, 0);
INSERT INTO public.event VALUES (1260, '2024-04-04 12:46:23.973479', 67, 0, 0);
INSERT INTO public.event VALUES (1261, '2024-04-04 12:46:24.373645', 68, 0, 0);
INSERT INTO public.event VALUES (1262, '2024-04-04 12:46:26.374501', 64, 0, 0);
INSERT INTO public.event VALUES (1263, '2024-04-04 12:46:26.77467', 65, 1, 0);
INSERT INTO public.event VALUES (1264, '2024-04-04 12:46:27.174853', 66, 0, 0);
INSERT INTO public.event VALUES (1265, '2024-04-04 12:46:27.574949', 67, 0, 0);
INSERT INTO public.event VALUES (1266, '2024-04-04 12:46:27.975107', 68, 1, 0);
INSERT INTO public.event VALUES (1267, '2024-04-04 12:46:29.975811', 64, 1, 0);
INSERT INTO public.event VALUES (1268, '2024-04-04 12:46:30.375934', 65, 1, 0);
INSERT INTO public.event VALUES (1269, '2024-04-04 12:46:30.776086', 66, 1, 0);
INSERT INTO public.event VALUES (1270, '2024-04-04 12:46:31.176146', 67, 0, 0);
INSERT INTO public.event VALUES (1271, '2024-04-04 12:46:31.576227', 68, 0, 0);
INSERT INTO public.event VALUES (1272, '2024-04-04 12:46:33.576981', 64, 1, 0);
INSERT INTO public.event VALUES (1273, '2024-04-04 12:46:33.977047', 65, 1, 0);
INSERT INTO public.event VALUES (1274, '2024-04-04 12:46:34.377124', 66, 0, 0);
INSERT INTO public.event VALUES (1275, '2024-04-04 12:46:34.777195', 67, 1, 0);
INSERT INTO public.event VALUES (1276, '2024-04-04 12:46:35.177326', 68, 0, 0);
INSERT INTO public.event VALUES (1277, '2024-04-04 12:46:37.178034', 64, 1, 0);
INSERT INTO public.event VALUES (1278, '2024-04-04 12:46:37.578199', 65, 0, 0);
INSERT INTO public.event VALUES (1279, '2024-04-04 12:46:37.978378', 66, 0, 0);
INSERT INTO public.event VALUES (1280, '2024-04-04 12:46:38.378437', 67, 0, 0);
INSERT INTO public.event VALUES (1281, '2024-04-04 12:46:38.778678', 68, 0, 0);
INSERT INTO public.event VALUES (1282, '2024-04-04 12:46:40.779556', 64, 1, 0);
INSERT INTO public.event VALUES (1283, '2024-04-04 12:46:41.179767', 65, 0, 0);
INSERT INTO public.event VALUES (1284, '2024-04-04 12:46:41.579994', 66, 0, 0);
INSERT INTO public.event VALUES (1285, '2024-04-04 12:46:41.980111', 67, 0, 0);
INSERT INTO public.event VALUES (1286, '2024-04-04 12:46:42.380237', 68, 1, 0);
INSERT INTO public.event VALUES (1287, '2024-04-04 12:46:44.380891', 64, 0, 0);
INSERT INTO public.event VALUES (1288, '2024-04-04 12:46:44.781003', 65, 0, 0);
INSERT INTO public.event VALUES (1289, '2024-04-04 12:46:45.181139', 66, 1, 0);
INSERT INTO public.event VALUES (1290, '2024-04-04 12:46:45.581213', 67, 1, 0);
INSERT INTO public.event VALUES (1291, '2024-04-04 12:46:45.981339', 68, 1, 0);
INSERT INTO public.event VALUES (1292, '2024-04-04 12:46:47.982061', 64, 1, 0);
INSERT INTO public.event VALUES (1293, '2024-04-04 12:46:48.382226', 65, 1, 0);
INSERT INTO public.event VALUES (1294, '2024-04-04 12:46:48.782322', 66, 1, 0);
INSERT INTO public.event VALUES (1295, '2024-04-04 12:46:49.182496', 67, 1, 0);
INSERT INTO public.event VALUES (1296, '2024-04-04 12:46:49.582697', 68, 1, 0);
INSERT INTO public.event VALUES (1297, '2024-04-04 12:46:51.583613', 64, 1, 0);
INSERT INTO public.event VALUES (1298, '2024-04-04 12:46:51.983832', 65, 0, 0);
INSERT INTO public.event VALUES (1299, '2024-04-04 12:46:52.384015', 66, 0, 0);
INSERT INTO public.event VALUES (1300, '2024-04-04 12:46:52.784213', 67, 1, 0);
INSERT INTO public.event VALUES (1301, '2024-04-04 12:46:53.184447', 68, 0, 0);
INSERT INTO public.event VALUES (1302, '2024-04-04 12:46:55.185154', 64, 1, 0);
INSERT INTO public.event VALUES (1303, '2024-04-04 12:46:55.585347', 65, 1, 0);
INSERT INTO public.event VALUES (1304, '2024-04-04 12:46:55.985446', 66, 0, 0);
INSERT INTO public.event VALUES (1305, '2024-04-04 12:46:56.385687', 67, 1, 0);
INSERT INTO public.event VALUES (1306, '2024-04-04 12:46:56.785746', 68, 0, 0);
INSERT INTO public.event VALUES (1307, '2024-04-04 12:46:58.786471', 64, 1, 0);
INSERT INTO public.event VALUES (1308, '2024-04-04 12:46:59.186577', 65, 1, 0);
INSERT INTO public.event VALUES (1309, '2024-04-04 12:46:59.586693', 66, 0, 0);
INSERT INTO public.event VALUES (1310, '2024-04-04 12:46:59.986888', 67, 0, 0);
INSERT INTO public.event VALUES (1311, '2024-04-04 12:47:00.387084', 68, 0, 0);
INSERT INTO public.event VALUES (1312, '2024-04-04 12:47:02.387779', 64, 1, 0);
INSERT INTO public.event VALUES (1313, '2024-04-04 12:47:02.787871', 65, 0, 0);
INSERT INTO public.event VALUES (1314, '2024-04-04 12:47:03.188048', 66, 0, 0);
INSERT INTO public.event VALUES (1315, '2024-04-04 12:47:03.588241', 67, 1, 0);
INSERT INTO public.event VALUES (1316, '2024-04-04 12:47:03.98831', 68, 1, 0);
INSERT INTO public.event VALUES (1317, '2024-04-04 12:47:05.989041', 64, 0, 0);
INSERT INTO public.event VALUES (1318, '2024-04-04 12:47:06.389201', 65, 0, 0);
INSERT INTO public.event VALUES (1319, '2024-04-04 12:47:06.7893', 66, 1, 0);
INSERT INTO public.event VALUES (1320, '2024-04-04 12:47:07.189356', 67, 0, 0);
INSERT INTO public.event VALUES (1321, '2024-04-04 12:47:07.589417', 68, 1, 0);
INSERT INTO public.event VALUES (1322, '2024-04-04 12:47:09.589904', 64, 0, 0);
INSERT INTO public.event VALUES (1323, '2024-04-04 12:47:09.990008', 65, 1, 0);
INSERT INTO public.event VALUES (1324, '2024-04-04 12:47:10.390132', 66, 0, 0);
INSERT INTO public.event VALUES (1325, '2024-04-04 12:47:10.790251', 67, 0, 0);
INSERT INTO public.event VALUES (1326, '2024-04-04 12:47:11.19041', 68, 1, 0);
INSERT INTO public.event VALUES (1327, '2024-04-04 12:47:13.191211', 64, 1, 0);
INSERT INTO public.event VALUES (1328, '2024-04-04 12:47:13.591369', 65, 1, 0);
INSERT INTO public.event VALUES (1329, '2024-04-04 12:47:13.991594', 66, 1, 0);
INSERT INTO public.event VALUES (1330, '2024-04-04 12:47:14.391738', 67, 1, 0);
INSERT INTO public.event VALUES (1331, '2024-04-04 12:47:14.791849', 68, 0, 0);
INSERT INTO public.event VALUES (1332, '2024-04-04 12:47:16.792483', 64, 0, 0);
INSERT INTO public.event VALUES (1333, '2024-04-04 12:47:17.192593', 65, 1, 0);
INSERT INTO public.event VALUES (1334, '2024-04-04 12:47:17.592662', 66, 0, 0);
INSERT INTO public.event VALUES (1335, '2024-04-04 12:47:17.992859', 67, 0, 0);
INSERT INTO public.event VALUES (1336, '2024-04-04 12:47:18.39292', 68, 0, 0);
INSERT INTO public.event VALUES (1337, '2024-04-04 12:47:20.393427', 64, 0, 0);
INSERT INTO public.event VALUES (1338, '2024-04-04 12:47:20.793624', 65, 0, 0);
INSERT INTO public.event VALUES (1339, '2024-04-04 12:47:21.193828', 66, 0, 0);
INSERT INTO public.event VALUES (1340, '2024-04-04 12:47:21.594024', 67, 0, 0);
INSERT INTO public.event VALUES (1341, '2024-04-04 12:47:21.994228', 68, 0, 0);
INSERT INTO public.event VALUES (1342, '2024-04-04 12:47:23.995217', 64, 1, 0);
INSERT INTO public.event VALUES (1343, '2024-04-04 12:47:24.395399', 65, 1, 0);
INSERT INTO public.event VALUES (1344, '2024-04-04 12:47:24.795579', 66, 0, 0);
INSERT INTO public.event VALUES (1345, '2024-04-04 12:47:25.195758', 67, 1, 0);
INSERT INTO public.event VALUES (1346, '2024-04-04 12:47:25.595954', 68, 1, 0);
INSERT INTO public.event VALUES (1347, '2024-04-04 12:47:27.596876', 64, 0, 0);
INSERT INTO public.event VALUES (1348, '2024-04-04 12:47:27.996937', 65, 1, 0);
INSERT INTO public.event VALUES (1349, '2024-04-04 12:47:28.397015', 66, 0, 0);
INSERT INTO public.event VALUES (1350, '2024-04-04 12:47:28.797085', 67, 0, 0);
INSERT INTO public.event VALUES (1351, '2024-04-04 12:47:29.197146', 68, 1, 0);
INSERT INTO public.event VALUES (1352, '2024-04-04 12:47:31.197723', 64, 1, 0);
INSERT INTO public.event VALUES (1353, '2024-04-04 12:47:31.59781', 65, 1, 0);
INSERT INTO public.event VALUES (1354, '2024-04-04 12:47:31.99789', 66, 0, 0);
INSERT INTO public.event VALUES (1355, '2024-04-04 12:47:32.398066', 67, 0, 0);
INSERT INTO public.event VALUES (1356, '2024-04-04 12:47:32.798232', 68, 1, 0);
INSERT INTO public.event VALUES (1357, '2024-04-04 12:47:34.798972', 64, 1, 0);
INSERT INTO public.event VALUES (1358, '2024-04-04 12:47:35.199064', 65, 1, 0);
INSERT INTO public.event VALUES (1359, '2024-04-04 12:47:35.599222', 66, 0, 0);
INSERT INTO public.event VALUES (1360, '2024-04-04 12:47:35.999291', 67, 0, 0);
INSERT INTO public.event VALUES (1361, '2024-04-04 12:47:36.399472', 68, 0, 0);
INSERT INTO public.event VALUES (1362, '2024-04-04 12:47:38.400276', 64, 1, 0);
INSERT INTO public.event VALUES (1363, '2024-04-04 12:47:38.800359', 65, 1, 0);
INSERT INTO public.event VALUES (1364, '2024-04-04 12:47:39.200525', 66, 1, 0);
INSERT INTO public.event VALUES (1365, '2024-04-04 12:47:39.600712', 67, 0, 0);
INSERT INTO public.event VALUES (1366, '2024-04-04 12:47:40.000777', 68, 0, 0);
INSERT INTO public.event VALUES (1367, '2024-04-04 12:47:42.001271', 64, 1, 0);
INSERT INTO public.event VALUES (1368, '2024-04-04 12:47:42.401449', 65, 0, 0);
INSERT INTO public.event VALUES (1369, '2024-04-04 12:47:42.801536', 66, 0, 0);
INSERT INTO public.event VALUES (1370, '2024-04-04 12:47:43.201628', 67, 0, 0);
INSERT INTO public.event VALUES (1371, '2024-04-04 12:47:43.601722', 68, 0, 0);
INSERT INTO public.event VALUES (1372, '2024-04-04 12:47:45.602633', 64, 1, 0);
INSERT INTO public.event VALUES (1373, '2024-04-04 12:47:46.002696', 65, 1, 0);
INSERT INTO public.event VALUES (1374, '2024-04-04 12:47:46.402885', 66, 1, 0);
INSERT INTO public.event VALUES (1375, '2024-04-04 12:47:46.802971', 67, 1, 0);
INSERT INTO public.event VALUES (1376, '2024-04-04 12:47:47.203163', 68, 1, 0);
INSERT INTO public.event VALUES (1377, '2024-04-04 12:47:49.204048', 64, 0, 0);
INSERT INTO public.event VALUES (1378, '2024-04-04 12:47:49.604216', 65, 1, 0);
INSERT INTO public.event VALUES (1379, '2024-04-04 12:47:50.004402', 66, 1, 0);
INSERT INTO public.event VALUES (1380, '2024-04-04 12:47:50.404595', 67, 0, 0);
INSERT INTO public.event VALUES (1381, '2024-04-04 12:47:50.804717', 68, 1, 0);
INSERT INTO public.event VALUES (1382, '2024-04-04 12:47:52.805207', 64, 1, 0);
INSERT INTO public.event VALUES (1383, '2024-04-04 12:47:53.205309', 65, 0, 0);
INSERT INTO public.event VALUES (1384, '2024-04-04 12:47:53.605391', 66, 1, 0);
INSERT INTO public.event VALUES (1385, '2024-04-04 12:47:54.005561', 67, 0, 0);
INSERT INTO public.event VALUES (1386, '2024-04-04 12:47:54.405693', 68, 1, 0);
INSERT INTO public.event VALUES (1387, '2024-04-04 12:47:56.406217', 64, 0, 0);
INSERT INTO public.event VALUES (1388, '2024-04-04 12:47:56.806416', 65, 1, 0);
INSERT INTO public.event VALUES (1389, '2024-04-04 12:54:54.52189', 65, 1, 0);
INSERT INTO public.event VALUES (1390, '2024-04-04 12:54:54.922056', 66, 0, 0);
INSERT INTO public.event VALUES (1391, '2024-04-04 12:54:55.322258', 67, 0, 0);
INSERT INTO public.event VALUES (1392, '2024-04-04 12:54:55.722446', 68, 1, 0);
INSERT INTO public.event VALUES (1393, '2024-04-04 12:54:57.723294', 64, 0, 0);
INSERT INTO public.event VALUES (1394, '2024-04-04 12:54:58.123467', 65, 1, 0);
INSERT INTO public.event VALUES (1395, '2024-04-04 12:54:58.523641', 66, 1, 0);
INSERT INTO public.event VALUES (1396, '2024-04-04 12:54:58.923826', 67, 1, 0);
INSERT INTO public.event VALUES (1397, '2024-04-04 12:54:59.324012', 68, 0, 0);
INSERT INTO public.event VALUES (1398, '2024-04-04 12:55:01.32482', 64, 0, 0);
INSERT INTO public.event VALUES (1399, '2024-04-04 12:55:01.724882', 65, 0, 0);
INSERT INTO public.event VALUES (1400, '2024-04-04 12:55:02.124941', 66, 1, 0);
INSERT INTO public.event VALUES (1401, '2024-04-04 12:55:02.525003', 67, 0, 0);
INSERT INTO public.event VALUES (1402, '2024-04-04 12:55:02.925104', 68, 1, 0);
INSERT INTO public.event VALUES (1403, '2024-04-04 12:55:04.925775', 64, 0, 0);
INSERT INTO public.event VALUES (1404, '2024-04-04 12:55:05.32597', 65, 1, 0);
INSERT INTO public.event VALUES (1405, '2024-04-04 12:55:05.726027', 66, 1, 0);
INSERT INTO public.event VALUES (1406, '2024-04-04 12:55:06.126192', 67, 1, 0);
INSERT INTO public.event VALUES (1407, '2024-04-04 12:55:06.526238', 68, 1, 0);
INSERT INTO public.event VALUES (1408, '2024-04-04 12:55:08.527099', 64, 1, 0);
INSERT INTO public.event VALUES (1409, '2024-04-04 12:55:08.927166', 65, 1, 0);
INSERT INTO public.event VALUES (1410, '2024-04-04 12:55:09.327231', 66, 0, 0);
INSERT INTO public.event VALUES (1411, '2024-04-04 12:55:09.727428', 67, 1, 0);
INSERT INTO public.event VALUES (1412, '2024-04-04 12:55:10.127597', 68, 0, 0);
INSERT INTO public.event VALUES (1413, '2024-04-04 12:55:12.128509', 64, 0, 0);
INSERT INTO public.event VALUES (1414, '2024-04-04 12:55:12.528678', 65, 0, 0);
INSERT INTO public.event VALUES (1415, '2024-04-04 12:55:12.92887', 66, 1, 0);
INSERT INTO public.event VALUES (1416, '2024-04-04 12:55:13.328934', 67, 0, 0);
INSERT INTO public.event VALUES (1417, '2024-04-04 12:55:13.729041', 68, 1, 0);
INSERT INTO public.event VALUES (1418, '2024-04-04 12:55:15.729958', 64, 1, 0);
INSERT INTO public.event VALUES (1419, '2024-04-04 12:55:16.130138', 65, 0, 0);
INSERT INTO public.event VALUES (1420, '2024-04-04 12:55:16.530225', 66, 1, 0);
INSERT INTO public.event VALUES (1421, '2024-04-04 12:55:16.930407', 67, 0, 0);
INSERT INTO public.event VALUES (1422, '2024-04-04 12:55:17.330564', 68, 1, 0);
INSERT INTO public.event VALUES (1423, '2024-04-04 12:55:19.331413', 64, 1, 0);
INSERT INTO public.event VALUES (1424, '2024-04-04 12:55:19.731595', 65, 0, 0);
INSERT INTO public.event VALUES (1425, '2024-04-04 12:55:20.13177', 66, 0, 0);
INSERT INTO public.event VALUES (1426, '2024-04-04 12:55:20.531927', 67, 1, 0);
INSERT INTO public.event VALUES (1427, '2024-04-04 12:55:20.932003', 68, 1, 0);
INSERT INTO public.event VALUES (1428, '2024-04-04 12:55:22.932798', 64, 0, 0);
INSERT INTO public.event VALUES (1429, '2024-04-04 12:55:23.332974', 65, 0, 0);
INSERT INTO public.event VALUES (1430, '2024-04-04 12:55:23.733137', 66, 0, 0);
INSERT INTO public.event VALUES (1431, '2024-04-04 12:55:24.133317', 67, 1, 0);
INSERT INTO public.event VALUES (1432, '2024-04-04 12:55:24.533436', 68, 1, 0);
INSERT INTO public.event VALUES (1433, '2024-04-04 12:55:26.534279', 64, 1, 0);
INSERT INTO public.event VALUES (1434, '2024-04-04 12:55:26.934345', 65, 1, 0);
INSERT INTO public.event VALUES (1435, '2024-04-04 12:55:27.334525', 66, 1, 0);
INSERT INTO public.event VALUES (1436, '2024-04-04 12:55:27.734588', 67, 0, 0);
INSERT INTO public.event VALUES (1437, '2024-04-04 12:55:28.134767', 68, 1, 0);
INSERT INTO public.event VALUES (1438, '2024-04-04 12:55:30.135453', 64, 1, 0);
INSERT INTO public.event VALUES (1439, '2024-04-04 12:55:30.535519', 65, 1, 0);
INSERT INTO public.event VALUES (1440, '2024-04-04 12:55:30.935698', 66, 1, 0);
INSERT INTO public.event VALUES (1441, '2024-04-04 12:55:31.335873', 67, 0, 0);
INSERT INTO public.event VALUES (1442, '2024-04-04 12:55:31.736038', 68, 0, 0);
INSERT INTO public.event VALUES (1443, '2024-04-04 12:55:33.736884', 64, 1, 0);
INSERT INTO public.event VALUES (1444, '2024-04-04 12:55:34.136951', 65, 1, 0);
INSERT INTO public.event VALUES (1445, '2024-04-04 12:55:34.537059', 66, 0, 0);
INSERT INTO public.event VALUES (1446, '2024-04-04 12:55:34.937259', 67, 1, 0);
INSERT INTO public.event VALUES (1447, '2024-04-04 12:55:35.337372', 68, 1, 0);
INSERT INTO public.event VALUES (1448, '2024-04-04 12:55:37.338253', 64, 1, 0);
INSERT INTO public.event VALUES (1449, '2024-04-04 12:55:37.738434', 65, 0, 0);
INSERT INTO public.event VALUES (1450, '2024-04-04 12:55:38.13863', 66, 1, 0);
INSERT INTO public.event VALUES (1451, '2024-04-04 12:55:38.53884', 67, 1, 0);
INSERT INTO public.event VALUES (1452, '2024-04-04 12:55:38.938994', 68, 0, 0);
INSERT INTO public.event VALUES (1453, '2024-04-04 12:55:40.939587', 64, 1, 0);
INSERT INTO public.event VALUES (1454, '2024-04-04 12:55:41.339767', 65, 1, 0);
INSERT INTO public.event VALUES (1455, '2024-04-04 12:55:41.739963', 66, 1, 0);
INSERT INTO public.event VALUES (1456, '2024-04-04 12:55:42.140148', 67, 0, 0);
INSERT INTO public.event VALUES (1457, '2024-04-04 12:55:42.540235', 68, 1, 0);
INSERT INTO public.event VALUES (1458, '2024-04-04 12:55:44.541109', 64, 1, 0);
INSERT INTO public.event VALUES (1459, '2024-04-04 12:55:44.941172', 65, 1, 0);
INSERT INTO public.event VALUES (1460, '2024-04-04 12:55:45.341355', 66, 0, 0);
INSERT INTO public.event VALUES (1461, '2024-04-04 12:55:45.741457', 67, 0, 0);
INSERT INTO public.event VALUES (1462, '2024-04-04 12:55:46.141617', 68, 1, 0);
INSERT INTO public.event VALUES (1463, '2024-04-04 12:55:48.142559', 64, 1, 0);
INSERT INTO public.event VALUES (1464, '2024-04-04 12:55:48.542729', 65, 1, 0);
INSERT INTO public.event VALUES (1465, '2024-04-04 12:55:48.942916', 66, 1, 0);
INSERT INTO public.event VALUES (1466, '2024-04-04 12:55:49.343091', 67, 1, 0);
INSERT INTO public.event VALUES (1467, '2024-04-04 12:55:49.743161', 68, 1, 0);
INSERT INTO public.event VALUES (1468, '2024-04-04 12:55:51.743827', 64, 1, 0);
INSERT INTO public.event VALUES (1469, '2024-04-04 12:55:52.144005', 65, 0, 0);
INSERT INTO public.event VALUES (1470, '2024-04-04 12:55:52.544086', 66, 1, 0);
INSERT INTO public.event VALUES (1471, '2024-04-04 12:55:52.944276', 67, 0, 0);
INSERT INTO public.event VALUES (1472, '2024-04-04 12:55:53.344465', 68, 1, 0);
INSERT INTO public.event VALUES (1473, '2024-04-04 12:55:55.345211', 64, 0, 0);
INSERT INTO public.event VALUES (1474, '2024-04-04 12:55:55.74529', 65, 0, 0);
INSERT INTO public.event VALUES (1475, '2024-04-04 12:55:56.145362', 66, 1, 0);
INSERT INTO public.event VALUES (1476, '2024-04-04 12:55:56.545431', 67, 0, 0);
INSERT INTO public.event VALUES (1477, '2024-04-04 12:55:56.94549', 68, 1, 0);
INSERT INTO public.event VALUES (1478, '2024-04-04 12:55:58.94602', 64, 0, 0);
INSERT INTO public.event VALUES (1479, '2024-04-04 12:55:59.346191', 65, 1, 0);
INSERT INTO public.event VALUES (1480, '2024-04-04 12:55:59.746254', 66, 1, 0);
INSERT INTO public.event VALUES (1481, '2024-04-04 12:56:00.146422', 67, 0, 0);
INSERT INTO public.event VALUES (1482, '2024-04-04 12:56:00.546483', 68, 0, 0);
INSERT INTO public.event VALUES (1483, '2024-04-04 12:56:02.547113', 64, 0, 0);
INSERT INTO public.event VALUES (1484, '2024-04-04 12:56:02.94718', 65, 1, 0);
INSERT INTO public.event VALUES (1485, '2024-04-04 12:56:03.347245', 66, 1, 0);
INSERT INTO public.event VALUES (1486, '2024-04-04 12:56:03.747336', 67, 0, 0);
INSERT INTO public.event VALUES (1487, '2024-04-04 12:56:04.147394', 68, 1, 0);
INSERT INTO public.event VALUES (1488, '2024-04-04 12:56:06.148172', 64, 1, 0);
INSERT INTO public.event VALUES (1489, '2024-04-04 12:56:06.548331', 65, 0, 0);
INSERT INTO public.event VALUES (1490, '2024-04-04 12:56:06.948501', 66, 0, 0);
INSERT INTO public.event VALUES (1491, '2024-04-04 12:56:07.348715', 67, 1, 0);
INSERT INTO public.event VALUES (1492, '2024-04-04 12:56:07.748824', 68, 1, 0);
INSERT INTO public.event VALUES (1493, '2024-04-04 12:56:09.749482', 64, 1, 0);
INSERT INTO public.event VALUES (1494, '2024-04-04 12:56:10.14966', 65, 0, 0);
INSERT INTO public.event VALUES (1495, '2024-04-04 12:56:10.549824', 66, 1, 0);
INSERT INTO public.event VALUES (1496, '2024-04-04 12:56:10.950006', 67, 0, 0);
INSERT INTO public.event VALUES (1497, '2024-04-04 12:56:11.350192', 68, 0, 0);
INSERT INTO public.event VALUES (1498, '2024-04-04 12:56:13.35109', 64, 1, 0);
INSERT INTO public.event VALUES (1499, '2024-04-04 12:56:13.751249', 65, 1, 0);
INSERT INTO public.event VALUES (1500, '2024-04-04 12:56:14.151411', 66, 0, 0);
INSERT INTO public.event VALUES (1501, '2024-04-04 12:56:14.551574', 67, 0, 0);
INSERT INTO public.event VALUES (1502, '2024-04-04 12:56:14.951743', 68, 0, 0);
INSERT INTO public.event VALUES (1503, '2024-04-04 12:56:16.952465', 64, 1, 0);
INSERT INTO public.event VALUES (1504, '2024-04-04 12:56:17.352542', 65, 0, 0);
INSERT INTO public.event VALUES (1505, '2024-04-04 12:56:17.752723', 66, 1, 0);
INSERT INTO public.event VALUES (1506, '2024-04-04 12:56:18.15278', 67, 1, 0);
INSERT INTO public.event VALUES (1507, '2024-04-04 12:56:18.552846', 68, 0, 0);
INSERT INTO public.event VALUES (1508, '2024-04-04 12:56:20.55358', 64, 1, 0);
INSERT INTO public.event VALUES (1509, '2024-04-04 12:56:20.953663', 65, 0, 0);
INSERT INTO public.event VALUES (1510, '2024-04-04 12:56:21.353852', 66, 1, 0);
INSERT INTO public.event VALUES (1511, '2024-04-04 12:56:21.754001', 67, 1, 0);
INSERT INTO public.event VALUES (1512, '2024-04-04 12:56:22.154322', 68, 0, 0);
INSERT INTO public.event VALUES (1513, '2024-04-04 12:56:24.155224', 64, 1, 0);
INSERT INTO public.event VALUES (1514, '2024-04-04 12:56:24.555413', 65, 0, 0);
INSERT INTO public.event VALUES (1515, '2024-04-04 12:56:24.95562', 66, 0, 0);
INSERT INTO public.event VALUES (1516, '2024-04-04 12:56:25.355794', 67, 0, 0);
INSERT INTO public.event VALUES (1517, '2024-04-04 12:56:25.755982', 68, 1, 0);
INSERT INTO public.event VALUES (1518, '2024-04-04 12:56:27.756753', 64, 0, 0);
INSERT INTO public.event VALUES (1519, '2024-04-04 12:56:28.156934', 65, 1, 0);
INSERT INTO public.event VALUES (1520, '2024-04-04 12:56:28.557129', 66, 0, 0);
INSERT INTO public.event VALUES (1521, '2024-04-04 12:56:28.957228', 67, 1, 0);
INSERT INTO public.event VALUES (1522, '2024-04-04 12:56:29.357415', 68, 1, 0);
INSERT INTO public.event VALUES (1523, '2024-04-04 12:56:31.358361', 64, 0, 0);
INSERT INTO public.event VALUES (1524, '2024-04-04 12:56:31.758523', 65, 1, 0);
INSERT INTO public.event VALUES (1525, '2024-04-04 12:56:32.158704', 66, 0, 0);
INSERT INTO public.event VALUES (1526, '2024-04-04 12:56:32.558894', 67, 0, 0);
INSERT INTO public.event VALUES (1527, '2024-04-04 12:56:32.958961', 68, 1, 0);
INSERT INTO public.event VALUES (1528, '2024-04-04 12:56:34.959685', 64, 0, 0);
INSERT INTO public.event VALUES (1529, '2024-04-04 12:56:35.359851', 65, 0, 0);
INSERT INTO public.event VALUES (1530, '2024-04-04 12:56:35.760018', 66, 1, 0);
INSERT INTO public.event VALUES (1531, '2024-04-04 12:56:36.160076', 67, 0, 0);
INSERT INTO public.event VALUES (1532, '2024-04-04 12:56:36.560153', 68, 1, 0);
INSERT INTO public.event VALUES (1533, '2024-04-04 13:02:18.404815', 64, 0, 0);
INSERT INTO public.event VALUES (1534, '2024-04-04 13:02:18.805003', 65, 0, 0);
INSERT INTO public.event VALUES (1535, '2024-04-04 13:02:19.205065', 66, 1, 0);
INSERT INTO public.event VALUES (1536, '2024-04-04 13:02:19.60523', 67, 1, 0);
INSERT INTO public.event VALUES (1537, '2024-04-04 13:02:20.005386', 68, 1, 0);
INSERT INTO public.event VALUES (1538, '2024-04-04 13:02:22.00597', 64, 1, 0);
INSERT INTO public.event VALUES (1539, '2024-04-04 13:02:22.406093', 65, 0, 0);
INSERT INTO public.event VALUES (1540, '2024-04-04 13:02:22.806163', 66, 1, 0);
INSERT INTO public.event VALUES (1541, '2024-04-04 13:02:23.206335', 67, 0, 0);
INSERT INTO public.event VALUES (1542, '2024-04-04 13:02:23.606446', 68, 1, 0);
INSERT INTO public.event VALUES (1543, '2024-04-04 13:02:25.607073', 64, 0, 0);
INSERT INTO public.event VALUES (1544, '2024-04-04 13:02:26.007238', 65, 1, 0);
INSERT INTO public.event VALUES (1545, '2024-04-04 13:02:26.407401', 66, 1, 0);
INSERT INTO public.event VALUES (1546, '2024-04-04 13:02:26.807565', 67, 1, 0);
INSERT INTO public.event VALUES (1547, '2024-04-04 13:02:27.207721', 68, 0, 0);
INSERT INTO public.event VALUES (1548, '2024-04-04 13:02:29.208408', 64, 1, 0);
INSERT INTO public.event VALUES (1549, '2024-04-04 13:02:29.608582', 65, 0, 0);
INSERT INTO public.event VALUES (1550, '2024-04-04 13:02:30.008681', 66, 1, 0);
INSERT INTO public.event VALUES (1551, '2024-04-04 13:02:30.408813', 67, 0, 0);
INSERT INTO public.event VALUES (1552, '2024-04-04 13:02:30.808882', 68, 1, 0);
INSERT INTO public.event VALUES (1553, '2024-04-04 13:02:32.809397', 64, 0, 0);
INSERT INTO public.event VALUES (1554, '2024-04-04 13:02:33.209492', 65, 1, 0);
INSERT INTO public.event VALUES (1555, '2024-04-04 13:02:33.609671', 66, 0, 0);
INSERT INTO public.event VALUES (1556, '2024-04-04 13:02:34.009864', 67, 0, 0);
INSERT INTO public.event VALUES (1557, '2024-04-04 13:02:34.410051', 68, 0, 0);
INSERT INTO public.event VALUES (1558, '2024-04-04 13:02:36.410829', 64, 0, 0);
INSERT INTO public.event VALUES (1559, '2024-04-04 13:02:36.811014', 65, 0, 0);
INSERT INTO public.event VALUES (1560, '2024-04-04 13:02:37.211191', 66, 0, 0);
INSERT INTO public.event VALUES (1561, '2024-04-04 13:02:37.611375', 67, 1, 0);
INSERT INTO public.event VALUES (1562, '2024-04-04 13:02:38.011567', 68, 0, 0);
INSERT INTO public.event VALUES (1563, '2024-04-04 13:04:16.5563', 64, 0, 0);
INSERT INTO public.event VALUES (1564, '2024-04-04 13:04:16.956468', 65, 0, 0);
INSERT INTO public.event VALUES (1565, '2024-04-04 13:04:17.35664', 66, 0, 0);
INSERT INTO public.event VALUES (1566, '2024-04-04 13:04:17.756824', 67, 1, 0);
INSERT INTO public.event VALUES (1567, '2024-04-04 13:04:18.156889', 68, 1, 0);
INSERT INTO public.event VALUES (1568, '2024-04-04 13:04:20.157448', 64, 1, 0);
INSERT INTO public.event VALUES (1569, '2024-04-04 13:04:20.557635', 65, 0, 0);
INSERT INTO public.event VALUES (1570, '2024-04-04 13:04:20.957736', 66, 0, 0);
INSERT INTO public.event VALUES (1571, '2024-04-04 13:04:21.357922', 67, 1, 0);
INSERT INTO public.event VALUES (1572, '2024-04-04 13:04:21.758108', 68, 1, 0);
INSERT INTO public.event VALUES (1573, '2024-04-04 13:04:23.759013', 64, 1, 0);
INSERT INTO public.event VALUES (1574, '2024-04-04 13:05:17.913697', 65, 1, 0);
INSERT INTO public.event VALUES (1575, '2024-04-04 13:05:18.31379', 66, 0, 0);
INSERT INTO public.event VALUES (1576, '2024-04-04 13:05:18.713947', 67, 0, 0);
INSERT INTO public.event VALUES (1577, '2024-04-04 13:05:19.114107', 68, 1, 0);
INSERT INTO public.event VALUES (1578, '2024-04-04 13:05:21.11483', 64, 0, 0);
INSERT INTO public.event VALUES (1579, '2024-04-04 13:05:21.515006', 65, 0, 0);
INSERT INTO public.event VALUES (1580, '2024-04-04 13:05:21.915178', 66, 1, 0);
INSERT INTO public.event VALUES (1581, '2024-04-04 13:05:22.315373', 67, 1, 0);
INSERT INTO public.event VALUES (1582, '2024-04-04 13:05:22.715457', 68, 0, 0);
INSERT INTO public.event VALUES (1583, '2024-04-04 13:05:24.715925', 64, 1, 0);
INSERT INTO public.event VALUES (1584, '2024-04-04 13:05:25.116106', 65, 0, 0);
INSERT INTO public.event VALUES (1585, '2024-04-04 13:05:25.516275', 66, 1, 0);
INSERT INTO public.event VALUES (1586, '2024-04-04 13:05:25.916353', 67, 0, 0);
INSERT INTO public.event VALUES (1587, '2024-04-04 13:05:26.316524', 68, 1, 0);
INSERT INTO public.event VALUES (1588, '2024-04-04 13:05:28.317106', 64, 1, 0);
INSERT INTO public.event VALUES (1589, '2024-04-04 13:05:28.717292', 65, 1, 0);
INSERT INTO public.event VALUES (1590, '2024-04-04 13:05:29.117462', 66, 1, 0);
INSERT INTO public.event VALUES (1591, '2024-04-04 13:05:29.517608', 67, 0, 0);
INSERT INTO public.event VALUES (1592, '2024-04-04 13:05:29.917672', 68, 1, 0);
INSERT INTO public.event VALUES (1593, '2024-04-04 13:05:31.918192', 64, 0, 0);
INSERT INTO public.event VALUES (1594, '2024-04-04 13:05:32.318351', 65, 0, 0);
INSERT INTO public.event VALUES (1595, '2024-04-04 13:05:32.718473', 66, 1, 0);
INSERT INTO public.event VALUES (1596, '2024-04-04 13:05:33.118532', 67, 0, 0);
INSERT INTO public.event VALUES (1597, '2024-04-04 13:05:33.518679', 68, 1, 0);
INSERT INTO public.event VALUES (1598, '2024-04-04 13:05:35.519367', 64, 1, 0);
INSERT INTO public.event VALUES (1599, '2024-04-04 13:05:35.919429', 65, 0, 0);
INSERT INTO public.event VALUES (1600, '2024-04-04 13:05:36.319619', 66, 1, 0);
INSERT INTO public.event VALUES (1601, '2024-04-04 13:09:26.56518', 64, 1, 0);
INSERT INTO public.event VALUES (1602, '2024-04-04 13:09:26.965284', 65, 1, 0);
INSERT INTO public.event VALUES (1603, '2024-04-04 13:09:27.365359', 66, 1, 0);
INSERT INTO public.event VALUES (1604, '2024-04-04 13:09:27.765431', 67, 0, 0);
INSERT INTO public.event VALUES (1605, '2024-04-04 13:09:28.165486', 68, 0, 0);
INSERT INTO public.event VALUES (1606, '2024-04-04 13:10:45.392915', 64, 0, 0);
INSERT INTO public.event VALUES (1607, '2024-04-04 13:10:45.792982', 65, 0, 0);
INSERT INTO public.event VALUES (1608, '2024-04-04 13:10:46.193197', 66, 0, 0);
INSERT INTO public.event VALUES (1609, '2024-04-04 13:10:46.593376', 67, 1, 0);
INSERT INTO public.event VALUES (1610, '2024-04-04 13:10:46.993572', 68, 1, 0);
INSERT INTO public.event VALUES (1611, '2024-04-04 13:10:48.994368', 64, 1, 0);
INSERT INTO public.event VALUES (1612, '2024-04-04 13:10:49.394567', 65, 1, 0);
INSERT INTO public.event VALUES (1613, '2024-04-04 13:10:49.794738', 66, 1, 0);
INSERT INTO public.event VALUES (1614, '2024-04-04 13:10:50.194904', 67, 1, 0);
INSERT INTO public.event VALUES (1615, '2024-04-04 13:10:50.595068', 68, 0, 0);
INSERT INTO public.event VALUES (1616, '2024-04-04 13:10:52.595762', 64, 1, 0);
INSERT INTO public.event VALUES (1617, '2024-04-04 13:10:52.995954', 65, 0, 0);
INSERT INTO public.event VALUES (1618, '2024-04-04 13:10:53.396134', 66, 0, 0);
INSERT INTO public.event VALUES (1619, '2024-04-04 13:10:53.796321', 67, 1, 0);
INSERT INTO public.event VALUES (1620, '2024-04-04 13:10:54.1965', 68, 1, 0);
INSERT INTO public.event VALUES (1621, '2024-04-04 13:10:56.197185', 64, 1, 0);
INSERT INTO public.event VALUES (1622, '2024-04-04 13:10:56.597252', 65, 1, 0);
INSERT INTO public.event VALUES (1623, '2024-04-04 13:10:56.997472', 66, 1, 0);
INSERT INTO public.event VALUES (1624, '2024-04-04 13:10:57.397648', 67, 1, 0);
INSERT INTO public.event VALUES (1625, '2024-04-04 13:10:57.7978', 68, 0, 0);
INSERT INTO public.event VALUES (1626, '2024-04-04 13:10:59.798753', 64, 1, 0);
INSERT INTO public.event VALUES (1627, '2024-04-04 13:11:00.198942', 65, 1, 0);
INSERT INTO public.event VALUES (1628, '2024-04-04 13:11:00.599124', 66, 1, 0);
INSERT INTO public.event VALUES (1629, '2024-04-04 13:11:00.999339', 67, 1, 0);
INSERT INTO public.event VALUES (1630, '2024-04-04 13:11:01.39952', 68, 1, 0);
INSERT INTO public.event VALUES (1631, '2024-04-04 13:11:03.400318', 64, 1, 0);
INSERT INTO public.event VALUES (1632, '2024-04-04 13:11:03.800518', 65, 0, 0);
INSERT INTO public.event VALUES (1633, '2024-04-04 13:11:04.200718', 66, 0, 0);
INSERT INTO public.event VALUES (1634, '2024-04-04 13:11:04.60092', 67, 1, 0);
INSERT INTO public.event VALUES (1635, '2024-04-04 13:11:05.00099', 68, 0, 0);
INSERT INTO public.event VALUES (1636, '2024-04-04 13:11:07.001936', 64, 0, 0);
INSERT INTO public.event VALUES (1637, '2024-04-04 13:11:07.402157', 65, 1, 0);
INSERT INTO public.event VALUES (1638, '2024-04-04 13:11:07.802354', 66, 1, 0);
INSERT INTO public.event VALUES (1639, '2024-04-04 13:11:08.202563', 67, 0, 0);
INSERT INTO public.event VALUES (1640, '2024-04-04 13:11:08.602777', 68, 1, 0);
INSERT INTO public.event VALUES (1641, '2024-04-04 13:11:10.603714', 64, 1, 0);
INSERT INTO public.event VALUES (1642, '2024-04-04 13:11:11.003895', 65, 0, 0);
INSERT INTO public.event VALUES (1643, '2024-04-04 13:11:11.403969', 66, 1, 0);
INSERT INTO public.event VALUES (1644, '2024-04-04 13:11:11.804046', 67, 1, 0);
INSERT INTO public.event VALUES (1645, '2024-04-04 13:11:12.204104', 68, 0, 0);
INSERT INTO public.event VALUES (1646, '2024-04-04 13:11:14.204971', 64, 0, 0);
INSERT INTO public.event VALUES (1647, '2024-04-04 13:11:14.605185', 65, 0, 0);
INSERT INTO public.event VALUES (1648, '2024-04-04 13:11:15.00539', 66, 1, 0);
INSERT INTO public.event VALUES (1649, '2024-04-04 13:11:15.405587', 67, 1, 0);
INSERT INTO public.event VALUES (1650, '2024-04-04 13:11:15.805786', 68, 0, 0);
INSERT INTO public.event VALUES (1651, '2024-04-04 13:11:17.806592', 64, 1, 0);
INSERT INTO public.event VALUES (1652, '2024-04-04 13:11:18.206762', 65, 0, 0);
INSERT INTO public.event VALUES (1653, '2024-04-04 13:11:18.606944', 66, 1, 0);
INSERT INTO public.event VALUES (1654, '2024-04-04 13:11:19.007061', 67, 1, 0);
INSERT INTO public.event VALUES (1655, '2024-04-04 13:11:19.407203', 68, 1, 0);
INSERT INTO public.event VALUES (1656, '2024-04-04 13:11:21.407952', 64, 1, 0);
INSERT INTO public.event VALUES (1657, '2024-04-04 13:11:21.808155', 65, 1, 0);
INSERT INTO public.event VALUES (1658, '2024-04-04 13:11:22.208344', 66, 0, 0);
INSERT INTO public.event VALUES (1659, '2024-04-04 13:11:22.608592', 67, 0, 0);
INSERT INTO public.event VALUES (1660, '2024-04-04 13:11:23.008816', 68, 0, 0);
INSERT INTO public.event VALUES (1661, '2024-04-04 13:11:25.009843', 64, 1, 0);
INSERT INTO public.event VALUES (1662, '2024-04-04 13:11:25.410069', 65, 0, 0);
INSERT INTO public.event VALUES (1663, '2024-04-04 13:11:25.810266', 66, 0, 0);
INSERT INTO public.event VALUES (1664, '2024-04-04 13:11:26.210382', 67, 0, 0);
INSERT INTO public.event VALUES (1665, '2024-04-04 13:11:26.610566', 68, 1, 0);
INSERT INTO public.event VALUES (1666, '2024-04-04 13:11:28.611549', 64, 0, 0);
INSERT INTO public.event VALUES (1667, '2024-04-04 13:11:29.011747', 65, 1, 0);
INSERT INTO public.event VALUES (1668, '2024-04-04 13:11:29.411951', 66, 0, 0);
INSERT INTO public.event VALUES (1669, '2024-04-04 13:11:29.812132', 67, 0, 0);
INSERT INTO public.event VALUES (1670, '2024-04-04 13:11:30.212336', 68, 0, 0);
INSERT INTO public.event VALUES (1671, '2024-04-04 13:11:32.213215', 64, 0, 0);
INSERT INTO public.event VALUES (1672, '2024-04-04 13:11:32.613393', 65, 1, 0);
INSERT INTO public.event VALUES (1673, '2024-04-04 13:11:33.013569', 66, 1, 0);
INSERT INTO public.event VALUES (1674, '2024-04-04 13:11:33.413749', 67, 0, 0);
INSERT INTO public.event VALUES (1675, '2024-04-04 13:11:33.813948', 68, 0, 0);
INSERT INTO public.event VALUES (1676, '2024-04-04 13:11:35.814908', 64, 1, 0);
INSERT INTO public.event VALUES (1677, '2024-04-04 13:11:36.215112', 65, 1, 0);
INSERT INTO public.event VALUES (1678, '2024-04-04 13:11:36.61531', 66, 0, 0);
INSERT INTO public.event VALUES (1679, '2024-04-04 13:11:37.015504', 67, 0, 0);
INSERT INTO public.event VALUES (1680, '2024-04-04 13:11:37.415696', 68, 0, 0);
INSERT INTO public.event VALUES (1681, '2024-04-04 13:11:39.41661', 64, 1, 0);
INSERT INTO public.event VALUES (1682, '2024-04-04 13:11:39.81682', 65, 0, 0);
INSERT INTO public.event VALUES (1683, '2024-04-04 13:11:40.217025', 66, 1, 0);
INSERT INTO public.event VALUES (1684, '2024-04-04 13:11:40.617217', 67, 1, 0);
INSERT INTO public.event VALUES (1685, '2024-04-04 13:11:41.017423', 68, 0, 0);
INSERT INTO public.event VALUES (1686, '2024-04-04 13:11:43.018435', 64, 0, 0);
INSERT INTO public.event VALUES (1687, '2024-04-04 13:11:43.418635', 65, 0, 0);
INSERT INTO public.event VALUES (1688, '2024-04-04 13:11:43.818842', 66, 1, 0);
INSERT INTO public.event VALUES (1689, '2024-04-04 13:11:44.219065', 67, 0, 0);
INSERT INTO public.event VALUES (1690, '2024-04-04 13:11:44.619254', 68, 1, 0);
INSERT INTO public.event VALUES (1691, '2024-04-04 13:11:46.620258', 64, 0, 0);
INSERT INTO public.event VALUES (1692, '2024-04-04 13:11:47.020359', 65, 0, 0);
INSERT INTO public.event VALUES (1693, '2024-04-04 13:11:47.420565', 66, 1, 0);
INSERT INTO public.event VALUES (1694, '2024-04-04 13:11:47.820685', 67, 0, 0);
INSERT INTO public.event VALUES (1695, '2024-04-04 13:11:48.220749', 68, 0, 0);
INSERT INTO public.event VALUES (1696, '2024-04-04 13:11:50.221721', 64, 1, 0);
INSERT INTO public.event VALUES (1697, '2024-04-04 13:11:50.621943', 65, 1, 0);
INSERT INTO public.event VALUES (1698, '2024-04-04 13:11:51.022138', 66, 0, 0);
INSERT INTO public.event VALUES (1699, '2024-04-04 13:11:51.422323', 67, 1, 0);
INSERT INTO public.event VALUES (1700, '2024-04-04 13:11:51.822528', 68, 1, 0);
INSERT INTO public.event VALUES (1701, '2024-04-04 13:11:53.823572', 64, 0, 0);
INSERT INTO public.event VALUES (1702, '2024-04-04 13:11:54.223752', 65, 1, 0);
INSERT INTO public.event VALUES (1703, '2024-04-04 13:11:54.623933', 66, 1, 0);
INSERT INTO public.event VALUES (1704, '2024-04-04 13:11:55.024114', 67, 0, 0);
INSERT INTO public.event VALUES (1705, '2024-04-04 13:11:55.424317', 68, 1, 0);
INSERT INTO public.event VALUES (1706, '2024-04-04 13:11:57.425102', 64, 0, 0);
INSERT INTO public.event VALUES (1707, '2024-04-04 13:11:57.825283', 65, 1, 0);
INSERT INTO public.event VALUES (1708, '2024-04-04 13:11:58.225466', 66, 0, 0);
INSERT INTO public.event VALUES (1709, '2024-04-04 13:11:58.625638', 67, 1, 0);
INSERT INTO public.event VALUES (1710, '2024-04-04 13:11:59.025816', 68, 0, 0);
INSERT INTO public.event VALUES (1711, '2024-04-04 13:12:01.026579', 64, 1, 0);
INSERT INTO public.event VALUES (1712, '2024-04-04 13:12:01.426744', 65, 1, 0);
INSERT INTO public.event VALUES (1713, '2024-04-04 13:12:01.826922', 66, 0, 0);
INSERT INTO public.event VALUES (1714, '2024-04-04 13:12:02.226982', 67, 0, 0);
INSERT INTO public.event VALUES (1715, '2024-04-04 13:12:02.627166', 68, 1, 0);
INSERT INTO public.event VALUES (1716, '2024-04-04 13:12:04.627875', 64, 1, 0);
INSERT INTO public.event VALUES (1717, '2024-04-04 13:12:05.028068', 65, 0, 0);
INSERT INTO public.event VALUES (1718, '2024-04-04 13:12:05.428255', 66, 1, 0);
INSERT INTO public.event VALUES (1719, '2024-04-04 13:12:05.828437', 67, 0, 0);
INSERT INTO public.event VALUES (1720, '2024-04-04 13:12:06.2286', 68, 1, 0);
INSERT INTO public.event VALUES (1721, '2024-04-04 13:12:08.229431', 64, 1, 0);
INSERT INTO public.event VALUES (1722, '2024-04-04 13:12:08.629623', 65, 0, 0);
INSERT INTO public.event VALUES (1723, '2024-04-04 13:12:09.029825', 66, 1, 0);
INSERT INTO public.event VALUES (1724, '2024-04-04 13:12:09.429888', 67, 0, 0);
INSERT INTO public.event VALUES (1725, '2024-04-04 13:12:09.830038', 68, 0, 0);
INSERT INTO public.event VALUES (1726, '2024-04-04 13:12:11.830802', 64, 0, 0);
INSERT INTO public.event VALUES (1727, '2024-04-04 13:12:12.230881', 65, 1, 0);
INSERT INTO public.event VALUES (1728, '2024-04-04 13:12:12.631059', 66, 1, 0);
INSERT INTO public.event VALUES (1729, '2024-04-04 13:12:13.03123', 67, 1, 0);
INSERT INTO public.event VALUES (1730, '2024-04-04 13:12:13.431408', 68, 1, 0);
INSERT INTO public.event VALUES (1731, '2024-04-04 13:12:15.432235', 64, 1, 0);
INSERT INTO public.event VALUES (1732, '2024-04-04 13:12:15.832414', 65, 1, 0);
INSERT INTO public.event VALUES (1733, '2024-04-04 13:12:16.232603', 66, 1, 0);
INSERT INTO public.event VALUES (1734, '2024-04-04 13:12:16.632769', 67, 1, 0);
INSERT INTO public.event VALUES (1735, '2024-04-04 13:12:17.032843', 68, 1, 0);
INSERT INTO public.event VALUES (1736, '2024-04-04 13:12:19.033655', 64, 0, 0);
INSERT INTO public.event VALUES (1737, '2024-04-04 13:12:19.433813', 65, 1, 0);
INSERT INTO public.event VALUES (1738, '2024-04-04 13:12:19.833993', 66, 0, 0);
INSERT INTO public.event VALUES (1739, '2024-04-04 13:12:20.234056', 67, 1, 0);
INSERT INTO public.event VALUES (1740, '2024-04-04 13:12:20.634213', 68, 1, 0);
INSERT INTO public.event VALUES (1741, '2024-04-04 13:12:22.634905', 64, 1, 0);
INSERT INTO public.event VALUES (1742, '2024-04-04 13:12:23.03506', 65, 1, 0);
INSERT INTO public.event VALUES (1743, '2024-04-04 13:12:23.435222', 66, 0, 0);
INSERT INTO public.event VALUES (1744, '2024-04-04 13:12:23.835286', 67, 0, 0);
INSERT INTO public.event VALUES (1745, '2024-04-04 13:12:24.235457', 68, 1, 0);
INSERT INTO public.event VALUES (1746, '2024-04-04 13:12:26.236319', 64, 1, 0);
INSERT INTO public.event VALUES (1747, '2024-04-04 13:12:26.636377', 65, 1, 0);
INSERT INTO public.event VALUES (1748, '2024-04-04 13:12:27.036561', 66, 1, 0);
INSERT INTO public.event VALUES (1749, '2024-04-04 13:12:27.436755', 67, 0, 0);
INSERT INTO public.event VALUES (1750, '2024-04-04 13:12:27.836823', 68, 1, 0);
INSERT INTO public.event VALUES (1751, '2024-04-04 13:12:29.837389', 64, 1, 0);
INSERT INTO public.event VALUES (1752, '2024-04-04 13:12:30.237571', 65, 1, 0);
INSERT INTO public.event VALUES (1753, '2024-04-04 13:12:30.637727', 66, 0, 0);
INSERT INTO public.event VALUES (1754, '2024-04-04 13:12:31.03791', 67, 1, 0);
INSERT INTO public.event VALUES (1755, '2024-04-04 13:12:31.438074', 68, 0, 0);
INSERT INTO public.event VALUES (1756, '2024-04-04 13:12:33.438927', 64, 1, 0);
INSERT INTO public.event VALUES (1757, '2024-04-04 13:12:33.839106', 65, 0, 0);
INSERT INTO public.event VALUES (1758, '2024-04-04 13:12:34.239267', 66, 1, 0);
INSERT INTO public.event VALUES (1759, '2024-04-04 13:12:34.639338', 67, 0, 0);
INSERT INTO public.event VALUES (1760, '2024-04-04 13:12:35.039526', 68, 0, 0);
INSERT INTO public.event VALUES (1761, '2024-04-04 13:12:37.040288', 64, 0, 0);
INSERT INTO public.event VALUES (1762, '2024-04-04 13:12:37.440428', 65, 0, 0);
INSERT INTO public.event VALUES (1763, '2024-04-04 13:12:37.840607', 66, 0, 0);
INSERT INTO public.event VALUES (1764, '2024-04-04 13:12:38.240796', 67, 1, 0);
INSERT INTO public.event VALUES (1765, '2024-04-04 13:12:38.640855', 68, 1, 0);
INSERT INTO public.event VALUES (1766, '2024-04-04 13:12:40.641356', 64, 0, 0);
INSERT INTO public.event VALUES (1767, '2024-04-04 13:12:41.041548', 65, 1, 0);
INSERT INTO public.event VALUES (1768, '2024-04-04 13:12:41.441612', 66, 0, 0);
INSERT INTO public.event VALUES (1769, '2024-04-04 13:12:41.841669', 67, 1, 0);
INSERT INTO public.event VALUES (1770, '2024-04-04 13:12:42.241766', 68, 0, 0);
INSERT INTO public.event VALUES (1771, '2024-04-04 13:12:44.242217', 64, 1, 0);
INSERT INTO public.event VALUES (1772, '2024-04-04 13:12:44.642298', 65, 1, 0);
INSERT INTO public.event VALUES (1773, '2024-04-04 13:12:45.042356', 66, 1, 0);
INSERT INTO public.event VALUES (1774, '2024-04-04 13:12:45.442412', 67, 1, 0);
INSERT INTO public.event VALUES (1775, '2024-04-04 13:12:45.842488', 68, 0, 0);
INSERT INTO public.event VALUES (1776, '2024-04-04 13:12:47.842821', 64, 0, 0);
INSERT INTO public.event VALUES (1777, '2024-04-04 13:12:48.243015', 65, 1, 0);
INSERT INTO public.event VALUES (1778, '2024-04-04 13:12:48.643169', 66, 1, 0);
INSERT INTO public.event VALUES (1779, '2024-04-04 13:12:49.04335', 67, 0, 0);
INSERT INTO public.event VALUES (1780, '2024-04-04 13:12:49.443534', 68, 0, 0);
INSERT INTO public.event VALUES (1781, '2024-04-04 13:12:51.444431', 64, 0, 0);
INSERT INTO public.event VALUES (1782, '2024-04-04 13:12:51.844618', 65, 1, 0);
INSERT INTO public.event VALUES (1783, '2024-04-04 13:12:52.24477', 66, 1, 0);
INSERT INTO public.event VALUES (1784, '2024-04-04 13:12:52.644929', 67, 0, 0);
INSERT INTO public.event VALUES (1785, '2024-04-04 13:12:53.045115', 68, 1, 0);
INSERT INTO public.event VALUES (1786, '2024-04-04 13:12:55.045907', 64, 1, 0);
INSERT INTO public.event VALUES (1787, '2024-04-04 13:12:55.446076', 65, 1, 0);
INSERT INTO public.event VALUES (1788, '2024-04-04 13:12:55.846261', 66, 1, 0);
INSERT INTO public.event VALUES (1789, '2024-04-04 13:12:56.246426', 67, 1, 0);
INSERT INTO public.event VALUES (1790, '2024-04-04 13:12:56.646607', 68, 0, 0);
INSERT INTO public.event VALUES (1791, '2024-04-04 13:12:58.647554', 64, 1, 0);
INSERT INTO public.event VALUES (1792, '2024-04-04 13:12:59.047734', 65, 0, 0);
INSERT INTO public.event VALUES (1793, '2024-04-04 13:12:59.447916', 66, 0, 0);
INSERT INTO public.event VALUES (1794, '2024-04-04 13:12:59.848098', 67, 1, 0);
INSERT INTO public.event VALUES (1795, '2024-04-04 13:13:00.248261', 68, 0, 0);
INSERT INTO public.event VALUES (1796, '2024-04-04 13:13:02.249081', 64, 1, 0);
INSERT INTO public.event VALUES (1797, '2024-04-04 13:13:02.64924', 65, 1, 0);
INSERT INTO public.event VALUES (1798, '2024-04-04 13:13:03.049333', 66, 1, 0);
INSERT INTO public.event VALUES (1799, '2024-04-04 13:13:03.449397', 67, 0, 0);
INSERT INTO public.event VALUES (1800, '2024-04-04 13:13:03.849502', 68, 1, 0);
INSERT INTO public.event VALUES (1801, '2024-04-04 13:13:05.850078', 64, 1, 0);
INSERT INTO public.event VALUES (1802, '2024-04-04 13:13:06.250286', 65, 0, 0);
INSERT INTO public.event VALUES (1803, '2024-04-04 13:13:06.650455', 66, 0, 0);
INSERT INTO public.event VALUES (1804, '2024-04-04 13:13:07.05063', 67, 0, 0);
INSERT INTO public.event VALUES (1805, '2024-04-04 13:13:07.4507', 68, 1, 0);
INSERT INTO public.event VALUES (1806, '2024-04-04 13:13:09.451815', 64, 0, 0);
INSERT INTO public.event VALUES (1807, '2024-04-04 13:13:09.852009', 65, 0, 0);
INSERT INTO public.event VALUES (1808, '2024-04-04 13:13:10.252204', 66, 1, 0);
INSERT INTO public.event VALUES (1809, '2024-04-04 13:13:10.65244', 67, 1, 0);
INSERT INTO public.event VALUES (1810, '2024-04-04 13:13:11.052618', 68, 0, 0);
INSERT INTO public.event VALUES (1811, '2024-04-04 13:13:13.053506', 64, 1, 0);
INSERT INTO public.event VALUES (1812, '2024-04-04 13:13:13.453697', 65, 1, 0);
INSERT INTO public.event VALUES (1813, '2024-04-04 13:13:13.853893', 66, 0, 0);
INSERT INTO public.event VALUES (1814, '2024-04-04 13:13:14.25409', 67, 0, 0);
INSERT INTO public.event VALUES (1815, '2024-04-04 13:13:14.654171', 68, 1, 0);
INSERT INTO public.event VALUES (1816, '2024-04-04 13:13:16.65477', 64, 0, 0);
INSERT INTO public.event VALUES (1817, '2024-04-04 13:13:17.054923', 65, 0, 0);
INSERT INTO public.event VALUES (1818, '2024-04-04 13:13:17.455089', 66, 1, 0);
INSERT INTO public.event VALUES (1819, '2024-04-04 13:13:17.855284', 67, 1, 0);
INSERT INTO public.event VALUES (1820, '2024-04-04 13:13:18.255439', 68, 1, 0);
INSERT INTO public.event VALUES (1821, '2024-04-04 13:13:20.256522', 64, 0, 0);
INSERT INTO public.event VALUES (1822, '2024-04-04 13:13:20.656697', 65, 1, 0);
INSERT INTO public.event VALUES (1823, '2024-04-04 13:13:21.057233', 66, 0, 0);
INSERT INTO public.event VALUES (1824, '2024-04-04 13:13:21.457291', 67, 0, 0);
INSERT INTO public.event VALUES (1825, '2024-04-04 13:13:21.857476', 68, 1, 0);
INSERT INTO public.event VALUES (1826, '2024-04-04 13:13:23.858105', 64, 0, 0);
INSERT INTO public.event VALUES (1827, '2024-04-04 13:13:24.25831', 65, 0, 0);
INSERT INTO public.event VALUES (1828, '2024-04-04 13:13:24.658471', 66, 1, 0);
INSERT INTO public.event VALUES (1829, '2024-04-04 13:13:25.058641', 67, 1, 0);
INSERT INTO public.event VALUES (1830, '2024-04-04 13:13:25.458708', 68, 1, 0);
INSERT INTO public.event VALUES (1831, '2024-04-04 13:13:27.459311', 64, 0, 0);
INSERT INTO public.event VALUES (1832, '2024-04-04 13:13:27.859494', 65, 1, 0);
INSERT INTO public.event VALUES (1833, '2024-04-04 13:13:28.259651', 66, 1, 0);
INSERT INTO public.event VALUES (1834, '2024-04-04 13:13:28.659787', 67, 1, 0);
INSERT INTO public.event VALUES (1835, '2024-04-04 13:13:29.059875', 68, 1, 0);
INSERT INTO public.event VALUES (1836, '2024-04-04 13:13:31.06057', 64, 0, 0);
INSERT INTO public.event VALUES (1837, '2024-04-04 13:13:31.460739', 65, 1, 0);
INSERT INTO public.event VALUES (1838, '2024-04-04 13:13:31.860857', 66, 0, 0);
INSERT INTO public.event VALUES (1839, '2024-04-04 13:13:32.260919', 67, 1, 0);
INSERT INTO public.event VALUES (1840, '2024-04-04 13:13:32.660977', 68, 0, 0);
INSERT INTO public.event VALUES (1841, '2024-04-04 13:13:34.661826', 64, 1, 0);
INSERT INTO public.event VALUES (1842, '2024-04-04 13:13:35.062026', 65, 0, 0);
INSERT INTO public.event VALUES (1843, '2024-04-04 13:13:35.462098', 66, 1, 0);
INSERT INTO public.event VALUES (1844, '2024-04-04 13:13:35.862179', 67, 0, 0);
INSERT INTO public.event VALUES (1845, '2024-04-04 13:13:36.262253', 68, 1, 0);
INSERT INTO public.event VALUES (1846, '2024-04-04 13:13:38.262802', 64, 1, 0);
INSERT INTO public.event VALUES (1847, '2024-04-04 13:13:38.66297', 65, 0, 0);
INSERT INTO public.event VALUES (1848, '2024-04-04 13:13:39.063129', 66, 0, 0);
INSERT INTO public.event VALUES (1849, '2024-04-04 13:13:39.463198', 67, 1, 0);
INSERT INTO public.event VALUES (1850, '2024-04-04 13:13:39.863377', 68, 0, 0);
INSERT INTO public.event VALUES (1851, '2024-04-04 13:13:41.86394', 64, 0, 0);
INSERT INTO public.event VALUES (1852, '2024-04-04 13:13:42.264003', 65, 1, 0);
INSERT INTO public.event VALUES (1853, '2024-04-04 13:13:42.66418', 66, 0, 0);
INSERT INTO public.event VALUES (1854, '2024-04-04 13:13:43.064359', 67, 1, 0);
INSERT INTO public.event VALUES (1855, '2024-04-04 13:13:43.464542', 68, 0, 0);
INSERT INTO public.event VALUES (1856, '2024-04-04 13:13:45.465026', 64, 1, 0);
INSERT INTO public.event VALUES (1857, '2024-04-04 13:13:45.865139', 65, 1, 0);
INSERT INTO public.event VALUES (1858, '2024-04-04 13:13:46.265236', 66, 1, 0);
INSERT INTO public.event VALUES (1859, '2024-04-04 13:13:46.665314', 67, 1, 0);
INSERT INTO public.event VALUES (1860, '2024-04-04 13:13:47.065421', 68, 0, 0);
INSERT INTO public.event VALUES (1861, '2024-04-04 13:13:49.066249', 64, 1, 0);
INSERT INTO public.event VALUES (1862, '2024-04-04 13:13:49.466403', 65, 1, 0);
INSERT INTO public.event VALUES (1863, '2024-04-04 13:13:49.866561', 66, 0, 0);
INSERT INTO public.event VALUES (1864, '2024-04-04 13:13:50.266728', 67, 0, 0);
INSERT INTO public.event VALUES (1865, '2024-04-04 13:13:50.666884', 68, 1, 0);
INSERT INTO public.event VALUES (1866, '2024-04-04 13:13:52.667586', 64, 0, 0);
INSERT INTO public.event VALUES (1867, '2024-04-04 13:13:53.067744', 65, 0, 0);
INSERT INTO public.event VALUES (1868, '2024-04-04 13:13:53.467902', 66, 1, 0);
INSERT INTO public.event VALUES (1869, '2024-04-04 13:13:53.868083', 67, 1, 0);
INSERT INTO public.event VALUES (1870, '2024-04-04 13:13:54.268279', 68, 1, 0);
INSERT INTO public.event VALUES (1871, '2024-04-04 13:13:56.268919', 64, 0, 0);
INSERT INTO public.event VALUES (1872, '2024-04-04 13:13:56.668979', 65, 0, 0);
INSERT INTO public.event VALUES (1873, '2024-04-04 13:13:57.069045', 66, 1, 0);
INSERT INTO public.event VALUES (1874, '2024-04-04 13:13:57.469144', 67, 1, 0);
INSERT INTO public.event VALUES (1875, '2024-04-04 13:13:57.869239', 68, 0, 0);
INSERT INTO public.event VALUES (1876, '2024-04-04 13:13:59.869869', 64, 0, 0);
INSERT INTO public.event VALUES (1877, '2024-04-04 13:14:00.269934', 65, 1, 0);
INSERT INTO public.event VALUES (1878, '2024-04-04 13:14:00.6701', 66, 0, 0);
INSERT INTO public.event VALUES (1879, '2024-04-04 13:14:01.070286', 67, 1, 0);
INSERT INTO public.event VALUES (1880, '2024-04-04 13:14:01.470353', 68, 0, 0);
INSERT INTO public.event VALUES (1881, '2024-04-04 13:14:03.471158', 64, 1, 0);
INSERT INTO public.event VALUES (1882, '2024-04-04 13:14:03.871235', 65, 1, 0);
INSERT INTO public.event VALUES (1883, '2024-04-04 13:14:04.271293', 66, 1, 0);
INSERT INTO public.event VALUES (1884, '2024-04-04 13:14:04.671372', 67, 0, 0);
INSERT INTO public.event VALUES (1885, '2024-04-04 13:14:05.071532', 68, 1, 0);
INSERT INTO public.event VALUES (1886, '2024-04-04 13:14:07.072055', 64, 1, 0);
INSERT INTO public.event VALUES (1887, '2024-04-04 13:14:07.472116', 65, 1, 0);
INSERT INTO public.event VALUES (1888, '2024-04-04 13:14:07.872199', 66, 1, 0);
INSERT INTO public.event VALUES (1889, '2024-04-04 13:14:08.272273', 67, 0, 0);
INSERT INTO public.event VALUES (1890, '2024-04-04 13:14:08.672436', 68, 0, 0);
INSERT INTO public.event VALUES (1891, '2024-04-04 13:14:10.672799', 64, 1, 0);
INSERT INTO public.event VALUES (1892, '2024-04-04 13:14:11.072858', 65, 0, 0);
INSERT INTO public.event VALUES (1893, '2024-04-04 13:14:11.472917', 66, 0, 0);
INSERT INTO public.event VALUES (1894, '2024-04-04 13:14:11.872977', 67, 1, 0);
INSERT INTO public.event VALUES (1895, '2024-04-04 13:14:12.273041', 68, 0, 0);
INSERT INTO public.event VALUES (1896, '2024-04-04 13:14:14.273653', 64, 0, 0);
INSERT INTO public.event VALUES (1897, '2024-04-04 13:14:14.673841', 65, 0, 0);
INSERT INTO public.event VALUES (1898, '2024-04-04 13:14:15.073921', 66, 0, 0);
INSERT INTO public.event VALUES (1899, '2024-04-04 13:14:15.474013', 67, 0, 0);
INSERT INTO public.event VALUES (1900, '2024-04-04 13:14:15.874209', 68, 0, 0);
INSERT INTO public.event VALUES (1901, '2024-04-04 13:14:17.875043', 64, 0, 0);
INSERT INTO public.event VALUES (1902, '2024-04-04 13:14:18.275226', 65, 1, 0);
INSERT INTO public.event VALUES (1903, '2024-04-04 13:14:18.675413', 66, 1, 0);
INSERT INTO public.event VALUES (1904, '2024-04-04 13:14:19.0756', 67, 1, 0);
INSERT INTO public.event VALUES (1905, '2024-04-04 13:14:19.475776', 68, 0, 0);
INSERT INTO public.event VALUES (1906, '2024-04-04 13:14:21.476409', 64, 1, 0);
INSERT INTO public.event VALUES (1907, '2024-04-04 13:14:21.87657', 65, 1, 0);
INSERT INTO public.event VALUES (1908, '2024-04-04 13:14:22.276659', 66, 1, 0);
INSERT INTO public.event VALUES (1909, '2024-04-04 13:14:22.676729', 67, 1, 0);
INSERT INTO public.event VALUES (1910, '2024-04-04 13:14:23.076794', 68, 0, 0);
INSERT INTO public.event VALUES (1911, '2024-04-04 13:14:25.077569', 64, 0, 0);
INSERT INTO public.event VALUES (1912, '2024-04-04 13:14:25.477629', 65, 0, 0);
INSERT INTO public.event VALUES (1913, '2024-04-04 13:14:25.877693', 66, 0, 0);
INSERT INTO public.event VALUES (1914, '2024-04-04 13:14:26.277764', 67, 1, 0);
INSERT INTO public.event VALUES (1915, '2024-04-04 13:14:26.677872', 68, 1, 0);
INSERT INTO public.event VALUES (1916, '2024-04-04 13:14:28.678314', 64, 1, 0);
INSERT INTO public.event VALUES (1917, '2024-04-04 13:14:29.078377', 65, 0, 0);
INSERT INTO public.event VALUES (1918, '2024-04-04 13:14:29.478434', 66, 1, 0);
INSERT INTO public.event VALUES (1919, '2024-04-04 13:14:29.878595', 67, 1, 0);
INSERT INTO public.event VALUES (1920, '2024-04-04 13:14:30.278769', 68, 0, 0);
INSERT INTO public.event VALUES (1921, '2024-04-04 13:14:32.279427', 64, 1, 0);
INSERT INTO public.event VALUES (1922, '2024-04-04 13:26:43.782741', 66, 0, 0);
INSERT INTO public.event VALUES (1923, '2024-04-04 13:26:44.182838', 67, 0, 0);
INSERT INTO public.event VALUES (1924, '2024-04-04 13:26:44.582998', 68, 0, 0);
INSERT INTO public.event VALUES (1925, '2024-04-04 13:26:46.583674', 64, 0, 0);
INSERT INTO public.event VALUES (1926, '2024-04-04 13:26:46.983833', 65, 1, 0);
INSERT INTO public.event VALUES (1927, '2024-04-04 13:26:47.383898', 66, 1, 0);
INSERT INTO public.event VALUES (1928, '2024-04-04 13:26:47.784027', 67, 1, 0);
INSERT INTO public.event VALUES (1929, '2024-04-04 13:26:48.184127', 68, 1, 0);
INSERT INTO public.event VALUES (1930, '2024-04-04 13:28:23.368169', 64, 0, 0);
INSERT INTO public.event VALUES (1931, '2024-04-04 13:28:23.768355', 65, 0, 0);
INSERT INTO public.event VALUES (1932, '2024-04-04 13:28:24.168538', 66, 1, 0);
INSERT INTO public.event VALUES (1933, '2024-04-04 13:28:24.568709', 67, 1, 0);
INSERT INTO public.event VALUES (1934, '2024-04-04 13:28:24.968883', 68, 1, 0);
INSERT INTO public.event VALUES (1935, '2024-04-04 13:28:26.96937', 64, 0, 0);
INSERT INTO public.event VALUES (1936, '2024-04-04 13:28:27.369442', 65, 0, 0);
INSERT INTO public.event VALUES (1937, '2024-04-04 13:28:27.76953', 66, 1, 0);
INSERT INTO public.event VALUES (1938, '2024-04-04 13:28:28.169707', 67, 0, 0);
INSERT INTO public.event VALUES (1939, '2024-04-04 13:28:28.5699', 68, 1, 0);
INSERT INTO public.event VALUES (1940, '2024-04-04 13:28:30.570618', 64, 0, 0);
INSERT INTO public.event VALUES (1941, '2024-04-04 13:28:30.970769', 65, 1, 0);
INSERT INTO public.event VALUES (1942, '2024-04-04 13:28:31.370862', 66, 0, 0);
INSERT INTO public.event VALUES (1943, '2024-04-04 13:28:31.771046', 67, 1, 0);
INSERT INTO public.event VALUES (1944, '2024-04-04 13:28:32.171233', 68, 1, 0);
INSERT INTO public.event VALUES (1945, '2024-04-04 13:28:34.171767', 64, 0, 0);
INSERT INTO public.event VALUES (1946, '2024-04-04 13:28:34.571932', 65, 1, 0);
INSERT INTO public.event VALUES (1947, '2024-04-04 13:28:34.972121', 66, 0, 0);
INSERT INTO public.event VALUES (1948, '2024-04-04 13:28:35.372307', 67, 0, 0);
INSERT INTO public.event VALUES (1949, '2024-04-04 13:28:35.772497', 68, 0, 0);
INSERT INTO public.event VALUES (1950, '2024-04-04 13:29:35.734671', 65, 1, 0);
INSERT INTO public.event VALUES (1951, '2024-04-04 13:29:36.134733', 66, 1, 0);
INSERT INTO public.event VALUES (1952, '2024-04-04 13:29:36.534912', 67, 0, 0);
INSERT INTO public.event VALUES (1953, '2024-04-04 13:29:36.935097', 68, 1, 0);
INSERT INTO public.event VALUES (1954, '2024-04-04 13:29:38.93589', 64, 1, 0);
INSERT INTO public.event VALUES (1955, '2024-04-04 13:29:39.33597', 65, 0, 0);
INSERT INTO public.event VALUES (1956, '2024-04-04 13:29:39.736055', 66, 0, 0);
INSERT INTO public.event VALUES (1957, '2024-04-04 13:29:40.136243', 67, 0, 0);
INSERT INTO public.event VALUES (1958, '2024-04-04 13:29:40.536326', 68, 1, 0);
INSERT INTO public.event VALUES (1959, '2024-04-04 13:29:42.536958', 64, 1, 0);
INSERT INTO public.event VALUES (1960, '2024-04-04 13:29:42.937021', 65, 0, 0);
INSERT INTO public.event VALUES (1961, '2024-04-04 13:29:43.337103', 66, 1, 0);
INSERT INTO public.event VALUES (1962, '2024-04-04 13:29:43.737204', 67, 1, 0);
INSERT INTO public.event VALUES (1963, '2024-04-04 13:29:44.137375', 68, 0, 0);
INSERT INTO public.event VALUES (1964, '2024-04-04 13:29:46.138203', 64, 0, 0);
INSERT INTO public.event VALUES (1965, '2024-04-04 13:29:46.538382', 65, 0, 0);
INSERT INTO public.event VALUES (1966, '2024-04-04 13:29:46.938566', 66, 1, 0);
INSERT INTO public.event VALUES (1967, '2024-04-04 13:29:47.338746', 67, 1, 0);
INSERT INTO public.event VALUES (1968, '2024-04-04 13:29:47.738812', 68, 1, 0);
INSERT INTO public.event VALUES (1969, '2024-04-04 13:29:49.7396', 64, 1, 0);
INSERT INTO public.event VALUES (1970, '2024-04-04 13:29:50.139763', 65, 1, 0);
INSERT INTO public.event VALUES (1971, '2024-04-04 13:44:51.849873', 64, 0, 0);
INSERT INTO public.event VALUES (1972, '2024-04-04 13:44:52.24993', 65, 0, 0);
INSERT INTO public.event VALUES (1973, '2024-04-04 13:44:52.65004', 66, 1, 0);
INSERT INTO public.event VALUES (1974, '2024-04-04 13:44:53.050215', 67, 1, 0);
INSERT INTO public.event VALUES (1975, '2024-04-04 13:44:53.450389', 68, 0, 0);
INSERT INTO public.event VALUES (1976, '2024-04-04 13:44:55.451043', 64, 1, 0);
INSERT INTO public.event VALUES (1977, '2024-04-04 13:44:55.851221', 65, 1, 0);
INSERT INTO public.event VALUES (1978, '2024-04-04 13:44:56.251397', 66, 1, 0);
INSERT INTO public.event VALUES (1979, '2024-04-04 14:02:48.724931', 64, 0, 0);
INSERT INTO public.event VALUES (1980, '2024-04-04 14:02:49.124992', 65, 0, 0);
INSERT INTO public.event VALUES (1981, '2024-04-04 14:02:49.525054', 66, 1, 0);
INSERT INTO public.event VALUES (1982, '2024-04-04 14:02:49.925163', 67, 0, 0);
INSERT INTO public.event VALUES (1983, '2024-04-04 14:02:50.325258', 68, 0, 0);
INSERT INTO public.event VALUES (1984, '2024-04-04 14:02:52.326071', 64, 0, 0);
INSERT INTO public.event VALUES (1985, '2024-04-04 14:02:52.726236', 65, 1, 0);
INSERT INTO public.event VALUES (1986, '2024-04-04 14:02:53.126426', 66, 1, 0);
INSERT INTO public.event VALUES (1987, '2024-04-04 14:02:53.526605', 67, 0, 0);
INSERT INTO public.event VALUES (1988, '2024-04-04 14:02:53.92679', 68, 1, 0);
INSERT INTO public.event VALUES (1989, '2024-04-04 14:02:55.927587', 64, 0, 0);
INSERT INTO public.event VALUES (1990, '2024-04-04 14:02:56.327761', 65, 0, 0);
INSERT INTO public.event VALUES (1991, '2024-04-04 14:02:56.727926', 66, 1, 0);
INSERT INTO public.event VALUES (1992, '2024-04-04 14:02:57.128105', 67, 0, 0);
INSERT INTO public.event VALUES (1993, '2024-04-04 14:02:57.528168', 68, 0, 0);
INSERT INTO public.event VALUES (1994, '2024-04-04 14:02:59.529065', 64, 0, 0);
INSERT INTO public.event VALUES (1995, '2024-04-04 14:02:59.92917', 65, 0, 0);
INSERT INTO public.event VALUES (1996, '2024-04-04 14:03:00.329231', 66, 1, 0);
INSERT INTO public.event VALUES (1997, '2024-04-04 14:46:21.886426', 64, 0, 0);
INSERT INTO public.event VALUES (1998, '2024-04-04 14:46:22.28658', 65, 0, 0);
INSERT INTO public.event VALUES (1999, '2024-04-04 14:46:22.686752', 66, 0, 0);
INSERT INTO public.event VALUES (2000, '2024-04-04 14:46:23.086913', 67, 0, 0);
INSERT INTO public.event VALUES (2001, '2024-04-04 14:46:23.487092', 68, 1, 0);
INSERT INTO public.event VALUES (2002, '2024-04-04 14:46:25.487681', 64, 0, 0);
INSERT INTO public.event VALUES (2003, '2024-04-04 14:46:25.887879', 65, 1, 0);
INSERT INTO public.event VALUES (2004, '2024-04-04 14:46:26.288042', 66, 0, 0);
INSERT INTO public.event VALUES (2005, '2024-04-04 14:46:26.688199', 67, 0, 0);
INSERT INTO public.event VALUES (2006, '2024-04-04 14:46:27.088388', 68, 0, 0);
INSERT INTO public.event VALUES (2007, '2024-04-04 14:46:29.088965', 64, 0, 0);
INSERT INTO public.event VALUES (2008, '2024-04-04 14:46:29.48903', 65, 1, 0);
INSERT INTO public.event VALUES (2009, '2024-04-04 14:46:29.889097', 66, 0, 0);
INSERT INTO public.event VALUES (2010, '2024-04-04 14:46:30.28933', 67, 0, 0);
INSERT INTO public.event VALUES (2011, '2024-04-04 14:46:30.689452', 68, 0, 0);
INSERT INTO public.event VALUES (2012, '2024-04-04 14:46:32.690236', 64, 1, 0);
INSERT INTO public.event VALUES (2013, '2024-04-04 14:46:33.090401', 65, 1, 0);
INSERT INTO public.event VALUES (2014, '2024-04-04 14:46:33.490458', 66, 0, 0);
INSERT INTO public.event VALUES (2015, '2024-04-04 14:46:33.89052', 67, 1, 0);
INSERT INTO public.event VALUES (2016, '2024-04-04 14:46:34.290682', 68, 0, 0);
INSERT INTO public.event VALUES (2017, '2024-04-04 14:46:36.291101', 64, 1, 0);
INSERT INTO public.event VALUES (2018, '2024-04-04 14:46:36.691161', 65, 1, 0);
INSERT INTO public.event VALUES (2019, '2024-04-04 14:46:37.091219', 66, 1, 0);
INSERT INTO public.event VALUES (2020, '2024-04-04 14:46:37.491381', 67, 0, 0);
INSERT INTO public.event VALUES (2021, '2024-04-04 14:46:37.891441', 68, 1, 0);
INSERT INTO public.event VALUES (2022, '2024-04-04 14:46:39.892346', 64, 1, 0);
INSERT INTO public.event VALUES (2023, '2024-04-04 14:46:40.292428', 65, 0, 0);
INSERT INTO public.event VALUES (2024, '2024-04-04 14:46:40.692499', 66, 1, 0);
INSERT INTO public.event VALUES (2025, '2024-04-04 14:46:41.092575', 67, 0, 0);
INSERT INTO public.event VALUES (2026, '2024-04-04 14:46:41.492631', 68, 1, 0);
INSERT INTO public.event VALUES (2027, '2024-04-04 14:46:43.493014', 64, 1, 0);
INSERT INTO public.event VALUES (2028, '2024-04-04 14:46:43.89308', 65, 1, 0);
INSERT INTO public.event VALUES (2029, '2024-04-04 14:46:44.293143', 66, 0, 0);
INSERT INTO public.event VALUES (2030, '2024-04-04 14:46:44.693213', 67, 1, 0);
INSERT INTO public.event VALUES (2031, '2024-04-04 14:46:45.093278', 68, 0, 0);
INSERT INTO public.event VALUES (2032, '2024-04-04 14:46:47.09373', 64, 1, 0);
INSERT INTO public.event VALUES (2033, '2024-04-04 14:46:47.493785', 65, 1, 0);
INSERT INTO public.event VALUES (2034, '2024-04-04 14:46:47.893982', 66, 1, 0);
INSERT INTO public.event VALUES (2035, '2024-04-04 14:46:48.294104', 67, 0, 0);
INSERT INTO public.event VALUES (2036, '2024-04-04 14:46:48.69418', 68, 1, 0);
INSERT INTO public.event VALUES (2037, '2024-04-04 14:46:50.694697', 64, 0, 0);
INSERT INTO public.event VALUES (2038, '2024-04-04 14:46:51.094893', 65, 0, 0);
INSERT INTO public.event VALUES (2039, '2024-04-04 14:46:51.495097', 66, 0, 0);
INSERT INTO public.event VALUES (2040, '2024-04-04 14:46:51.895258', 67, 1, 0);
INSERT INTO public.event VALUES (2041, '2024-04-04 14:46:52.295456', 68, 1, 0);
INSERT INTO public.event VALUES (2042, '2024-04-04 14:46:54.296017', 64, 1, 0);
INSERT INTO public.event VALUES (2043, '2024-04-04 14:46:54.696104', 65, 1, 0);
INSERT INTO public.event VALUES (2044, '2024-04-04 14:46:55.096273', 66, 1, 0);
INSERT INTO public.event VALUES (2045, '2024-04-04 14:46:55.49643', 67, 1, 0);
INSERT INTO public.event VALUES (2046, '2024-04-04 14:46:55.896517', 68, 0, 0);
INSERT INTO public.event VALUES (2047, '2024-04-04 14:46:57.896935', 64, 0, 0);
INSERT INTO public.event VALUES (2048, '2024-04-04 14:46:58.296993', 65, 0, 0);
INSERT INTO public.event VALUES (2049, '2024-04-04 14:46:58.69705', 66, 1, 0);
INSERT INTO public.event VALUES (2050, '2024-04-04 14:46:59.097137', 67, 1, 0);
INSERT INTO public.event VALUES (2051, '2024-04-04 14:46:59.497212', 68, 1, 0);
INSERT INTO public.event VALUES (2052, '2024-04-04 14:47:01.497621', 64, 0, 0);
INSERT INTO public.event VALUES (2053, '2024-04-04 14:47:01.897709', 65, 0, 0);
INSERT INTO public.event VALUES (2054, '2024-04-04 14:47:02.297797', 66, 1, 0);
INSERT INTO public.event VALUES (2055, '2024-04-04 14:47:02.697875', 67, 1, 0);
INSERT INTO public.event VALUES (2056, '2024-04-04 14:47:03.098041', 68, 0, 0);
INSERT INTO public.event VALUES (2057, '2024-04-04 14:51:49.654613', 64, 0, 0);
INSERT INTO public.event VALUES (2058, '2024-04-04 14:51:49.754786', 65, 0, 0);
INSERT INTO public.event VALUES (2059, '2024-04-04 14:51:49.85496', 66, 0, 0);
INSERT INTO public.event VALUES (2060, '2024-04-04 14:52:09.248172', 64, 1, 0);
INSERT INTO public.event VALUES (2061, '2024-04-04 14:52:09.348236', 65, 1, 0);
INSERT INTO public.event VALUES (2062, '2024-04-04 14:52:09.448309', 66, 1, 0);
INSERT INTO public.event VALUES (2063, '2024-04-04 14:52:09.548361', 67, 0, 0);
INSERT INTO public.event VALUES (2064, '2024-04-04 14:52:09.648419', 68, 0, 0);
INSERT INTO public.event VALUES (2065, '2024-04-04 14:52:10.148899', 64, 1, 0);
INSERT INTO public.event VALUES (2066, '2024-04-04 14:52:10.249076', 65, 1, 0);
INSERT INTO public.event VALUES (2067, '2024-04-04 14:52:10.349244', 66, 1, 0);
INSERT INTO public.event VALUES (2068, '2024-04-04 14:52:10.449339', 67, 0, 0);
INSERT INTO public.event VALUES (2069, '2024-04-04 14:52:10.549507', 68, 0, 0);
INSERT INTO public.event VALUES (2070, '2024-04-04 14:52:11.050263', 64, 1, 0);
INSERT INTO public.event VALUES (2071, '2024-04-04 14:52:11.150445', 65, 1, 0);
INSERT INTO public.event VALUES (2072, '2024-04-04 14:52:11.250617', 66, 1, 0);
INSERT INTO public.event VALUES (2073, '2024-04-04 14:52:11.350788', 67, 0, 0);
INSERT INTO public.event VALUES (2074, '2024-04-04 14:52:11.450956', 68, 0, 0);
INSERT INTO public.event VALUES (2075, '2024-04-04 14:52:11.951547', 64, 0, 0);
INSERT INTO public.event VALUES (2076, '2024-04-04 14:52:12.051667', 65, 0, 0);
INSERT INTO public.event VALUES (2077, '2024-04-04 14:52:12.151775', 66, 0, 0);
INSERT INTO public.event VALUES (2078, '2024-04-04 14:52:12.251869', 67, 0, 0);
INSERT INTO public.event VALUES (2079, '2024-04-04 14:52:12.352088', 68, 1, 0);
INSERT INTO public.event VALUES (2080, '2024-04-04 14:52:12.853044', 64, 0, 0);
INSERT INTO public.event VALUES (2081, '2024-04-04 14:52:12.953179', 65, 1, 0);
INSERT INTO public.event VALUES (2082, '2024-04-04 14:52:13.053281', 66, 0, 0);
INSERT INTO public.event VALUES (2083, '2024-04-04 14:52:13.15338', 67, 1, 0);
INSERT INTO public.event VALUES (2084, '2024-04-04 14:52:13.253523', 68, 0, 0);
INSERT INTO public.event VALUES (2085, '2024-04-04 14:52:13.754265', 64, 0, 0);
INSERT INTO public.event VALUES (2086, '2024-04-04 14:52:13.854467', 65, 0, 0);
INSERT INTO public.event VALUES (2087, '2024-04-04 14:52:13.954671', 66, 1, 0);
INSERT INTO public.event VALUES (2088, '2024-04-04 14:52:14.054889', 67, 0, 0);
INSERT INTO public.event VALUES (2089, '2024-04-04 14:52:14.155091', 68, 1, 0);
INSERT INTO public.event VALUES (2090, '2024-04-04 14:52:14.656033', 64, 0, 0);


--
-- TOC entry 3120 (class 0 OID 56510)
-- Dependencies: 219
-- Data for Name: event_utils; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.event_utils VALUES (1, 879, 6000000, 1000, 1000, false);


--
-- TOC entry 3115 (class 0 OID 27941)
-- Dependencies: 208
-- Data for Name: rec_basic_metric; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.rec_basic_metric VALUES ('1.1                             ', 'string', 'crane-type', 'тип крана', 'unknown');
INSERT INTO public.rec_basic_metric VALUES ('1.2                             ', 'string', 'crane-index', 'индекс крана', 'unknown');
INSERT INTO public.rec_basic_metric VALUES ('1.3                             ', 'string', 'crane-vendor', 'наименование предприятия - изготовителя крана', 'ООО "ТКЗ"');
INSERT INTO public.rec_basic_metric VALUES ('1.4                             ', 'string', 'crane-serial-number', 'заводской номер крана', '000-000');
INSERT INTO public.rec_basic_metric VALUES ('1.5                             ', 'date', 'crane-manufacturing-date', 'год изготовления крана', '2023-03-03');
INSERT INTO public.rec_basic_metric VALUES ('1.6                             ', 'real', 'crane-capacity', 'грузоподъемность крана, тонны', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('1.7                             ', 'string', 'crane-classification-group', 'группа классификации (режима) крана', 'M8');
INSERT INTO public.rec_basic_metric VALUES ('1.7.1                           ', 'string', 'winch1-classification-group', 'группа классификации (режима) лебедки 1 крана', 'M8');
INSERT INTO public.rec_basic_metric VALUES ('1.7.2                           ', 'string', 'winch2-classification-group', 'группа классификации (режима) лебедки 2 крана', 'M8');
INSERT INTO public.rec_basic_metric VALUES ('1.7.3                           ', 'string', 'winch3-classification-group', 'группа классификации (режима) лебедки 3 крана', 'M8');
INSERT INTO public.rec_basic_metric VALUES ('1.8                             ', 'real', 'crane-nominal-characteristic-number', 'нор­мативное характеристическое число крана', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('1.8.1                           ', 'real', 'winch1-nominal-characteristic-number', 'нор­мативное характеристическое число лебедки 1 крана', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('1.8.2                           ', 'real', 'winch2-nominal-characteristic-number', 'нор­мативное характеристическое число лебедки 2 крана', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('1.8.3                           ', 'real', 'winch3-nominal-characteristic-number', 'нор­мативное характеристическое число лебедки 3 крана', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('1.9                             ', 'date', 'crane-commissioning-date', 'дата ввода крана в эксплуатацию', '2023-03-03');
INSERT INTO public.rec_basic_metric VALUES ('1.10                            ', 'int', 'crane-standard-service-life ', 'нормативный срок службы крана', '0');
INSERT INTO public.rec_basic_metric VALUES ('2.1                             ', 'string', 'fault-recorder-type', 'тип Регистратора параметров', 'Fault Recorder');
INSERT INTO public.rec_basic_metric VALUES ('2.2                             ', 'string', 'fault-recorder-model', 'модификация Регистратора параметров', 'v0.0.1');
INSERT INTO public.rec_basic_metric VALUES ('2.3                             ', 'string', 'fault-recorder-vendor', 'наименование предприятия - изготовителя Регистратора параметров', 'ООО "ТКЗ"');
INSERT INTO public.rec_basic_metric VALUES ('2.4                             ', 'string', 'fault-recorder-serial-number', 'заводской номер Регистратора параметров', '000-000');
INSERT INTO public.rec_basic_metric VALUES ('2.5                             ', 'date', 'fault-recorder-manufacturing-date', 'год изготовления Регистратора параметров', '2023-03-03');
INSERT INTO public.rec_basic_metric VALUES ('2.6                             ', 'date', 'fault-recorder-installation-date', 'дата установки РП на кран', '2023-03-03');
INSERT INTO public.rec_basic_metric VALUES ('2.7                             ', 'string', 'fault-recorder-installation-company', 'наименование организации, установившей Регистратора параметров на кран', 'ООО "ТКЗ"');
INSERT INTO public.rec_basic_metric VALUES ('3.1                             ', 'real', 'crane-total-operating-hours', 'общее количество часов работы крана', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.2.0                           ', 'real', 'pump-total-operating-hours', 'общее количество часов работы насосной станции (моточасы)', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.2.1                           ', 'real', 'winch1-total-operating-hours', 'общее количество часов работы лебедки 1 (моточасы)', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.2.2                           ', 'real', 'winch2-total-operating-hours', 'общее количество часов работы лебедки 2 (моточасы)', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.2.3                           ', 'real', 'winch3-total-operating-hours', 'общее количество часов работы лебедки 3 (моточасы)', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.7.1                           ', 'real', 'winch1-characteristic-number', 'текущее характеристическое число лебедка 1', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.7.2                           ', 'real', 'winch2-characteristic-number', 'текущее характеристическое число лебедка 2', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.5                             ', 'real', 'crane-total-lifted-mass', 'суммарная масса поднятых грузов. тонн', '169.15152');
INSERT INTO public.rec_basic_metric VALUES ('3.5.1                           ', 'real', 'winch1-total-lifted-mass', 'суммарная масса поднятых грузов лебедка 1', '169.15152');
INSERT INTO public.rec_basic_metric VALUES ('3.5.2                           ', 'real', 'winch2-total-lifted-mass', 'суммарная масса поднятых грузов лебедка 2', '169.15152');
INSERT INTO public.rec_basic_metric VALUES ('3.5.3                           ', 'real', 'winch3-total-lifted-mass', 'суммарная масса поднятых грузов лебедка 3', '169.15152');
INSERT INTO public.rec_basic_metric VALUES ('3.6.2                           ', 'int', 'winch2-load-limiter-trip-count', 'количество срабатываний ограничителя грузоподъемности лебедка 2', '4');
INSERT INTO public.rec_basic_metric VALUES ('3.6.3                           ', 'int', 'winch3-load-limiter-trip-count', 'количество срабатываний ограничителя грузоподъемности лебедка 3', '4');
INSERT INTO public.rec_basic_metric VALUES ('3.7                             ', 'real', 'crane-characteristic-number', 'текущее характеристическое число для крана', '2.7883105');
INSERT INTO public.rec_basic_metric VALUES ('3.3                             ', 'int', 'total-operating-cycles-count', 'суммарное число рабочих циклов', '4');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.12                        ', 'real', 'cycles-1_15-1_25-load-range', 'циклов в диапазоне загрузки 1,15 - 1,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.13                        ', 'real', 'cycles-1_25-load-range', 'циклов в диапазоне загрузки 1,25 -', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.04                        ', 'real', 'cycles-0_35-0_45-load-range', 'циклов в диапазоне загрузки 0,35 - 0,45', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.06                        ', 'real', 'cycles-0_55-0_65-load-range', 'циклов в диапазоне загрузки 0,55 - 0,65', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.09                        ', 'real', 'cycles-0_85-0_95-load-range', 'циклов в диапазоне загрузки 0,85 - 0,95', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.03                        ', 'real', 'cycles-0_25-0_35-load-range', 'циклов в диапазоне загрузки 0,25 - 0,35', '4');
INSERT INTO public.rec_basic_metric VALUES ('3.7.3                           ', 'real', 'winch3-characteristic-number', 'текущее характеристическое число лебедка 3', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.8                             ', 'real', 'crane-load-spectrum-factor', 'коэффициент распределения нагрузок для крана', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.8.1                           ', 'real', 'winch1-load-spectrum-factor', 'коэффициент распределения нагрузок лебедка 1', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.8.2                           ', 'real', 'winch2-load-spectrum-factor', 'коэффициент распределения нагрузок лебедка 2', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.8.3                           ', 'real', 'winch3-load-spectrum-factor', 'коэффициент распределения нагрузок лебедка 3', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.1.1                           ', 'real', 'crane-total-operating-secs', 'общее количество часов работы крана', '1.2955836');
INSERT INTO public.rec_basic_metric VALUES ('3.6.1                           ', 'int', 'winch1-load-limiter-trip-count', 'количество срабатываний ограничителя грузоподъемности лебедка 1', '8');
INSERT INTO public.rec_basic_metric VALUES ('3.4                             ', 'real', 'cycles-distribution-by-load-ranges', 'распределение циклов по диапазонам нагрузки', '');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.10.L                      ', 'real', '0_95-1_05-load', 'нагрузка в диапазоне загрузки 0,95 - 1,05', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.10                        ', 'real', 'cycles-0_95-1_05-load-range', 'циклов в диапазоне загрузки 0,95 - 1,05', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.11                        ', 'real', 'cycles-1_05-1_15-load-range', 'циклов в диапазоне загрузки 1,05 - 1,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.11.L                      ', 'real', '1_05-1_15-load', 'нагрузка в диапазоне загрузки 1,05 - 1,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.12.L                      ', 'real', '1_15-1_25-load', 'нагрузка в диапазоне загрузки 1,15 - 1,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.13.L                      ', 'real', '1_25-load', 'нагрузка в диапазоне загрузки 1,25 -', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.03.L                      ', 'real', '0_25-0_35-load', 'нагрузка в диапазоне загрузки 0,25 - 0,35', '0.28');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.04.L                      ', 'real', '0_35-0_45-load', 'нагрузка в диапазоне загрузки 0,35 - 0,45', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.05                        ', 'real', 'cycles-0_45-0_55-load-range', 'циклов в диапазоне загрузки 0,45 - 0,55', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.05.L                      ', 'real', '0_45-0_55-load', 'нагрузка в диапазоне загрузки 0,45 - 0,55', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.06.L                      ', 'real', '0_55-0_65-load', 'нагрузка в диапазоне загрузки 0,55 - 0,65', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.07                        ', 'real', 'cycles-0_65-0_75-load-range', 'циклов в диапазоне загрузки 0,65 - 0,75', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.07.L                      ', 'real', '0_65-0_75-load', 'нагрузка в диапазоне загрузки 0,65 - 0,75', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.08                        ', 'real', 'cycles-0_75-0_85-load-range', 'циклов в диапазоне загрузки 0,75 - 0,85', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.08.L                      ', 'real', '0_75-0_85-load', 'нагрузка в диапазоне загрузки 0,75 - 0,85', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.09.L                      ', 'real', '0_85-0_95-load', 'нагрузка в диапазоне загрузки 0,85 - 0,95', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.01                        ', 'real', 'winch1-cycles-0_05-0_15-load-range', 'циклов в диапазоне загрузки 0,05 - 0,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.02                        ', 'real', 'winch1-cycles-0_15-0_25-load-range', 'циклов в диапазоне загрузки 0,15 - 0,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.01.L                      ', 'real', 'winch1-0_05-0_15-load', 'нагрузка в диапазоне загрузки 0,05 - 0,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.02.L                      ', 'real', 'winch1-0_15-0_25-load', 'нагрузка в диапазоне загрузки 0,15 - 0,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.01                        ', 'real', 'cycles-0_05-0_15-load-range', 'циклов в диапазоне загрузки 0,05 - 0,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.01.L                      ', 'real', '0_05-0_15-load', 'нагрузка в диапазоне загрузки 0,05 - 0,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.02                        ', 'real', 'cycles-0_15-0_25-load-range', 'циклов в диапазоне загрузки 0,15 - 0,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.1.02.L                      ', 'real', '0_15-0_25-load', 'нагрузка в диапазоне загрузки 0,15 - 0,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.03                        ', 'real', 'winch1-cycles-0_25-0_35-load-range', 'циклов в диапазоне загрузки 0,25 - 0,35', '4');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.03.L                      ', 'real', 'winch1-0_25-0_35-load', 'нагрузка в диапазоне загрузки 0,25 - 0,35', '0.28');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.04                        ', 'real', 'winch1-cycles-0_35-0_45-load-range', 'циклов в диапазоне загрузки 0,35 - 0,45', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.04.L                      ', 'real', 'winch1-0_35-0_45-load', 'нагрузка в диапазоне загрузки 0,35 - 0,45', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.05                        ', 'real', 'winch1-cycles-0_45-0_55-load-range', 'циклов в диапазоне загрузки 0,45 - 0,55', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.05.L                      ', 'real', 'winch1-0_45-0_55-load', 'нагрузка в диапазоне загрузки 0,45 - 0,55', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.06                        ', 'real', 'winch1-cycles-0_55-0_65-load-range', 'циклов в диапазоне загрузки 0,55 - 0,65', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.06.L                      ', 'real', 'winch1-0_55-0_65-load', 'нагрузка в диапазоне загрузки 0,55 - 0,65', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.07                        ', 'real', 'winch1-cycles-0_65-0_75-load-range', 'циклов в диапазоне загрузки 0,65 - 0,75', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.07.L                      ', 'real', 'winch1-0_65-0_75-load', 'нагрузка в диапазоне загрузки 0,65 - 0,75', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.08                        ', 'real', 'winch1-cycles-0_75-0_85-load-range', 'циклов в диапазоне загрузки 0,75 - 0,85', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.08.L                      ', 'real', 'winch1-0_75-0_85-load', 'нагрузка в диапазоне загрузки 0,75 - 0,85', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.09                        ', 'real', 'winch1-cycles-0_85-0_95-load-range', 'циклов в диапазоне загрузки 0,85 - 0,95', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.09.L                      ', 'real', 'winch1-0_85-0_95-load', 'нагрузка в диапазоне загрузки 0,85 - 0,95', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.10                        ', 'real', 'winch1-cycles-0_95-1_05-load-range', 'циклов в диапазоне загрузки 0,95 - 1,05', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.10.L                      ', 'real', 'winch1-0_95-1_05-load', 'нагрузка в диапазоне загрузки 0,95 - 1,05', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.11                        ', 'real', 'winch1-cycles-1_05-1_15-load-range', 'циклов в диапазоне загрузки 1,05 - 1,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.11.L                      ', 'real', 'winch1-1_05-1_15-load', 'нагрузка в диапазоне загрузки 1,05 - 1,15', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.12                        ', 'real', 'winch1-cycles-1_15-1_25-load-range', 'циклов в диапазоне загрузки 1,15 - 1,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.12.L                      ', 'real', 'winch1-1_15-1_25-load', 'нагрузка в диапазоне загрузки 1,15 - 1,25', '0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.13                        ', 'real', 'winch1-cycles-1_25-load-range', 'циклов в диапазоне загрузки 1,25 -', '0.0');
INSERT INTO public.rec_basic_metric VALUES ('3.4.2.13.L                      ', 'real', 'winch1-1_25-load', 'нагрузка в диапазоне загрузки 1,25 -', '0.0');


--
-- TOC entry 3124 (class 0 OID 74298)
-- Dependencies: 224
-- Data for Name: rec_name; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.rec_name VALUES ('4               ', NULL, 'Trip count', 'Количество срабатываний');
INSERT INTO public.rec_name VALUES ('5               ', NULL, 'Diviation max', 'Максимальное отклонение');
INSERT INTO public.rec_name VALUES ('average_load    ', NULL, 'Average load', 'Средняя нагрузка за цикл');
INSERT INTO public.rec_name VALUES ('average         ', NULL, 'Average', 'Среднее арифметическое');
INSERT INTO public.rec_name VALUES ('max             ', NULL, 'Maximum', 'Максимальное');
INSERT INTO public.rec_name VALUES ('min             ', NULL, 'Minimum', 'Минимальное');
INSERT INTO public.rec_name VALUES ('max_load        ', NULL, 'Maximum load', 'Максимальная нашрузка');
INSERT INTO public.rec_name VALUES ('min_load        ', NULL, 'Minimum load', 'Минимальная нагрузка');


--
-- TOC entry 3113 (class 0 OID 27918)
-- Dependencies: 206
-- Data for Name: rec_operating_cycle; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.rec_operating_cycle VALUES (0, '2024-06-27 16:14:27.39166', '2024-06-27 16:14:27.714717', '0 ');
INSERT INTO public.rec_operating_cycle VALUES (1, '2024-06-27 16:20:13.18401', '2024-06-27 16:20:13.507822', '0 ');
INSERT INTO public.rec_operating_cycle VALUES (2, '2024-06-27 16:20:44.464925', '2024-06-27 16:20:44.789916', '0 ');
INSERT INTO public.rec_operating_cycle VALUES (3, '2024-06-27 16:23:01.647173', '2024-06-27 16:23:01.971118', '0 ');
INSERT INTO public.rec_operating_cycle VALUES (8, '2024-07-16 10:06:28.990112', '2024-07-16 10:06:29.322689', '0 ');
INSERT INTO public.rec_operating_cycle VALUES (9, '2024-07-16 10:09:42.195177', '2024-07-16 10:09:42.529297', '0 ');
INSERT INTO public.rec_operating_cycle VALUES (275, '2024-07-17 15:50:13.9998', '2024-07-17 16:12:14.254342', '0 ');


--
-- TOC entry 3122 (class 0 OID 74242)
-- Dependencies: 222
-- Data for Name: rec_operating_event; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.rec_operating_event VALUES (1, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (2, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (3, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (4, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (5, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (6, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (7, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (8, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (9, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (10, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (11, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (12, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (13, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (14, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (15, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (16, 81, '2024-07-16 12:44:01.833374', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (17, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (18, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (19, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (20, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (21, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (22, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (23, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (24, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (25, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (26, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (27, 82, '2024-07-16 12:47:23.153087', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (28, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (29, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (30, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (31, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (32, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (33, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (34, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (35, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (36, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (37, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (38, 83, '2024-07-16 12:52:34.784077', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (52, 112, '2024-07-16 14:04:06.744644', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (53, 112, '2024-07-16 14:04:06.764812', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (54, 112, '2024-07-16 14:04:06.815244', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (55, 112, '2024-07-16 14:04:06.825321', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (56, 112, '2024-07-16 14:04:06.865825', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (57, 112, '2024-07-16 14:04:06.875904', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (58, 112, '2024-07-16 14:04:06.896051', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (59, 113, '2024-07-16 14:04:07.492361', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (60, 113, '2024-07-16 14:04:07.583053', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (61, 113, '2024-07-16 14:04:07.603202', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (62, 117, '2024-07-16 14:14:20.165087', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (63, 117, '2024-07-16 14:14:20.185238', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (64, 117, '2024-07-16 14:14:20.185238', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (65, 117, '2024-07-16 14:14:20.185238', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (66, 117, '2024-07-16 14:14:20.185238', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (67, 117, '2024-07-16 14:14:20.237515', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (68, 117, '2024-07-16 14:14:20.247591', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (69, 117, '2024-07-16 14:14:20.247591', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (70, 117, '2024-07-16 14:14:20.247591', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (71, 117, '2024-07-16 14:14:20.247591', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (72, 117, '2024-07-16 14:14:20.287929', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (73, 117, '2024-07-16 14:14:20.298019', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (74, 117, '2024-07-16 14:14:20.298019', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (75, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (76, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (77, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (78, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (79, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (80, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (81, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (82, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (83, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (84, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (85, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (86, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (87, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (88, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (89, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (90, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (91, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (92, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (93, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (94, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (95, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (96, 117, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (97, 118, '2024-07-16 14:14:20.320057', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (98, 132, '2024-07-16 14:30:39.113113', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (99, 132, '2024-07-16 14:30:39.133251', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (100, 132, '2024-07-16 14:30:39.183639', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (101, 132, '2024-07-16 14:30:39.193716', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (102, 132, '2024-07-16 14:30:39.234055', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (103, 132, '2024-07-16 14:30:39.244134', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (104, 132, '2024-07-16 14:30:39.264319', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (105, 133, '2024-07-16 14:30:39.864408', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (106, 133, '2024-07-16 14:30:39.955198', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (107, 133, '2024-07-16 14:30:39.975338', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (108, 137, '2024-07-16 14:32:18.370835', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (109, 137, '2024-07-16 14:32:18.391113', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (110, 137, '2024-07-16 14:32:18.442228', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (111, 137, '2024-07-16 14:32:18.452305', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (112, 137, '2024-07-16 14:32:18.492733', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (113, 137, '2024-07-16 14:32:18.502805', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (114, 137, '2024-07-16 14:32:18.522946', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (115, 138, '2024-07-16 14:32:19.122626', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (116, 138, '2024-07-16 14:32:19.213394', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (117, 138, '2024-07-16 14:32:19.233584', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (118, 142, '2024-07-16 14:36:06.554153', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (119, 142, '2024-07-16 14:36:06.574295', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (120, 142, '2024-07-16 14:36:06.62468', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (121, 142, '2024-07-16 14:36:06.634755', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (122, 142, '2024-07-16 14:36:06.675119', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (123, 142, '2024-07-16 14:36:06.685204', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (124, 142, '2024-07-16 14:36:06.705375', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (125, 143, '2024-07-16 14:36:07.300766', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (126, 143, '2024-07-16 14:36:07.39161', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (127, 143, '2024-07-16 14:36:07.411753', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (128, 144, '2024-07-16 14:36:07.63534', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (129, 147, '2024-07-16 14:36:41.362567', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (130, 147, '2024-07-16 14:36:41.382714', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (131, 147, '2024-07-16 14:36:41.433684', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (132, 147, '2024-07-16 14:36:41.443765', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (133, 147, '2024-07-16 14:36:41.485744', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (134, 147, '2024-07-16 14:36:41.495828', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (135, 147, '2024-07-16 14:36:41.516182', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (136, 148, '2024-07-16 14:36:42.113964', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (137, 148, '2024-07-16 14:36:42.204804', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (138, 148, '2024-07-16 14:36:42.225062', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (139, 149, '2024-07-16 14:36:42.447308', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (140, 152, '2024-07-16 14:42:19.018725', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (141, 152, '2024-07-16 14:42:19.038891', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (142, 152, '2024-07-16 14:42:19.089269', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (143, 152, '2024-07-16 14:42:19.099344', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (144, 152, '2024-07-16 14:42:19.139662', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (145, 152, '2024-07-16 14:42:19.153028', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (146, 152, '2024-07-16 14:42:19.173267', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (147, 153, '2024-07-16 14:42:19.767915', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (148, 153, '2024-07-16 14:42:19.858556', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (149, 153, '2024-07-16 14:42:19.878721', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (150, 154, '2024-07-16 14:42:20.102391', 'CraneLoadEvent', 0.30000000, 0);
INSERT INTO public.rec_operating_event VALUES (151, 157, '2024-07-16 14:58:35.259658', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (152, 157, '2024-07-16 14:58:35.281081', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (153, 157, '2024-07-16 14:58:35.33148', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (154, 157, '2024-07-16 14:58:35.341551', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (155, 157, '2024-07-16 14:58:35.381953', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (156, 157, '2024-07-16 14:58:35.392045', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (157, 157, '2024-07-16 14:58:35.412204', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (158, 158, '2024-07-16 14:58:36.007644', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (159, 158, '2024-07-16 14:58:36.098368', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (160, 158, '2024-07-16 14:58:36.118514', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (161, 162, '2024-07-16 15:26:58.632972', 'CraneLoadEvent', 8.10000000, 0);
INSERT INTO public.rec_operating_event VALUES (162, 163, '2024-07-16 15:26:58.815428', 'CraneLoadEvent', 12.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (163, 163, '2024-07-16 15:26:58.825499', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (164, 163, '2024-07-16 15:26:58.845691', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (165, 163, '2024-07-16 15:26:58.89623', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (166, 163, '2024-07-16 15:26:58.906296', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (167, 163, '2024-07-16 15:26:58.946661', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (168, 163, '2024-07-16 15:26:58.956729', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (169, 163, '2024-07-16 15:26:58.976951', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (170, 164, '2024-07-16 15:26:59.551866', 'CraneLoadEvent', 12.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (171, 164, '2024-07-16 15:26:59.561938', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (172, 164, '2024-07-16 15:26:59.572019', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (173, 164, '2024-07-16 15:26:59.662755', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (174, 164, '2024-07-16 15:26:59.682911', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (175, 170, '2024-07-16 15:32:42.779267', 'CraneLoadEvent', 8.10000000, 0);
INSERT INTO public.rec_operating_event VALUES (176, 171, '2024-07-16 15:32:42.960785', 'CraneLoadEvent', 12.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (177, 171, '2024-07-16 15:32:42.970857', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (178, 171, '2024-07-16 15:32:42.991', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (179, 171, '2024-07-16 15:32:43.041727', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (180, 171, '2024-07-16 15:32:43.051812', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (181, 171, '2024-07-16 15:32:43.092166', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (182, 171, '2024-07-16 15:32:43.102242', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (183, 171, '2024-07-16 15:32:43.122419', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (184, 172, '2024-07-16 15:32:43.697029', 'CraneLoadEvent', 12.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (185, 172, '2024-07-16 15:32:43.707104', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (186, 172, '2024-07-16 15:32:43.717276', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (187, 172, '2024-07-16 15:32:43.808219', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (188, 172, '2024-07-16 15:32:43.828364', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (189, 178, '2024-07-16 15:34:26.003581', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (190, 178, '2024-07-16 15:34:26.023737', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (191, 178, '2024-07-16 15:34:26.074164', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (192, 178, '2024-07-16 15:34:26.084391', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (193, 178, '2024-07-16 15:34:26.124712', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (194, 178, '2024-07-16 15:34:26.134788', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (195, 178, '2024-07-16 15:34:26.15495', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (196, 179, '2024-07-16 15:34:26.749941', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (197, 179, '2024-07-16 15:34:26.840732', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (198, 179, '2024-07-16 15:34:26.860891', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (199, 185, '2024-07-16 15:38:38.954377', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (200, 185, '2024-07-16 15:38:38.974643', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (201, 185, '2024-07-16 15:38:39.025013', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (202, 185, '2024-07-16 15:38:39.035092', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (203, 185, '2024-07-16 15:38:39.075432', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (204, 185, '2024-07-16 15:38:39.08551', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (205, 185, '2024-07-16 15:38:39.105659', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (206, 186, '2024-07-16 15:38:39.700901', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (207, 186, '2024-07-16 15:38:39.792572', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (208, 186, '2024-07-16 15:38:39.812733', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (209, 192, '2024-07-16 15:39:55.04622', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (210, 192, '2024-07-16 15:39:55.066365', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (211, 192, '2024-07-16 15:39:55.120918', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (212, 192, '2024-07-16 15:39:55.131384', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (213, 192, '2024-07-16 15:39:55.171703', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (214, 192, '2024-07-16 15:39:55.181799', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (215, 192, '2024-07-16 15:39:55.201961', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (216, 193, '2024-07-16 15:39:55.645791', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (217, 193, '2024-07-16 15:39:55.787571', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (218, 193, '2024-07-16 15:39:55.797642', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (219, 193, '2024-07-16 15:39:55.888418', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (220, 193, '2024-07-16 15:39:55.908564', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (221, 199, '2024-07-16 15:44:23.854736', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (222, 199, '2024-07-16 15:44:23.87487', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (223, 199, '2024-07-16 15:44:23.925323', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (224, 199, '2024-07-16 15:44:23.935559', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (225, 199, '2024-07-16 15:44:23.975863', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (226, 199, '2024-07-16 15:44:23.985957', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (227, 199, '2024-07-16 15:44:24.006161', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (228, 200, '2024-07-16 15:44:24.452712', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (229, 200, '2024-07-16 15:44:24.593915', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (230, 200, '2024-07-16 15:44:24.603992', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (231, 200, '2024-07-16 15:44:24.694884', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (232, 200, '2024-07-16 15:44:24.715032', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (233, 204, '2024-07-16 15:45:09.738593', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (234, 204, '2024-07-16 15:45:09.758756', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (235, 204, '2024-07-16 15:45:09.809189', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (236, 204, '2024-07-16 15:45:09.819261', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (237, 204, '2024-07-16 15:45:09.859607', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (238, 204, '2024-07-16 15:45:09.869699', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (239, 204, '2024-07-16 15:45:09.889849', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (240, 205, '2024-07-16 15:45:10.337431', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (241, 205, '2024-07-16 15:45:10.478405', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (242, 205, '2024-07-16 15:45:10.488476', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (243, 205, '2024-07-16 15:45:10.579216', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (244, 205, '2024-07-16 15:45:10.599896', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (245, 209, '2024-07-16 15:46:58.003067', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (246, 209, '2024-07-16 15:46:58.946554', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (247, 209, '2024-07-16 15:46:58.966715', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (248, 209, '2024-07-16 15:46:59.017106', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (249, 209, '2024-07-16 15:46:59.027185', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (250, 209, '2024-07-16 15:46:59.067514', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (251, 209, '2024-07-16 15:46:59.077589', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (252, 209, '2024-07-16 15:46:59.097794', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (253, 210, '2024-07-16 15:46:59.541508', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (254, 210, '2024-07-16 15:46:59.682509', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (255, 210, '2024-07-16 15:46:59.692598', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (256, 210, '2024-07-16 15:46:59.783324', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (257, 210, '2024-07-16 15:46:59.803542', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (258, 211, '2024-07-16 15:47:00.267473', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (259, 211, '2024-07-16 15:47:00.27755', 'Winch1LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (260, 211, '2024-07-16 15:47:00.368397', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (261, 211, '2024-07-16 15:47:00.388547', 'Winch1LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (262, 212, '2024-07-16 15:47:00.842368', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (263, 212, '2024-07-16 15:47:00.852441', 'Winch2LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (264, 212, '2024-07-16 15:47:00.94339', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (265, 212, '2024-07-16 15:47:00.963554', 'Winch2LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (266, 213, '2024-07-16 15:47:01.417287', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (267, 213, '2024-07-16 15:47:01.427366', 'Winch3LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (268, 213, '2024-07-16 15:47:01.518067', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (269, 213, '2024-07-16 15:47:01.538216', 'Winch3LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (270, 214, '2024-07-16 15:49:38.523658', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (271, 214, '2024-07-16 15:49:39.466924', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (272, 214, '2024-07-16 15:49:39.487069', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (273, 214, '2024-07-16 15:49:39.537567', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (274, 214, '2024-07-16 15:49:39.547636', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (275, 214, '2024-07-16 15:49:39.587944', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (276, 214, '2024-07-16 15:49:39.598017', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (277, 214, '2024-07-16 15:49:39.618124', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (278, 215, '2024-07-16 15:49:40.062092', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (279, 215, '2024-07-16 15:49:40.203787', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (280, 215, '2024-07-16 15:49:40.21386', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (281, 215, '2024-07-16 15:49:40.304529', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (282, 215, '2024-07-16 15:49:40.324814', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (283, 216, '2024-07-16 15:49:40.788502', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (284, 216, '2024-07-16 15:49:40.798601', 'Winch1LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (285, 216, '2024-07-16 15:49:40.889286', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (286, 216, '2024-07-16 15:49:40.909426', 'Winch1LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (287, 217, '2024-07-16 15:49:41.36391', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (288, 217, '2024-07-16 15:49:41.374093', 'Winch2LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (289, 217, '2024-07-16 15:49:41.464794', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (290, 217, '2024-07-16 15:49:41.484908', 'Winch2LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (291, 218, '2024-07-16 15:49:41.939566', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (292, 218, '2024-07-16 15:49:41.949633', 'Winch3LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (293, 218, '2024-07-16 15:49:42.040372', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (294, 218, '2024-07-16 15:49:42.060519', 'Winch3LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (295, 219, '2024-07-16 15:51:30.310964', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (296, 219, '2024-07-16 15:51:31.254501', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (297, 219, '2024-07-16 15:51:31.274766', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (298, 219, '2024-07-16 15:51:31.325282', 'CraneLoadEvent', 141.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (299, 219, '2024-07-16 15:51:31.335356', 'CraneLoadEvent', 130.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (300, 219, '2024-07-16 15:51:31.37565', 'CraneLoadEvent', 120.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (301, 219, '2024-07-16 15:51:31.385742', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (302, 219, '2024-07-16 15:51:31.405987', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (303, 220, '2024-07-16 15:51:31.850207', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (304, 220, '2024-07-16 15:51:31.991384', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (305, 220, '2024-07-16 15:51:32.001449', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (306, 220, '2024-07-16 15:51:32.092154', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (307, 220, '2024-07-16 15:51:32.112318', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (308, 221, '2024-07-16 15:51:32.576129', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (309, 221, '2024-07-16 15:51:32.586206', 'Winch1LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (310, 221, '2024-07-16 15:51:32.676907', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (311, 221, '2024-07-16 15:51:32.697047', 'Winch1LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (312, 222, '2024-07-16 15:51:33.159251', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (313, 222, '2024-07-16 15:51:33.169436', 'Winch2LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (314, 222, '2024-07-16 15:51:33.260106', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (315, 222, '2024-07-16 15:51:33.280261', 'Winch2LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (316, 223, '2024-07-16 15:51:33.733659', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (317, 223, '2024-07-16 15:51:33.743743', 'Winch3LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (318, 223, '2024-07-16 15:51:33.834531', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (319, 223, '2024-07-16 15:51:33.85468', 'Winch3LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (320, 224, '2024-07-16 15:54:01.962773', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (321, 224, '2024-07-16 15:54:02.907245', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (322, 224, '2024-07-16 15:54:02.931228', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (323, 224, '2024-07-16 15:54:03.032127', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (324, 224, '2024-07-16 15:54:03.052311', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (325, 225, '2024-07-16 15:54:03.496947', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (326, 225, '2024-07-16 15:54:03.63886', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (327, 225, '2024-07-16 15:54:03.648978', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (328, 225, '2024-07-16 15:54:03.739988', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (329, 225, '2024-07-16 15:54:03.760198', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (330, 226, '2024-07-16 15:54:04.228507', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (331, 226, '2024-07-16 15:54:04.238603', 'Winch1LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (332, 226, '2024-07-16 15:54:04.329485', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (333, 226, '2024-07-16 15:54:04.349681', 'Winch1LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (334, 227, '2024-07-16 15:54:04.812085', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (335, 227, '2024-07-16 15:54:04.822179', 'Winch2LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (336, 227, '2024-07-16 15:54:04.91323', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (337, 227, '2024-07-16 15:54:04.933404', 'Winch2LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (338, 228, '2024-07-16 15:54:05.396048', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (339, 228, '2024-07-16 15:54:05.406145', 'Winch3LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (340, 228, '2024-07-16 15:54:05.497492', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (341, 228, '2024-07-16 15:54:05.517674', 'Winch3LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (342, 265, '2024-07-17 15:21:21.956131', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (343, 265, '2024-07-17 15:21:22.900104', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (344, 265, '2024-07-17 15:21:22.910172', 'CraneMOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (345, 265, '2024-07-17 15:21:22.920272', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (346, 265, '2024-07-17 15:21:22.940451', 'CraneAOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (347, 265, '2024-07-17 15:21:23.02108', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (348, 265, '2024-07-17 15:21:23.041225', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (349, 266, '2024-07-17 15:21:23.49061', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (350, 266, '2024-07-17 15:21:23.631893', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (351, 266, '2024-07-17 15:21:23.641971', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (352, 266, '2024-07-17 15:21:23.732661', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (353, 266, '2024-07-17 15:21:23.752846', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (354, 267, '2024-07-17 15:21:24.21699', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (355, 267, '2024-07-17 15:21:24.22707', 'Winch1LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (356, 267, '2024-07-17 15:21:24.317794', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (357, 267, '2024-07-17 15:21:24.337948', 'Winch1LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (358, 268, '2024-07-17 15:21:24.791864', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (359, 268, '2024-07-17 15:21:24.801939', 'Winch2LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (360, 268, '2024-07-17 15:21:24.892604', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (361, 268, '2024-07-17 15:21:24.91276', 'Winch2LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (362, 269, '2024-07-17 15:21:25.366748', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (363, 269, '2024-07-17 15:21:25.376819', 'Winch3LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (364, 269, '2024-07-17 15:21:25.467559', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (365, 269, '2024-07-17 15:21:25.487789', 'Winch3LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (366, 270, '2024-07-17 15:38:56.315484', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (367, 270, '2024-07-17 15:38:57.262215', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (368, 270, '2024-07-17 15:38:57.272299', 'CraneMOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (369, 270, '2024-07-17 15:41:03.574199', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (370, 270, '2024-07-17 15:41:04.517122', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (371, 270, '2024-07-17 15:41:04.527191', 'CraneMOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (372, 270, '2024-07-17 15:41:04.537261', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (373, 270, '2024-07-17 15:41:04.557527', 'CraneAOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (374, 270, '2024-07-17 15:41:04.638375', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (375, 270, '2024-07-17 15:41:04.65855', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (376, 271, '2024-07-17 15:41:05.105763', 'CraneLoadEvent', 5.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (377, 271, '2024-07-17 15:41:05.24709', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (378, 271, '2024-07-17 15:41:05.257167', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (379, 271, '2024-07-17 15:41:05.34856', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (380, 271, '2024-07-17 15:41:05.368719', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (381, 272, '2024-07-17 15:41:05.833194', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (382, 272, '2024-07-17 15:41:05.843266', 'Winch1LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (383, 272, '2024-07-17 15:41:05.93396', 'Winch1LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (384, 272, '2024-07-17 15:41:05.954109', 'Winch1LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (385, 273, '2024-07-17 15:41:06.411683', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (386, 273, '2024-07-17 15:41:06.421757', 'Winch2LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (387, 273, '2024-07-17 15:41:06.512578', 'Winch2LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (388, 273, '2024-07-17 15:41:06.53274', 'Winch2LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (389, 274, '2024-07-17 15:41:06.988886', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (390, 274, '2024-07-17 15:41:06.99896', 'Winch3LoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (391, 274, '2024-07-17 15:41:07.089691', 'Winch3LoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (392, 274, '2024-07-17 15:41:07.109854', 'Winch3LoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (393, 275, '2024-07-17 15:50:13.9998', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (394, 275, '2024-07-17 15:50:14.472255', 'CraneLoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (395, 275, '2024-07-17 15:50:14.634607', 'CraneLoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (396, 275, '2024-07-17 15:50:14.644672', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (397, 275, '2024-07-17 15:50:14.675176', 'CraneLoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (398, 275, '2024-07-17 15:50:14.685331', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (399, 275, '2024-07-17 15:50:14.715839', 'CraneLoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (400, 275, '2024-07-17 15:50:14.726005', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (401, 275, '2024-07-17 15:50:14.756508', 'CraneLoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (402, 275, '2024-07-17 15:50:14.766668', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (403, 275, '2024-07-17 15:50:14.797163', 'CraneLoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (404, 275, '2024-07-17 15:50:14.807323', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (405, 275, '2024-07-17 15:50:14.837714', 'CraneLoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (406, 275, '2024-07-17 15:50:14.847809', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (407, 275, '2024-07-17 15:50:14.878027', 'CraneLoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (408, 275, '2024-07-17 15:50:14.888086', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (409, 275, '2024-07-17 15:50:14.918297', 'CraneLoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (410, 275, '2024-07-17 15:50:14.928352', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (411, 275, '2024-07-17 15:50:14.958506', 'CraneLoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (412, 275, '2024-07-17 15:50:14.96856', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (413, 275, '2024-07-17 15:50:14.998738', 'CraneLoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (414, 275, '2024-07-17 15:50:15.008814', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (415, 275, '2024-07-17 15:50:15.039018', 'CraneLoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (416, 275, '2024-07-17 15:50:15.049088', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (417, 275, '2024-07-17 15:50:15.079339', 'CraneLoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (418, 275, '2024-07-17 15:50:15.089413', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (419, 275, '2024-07-17 15:50:15.119626', 'CraneLoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (420, 275, '2024-07-17 15:50:15.12972', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (421, 275, '2024-07-17 15:50:15.159948', 'CraneLoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (422, 275, '2024-07-17 15:50:15.170039', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (423, 275, '2024-07-17 15:50:15.200261', 'CraneLoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (424, 275, '2024-07-17 15:50:15.210443', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (425, 275, '2024-07-17 15:50:15.240754', 'CraneLoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (426, 275, '2024-07-17 15:50:15.250855', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (427, 275, '2024-07-17 15:50:15.281292', 'CraneLoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (428, 275, '2024-07-17 15:50:15.291464', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (429, 275, '2024-07-17 15:50:15.321685', 'CraneLoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (430, 275, '2024-07-17 15:50:15.331759', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (431, 275, '2024-07-17 15:50:15.362737', 'CraneLoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (432, 275, '2024-07-17 15:50:15.372866', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (433, 275, '2024-07-17 15:50:15.524951', 'Winch1LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (434, 275, '2024-07-17 15:50:15.687449', 'Winch1LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (435, 275, '2024-07-17 15:50:15.697607', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (436, 275, '2024-07-17 15:50:15.728086', 'Winch1LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (437, 275, '2024-07-17 15:50:15.738244', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (438, 275, '2024-07-17 15:50:15.768729', 'Winch1LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (439, 275, '2024-07-17 15:50:15.778887', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (440, 275, '2024-07-17 15:50:15.809318', 'Winch1LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (441, 275, '2024-07-17 15:50:15.819482', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (442, 275, '2024-07-17 15:50:15.84999', 'Winch1LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (443, 275, '2024-07-17 15:50:15.860149', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (444, 275, '2024-07-17 15:50:15.890669', 'Winch1LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (445, 275, '2024-07-17 15:50:15.90083', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (446, 275, '2024-07-17 15:50:15.931268', 'Winch1LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (447, 275, '2024-07-17 15:50:15.941352', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (448, 275, '2024-07-17 15:50:15.971849', 'Winch1LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (449, 275, '2024-07-17 15:50:15.982026', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (450, 275, '2024-07-17 15:50:16.012323', 'Winch1LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (451, 275, '2024-07-17 15:50:16.022389', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (452, 275, '2024-07-17 15:50:16.05273', 'Winch1LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (453, 275, '2024-07-17 15:50:16.062794', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (454, 275, '2024-07-17 15:50:16.093039', 'Winch1LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (455, 275, '2024-07-17 15:50:16.103112', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (456, 275, '2024-07-17 15:50:16.134914', 'Winch1LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (457, 275, '2024-07-17 15:50:16.144987', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (458, 275, '2024-07-17 15:50:16.17521', 'Winch1LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (459, 275, '2024-07-17 15:50:16.185288', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (460, 275, '2024-07-17 15:50:16.215521', 'Winch1LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (461, 275, '2024-07-17 15:50:16.225634', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (462, 275, '2024-07-17 15:50:16.256062', 'Winch1LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (463, 275, '2024-07-17 15:50:16.266192', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (464, 275, '2024-07-17 15:50:16.296449', 'Winch1LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (465, 275, '2024-07-17 15:50:16.306522', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (466, 275, '2024-07-17 15:50:16.336918', 'Winch1LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (467, 275, '2024-07-17 15:50:16.347113', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (468, 275, '2024-07-17 15:50:16.377582', 'Winch1LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (469, 275, '2024-07-17 15:50:16.387784', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (470, 275, '2024-07-17 15:50:16.41841', 'Winch1LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (471, 275, '2024-07-17 15:50:16.428609', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (472, 275, '2024-07-17 15:50:16.581091', 'Winch2LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (473, 275, '2024-07-17 15:50:16.743274', 'Winch2LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (474, 275, '2024-07-17 15:50:16.75338', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (475, 275, '2024-07-17 15:50:16.783878', 'Winch2LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (476, 275, '2024-07-17 15:50:16.794078', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (477, 275, '2024-07-17 15:50:16.824424', 'Winch2LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (478, 275, '2024-07-17 15:50:16.834624', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (479, 275, '2024-07-17 15:50:16.864949', 'Winch2LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (480, 275, '2024-07-17 15:50:16.875093', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (481, 275, '2024-07-17 15:50:16.905492', 'Winch2LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (482, 275, '2024-07-17 15:50:16.915693', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (483, 275, '2024-07-17 15:50:16.946085', 'Winch2LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (484, 275, '2024-07-17 15:50:16.956283', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (485, 275, '2024-07-17 15:50:16.98668', 'Winch2LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (486, 275, '2024-07-17 15:50:16.996753', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (487, 275, '2024-07-17 15:50:17.027088', 'Winch2LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (488, 275, '2024-07-17 15:50:17.037214', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (489, 275, '2024-07-17 15:50:17.067554', 'Winch2LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (490, 275, '2024-07-17 15:50:17.077653', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (491, 275, '2024-07-17 15:50:17.108084', 'Winch2LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (492, 275, '2024-07-17 15:50:17.118177', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (493, 275, '2024-07-17 15:50:17.148524', 'Winch2LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (494, 275, '2024-07-17 15:50:17.158592', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (495, 275, '2024-07-17 15:50:17.188912', 'Winch2LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (496, 275, '2024-07-17 15:50:17.199104', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (497, 275, '2024-07-17 15:50:17.229633', 'Winch2LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (498, 275, '2024-07-17 15:50:17.239737', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (499, 275, '2024-07-17 15:50:17.270199', 'Winch2LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (500, 275, '2024-07-17 15:50:17.280389', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (501, 275, '2024-07-17 15:50:17.310786', 'Winch2LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (502, 275, '2024-07-17 15:50:17.320868', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (503, 275, '2024-07-17 15:50:17.351142', 'Winch2LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (504, 275, '2024-07-17 15:50:17.361211', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (505, 275, '2024-07-17 15:50:17.391555', 'Winch2LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (506, 275, '2024-07-17 15:50:17.40165', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (507, 275, '2024-07-17 15:50:17.431909', 'Winch2LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (508, 275, '2024-07-17 15:50:17.441983', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (509, 275, '2024-07-17 15:50:17.472509', 'Winch2LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (510, 275, '2024-07-17 15:50:17.482697', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (511, 275, '2024-07-17 15:50:17.635409', 'Winch3LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (512, 275, '2024-07-17 15:50:17.797651', 'Winch3LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (513, 275, '2024-07-17 15:50:17.807822', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (514, 275, '2024-07-17 15:50:17.838239', 'Winch3LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (515, 275, '2024-07-17 15:50:17.848407', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (516, 275, '2024-07-17 15:50:17.878672', 'Winch3LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (517, 275, '2024-07-17 15:50:17.888742', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (518, 275, '2024-07-17 15:50:17.919107', 'Winch3LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (519, 275, '2024-07-17 15:50:17.929351', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (520, 275, '2024-07-17 15:53:12.865368', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (521, 275, '2024-07-17 15:53:13.338141', 'CraneLoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (522, 275, '2024-07-17 15:53:13.500459', 'CraneLoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (523, 275, '2024-07-17 15:53:13.510635', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (524, 275, '2024-07-17 15:53:13.540901', 'CraneLoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (525, 275, '2024-07-17 15:53:13.551072', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (526, 275, '2024-07-17 15:53:13.581568', 'CraneLoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (527, 275, '2024-07-17 15:53:13.591726', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (528, 275, '2024-07-17 15:53:13.62222', 'CraneLoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (529, 275, '2024-07-17 15:53:13.632279', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (530, 275, '2024-07-17 15:53:13.662681', 'CraneLoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (531, 275, '2024-07-17 15:53:13.67286', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (532, 275, '2024-07-17 15:53:13.703433', 'CraneLoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (533, 275, '2024-07-17 15:53:13.713619', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (534, 275, '2024-07-17 15:53:13.744025', 'CraneLoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (535, 275, '2024-07-17 15:53:13.75409', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (536, 275, '2024-07-17 15:53:13.784432', 'CraneLoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (537, 275, '2024-07-17 15:53:13.79453', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (538, 275, '2024-07-17 15:53:13.824927', 'CraneLoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (539, 275, '2024-07-17 15:53:13.835114', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (540, 275, '2024-07-17 15:53:13.865586', 'CraneLoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (541, 275, '2024-07-17 15:53:13.87577', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (542, 275, '2024-07-17 15:53:13.906397', 'CraneLoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (543, 275, '2024-07-17 15:53:13.916604', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (544, 275, '2024-07-17 15:53:13.947174', 'CraneLoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (545, 275, '2024-07-17 15:53:13.957358', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (546, 275, '2024-07-17 15:53:13.98783', 'CraneLoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (547, 275, '2024-07-17 15:53:13.998021', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (548, 275, '2024-07-17 15:53:14.028601', 'CraneLoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (549, 275, '2024-07-17 15:53:14.038787', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (550, 275, '2024-07-17 15:53:14.069328', 'CraneLoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (551, 275, '2024-07-17 15:53:14.079521', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (552, 275, '2024-07-17 15:53:14.110088', 'CraneLoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (553, 275, '2024-07-17 15:53:14.120298', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (554, 275, '2024-07-17 15:53:14.150822', 'CraneLoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (555, 275, '2024-07-17 15:53:14.160891', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (556, 275, '2024-07-17 15:53:14.19106', 'CraneLoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (557, 275, '2024-07-17 15:53:14.201144', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (558, 275, '2024-07-17 15:53:14.231363', 'CraneLoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (559, 275, '2024-07-17 15:53:14.241436', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (560, 275, '2024-07-17 15:53:14.392598', 'Winch1LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (561, 275, '2024-07-17 15:53:14.5541', 'Winch1LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (562, 275, '2024-07-17 15:53:14.564175', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (563, 275, '2024-07-17 15:53:14.5944', 'Winch1LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (564, 275, '2024-07-17 15:53:14.604461', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (565, 275, '2024-07-17 15:53:14.634682', 'Winch1LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (566, 275, '2024-07-17 15:53:14.644753', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (567, 275, '2024-07-17 15:53:14.675122', 'Winch1LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (568, 275, '2024-07-17 15:53:14.685192', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (569, 275, '2024-07-17 15:53:14.7154', 'Winch1LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (570, 275, '2024-07-17 15:53:14.725472', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (571, 275, '2024-07-17 15:53:14.755716', 'Winch1LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (572, 275, '2024-07-17 15:53:14.765789', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (573, 275, '2024-07-17 15:53:14.796059', 'Winch1LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (574, 275, '2024-07-17 15:53:14.806159', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (575, 275, '2024-07-17 15:53:14.836415', 'Winch1LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (576, 275, '2024-07-17 15:53:14.846488', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (577, 275, '2024-07-17 15:53:14.87672', 'Winch1LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (578, 275, '2024-07-17 15:53:14.886802', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (579, 275, '2024-07-17 15:53:14.917039', 'Winch1LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (580, 275, '2024-07-17 15:53:14.927118', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (581, 275, '2024-07-17 15:53:14.957361', 'Winch1LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (582, 275, '2024-07-17 15:53:14.967432', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (583, 275, '2024-07-17 15:53:14.997658', 'Winch1LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (584, 275, '2024-07-17 15:53:15.00774', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (585, 275, '2024-07-17 15:53:15.037957', 'Winch1LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (586, 275, '2024-07-17 15:53:15.04803', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (587, 275, '2024-07-17 15:53:15.078251', 'Winch1LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (588, 275, '2024-07-17 15:53:15.088357', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (589, 275, '2024-07-17 15:53:15.118614', 'Winch1LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (590, 275, '2024-07-17 15:53:15.128694', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (591, 275, '2024-07-17 15:53:15.158988', 'Winch1LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (592, 275, '2024-07-17 15:53:15.169069', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (593, 275, '2024-07-17 15:53:15.199335', 'Winch1LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (594, 275, '2024-07-17 15:53:15.209426', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (595, 275, '2024-07-17 15:53:15.239691', 'Winch1LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (596, 275, '2024-07-17 15:53:15.249766', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (597, 275, '2024-07-17 15:53:15.280078', 'Winch1LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (598, 275, '2024-07-17 15:53:15.290174', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (599, 275, '2024-07-17 15:53:15.441698', 'Winch2LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (600, 275, '2024-07-17 15:53:15.603214', 'Winch2LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (601, 275, '2024-07-17 15:53:15.613291', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (602, 275, '2024-07-17 15:53:15.643624', 'Winch2LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (603, 275, '2024-07-17 15:53:15.653698', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (604, 275, '2024-07-17 15:53:15.683951', 'Winch2LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (605, 275, '2024-07-17 15:53:15.694028', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (606, 275, '2024-07-17 15:53:15.724255', 'Winch2LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (607, 275, '2024-07-17 15:53:15.734365', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (608, 275, '2024-07-17 15:53:15.76461', 'Winch2LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (609, 275, '2024-07-17 15:53:15.774799', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (610, 275, '2024-07-17 15:53:15.80505', 'Winch2LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (611, 275, '2024-07-17 15:53:15.815227', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (612, 275, '2024-07-17 15:53:15.845451', 'Winch2LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (613, 275, '2024-07-17 15:53:15.85552', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (614, 275, '2024-07-17 15:53:15.885726', 'Winch2LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (615, 275, '2024-07-17 15:53:15.895796', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (616, 275, '2024-07-17 15:53:15.926027', 'Winch2LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (617, 275, '2024-07-17 15:53:15.936121', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (618, 275, '2024-07-17 15:53:15.966374', 'Winch2LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (619, 275, '2024-07-17 15:53:15.976461', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (620, 275, '2024-07-17 15:53:16.006722', 'Winch2LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (621, 275, '2024-07-17 15:53:16.01682', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (622, 275, '2024-07-17 15:53:16.047031', 'Winch2LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (623, 275, '2024-07-17 15:53:16.057099', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (624, 275, '2024-07-17 15:53:16.087432', 'Winch2LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (625, 275, '2024-07-17 15:53:16.097502', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (626, 275, '2024-07-17 15:53:16.12773', 'Winch2LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (627, 275, '2024-07-17 15:53:16.137823', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (628, 275, '2024-07-17 15:53:16.168102', 'Winch2LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (629, 275, '2024-07-17 15:53:16.178194', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (630, 275, '2024-07-17 15:53:16.20842', 'Winch2LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (631, 275, '2024-07-17 15:53:16.218519', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (632, 275, '2024-07-17 15:53:16.24875', 'Winch2LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (633, 275, '2024-07-17 15:53:16.258818', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (634, 275, '2024-07-17 15:53:16.289017', 'Winch2LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (635, 275, '2024-07-17 15:53:16.299087', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (636, 275, '2024-07-17 15:53:16.329306', 'Winch2LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (637, 275, '2024-07-17 15:53:16.339375', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (638, 275, '2024-07-17 15:53:16.491324', 'Winch3LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (639, 275, '2024-07-17 15:53:16.65278', 'Winch3LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (640, 275, '2024-07-17 15:53:16.662849', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (641, 275, '2024-07-17 15:53:16.693116', 'Winch3LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (642, 275, '2024-07-17 15:53:16.703234', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (643, 275, '2024-07-17 15:53:16.733433', 'Winch3LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (644, 275, '2024-07-17 15:53:16.743499', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (645, 275, '2024-07-17 15:53:16.773709', 'Winch3LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (646, 275, '2024-07-17 15:53:16.78378', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (647, 275, '2024-07-17 15:53:16.814004', 'Winch3LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (648, 275, '2024-07-17 15:53:16.824082', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (649, 275, '2024-07-17 15:53:16.85442', 'Winch3LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (650, 275, '2024-07-17 15:53:16.864485', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (651, 275, '2024-07-17 15:53:16.894949', 'Winch3LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (652, 275, '2024-07-17 15:53:16.905041', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (653, 275, '2024-07-17 15:53:16.935352', 'Winch3LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (654, 275, '2024-07-17 15:53:16.945426', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (655, 275, '2024-07-17 15:53:16.975691', 'Winch3LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (656, 275, '2024-07-17 15:53:16.985785', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (657, 275, '2024-07-17 15:53:17.016022', 'Winch3LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (658, 275, '2024-07-17 15:53:17.026128', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (659, 275, '2024-07-17 15:53:17.056359', 'Winch3LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (660, 275, '2024-07-17 15:53:17.066426', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (661, 275, '2024-07-17 15:53:17.096631', 'Winch3LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (662, 275, '2024-07-17 15:53:17.106695', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (663, 275, '2024-07-17 15:53:17.136941', 'Winch3LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (664, 275, '2024-07-17 15:53:17.14702', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (665, 275, '2024-07-17 15:53:17.177264', 'Winch3LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (666, 275, '2024-07-17 15:53:17.187361', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (667, 275, '2024-07-17 15:53:17.21763', 'Winch3LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (668, 275, '2024-07-17 15:53:17.227802', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (669, 275, '2024-07-17 15:55:03.099637', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (670, 275, '2024-07-17 15:55:03.572593', 'CraneLoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (671, 275, '2024-07-17 15:55:03.735443', 'CraneLoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (672, 275, '2024-07-17 15:55:03.745636', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (673, 275, '2024-07-17 15:55:03.776091', 'CraneLoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (674, 275, '2024-07-17 15:55:03.786264', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (675, 275, '2024-07-17 15:55:03.816824', 'CraneLoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (676, 275, '2024-07-17 15:55:03.827004', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (677, 275, '2024-07-17 15:55:03.857542', 'CraneLoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (678, 275, '2024-07-17 15:55:03.867736', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (679, 275, '2024-07-17 15:55:03.898265', 'CraneLoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (680, 275, '2024-07-17 15:55:03.908455', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (681, 275, '2024-07-17 15:55:03.938928', 'CraneLoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (682, 275, '2024-07-17 15:55:03.949066', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (683, 275, '2024-07-17 15:55:03.979515', 'CraneLoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (684, 275, '2024-07-17 15:55:03.989689', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (685, 275, '2024-07-17 15:55:04.020115', 'CraneLoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (686, 275, '2024-07-17 15:55:04.030286', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (687, 275, '2024-07-17 15:55:04.060604', 'CraneLoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (688, 275, '2024-07-17 15:55:04.070697', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (689, 275, '2024-07-17 15:55:04.101127', 'CraneLoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (690, 275, '2024-07-17 15:55:04.111295', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (691, 275, '2024-07-17 15:55:04.14179', 'CraneLoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (692, 275, '2024-07-17 15:55:04.151953', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (693, 275, '2024-07-17 15:55:04.182432', 'CraneLoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (694, 275, '2024-07-17 15:55:04.19262', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (695, 275, '2024-07-17 15:55:04.22304', 'CraneLoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (696, 275, '2024-07-17 15:55:04.233205', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (697, 275, '2024-07-17 15:55:04.263697', 'CraneLoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (698, 275, '2024-07-17 15:55:04.273857', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (699, 275, '2024-07-17 15:55:04.304336', 'CraneLoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (700, 275, '2024-07-17 15:55:04.314496', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (701, 275, '2024-07-17 15:55:04.345002', 'CraneLoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (702, 275, '2024-07-17 15:55:04.355162', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (703, 275, '2024-07-17 15:55:04.385633', 'CraneLoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (704, 275, '2024-07-17 15:55:04.395793', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (705, 275, '2024-07-17 15:55:04.426262', 'CraneLoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (706, 275, '2024-07-17 15:55:04.436419', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (707, 275, '2024-07-17 15:55:04.466901', 'CraneLoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (708, 275, '2024-07-17 15:55:04.477055', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (709, 275, '2024-07-17 15:55:04.629376', 'Winch1LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (710, 275, '2024-07-17 15:55:04.791659', 'Winch1LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (711, 275, '2024-07-17 15:55:04.801752', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (712, 275, '2024-07-17 15:55:04.831977', 'Winch1LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (713, 275, '2024-07-17 15:55:04.842047', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (714, 275, '2024-07-17 15:55:04.872261', 'Winch1LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (715, 275, '2024-07-17 15:55:04.882327', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (716, 275, '2024-07-17 15:55:04.912563', 'Winch1LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (717, 275, '2024-07-17 15:55:04.922741', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (718, 275, '2024-07-17 15:55:04.952957', 'Winch1LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (719, 275, '2024-07-17 15:55:04.963026', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (720, 275, '2024-07-17 15:55:04.993251', 'Winch1LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (721, 275, '2024-07-17 15:55:05.003325', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (722, 275, '2024-07-17 15:55:05.033538', 'Winch1LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (723, 275, '2024-07-17 15:55:05.043616', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (724, 275, '2024-07-17 15:55:05.07384', 'Winch1LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (725, 275, '2024-07-17 15:55:05.083918', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (726, 275, '2024-07-17 15:55:05.114175', 'Winch1LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (727, 275, '2024-07-17 15:55:05.124252', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (728, 275, '2024-07-17 15:55:05.154501', 'Winch1LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (729, 275, '2024-07-17 15:55:05.164639', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (730, 275, '2024-07-17 15:55:05.194883', 'Winch1LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (731, 275, '2024-07-17 15:55:05.204963', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (732, 275, '2024-07-17 15:55:05.235211', 'Winch1LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (733, 275, '2024-07-17 15:55:05.245289', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (734, 275, '2024-07-17 15:55:05.275652', 'Winch1LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (735, 275, '2024-07-17 15:55:05.285756', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (736, 275, '2024-07-17 15:55:05.316073', 'Winch1LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (737, 275, '2024-07-17 15:55:05.326189', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (738, 275, '2024-07-17 15:55:05.356498', 'Winch1LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (739, 275, '2024-07-17 15:55:05.366611', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (740, 275, '2024-07-17 15:55:05.396968', 'Winch1LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (741, 275, '2024-07-17 15:55:05.40706', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (742, 275, '2024-07-17 15:55:05.437422', 'Winch1LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (743, 275, '2024-07-17 15:55:05.447536', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (744, 275, '2024-07-17 15:55:05.47808', 'Winch1LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (745, 275, '2024-07-17 15:55:05.488177', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (746, 275, '2024-07-17 15:55:05.518479', 'Winch1LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (747, 275, '2024-07-17 15:55:05.528567', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (748, 275, '2024-07-17 15:55:05.680357', 'Winch2LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (749, 275, '2024-07-17 15:55:05.842005', 'Winch2LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (750, 275, '2024-07-17 15:55:05.852096', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (751, 275, '2024-07-17 15:55:05.882375', 'Winch2LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (752, 275, '2024-07-17 15:55:05.892485', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (753, 275, '2024-07-17 15:55:05.922779', 'Winch2LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (754, 275, '2024-07-17 15:55:05.932883', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (755, 275, '2024-07-17 15:55:05.963193', 'Winch2LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (756, 275, '2024-07-17 15:55:05.973304', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (757, 275, '2024-07-17 15:55:06.003757', 'Winch2LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (758, 275, '2024-07-17 15:55:06.013862', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (759, 275, '2024-07-17 15:55:06.044115', 'Winch2LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (760, 275, '2024-07-17 15:55:06.054197', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (761, 275, '2024-07-17 15:55:06.084458', 'Winch2LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (762, 275, '2024-07-17 15:55:06.09454', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (763, 275, '2024-07-17 15:55:06.12493', 'Winch2LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (764, 275, '2024-07-17 15:55:06.135023', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (765, 275, '2024-07-17 15:55:06.165321', 'Winch2LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (766, 275, '2024-07-17 15:55:06.175424', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (767, 275, '2024-07-17 15:55:06.205719', 'Winch2LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (768, 275, '2024-07-17 15:55:06.215825', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (769, 275, '2024-07-17 15:55:06.24625', 'Winch2LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (770, 275, '2024-07-17 15:55:06.256343', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (771, 275, '2024-07-17 15:55:06.290809', 'Winch2LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (772, 275, '2024-07-17 15:55:06.300923', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (773, 275, '2024-07-17 15:55:06.331215', 'Winch2LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (774, 275, '2024-07-17 15:55:06.34133', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (775, 275, '2024-07-17 15:55:06.37161', 'Winch2LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (776, 275, '2024-07-17 15:55:06.381711', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (777, 275, '2024-07-17 15:55:06.411999', 'Winch2LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (778, 275, '2024-07-17 15:55:06.42209', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (779, 275, '2024-07-17 15:55:06.452373', 'Winch2LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (780, 275, '2024-07-17 15:55:06.462557', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (781, 275, '2024-07-17 15:55:06.492851', 'Winch2LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (782, 275, '2024-07-17 15:55:06.502943', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (783, 275, '2024-07-17 15:55:06.53325', 'Winch2LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (784, 275, '2024-07-17 15:55:06.543358', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (785, 275, '2024-07-17 15:55:06.573687', 'Winch2LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (786, 275, '2024-07-17 15:55:06.583792', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (787, 275, '2024-07-17 15:55:06.735646', 'Winch3LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (788, 275, '2024-07-17 15:55:06.897704', 'Winch3LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (789, 275, '2024-07-17 15:55:06.907812', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (790, 275, '2024-07-17 15:55:06.938081', 'Winch3LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (791, 275, '2024-07-17 15:55:06.948171', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (792, 275, '2024-07-17 15:55:06.978405', 'Winch3LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (793, 275, '2024-07-17 15:55:06.988479', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (794, 275, '2024-07-17 15:55:07.018865', 'Winch3LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (795, 275, '2024-07-17 15:55:07.02897', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (796, 275, '2024-07-17 15:55:07.059365', 'Winch3LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (797, 275, '2024-07-17 15:55:07.069453', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (798, 275, '2024-07-17 15:55:07.09969', 'Winch3LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (799, 275, '2024-07-17 15:55:07.109763', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (800, 275, '2024-07-17 15:55:07.140008', 'Winch3LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (801, 275, '2024-07-17 15:55:07.150098', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (802, 275, '2024-07-17 15:55:07.180359', 'Winch3LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (803, 275, '2024-07-17 15:55:07.190556', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (804, 275, '2024-07-17 15:55:07.220818', 'Winch3LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (805, 275, '2024-07-17 15:55:07.230901', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (806, 275, '2024-07-17 15:55:07.261397', 'Winch3LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (807, 275, '2024-07-17 15:55:07.271608', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (808, 275, '2024-07-17 15:56:18.880107', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (809, 275, '2024-07-17 15:56:19.352838', 'CraneLoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (810, 275, '2024-07-17 15:56:19.515335', 'CraneLoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (811, 275, '2024-07-17 15:56:19.525491', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (812, 275, '2024-07-17 15:56:19.555967', 'CraneLoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (813, 275, '2024-07-17 15:56:19.566127', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (814, 275, '2024-07-17 15:56:19.596551', 'CraneLoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (815, 275, '2024-07-17 15:56:19.60671', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (816, 275, '2024-07-17 15:56:19.637128', 'CraneLoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (817, 275, '2024-07-17 15:56:19.647296', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (818, 275, '2024-07-17 15:56:19.677786', 'CraneLoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (819, 275, '2024-07-17 15:56:19.687953', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (820, 275, '2024-07-17 15:56:19.718448', 'CraneLoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (821, 275, '2024-07-17 15:56:19.728627', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (822, 275, '2024-07-17 15:56:19.759132', 'CraneLoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (823, 275, '2024-07-17 15:56:19.769295', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (824, 275, '2024-07-17 15:56:19.79978', 'CraneLoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (825, 275, '2024-07-17 15:56:19.809947', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (826, 275, '2024-07-17 15:56:19.84045', 'CraneLoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (827, 275, '2024-07-17 15:56:19.850612', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (828, 275, '2024-07-17 15:56:19.881112', 'CraneLoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (829, 275, '2024-07-17 15:56:19.891278', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (830, 275, '2024-07-17 15:56:19.92178', 'CraneLoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (831, 275, '2024-07-17 15:56:19.931942', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (832, 275, '2024-07-17 15:56:19.962373', 'CraneLoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (833, 275, '2024-07-17 15:56:19.972532', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (834, 275, '2024-07-17 15:56:20.003013', 'CraneLoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (835, 275, '2024-07-17 15:56:20.01318', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (836, 275, '2024-07-17 15:56:20.043657', 'CraneLoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (837, 275, '2024-07-17 15:56:20.053818', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (838, 275, '2024-07-17 15:56:20.084303', 'CraneLoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (839, 275, '2024-07-17 15:56:20.094459', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (840, 275, '2024-07-17 15:56:20.12476', 'CraneLoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (841, 275, '2024-07-17 15:56:20.134829', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (842, 275, '2024-07-17 15:56:20.165173', 'CraneLoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (843, 275, '2024-07-17 15:56:20.17524', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (844, 275, '2024-07-17 15:56:20.205656', 'CraneLoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (845, 275, '2024-07-17 15:56:20.215824', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (846, 275, '2024-07-17 15:56:20.246148', 'CraneLoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (847, 275, '2024-07-17 15:56:20.256302', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (848, 275, '2024-07-17 15:56:20.408703', 'Winch1LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (849, 275, '2024-07-17 15:56:20.570869', 'Winch1LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (850, 275, '2024-07-17 15:56:20.580914', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (851, 275, '2024-07-17 15:56:20.611161', 'Winch1LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (852, 275, '2024-07-17 15:56:20.621227', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (853, 275, '2024-07-17 15:56:20.651442', 'Winch1LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (854, 275, '2024-07-17 15:56:20.661528', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (855, 275, '2024-07-17 15:56:20.69178', 'Winch1LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (856, 275, '2024-07-17 15:56:20.701853', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (857, 275, '2024-07-17 15:56:20.732264', 'Winch1LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (858, 275, '2024-07-17 15:56:20.74234', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (859, 275, '2024-07-17 15:56:20.77261', 'Winch1LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (860, 275, '2024-07-17 15:56:20.782724', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (861, 275, '2024-07-17 15:56:20.813008', 'Winch1LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (862, 275, '2024-07-17 15:56:20.823123', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (863, 275, '2024-07-17 15:56:20.853394', 'Winch1LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (864, 275, '2024-07-17 15:56:20.863563', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (865, 275, '2024-07-17 15:56:20.893862', 'Winch1LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (866, 275, '2024-07-17 15:56:20.904026', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (867, 275, '2024-07-17 15:56:20.934507', 'Winch1LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (868, 275, '2024-07-17 15:56:20.944581', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (869, 275, '2024-07-17 15:56:20.974875', 'Winch1LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (870, 275, '2024-07-17 15:56:20.984957', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (871, 275, '2024-07-17 15:56:21.015377', 'Winch1LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (872, 275, '2024-07-17 15:56:21.025465', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (873, 275, '2024-07-17 15:56:21.055755', 'Winch1LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (874, 275, '2024-07-17 15:56:21.065849', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (875, 275, '2024-07-17 15:56:21.096106', 'Winch1LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (876, 275, '2024-07-17 15:56:21.106238', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (877, 275, '2024-07-17 15:56:21.136592', 'Winch1LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (878, 275, '2024-07-17 15:56:21.146688', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (879, 275, '2024-07-17 15:56:21.177037', 'Winch1LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (880, 275, '2024-07-17 15:56:21.187134', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (881, 275, '2024-07-17 15:56:21.217505', 'Winch1LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (882, 275, '2024-07-17 15:56:21.227604', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (883, 275, '2024-07-17 15:56:21.257883', 'Winch1LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (884, 275, '2024-07-17 15:56:21.267973', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (885, 275, '2024-07-17 15:56:21.298322', 'Winch1LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (886, 275, '2024-07-17 15:56:21.308422', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (887, 275, '2024-07-17 15:56:21.460006', 'Winch2LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (888, 275, '2024-07-17 15:56:21.621865', 'Winch2LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (889, 275, '2024-07-17 15:56:21.631941', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (890, 275, '2024-07-17 15:56:21.662171', 'Winch2LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (891, 275, '2024-07-17 15:56:21.672247', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (892, 275, '2024-07-17 15:56:21.702467', 'Winch2LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (893, 275, '2024-07-17 15:56:21.712542', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (894, 275, '2024-07-17 15:56:21.742761', 'Winch2LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (895, 275, '2024-07-17 15:56:21.752829', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (896, 275, '2024-07-17 15:56:21.783086', 'Winch2LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (897, 275, '2024-07-17 15:56:21.793155', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (898, 275, '2024-07-17 15:56:21.823371', 'Winch2LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (899, 275, '2024-07-17 15:56:21.833439', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (900, 275, '2024-07-17 15:56:21.863658', 'Winch2LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (901, 275, '2024-07-17 15:56:21.873733', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (902, 275, '2024-07-17 15:56:21.903966', 'Winch2LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (903, 275, '2024-07-17 15:56:21.914037', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (904, 275, '2024-07-17 15:56:21.944273', 'Winch2LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (905, 275, '2024-07-17 15:56:21.954464', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (906, 275, '2024-07-17 15:56:21.984768', 'Winch2LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (907, 275, '2024-07-17 15:56:21.994859', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (908, 275, '2024-07-17 15:56:22.025257', 'Winch2LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (909, 275, '2024-07-17 15:56:22.035358', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (910, 275, '2024-07-17 15:56:22.065612', 'Winch2LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (911, 275, '2024-07-17 15:56:22.075685', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (912, 275, '2024-07-17 15:56:22.106065', 'Winch2LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (913, 275, '2024-07-17 15:56:22.116137', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (914, 275, '2024-07-17 15:56:22.14637', 'Winch2LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (915, 275, '2024-07-17 15:56:22.156499', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (916, 275, '2024-07-17 15:56:22.186724', 'Winch2LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (917, 275, '2024-07-17 15:56:22.196812', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (918, 275, '2024-07-17 15:56:22.227262', 'Winch2LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (919, 275, '2024-07-17 15:56:22.237377', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (920, 275, '2024-07-17 15:56:22.267749', 'Winch2LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (921, 275, '2024-07-17 15:56:22.277824', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (922, 275, '2024-07-17 15:56:22.309356', 'Winch2LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (923, 275, '2024-07-17 15:56:22.319452', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (924, 275, '2024-07-17 15:56:22.349731', 'Winch2LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (925, 275, '2024-07-17 15:56:22.35982', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (926, 275, '2024-07-17 15:56:22.511417', 'Winch3LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (927, 275, '2024-07-17 15:56:22.673647', 'Winch3LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (928, 275, '2024-07-17 15:56:22.683829', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (929, 275, '2024-07-17 15:56:22.714202', 'Winch3LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (930, 275, '2024-07-17 15:56:22.72431', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (931, 275, '2024-07-17 15:56:22.754719', 'Winch3LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (932, 275, '2024-07-17 15:56:22.764799', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (933, 275, '2024-07-17 15:56:22.795159', 'Winch3LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (934, 275, '2024-07-17 15:56:22.80527', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (935, 275, '2024-07-17 15:56:22.835577', 'Winch3LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (936, 275, '2024-07-17 15:56:22.845661', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (937, 275, '2024-07-17 15:56:22.876082', 'Winch3LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (938, 275, '2024-07-17 15:56:22.886269', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (939, 275, '2024-07-17 15:56:22.91658', 'Winch3LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (940, 275, '2024-07-17 15:56:22.926666', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (941, 275, '2024-07-17 15:56:22.95692', 'Winch3LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (942, 275, '2024-07-17 15:56:22.967001', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (943, 275, '2024-07-17 15:56:22.997405', 'Winch3LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (944, 275, '2024-07-17 15:58:35.720149', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (945, 275, '2024-07-17 15:58:36.19241', 'CraneLoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (946, 275, '2024-07-17 15:58:36.354708', 'CraneLoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (947, 275, '2024-07-17 15:58:36.364804', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (948, 275, '2024-07-17 15:58:36.395182', 'CraneLoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (949, 275, '2024-07-17 15:58:36.405241', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (950, 275, '2024-07-17 15:58:36.435601', 'CraneLoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (951, 275, '2024-07-17 15:58:36.44576', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (952, 275, '2024-07-17 15:58:36.476177', 'CraneLoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (953, 275, '2024-07-17 15:58:36.486341', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (954, 275, '2024-07-17 15:58:36.516654', 'CraneLoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (955, 275, '2024-07-17 15:58:36.526811', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (956, 275, '2024-07-17 15:58:36.557364', 'CraneLoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (957, 275, '2024-07-17 15:58:36.567521', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (958, 275, '2024-07-17 15:58:36.597929', 'CraneLoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (959, 275, '2024-07-17 15:58:36.608044', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (960, 275, '2024-07-17 15:58:36.638421', 'CraneLoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (961, 275, '2024-07-17 15:58:36.64857', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (962, 275, '2024-07-17 15:58:36.67895', 'CraneLoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (963, 275, '2024-07-17 15:58:36.689044', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (964, 275, '2024-07-17 15:58:36.719541', 'CraneLoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (965, 275, '2024-07-17 15:58:36.729699', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (966, 275, '2024-07-17 15:58:36.760083', 'CraneLoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (967, 275, '2024-07-17 15:58:36.770141', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (968, 275, '2024-07-17 15:58:36.800559', 'CraneLoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (969, 275, '2024-07-17 15:58:36.810717', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (970, 275, '2024-07-17 15:58:36.8412', 'CraneLoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (971, 275, '2024-07-17 15:58:36.85126', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (972, 275, '2024-07-17 15:58:36.881731', 'CraneLoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (973, 275, '2024-07-17 15:58:36.891933', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (974, 275, '2024-07-17 15:58:36.92242', 'CraneLoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (975, 275, '2024-07-17 15:58:36.932608', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (976, 275, '2024-07-17 15:58:36.963009', 'CraneLoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (977, 275, '2024-07-17 15:58:36.973098', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (978, 275, '2024-07-17 15:58:37.003379', 'CraneLoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (979, 275, '2024-07-17 15:58:37.013555', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (980, 275, '2024-07-17 15:58:37.043839', 'CraneLoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (981, 275, '2024-07-17 15:58:37.053911', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (982, 275, '2024-07-17 15:58:37.084245', 'CraneLoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (983, 275, '2024-07-17 15:58:37.094349', 'CraneLoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (984, 275, '2024-07-17 15:58:37.245722', 'Winch1LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (985, 275, '2024-07-17 15:58:37.407339', 'Winch1LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (986, 275, '2024-07-17 15:58:37.417416', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (987, 275, '2024-07-17 15:58:37.4477', 'Winch1LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (988, 275, '2024-07-17 15:58:37.457873', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (989, 275, '2024-07-17 15:58:37.488207', 'Winch1LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (990, 275, '2024-07-17 15:58:37.498285', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (991, 275, '2024-07-17 15:58:37.528526', 'Winch1LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (992, 275, '2024-07-17 15:58:37.538606', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (993, 275, '2024-07-17 15:58:37.568874', 'Winch1LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (994, 275, '2024-07-17 15:58:37.578971', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (995, 275, '2024-07-17 15:58:37.609217', 'Winch1LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (996, 275, '2024-07-17 15:58:37.619295', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (997, 275, '2024-07-17 15:58:37.649666', 'Winch1LoadEvent', 112.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (998, 275, '2024-07-17 15:58:37.65981', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (999, 275, '2024-07-17 15:58:37.690214', 'Winch1LoadEvent', 112.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1000, 275, '2024-07-17 15:58:37.700328', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1001, 275, '2024-07-17 15:58:37.730782', 'Winch1LoadEvent', 127.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1002, 275, '2024-07-17 15:58:37.740855', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1003, 275, '2024-07-17 15:58:37.771112', 'Winch1LoadEvent', 127.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1004, 275, '2024-07-17 15:58:37.781222', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1005, 275, '2024-07-17 15:58:37.811496', 'Winch1LoadEvent', 142.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1006, 275, '2024-07-17 15:58:37.821574', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1007, 275, '2024-07-17 15:58:37.851848', 'Winch1LoadEvent', 142.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1008, 275, '2024-07-17 15:58:37.86194', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1009, 275, '2024-07-17 15:58:37.892203', 'Winch1LoadEvent', 157.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1010, 275, '2024-07-17 15:58:37.902274', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1011, 275, '2024-07-17 15:58:37.932471', 'Winch1LoadEvent', 157.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1012, 275, '2024-07-17 15:58:37.942548', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1013, 275, '2024-07-17 15:58:37.97277', 'Winch1LoadEvent', 172.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1014, 275, '2024-07-17 15:58:37.982851', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1015, 275, '2024-07-17 15:58:38.013089', 'Winch1LoadEvent', 172.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1016, 275, '2024-07-17 15:58:38.023165', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1017, 275, '2024-07-17 15:58:38.053377', 'Winch1LoadEvent', 187.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1018, 275, '2024-07-17 15:58:38.063456', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1019, 275, '2024-07-17 15:58:38.093682', 'Winch1LoadEvent', 187.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1020, 275, '2024-07-17 15:58:38.103753', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1021, 275, '2024-07-17 15:58:38.133981', 'Winch1LoadEvent', 200.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1022, 275, '2024-07-17 15:58:38.144053', 'Winch1LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1023, 275, '2024-07-17 15:58:38.295656', 'Winch2LoadEvent', 37.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1024, 275, '2024-07-17 15:58:38.45712', 'Winch2LoadEvent', 67.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1025, 275, '2024-07-17 15:58:38.467197', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1026, 275, '2024-07-17 15:58:38.497541', 'Winch2LoadEvent', 67.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1027, 275, '2024-07-17 15:58:38.507654', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1028, 275, '2024-07-17 15:58:38.537866', 'Winch2LoadEvent', 82.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1029, 275, '2024-07-17 15:58:38.54794', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1030, 275, '2024-07-17 15:58:38.578181', 'Winch2LoadEvent', 82.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1031, 275, '2024-07-17 15:58:38.588359', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1032, 275, '2024-07-17 15:58:38.618718', 'Winch2LoadEvent', 97.49000000, 0);
INSERT INTO public.rec_operating_event VALUES (1033, 275, '2024-07-17 15:58:38.62881', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1034, 275, '2024-07-17 15:58:38.659053', 'Winch2LoadEvent', 97.50000000, 0);
INSERT INTO public.rec_operating_event VALUES (1035, 275, '2024-07-17 15:58:38.669131', 'Winch2LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1036, 275, '2024-07-17 16:02:13.391728', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1037, 275, '2024-07-17 16:12:13.56757', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1038, 275, '2024-07-17 16:12:14.21371', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1039, 275, '2024-07-17 16:12:14.223826', 'CraneMOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1040, 275, '2024-07-17 16:12:14.234011', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1041, 275, '2024-07-17 16:12:14.254342', 'CraneAOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1042, 276, '2024-07-17 16:13:16.52579', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1043, 276, '2024-07-17 16:13:17.169956', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1044, 276, '2024-07-17 16:13:17.180028', 'CraneMOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1045, 276, '2024-07-17 16:13:17.1902', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1046, 276, '2024-07-17 16:13:17.210523', 'CraneAOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1047, 276, '2024-07-17 16:13:17.291403', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1048, 277, '2024-07-17 16:17:34.521096', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1049, 277, '2024-07-17 16:17:35.166285', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1050, 277, '2024-07-17 16:17:35.176447', 'CraneMOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1051, 277, '2024-07-17 16:17:35.186542', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1052, 277, '2024-07-17 16:17:35.206876', 'CraneAOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1053, 277, '2024-07-17 16:17:35.2881', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1054, 277, '2024-07-17 16:17:35.308414', 'CraneLoadEvent', 24.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1055, 278, '2024-07-17 16:22:15.091303', 'Winch3LoadEvent', 0.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1056, 278, '2024-07-17 16:22:15.736423', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1057, 278, '2024-07-17 16:22:15.756641', 'CraneLoadEvent', 128.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1058, 278, '2024-07-17 16:22:15.776834', 'CraneAOPSEvent', 1.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1059, 278, '2024-07-17 16:22:15.857955', 'CraneLoadEvent', 64.00000000, 0);
INSERT INTO public.rec_operating_event VALUES (1060, 278, '2024-07-17 16:22:15.878289', 'CraneLoadEvent', 24.00000000, 0);


--
-- TOC entry 3114 (class 0 OID 27932)
-- Dependencies: 207
-- Data for Name: rec_operating_metric; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.rec_operating_metric VALUES (0, 'average_load    ', 42.28788000);
INSERT INTO public.rec_operating_metric VALUES (0, 'max_load        ', 133.00000000);
INSERT INTO public.rec_operating_metric VALUES (1, 'average_load    ', 42.28788000);
INSERT INTO public.rec_operating_metric VALUES (1, 'max_load        ', 133.00000000);
INSERT INTO public.rec_operating_metric VALUES (2, 'average_load    ', 42.28788000);
INSERT INTO public.rec_operating_metric VALUES (2, 'max_load        ', 133.00000000);
INSERT INTO public.rec_operating_metric VALUES (3, 'average_load    ', 42.28788000);
INSERT INTO public.rec_operating_metric VALUES (3, 'max_load        ', 133.00000000);
INSERT INTO public.rec_operating_metric VALUES (9, 'average_load    ', 43.48437500);
INSERT INTO public.rec_operating_metric VALUES (9, 'max_load        ', 133.00000000);
INSERT INTO public.rec_operating_metric VALUES (275, 'average_load    ', 43.48437500);
INSERT INTO public.rec_operating_metric VALUES (275, 'max_load        ', 133.00000000);
INSERT INTO public.rec_operating_metric VALUES (275, 'min_load        ', 5.00000000);


--
-- TOC entry 3116 (class 0 OID 27951)
-- Dependencies: 209
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.report VALUES ('2024-04-02 22:37:51.144553', 0, 'Null check operator used on a null value', '#0      StatefulElement.state (package:flutter/src/widgets/framework.dart:5599:44)
#1      Navigator.of (package:flutter/src/widgets/navigator.dart:2683:47)
#2      Flushbar.show (package:another_flushbar/flushbar.dart:233:28)
#3      EventListDataSource._showErrorFlushBar (package:crane_monitoring_app/infrastructure/event/event_list_data_source.dart:278:9)
#4      EventListDataSource._fetchUp.<anonymous closure> (package:crane_monitoring_app/infrastructure/event/event_list_data_source.dart:184:13)
#5      _rootRunUnary (dart:async/zone.dart:1407:47)
#6      _CustomZone.runUnary (dart:async/zone.dart:1308:19)
<asynchronous suspension>
#7      EventListDataSource._fetchUp.<anonymous closure> (package:crane_monitoring_app/infrastructure/event/event_list_data_source.dart:188:23)
<asynchronous suspension>
#8      EventListDataSource._fetchNewEvents.<anonymous closure> (package:crane_monitoring_app/infrastructure/event/event_list_data_source.dart:110:15)
<asynchronous suspension>
');


--
-- TOC entry 3111 (class 0 OID 27891)
-- Dependencies: 203
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: crane_data_server
--

INSERT INTO public.tags VALUES (5, 'Real', '/AppTest/RetainTask/Retained.Point', '');
INSERT INTO public.tags VALUES (23, 'Real', '/AppTest/Winch2.Load.Nom', '');
INSERT INTO public.tags VALUES (26, 'Real', '/AppTest/Winch1.Load.Nom', '');
INSERT INTO public.tags VALUES (25, 'Real', '/AppTest/Load', '');
INSERT INTO public.tags VALUES (24, 'Real', '/AppTest/Winch3.Load.Nom', '');
INSERT INTO public.tags VALUES (27, 'Real', '/AppTest/Load.Nom', '');
INSERT INTO public.tags VALUES (31, 'Bool', '/AppTest/RecorderTaskOperatingMetric-cycles-distributions/OpCycleIsDone', '');
INSERT INTO public.tags VALUES (29, 'Real', '/AppTest/RecorderTaskOperatingMetric-cycles-distributions/CraneLoad', '');
INSERT INTO public.tags VALUES (33, 'Real', '/AppTest/RecorderTaskOperatingMetric-cycles-distributions/CraneCycleAverageLoadRelative', '');
INSERT INTO public.tags VALUES (30, 'Bool', '/AppTest/RecorderTaskOperatingMetric-cycles-distributions/OpCycleIsActive', '');
INSERT INTO public.tags VALUES (32, 'Real', '/AppTest/RecorderTaskOperatingMetric-cycles-distributions/CraneCycleAverageLoad', '');
INSERT INTO public.tags VALUES (1, 'Bool', '/AppTest/RecorderTask/OpCycle', '');
INSERT INTO public.tags VALUES (17, 'Bool', '/AppTest/RecorderTask/IsChangedCraneLoad', '');
INSERT INTO public.tags VALUES (65, 'Real', '/AppTest/RecorderTask/winch1LoadFiltered', '');
INSERT INTO public.tags VALUES (12, 'Bool', '/AppTest/RecorderTask/OpCycleIsActive', '');
INSERT INTO public.tags VALUES (58, 'Real', '/AppTest/RecorderTask/craneLoadFiltered', '');
INSERT INTO public.tags VALUES (66, 'Real', '/AppTest/RecorderTask/winch2LoadFiltered', '');
INSERT INTO public.tags VALUES (13, 'Real', '/AppTest/RecorderTask/Load', '');
INSERT INTO public.tags VALUES (14, 'Real', '/AppTest/RecorderTask/AverageLoad', '');
INSERT INTO public.tags VALUES (16, 'Real', '/AppTest/RecorderTask/CraneLoadThreshold', '');
INSERT INTO public.tags VALUES (67, 'Real', '/AppTest/RecorderTask/winch3LoadFiltered', '');
INSERT INTO public.tags VALUES (57, 'Real', '/AppTest/RecorderTask/CraneLoad', '');
INSERT INTO public.tags VALUES (15, 'Real', '/AppTest/RecorderTask/AverageLoadRelative', '');
INSERT INTO public.tags VALUES (9, 'Bool', '/AppTest/Winch3.Load.Limiter.Trip', '');
INSERT INTO public.tags VALUES (8, 'Bool', '/AppTest/Winch1.Load.Limiter.Trip', '');
INSERT INTO public.tags VALUES (11, 'Bool', '/AppTest/Winch2.Load.Limiter.Trip', '');
INSERT INTO public.tags VALUES (39, 'Bool', '/AppTest/RecorderTaskOperatingMetric/OpCycleIsActive', '');
INSERT INTO public.tags VALUES (41, 'Real', '/AppTest/RecorderTaskOperatingMetric/CraneCycleAverageLoad', '');
INSERT INTO public.tags VALUES (40, 'Real', '/AppTest/RecorderTaskOperatingMetric/CraneLoad', '');
INSERT INTO public.tags VALUES (55, 'Real', '/AppTest/RecorderTaskOperatingMetric/CraneCycleAverageLoadRelative', '');
INSERT INTO public.tags VALUES (54, 'Bool', '/AppTest/RecorderTaskOperatingMetric/OpCycleIsDone', '');
INSERT INTO public.tags VALUES (56, 'Real', '/AppTest/RecorderTaskOperatingMetric/CraneCycleMaxLoad', '');
INSERT INTO public.tags VALUES (50, 'Real', '/AppTest/Winch3.Load', '');
INSERT INTO public.tags VALUES (48, 'Real', '/AppTest/Winch1.Load', '');
INSERT INTO public.tags VALUES (49, 'Real', '/AppTest/Winch2.Load', '');
INSERT INTO public.tags VALUES (59, 'Int', '/AppTest/CraneMode.AOPS', '');
INSERT INTO public.tags VALUES (60, 'Int', '/AppTest/CraneMode.MOPS', '');


--
-- TOC entry 3145 (class 0 OID 0)
-- Dependencies: 200
-- Name: app_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.app_user_id_seq', 1, false);


--
-- TOC entry 3146 (class 0 OID 0)
-- Dependencies: 216
-- Name: event_uid_seq1; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.event_uid_seq1', 2090, true);


--
-- TOC entry 3147 (class 0 OID 0)
-- Dependencies: 218
-- Name: event_utils_id_seq; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.event_utils_id_seq', 1, true);


--
-- TOC entry 3148 (class 0 OID 0)
-- Dependencies: 205
-- Name: operating_cycle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.operating_cycle_id_seq', 1, false);


--
-- TOC entry 3149 (class 0 OID 0)
-- Dependencies: 223
-- Name: rec_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.rec_name_id_seq', 1, false);


--
-- TOC entry 3150 (class 0 OID 0)
-- Dependencies: 221
-- Name: rec_operating_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.rec_operating_event_id_seq', 1060, true);


--
-- TOC entry 3151 (class 0 OID 0)
-- Dependencies: 202
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: crane_data_server
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- TOC entry 2947 (class 2606 OID 27869)
-- Name: app_user app_user_login_key; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_login_key UNIQUE (login);


--
-- TOC entry 2949 (class 2606 OID 27867)
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id, login);


--
-- TOC entry 2963 (class 2606 OID 56506)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (uid);


--
-- TOC entry 2967 (class 2606 OID 56515)
-- Name: event_utils event_utils_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.event_utils
    ADD CONSTRAINT event_utils_pkey PRIMARY KEY (id);


--
-- TOC entry 2955 (class 2606 OID 27923)
-- Name: rec_operating_cycle operating_cycle_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_operating_cycle
    ADD CONSTRAINT operating_cycle_pkey PRIMARY KEY (id);


--
-- TOC entry 2957 (class 2606 OID 74154)
-- Name: rec_basic_metric operating_metric_id_key; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_basic_metric
    ADD CONSTRAINT operating_metric_id_key UNIQUE (id);


--
-- TOC entry 2959 (class 2606 OID 27948)
-- Name: rec_basic_metric operating_metric_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_basic_metric
    ADD CONSTRAINT operating_metric_pkey PRIMARY KEY (name);


--
-- TOC entry 2971 (class 2606 OID 74309)
-- Name: rec_name rec_event_name_name; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_name
    ADD CONSTRAINT rec_event_name_name UNIQUE (name);


--
-- TOC entry 2973 (class 2606 OID 74313)
-- Name: rec_name rec_name_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_name
    ADD CONSTRAINT rec_name_pkey PRIMARY KEY (id);


--
-- TOC entry 2969 (class 2606 OID 74247)
-- Name: rec_operating_event rec_operating_event_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.rec_operating_event
    ADD CONSTRAINT rec_operating_event_pkey PRIMARY KEY (id);


--
-- TOC entry 2961 (class 2606 OID 27959)
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY ("timestamp");


--
-- TOC entry 2951 (class 2606 OID 27902)
-- Name: tags tags_name_key; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_name_key UNIQUE (name);


--
-- TOC entry 2953 (class 2606 OID 27900)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: crane_data_server
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 2964 (class 1259 OID 56507)
-- Name: idx_event_timestamp; Type: INDEX; Schema: public; Owner: crane_data_server
--

CREATE INDEX idx_event_timestamp ON public.event USING btree ("timestamp");


--
-- TOC entry 2965 (class 1259 OID 74177)
-- Name: idx_rec_operating_event_timestamp; Type: INDEX; Schema: public; Owner: crane_data_server
--

CREATE INDEX idx_rec_operating_event_timestamp ON public.event USING btree ("timestamp");

CREATE OR REPLACE FUNCTION public.event_purge_records()
RETURNS void 
LANGUAGE plpgsql AS $$
DECLARE
    deleted INT;
    to_delete INT;
    batch_size INT;
    is_purge_possible BOOLEAN;
BEGIN
    SELECT (row_count - row_limit + purge_shift_size), purge_batch_size
    FROM event_utils INTO to_delete, batch_size;
    
    WITH upd_result AS (
        UPDATE event_utils SET is_purge_running = true WHERE id = 1 AND is_purge_running = false
        RETURNING *
    ) SELECT count(*) = 1 FROM upd_result INTO is_purge_possible;

    IF is_purge_possible THEN
        deleted := 0;
    
        WHILE (to_delete - deleted) > batch_size LOOP
            WITH del_result AS (
                DELETE FROM event
                WHERE ctid IN (
                    SELECT ctid FROM event
                    ORDER BY timestamp, uid ASC
                    LIMIT batch_size
                ) RETURNING *
            ) SELECT (count(*) + deleted) FROM del_result into deleted;
        END LOOP;

        DELETE FROM event WHERE ctid IN (
            SELECT ctid FROM event
            ORDER BY timestamp, uid ASC
            LIMIT (to_delete - deleted)
        );

        UPDATE event_utils SET is_purge_running = false WHERE id = 1;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.event_check_for_purge()
RETURNS void 
LANGUAGE plpgsql
AS $$
DECLARE
    is_purge_needed BOOLEAN;
BEGIN
    SELECT row_count > row_limit FROM event_utils WHERE id = 1 INTO is_purge_needed;
    IF is_purge_needed THEN
        PERFORM public.event_purge_records();
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.event_counter_inc()
RETURNS trigger 
LANGUAGE plpgsql
AS $$
DECLARE
add_count INT;
BEGIN
    SELECT count(*) FROM new_tbl INTO add_count;
    UPDATE event_utils SET row_count = COALESCE(row_count, 0) + add_count WHERE id = 1;
    PERFORM public.event_check_for_purge();
    RETURN new;
END;
$$;

CREATE OR REPLACE FUNCTION public.event_counter_dec()
RETURNS trigger 
LANGUAGE plpgsql
AS $$
DECLARE
    del_count INT;
BEGIN
    SELECT count(*) FROM old_tbl INTO del_count;
    UPDATE event_utils SET row_count = COALESCE(row_count, 0) - del_count WHERE id = 1;
    RETURN new;
END;
$$;

--
-- TOC entry 2974 (class 2620 OID 56521)
-- Name: event event_delete_trigger; Type: TRIGGER; Schema: public; Owner: crane_data_server
--

CREATE TRIGGER event_delete_trigger AFTER DELETE ON public.event REFERENCING OLD TABLE AS old_tbl FOR EACH STATEMENT EXECUTE FUNCTION public.event_counter_dec();


--
-- TOC entry 2975 (class 2620 OID 56520)
-- Name: event event_insert_trigger; Type: TRIGGER; Schema: public; Owner: crane_data_server
--

CREATE TRIGGER event_insert_trigger AFTER INSERT ON public.event REFERENCING NEW TABLE AS new_tbl FOR EACH STATEMENT EXECUTE FUNCTION public.event_counter_inc();


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 3130
-- Name: DATABASE crane_data_server; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE crane_data_server TO crane_data_server;


-- Completed on 2024-08-14 12:55:33 MSK

--
-- PostgreSQL database dump complete
--

