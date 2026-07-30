--
-- PostgreSQL database dump
--

\restrict 8sf1ZPdnXlimWPK3nlUe0eWMVNM9mVRUEgHu6jwbfXmzTF16Xxajh9s2Yt2k1Tb

-- Dumped from database version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO eaas_user;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(100),
    resource character varying(100),
    details text,
    ip_address character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO eaas_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO eaas_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    client_code character varying,
    full_name character varying,
    email character varying,
    phone character varying,
    device_type character varying,
    provider_code character varying
);


ALTER TABLE public.clients OWNER TO eaas_user;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO eaas_user;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.devices (
    id integer NOT NULL,
    device_code character varying,
    device_type character varying,
    manufacturer character varying,
    connectivity character varying
);


ALTER TABLE public.devices OWNER TO eaas_user;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.devices_id_seq OWNER TO eaas_user;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: eaasgrid_migration_baseline; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.eaasgrid_migration_baseline (
    id bigint NOT NULL,
    migration_file text NOT NULL,
    migration_checksum text NOT NULL,
    alembic_revision text,
    baseline_created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.eaasgrid_migration_baseline OWNER TO eaas_user;

--
-- Name: eaasgrid_migration_baseline_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.eaasgrid_migration_baseline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eaasgrid_migration_baseline_id_seq OWNER TO eaas_user;

--
-- Name: eaasgrid_migration_baseline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.eaasgrid_migration_baseline_id_seq OWNED BY public.eaasgrid_migration_baseline.id;


--
-- Name: eaasgrid_migration_history; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.eaasgrid_migration_history (
    id bigint NOT NULL,
    migration_name text NOT NULL,
    checksum text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.eaasgrid_migration_history OWNER TO eaas_user;

--
-- Name: eaasgrid_migration_history_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.eaasgrid_migration_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eaasgrid_migration_history_id_seq OWNER TO eaas_user;

--
-- Name: eaasgrid_migration_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.eaasgrid_migration_history_id_seq OWNED BY public.eaasgrid_migration_history.id;


--
-- Name: energy_usage; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.energy_usage (
    id integer NOT NULL,
    "user" character varying,
    kwh double precision,
    cost double precision,
    "timestamp" timestamp without time zone,
    provider_code character varying
);


ALTER TABLE public.energy_usage OWNER TO eaas_user;

--
-- Name: energy_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.energy_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.energy_usage_id_seq OWNER TO eaas_user;

--
-- Name: energy_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.energy_usage_id_seq OWNED BY public.energy_usage.id;


--
-- Name: ledger_accounts; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.ledger_accounts (
    id integer NOT NULL,
    owner_id character varying,
    balance_cached double precision
);


ALTER TABLE public.ledger_accounts OWNER TO eaas_user;

--
-- Name: ledger_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.ledger_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ledger_accounts_id_seq OWNER TO eaas_user;

--
-- Name: ledger_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.ledger_accounts_id_seq OWNED BY public.ledger_accounts.id;


--
-- Name: ledger_entries; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.ledger_entries (
    id integer NOT NULL,
    owner_id character varying,
    entry_type character varying,
    amount double precision,
    reference character varying,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.ledger_entries OWNER TO eaas_user;

--
-- Name: ledger_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.ledger_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ledger_entries_id_seq OWNER TO eaas_user;

--
-- Name: ledger_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.ledger_entries_id_seq OWNED BY public.ledger_entries.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.password_reset_tokens (
    id integer NOT NULL,
    user_id integer,
    token text NOT NULL,
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.password_reset_tokens OWNER TO eaas_user;

--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.password_reset_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.password_reset_tokens_id_seq OWNER TO eaas_user;

--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.password_reset_tokens_id_seq OWNED BY public.password_reset_tokens.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.permissions OWNER TO eaas_user;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO eaas_user;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.providers (
    id integer NOT NULL,
    provider_code character varying,
    company_name character varying,
    contact_person character varying,
    email character varying,
    phone character varying,
    service_type character varying
);


ALTER TABLE public.providers OWNER TO eaas_user;

--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.providers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.providers_id_seq OWNER TO eaas_user;

--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.providers_id_seq OWNED BY public.providers.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO eaas_user;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.roles OWNER TO eaas_user;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO eaas_user;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    "user" character varying,
    type character varying,
    amount double precision,
    "timestamp" timestamp without time zone,
    provider_code character varying
);


ALTER TABLE public.transactions OWNER TO eaas_user;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO eaas_user;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO eaas_user;

--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.user_sessions (
    id integer NOT NULL,
    user_id integer,
    jwt_id character varying(255),
    ip_address character varying(100),
    user_agent text,
    expires_at timestamp without time zone,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_sessions OWNER TO eaas_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.user_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_sessions_id_seq OWNER TO eaas_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    role_id integer,
    status character varying(30) DEFAULT 'ACTIVE'::character varying,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO eaas_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO eaas_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: wallets; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.wallets (
    id integer NOT NULL,
    "user" character varying,
    balance double precision,
    provider_code character varying
);


ALTER TABLE public.wallets OWNER TO eaas_user;

--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: eaas_user
--

CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wallets_id_seq OWNER TO eaas_user;

--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eaas_user
--

ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallets.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: eaasgrid_migration_baseline id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.eaasgrid_migration_baseline ALTER COLUMN id SET DEFAULT nextval('public.eaasgrid_migration_baseline_id_seq'::regclass);


--
-- Name: eaasgrid_migration_history id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.eaasgrid_migration_history ALTER COLUMN id SET DEFAULT nextval('public.eaasgrid_migration_history_id_seq'::regclass);


--
-- Name: energy_usage id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.energy_usage ALTER COLUMN id SET DEFAULT nextval('public.energy_usage_id_seq'::regclass);


--
-- Name: ledger_accounts id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.ledger_accounts ALTER COLUMN id SET DEFAULT nextval('public.ledger_accounts_id_seq'::regclass);


--
-- Name: ledger_entries id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.ledger_entries ALTER COLUMN id SET DEFAULT nextval('public.ledger_entries_id_seq'::regclass);


--
-- Name: password_reset_tokens id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.password_reset_tokens ALTER COLUMN id SET DEFAULT nextval('public.password_reset_tokens_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: providers id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.providers ALTER COLUMN id SET DEFAULT nextval('public.providers_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wallets id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.wallets ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.alembic_version (version_num) FROM stdin;
0a456f4d97ca
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.audit_logs (id, user_id, action, resource, details, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.clients (id, client_code, full_name, email, phone, device_type, provider_code) FROM stdin;
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.devices (id, device_code, device_type, manufacturer, connectivity) FROM stdin;
1	D001	ESP32 Smart Meter	Espressif	WiFi
2	D002	Eastron SDM120	Eastron	Modbus RTU
3	D003	Eastron SDM630	Eastron	Modbus RTU
4	D004	Hybrid Inverter	Deye	WiFi
5	D005	Solar Inverter	Growatt	WiFi
6	D006	Battery Monitoring Unit	Pylontech	RS485
7	D007	Smart Energy Monitor	Shelly	WiFi
8	D008	ESP32 Gateway	Espressif	WiFi/Ethernet
9	D009	Battery Controller	Victron	Bluetooth
10	D010	Smart Meter	Custom EaaS	MQTT
\.


--
-- Data for Name: eaasgrid_migration_baseline; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.eaasgrid_migration_baseline (id, migration_file, migration_checksum, alembic_revision, baseline_created_at) FROM stdin;
1	/data/eaasgrid-platform/database/migrations/001_initial_schema.sql	d172963114a826a4e9910f8985e2729efcc70eace6a34c666929c683165a7d4d	0a456f4d97ca	2026-07-17 07:07:34.675626+00
\.


--
-- Data for Name: eaasgrid_migration_history; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.eaasgrid_migration_history (id, migration_name, checksum, applied_at) FROM stdin;
1	001_initial_schema.sql	d172963114a826a4e9910f8985e2729efcc70eace6a34c666929c683165a7d4d	2026-07-17 07:23:07.942362+00
\.


--
-- Data for Name: energy_usage; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.energy_usage (id, "user", kwh, cost, "timestamp", provider_code) FROM stdin;
\.


--
-- Data for Name: ledger_accounts; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.ledger_accounts (id, owner_id, balance_cached) FROM stdin;
1	test	0
\.


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.ledger_entries (id, owner_id, entry_type, amount, reference, "timestamp") FROM stdin;
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.password_reset_tokens (id, user_id, token, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.permissions (id, name, description, created_at) FROM stdin;
1	platform.admin	\N	2026-07-24 10:05:22.350692
2	platform.operations	\N	2026-07-24 10:05:22.350692
3	partner.manage	\N	2026-07-24 10:05:22.350692
4	customer.manage	\N	2026-07-24 10:05:22.350692
5	billing.manage	\N	2026-07-24 10:05:22.350692
6	investor.view	\N	2026-07-24 10:05:22.350692
7	system.settings	\N	2026-07-24 10:05:22.350692
\.


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.providers (id, provider_code, company_name, contact_person, email, phone, service_type) FROM stdin;
1	P001	SolarGrid Energy Ltd	Adewale Johnson	adewale.johnson@solargrid-demo.com	+2348001001001	Solar Installation
2	P002	GreenVolt Solutions Ltd	Chika Okafor	chika.okafor@greenvolt-demo.com	+2348001001002	Solar & Battery Systems
3	P003	BrightPower Technologies	Musa Ibrahim	musa.ibrahim@brightpower-demo.com	+2348001001003	Smart Metering
4	P004	EcoSun Services Ltd	Kemi Adebayo	kemi.adebayo@ecosun-demo.com	+2348001001004	Solar Maintenance
5	P005	Nova Energy Systems	Emeka Nwosu	emeka.nwosu@novaenergy-demo.com	+2348001001005	Energy-as-a-Service
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.roles (id, name, description, created_at, updated_at) FROM stdin;
1	ADMIN	Full platform administration	2026-07-24 10:05:22.329989	2026-07-24 10:05:22.329989
2	OPERATIONS	Daily platform operations	2026-07-24 10:05:22.329989	2026-07-24 10:05:22.329989
3	PARTNER	Partner ecosystem access	2026-07-24 10:05:22.329989	2026-07-24 10:05:22.329989
4	CUSTOMER	Customer portal access	2026-07-24 10:05:22.329989	2026-07-24 10:05:22.329989
5	INVESTOR	Investor access	2026-07-24 10:05:22.329989	2026-07-24 10:05:22.329989
6	COLLABORATOR	Collaboration access	2026-07-24 10:05:22.329989	2026-07-24 10:05:22.329989
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.transactions (id, "user", type, amount, "timestamp", provider_code) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.user_roles (user_id, role_id) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.user_sessions (id, user_id, jwt_id, ip_address, user_agent, expires_at, revoked_at, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.users (id, email, password_hash, first_name, last_name, role_id, status, last_login, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: eaas_user
--

COPY public.wallets (id, "user", balance, provider_code) FROM stdin;
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 1, false);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.clients_id_seq', 1, false);


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.devices_id_seq', 14, true);


--
-- Name: eaasgrid_migration_baseline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.eaasgrid_migration_baseline_id_seq', 1, true);


--
-- Name: eaasgrid_migration_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.eaasgrid_migration_history_id_seq', 7, true);


--
-- Name: energy_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.energy_usage_id_seq', 1, false);


--
-- Name: ledger_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.ledger_accounts_id_seq', 1, true);


--
-- Name: ledger_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.ledger_entries_id_seq', 1, false);


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.password_reset_tokens_id_seq', 1, false);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.permissions_id_seq', 7, true);


--
-- Name: providers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.providers_id_seq', 5, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.roles_id_seq', 12, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: wallets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eaas_user
--

SELECT pg_catalog.setval('public.wallets_id_seq', 1, false);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: eaasgrid_migration_baseline eaasgrid_migration_baseline_migration_file_key; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.eaasgrid_migration_baseline
    ADD CONSTRAINT eaasgrid_migration_baseline_migration_file_key UNIQUE (migration_file);


--
-- Name: eaasgrid_migration_baseline eaasgrid_migration_baseline_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.eaasgrid_migration_baseline
    ADD CONSTRAINT eaasgrid_migration_baseline_pkey PRIMARY KEY (id);


--
-- Name: eaasgrid_migration_history eaasgrid_migration_history_migration_name_key; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.eaasgrid_migration_history
    ADD CONSTRAINT eaasgrid_migration_history_migration_name_key UNIQUE (migration_name);


--
-- Name: eaasgrid_migration_history eaasgrid_migration_history_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.eaasgrid_migration_history
    ADD CONSTRAINT eaasgrid_migration_history_pkey PRIMARY KEY (id);


--
-- Name: energy_usage energy_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.energy_usage
    ADD CONSTRAINT energy_usage_pkey PRIMARY KEY (id);


--
-- Name: ledger_accounts ledger_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.ledger_accounts
    ADD CONSTRAINT ledger_accounts_pkey PRIMARY KEY (id);


--
-- Name: ledger_entries ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_user; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX idx_audit_user ON public.audit_logs USING btree (user_id);


--
-- Name: idx_sessions_user; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX idx_sessions_user ON public.user_sessions USING btree (user_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: ix_clients_client_code; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE UNIQUE INDEX ix_clients_client_code ON public.clients USING btree (client_code);


--
-- Name: ix_clients_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_clients_id ON public.clients USING btree (id);


--
-- Name: ix_devices_device_code; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE UNIQUE INDEX ix_devices_device_code ON public.devices USING btree (device_code);


--
-- Name: ix_devices_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_devices_id ON public.devices USING btree (id);


--
-- Name: ix_energy_usage_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_energy_usage_id ON public.energy_usage USING btree (id);


--
-- Name: ix_energy_usage_provider_code; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_energy_usage_provider_code ON public.energy_usage USING btree (provider_code);


--
-- Name: ix_energy_usage_user; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_energy_usage_user ON public.energy_usage USING btree ("user");


--
-- Name: ix_ledger_accounts_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_ledger_accounts_id ON public.ledger_accounts USING btree (id);


--
-- Name: ix_ledger_accounts_owner_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE UNIQUE INDEX ix_ledger_accounts_owner_id ON public.ledger_accounts USING btree (owner_id);


--
-- Name: ix_ledger_entries_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_ledger_entries_id ON public.ledger_entries USING btree (id);


--
-- Name: ix_ledger_entries_owner_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_ledger_entries_owner_id ON public.ledger_entries USING btree (owner_id);


--
-- Name: ix_providers_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_providers_id ON public.providers USING btree (id);


--
-- Name: ix_providers_provider_code; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE UNIQUE INDEX ix_providers_provider_code ON public.providers USING btree (provider_code);


--
-- Name: ix_transactions_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_transactions_id ON public.transactions USING btree (id);


--
-- Name: ix_transactions_provider_code; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_transactions_provider_code ON public.transactions USING btree (provider_code);


--
-- Name: ix_transactions_user; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_transactions_user ON public.transactions USING btree ("user");


--
-- Name: ix_wallets_id; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_wallets_id ON public.wallets USING btree (id);


--
-- Name: ix_wallets_provider_code; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_wallets_provider_code ON public.wallets USING btree (provider_code);


--
-- Name: ix_wallets_user; Type: INDEX; Schema: public; Owner: eaas_user
--

CREATE INDEX ix_wallets_user ON public.wallets USING btree ("user");


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: clients clients_provider_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_provider_code_fkey FOREIGN KEY (provider_code) REFERENCES public.providers(provider_code);


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 8sf1ZPdnXlimWPK3nlUe0eWMVNM9mVRUEgHu6jwbfXmzTF16Xxajh9s2Yt2k1Tb

