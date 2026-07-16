--
-- PostgreSQL database dump
--

\restrict mOrsm4rP7bh9MpRrBNGkWWVwMXHC85swHoJ6ETheG4V2utSIjsHxchKcZF344mK

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

--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
0a456f4d97ca
\.


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.providers (id, provider_code, company_name, contact_person, email, phone, service_type) FROM stdin;
1	P001	SolarGrid Energy Ltd	Adewale Johnson	adewale.johnson@solargrid-demo.com	+2348001001001	Solar Installation
2	P002	GreenVolt Solutions Ltd	Chika Okafor	chika.okafor@greenvolt-demo.com	+2348001001002	Solar & Battery Systems
3	P003	BrightPower Technologies	Musa Ibrahim	musa.ibrahim@brightpower-demo.com	+2348001001003	Smart Metering
4	P004	EcoSun Services Ltd	Kemi Adebayo	kemi.adebayo@ecosun-demo.com	+2348001001004	Solar Maintenance
5	P005	Nova Energy Systems	Emeka Nwosu	emeka.nwosu@novaenergy-demo.com	+2348001001005	Energy-as-a-Service
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
-- PostgreSQL database dump complete
--

\unrestrict mOrsm4rP7bh9MpRrBNGkWWVwMXHC85swHoJ6ETheG4V2utSIjsHxchKcZF344mK

