#!/usr/bin/env bash

set -e

echo "======================================"
echo "EaaSGrid Identity Schema Deployment"
echo "======================================"

cd /data/eaasgrid-platform

export $(grep -v '^#' .env | xargs)

echo "[1/6] Creating identity schema"

psql "$DATABASE_URL" <<'SQL'

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE IF NOT EXISTS roles
(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS users
(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name VARCHAR(255),
    role_id UUID REFERENCES roles(id),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS sessions
(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS permissions
(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);


CREATE TABLE IF NOT EXISTS role_permissions
(
    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY(role_id,permission_id)
);


CREATE TABLE IF NOT EXISTS audit_logs
(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID,
    action VARCHAR(255),
    details JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);



INSERT INTO roles(name,description)
VALUES
('ADMIN','Full platform administration'),
('OPERATIONS','Operations console access'),
('PARTNER','Partner management access'),
('CUSTOMER','Customer portal access'),
('INVESTOR','Investor dashboard access'),
('COLLABORATOR','External collaboration access')
ON CONFLICT(name) DO NOTHING;


SQL


echo "[2/6] Checking tables"

psql "$DATABASE_URL" -c "\dt"


echo "[3/6] Checking roles"

psql "$DATABASE_URL" -c "SELECT name FROM roles;"


echo "[4/6] Identity schema completed"

echo "[5/6] Database status"

psql "$DATABASE_URL" -c "
SELECT
current_database(),
current_user;
"


echo "[6/6] COMPLETE"
