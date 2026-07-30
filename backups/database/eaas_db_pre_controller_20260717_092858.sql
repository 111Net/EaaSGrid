--
-- PostgreSQL database dump
--

\restrict DJpaY2FdnsT3iH0WVIJw3pZK4vQuAxj0QkA7Rbyby99QNhdwXEi8s2u7tyrtUOK

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devices (
    id integer NOT NULL,
    device_code character varying,
    device_type character varying,
    manufacturer character varying,
    connectivity character varying
);


--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: eaasgrid_migration_baseline; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eaasgrid_migration_baseline (
    id bigint NOT NULL,
    migration_file text NOT NULL,
    migration_checksum text NOT NULL,
    alembic_revision text,
    baseline_created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: eaasgrid_migration_baseline_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eaasgrid_migration_baseline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eaasgrid_migration_baseline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eaasgrid_migration_baseline_id_seq OWNED BY public.eaasgrid_migration_baseline.id;


--
-- Name: eaasgrid_migration_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eaasgrid_migration_history (
    id bigint NOT NULL,
    migration_name text NOT NULL,
    checksum text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: eaasgrid_migration_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eaasgrid_migration_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eaasgrid_migration_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eaasgrid_migration_history_id_seq OWNED BY public.eaasgrid_migration_history.id;


--
-- Name: energy_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.energy_usage (
    id integer NOT NULL,
    "user" character varying,
    kwh double precision,
    cost double precision,
    "timestamp" timestamp without time zone,
    provider_code character varying
);


--
-- Name: energy_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.energy_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: energy_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.energy_usage_id_seq OWNED BY public.energy_usage.id;


--
-- Name: ledger_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ledger_accounts (
    id integer NOT NULL,
    owner_id character varying,
    balance_cached double precision
);


--
-- Name: ledger_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ledger_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ledger_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ledger_accounts_id_seq OWNED BY public.ledger_accounts.id;


--
-- Name: ledger_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ledger_entries (
    id integer NOT NULL,
    owner_id character varying,
    entry_type character varying,
    amount double precision,
    reference character varying,
    "timestamp" timestamp without time zone
);


--
-- Name: ledger_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ledger_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ledger_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ledger_entries_id_seq OWNED BY public.ledger_entries.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.providers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.providers_id_seq OWNED BY public.providers.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    "user" character varying,
    type character varying,
    amount double precision,
    "timestamp" timestamp without time zone,
    provider_code character varying
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: wallets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallets (
    id integer NOT NULL,
    "user" character varying,
    balance double precision,
    provider_code character varying
);


--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallets.id;


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: eaasgrid_migration_baseline id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eaasgrid_migration_baseline ALTER COLUMN id SET DEFAULT nextval('public.eaasgrid_migration_baseline_id_seq'::regclass);


--
-- Name: eaasgrid_migration_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eaasgrid_migration_history ALTER COLUMN id SET DEFAULT nextval('public.eaasgrid_migration_history_id_seq'::regclass);


--
-- Name: energy_usage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.energy_usage ALTER COLUMN id SET DEFAULT nextval('public.energy_usage_id_seq'::regclass);


--
-- Name: ledger_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ledger_accounts ALTER COLUMN id SET DEFAULT nextval('public.ledger_accounts_id_seq'::regclass);


--
-- Name: ledger_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ledger_entries ALTER COLUMN id SET DEFAULT nextval('public.ledger_entries_id_seq'::regclass);


--
-- Name: providers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers ALTER COLUMN id SET DEFAULT nextval('public.providers_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: wallets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallets ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
0a456f4d97ca
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clients (id, client_code, full_name, email, phone, device_type, provider_code) FROM stdin;
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: eaasgrid_migration_baseline; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.eaasgrid_migration_baseline (id, migration_file, migration_checksum, alembic_revision, baseline_created_at) FROM stdin;
1	/data/eaasgrid-platform/database/migrations/001_initial_schema.sql	d172963114a826a4e9910f8985e2729efcc70eace6a34c666929c683165a7d4d	0a456f4d97ca	2026-07-17 07:07:34.675626+00
\.


--
-- Data for Name: eaasgrid_migration_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.eaasgrid_migration_history (id, migration_name, checksum, applied_at) FROM stdin;
1	001_initial_schema.sql	d172963114a826a4e9910f8985e2729efcc70eace6a34c666929c683165a7d4d	2026-07-17 07:23:07.942362+00
\.


--
-- Data for Name: energy_usage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.energy_usage (id, "user", kwh, cost, "timestamp", provider_code) FROM stdin;
\.


--
-- Data for Name: ledger_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ledger_accounts (id, owner_id, balance_cached) FROM stdin;
1	test	0
\.


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ledger_entries (id, owner_id, entry_type, amount, reference, "timestamp") FROM stdin;
\.


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.providers (id, provider_code, company_name, contact_person, email, phone, service_type) FROM stdin;
1	P001	SolarGrid Energy Ltd	Adewale Johnson	adewale.johnson@solargrid-demo.com	+2348001001001	Solar Installation
2	P002	GreenVolt Solutions Ltd	Chika Okafor	chika.okafor@greenvolt-demo.com	+2348001001002	Solar & Battery Systems
3	P003	BrightPower Technologies	Musa Ibrahim	musa.ibrahim@brightpower-demo.com	+2348001001003	Smart Metering
4	P004	EcoSun Services Ltd	Kemi Adebayo	kemi.adebayo@ecosun-demo.com	+2348001001004	Solar Maintenance
5	P005	Nova Energy Systems	Emeka Nwosu	emeka.nwosu@novaenergy-demo.com	+2348001001005	Everything-as-a-Service
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (id, "user", type, amount, "timestamp", provider_code) FROM stdin;
\.


--
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wallets (id, "user", balance, provider_code) FROM stdin;
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clients_id_seq', 1, false);


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devices_id_seq', 14, true);


--
-- Name: eaasgrid_migration_baseline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eaasgrid_migration_baseline_id_seq', 1, true);


--
-- Name: eaasgrid_migration_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eaasgrid_migration_history_id_seq', 6, true);


--
-- Name: energy_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.energy_usage_id_seq', 1, false);


--
-- Name: ledger_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ledger_accounts_id_seq', 1, true);


--
-- Name: ledger_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ledger_entries_id_seq', 1, false);


--
-- Name: providers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.providers_id_seq', 5, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);


--
-- Name: wallets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wallets_id_seq', 1, false);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: eaasgrid_migration_baseline eaasgrid_migration_baseline_migration_file_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eaasgrid_migration_baseline
    ADD CONSTRAINT eaasgrid_migration_baseline_migration_file_key UNIQUE (migration_file);


--
-- Name: eaasgrid_migration_baseline eaasgrid_migration_baseline_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eaasgrid_migration_baseline
    ADD CONSTRAINT eaasgrid_migration_baseline_pkey PRIMARY KEY (id);


--
-- Name: eaasgrid_migration_history eaasgrid_migration_history_migration_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eaasgrid_migration_history
    ADD CONSTRAINT eaasgrid_migration_history_migration_name_key UNIQUE (migration_name);


--
-- Name: eaasgrid_migration_history eaasgrid_migration_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eaasgrid_migration_history
    ADD CONSTRAINT eaasgrid_migration_history_pkey PRIMARY KEY (id);


--
-- Name: energy_usage energy_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.energy_usage
    ADD CONSTRAINT energy_usage_pkey PRIMARY KEY (id);


--
-- Name: ledger_accounts ledger_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ledger_accounts
    ADD CONSTRAINT ledger_accounts_pkey PRIMARY KEY (id);


--
-- Name: ledger_entries ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: ix_clients_client_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_clients_client_code ON public.clients USING btree (client_code);


--
-- Name: ix_clients_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_clients_id ON public.clients USING btree (id);


--
-- Name: ix_devices_device_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_devices_device_code ON public.devices USING btree (device_code);


--
-- Name: ix_devices_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_devices_id ON public.devices USING btree (id);


--
-- Name: ix_energy_usage_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_energy_usage_id ON public.energy_usage USING btree (id);


--
-- Name: ix_energy_usage_provider_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_energy_usage_provider_code ON public.energy_usage USING btree (provider_code);


--
-- Name: ix_energy_usage_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_energy_usage_user ON public.energy_usage USING btree ("user");


--
-- Name: ix_ledger_accounts_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ledger_accounts_id ON public.ledger_accounts USING btree (id);


--
-- Name: ix_ledger_accounts_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_ledger_accounts_owner_id ON public.ledger_accounts USING btree (owner_id);


--
-- Name: ix_ledger_entries_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ledger_entries_id ON public.ledger_entries USING btree (id);


--
-- Name: ix_ledger_entries_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ledger_entries_owner_id ON public.ledger_entries USING btree (owner_id);


--
-- Name: ix_providers_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_providers_id ON public.providers USING btree (id);


--
-- Name: ix_providers_provider_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_providers_provider_code ON public.providers USING btree (provider_code);


--
-- Name: ix_transactions_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_transactions_id ON public.transactions USING btree (id);


--
-- Name: ix_transactions_provider_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_transactions_provider_code ON public.transactions USING btree (provider_code);


--
-- Name: ix_transactions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_transactions_user ON public.transactions USING btree ("user");


--
-- Name: ix_wallets_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_wallets_id ON public.wallets USING btree (id);


--
-- Name: ix_wallets_provider_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_wallets_provider_code ON public.wallets USING btree (provider_code);


--
-- Name: ix_wallets_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_wallets_user ON public.wallets USING btree ("user");


--
-- Name: clients clients_provider_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_provider_code_fkey FOREIGN KEY (provider_code) REFERENCES public.providers(provider_code);


--
-- PostgreSQL database dump complete
--

\unrestrict DJpaY2FdnsT3iH0WVIJw3pZK4vQuAxj0QkA7Rbyby99QNhdwXEi8s2u7tyrtUOK

