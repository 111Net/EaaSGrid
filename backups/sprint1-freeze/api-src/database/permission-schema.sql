CREATE TABLE IF NOT EXISTS permissions (

    id SERIAL PRIMARY KEY,

    name VARCHAR(100)
        UNIQUE NOT NULL,

    description TEXT

);


CREATE TABLE IF NOT EXISTS role_permissions (

    role_id INTEGER
        REFERENCES roles(id)
        ON DELETE CASCADE,

    permission_id INTEGER
        REFERENCES permissions(id)
        ON DELETE CASCADE,


    PRIMARY KEY(
        role_id,
        permission_id
    )

);



INSERT INTO permissions(name,description)

VALUES

(
'VIEW_DASHBOARD',
'Access executive dashboard'
),

(
'VIEW_OPERATIONS',
'Access operations module'
),

(
'MANAGE_USERS',
'Create and manage users'
),

(
'VIEW_BILLING',
'Access billing information'
),

(
'VIEW_INVESTOR',
'Access investor intelligence'
),

(
'MANAGE_SECURITY',
'Manage security controls'
)

ON CONFLICT DO NOTHING;
