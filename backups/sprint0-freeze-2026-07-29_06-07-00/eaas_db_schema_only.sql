--
-- PostgreSQL database dump
--

\restrict 9Tw26Pe1wu1ueO3GlimLHuNtUrzeUC1BODdPXTuHpG4dda9ot8BSCwGrnJTTqFE

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
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    action character varying(255),
    details jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.audit_logs OWNER TO eaas_user;

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
-- Name: organisation_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation_users (
    organisation_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.organisation_users OWNER TO postgres;

--
-- Name: organisations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    status character varying(50) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.organisations OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.permissions OWNER TO eaas_user;

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
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO eaas_user;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.roles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.roles OWNER TO eaas_user;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.sessions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    token text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sessions OWNER TO eaas_user;

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
-- Name: users; Type: TABLE; Schema: public; Owner: eaas_user
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    full_name character varying(255),
    role_id uuid,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO eaas_user;

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
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


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
-- Name: providers id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.providers ALTER COLUMN id SET DEFAULT nextval('public.providers_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: wallets id; Type: DEFAULT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.wallets ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);


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
-- Name: organisation_users organisation_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT organisation_users_pkey PRIMARY KEY (organisation_id, user_id);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


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
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


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
-- Name: clients clients_provider_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_provider_code_fkey FOREIGN KEY (provider_code) REFERENCES public.providers(provider_code);


--
-- Name: organisation_users organisation_users_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT organisation_users_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisations(id) ON DELETE CASCADE;


--
-- Name: organisation_users organisation_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT organisation_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eaas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 9Tw26Pe1wu1ueO3GlimLHuNtUrzeUC1BODdPXTuHpG4dda9ot8BSCwGrnJTTqFE

