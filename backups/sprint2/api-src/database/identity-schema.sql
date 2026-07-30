
CREATE TABLE IF NOT EXISTS users (

    id SERIAL PRIMARY KEY,

    email VARCHAR(255) UNIQUE NOT NULL,

    password_hash TEXT NOT NULL,

    full_name VARCHAR(255),

    status VARCHAR(50)
        DEFAULT 'ACTIVE',

    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);


CREATE TABLE IF NOT EXISTS roles (

    id SERIAL PRIMARY KEY,

    name VARCHAR(50)
        UNIQUE NOT NULL

);


CREATE TABLE IF NOT EXISTS user_roles (

    user_id INTEGER
        REFERENCES users(id)
        ON DELETE CASCADE,

    role_id INTEGER
        REFERENCES roles(id)
        ON DELETE CASCADE,

    PRIMARY KEY(user_id, role_id)

);


INSERT INTO roles(name)
VALUES

('ADMIN'),
('OPERATIONS'),
('PARTNER'),
('CUSTOMER'),
('INVESTOR'),
('COLLABORATOR')

ON CONFLICT DO NOTHING;

\i permission-schema.sql

