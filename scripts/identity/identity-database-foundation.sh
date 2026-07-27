#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/identity-service"
MIGRATION_DIR="$ROOT/database/migrations/identity"

mkdir -p "$REPORT_DIR"
mkdir -p "$MIGRATION_DIR"

REPORT="$REPORT_DIR/identity-database-report.txt"

echo "=====================================" > "$REPORT"
echo "EaaSGrid Identity Database Foundation" >> "$REPORT"
echo "Date: $DATE" >> "$REPORT"
echo "=====================================" >> "$REPORT"

echo "[1] Creating identity schema files"

cat > "$MIGRATION_DIR/001_identity_schema.sql" <<'SQL'

CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY(role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role_id INTEGER REFERENCES roles(id),
    status VARCHAR(30) DEFAULT 'ACTIVE',
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    jwt_id VARCHAR(255),
    ip_address VARCHAR(100),
    user_agent TEXT,
    expires_at TIMESTAMP,
    revoked_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100),
    resource VARCHAR(100),
    details TEXT,
    ip_address VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SQL


cat > "$MIGRATION_DIR/002_identity_indexes.sql" <<'SQL'

CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

CREATE INDEX IF NOT EXISTS idx_sessions_user
ON user_sessions(user_id);

CREATE INDEX IF NOT EXISTS idx_audit_user
ON audit_logs(user_id);

SQL


cat > "$MIGRATION_DIR/003_identity_seed.sql" <<'SQL'

INSERT INTO roles(name, description)
VALUES
('ADMIN','Full platform administration'),
('OPERATIONS','Daily platform operations'),
('PARTNER','Partner ecosystem access'),
('CUSTOMER','Customer portal access'),
('INVESTOR','Investor access'),
('COLLABORATOR','Collaboration access')
ON CONFLICT(name) DO NOTHING;


INSERT INTO permissions(name)
VALUES
('platform.admin'),
('platform.operations'),
('partner.manage'),
('customer.manage'),
('billing.manage'),
('investor.view'),
('system.settings')
ON CONFLICT(name) DO NOTHING;

SQL


echo "[2] Applying migrations"

DB_URL=$(grep DATABASE_URL "$ROOT/.env" | cut -d '=' -f2-)

psql "$DB_URL" \
-f "$MIGRATION_DIR/001_identity_schema.sql"

psql "$DB_URL" \
-f "$MIGRATION_DIR/002_identity_indexes.sql"

psql "$DB_URL" \
-f "$MIGRATION_DIR/003_identity_seed.sql"


echo "[3] Validation"

TABLES=$(psql "$DB_URL" -t -c "
SELECT count(*)
FROM information_schema.tables
WHERE table_name IN
(
'users',
'roles',
'permissions',
'role_permissions',
'user_sessions',
'password_reset_tokens',
'audit_logs'
);
")

echo "Identity tables detected: $TABLES" >> "$REPORT"


if [ "$TABLES" -eq 7 ]; then

    echo "STATUS: PASS" >> "$REPORT"
    echo "Identity Database Foundation COMPLETE"

else

    echo "STATUS: FAIL" >> "$REPORT"
    echo "Identity Database Foundation FAILED"
    exit 1

fi
