
CREATE TABLE IF NOT EXISTS organisations
(

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

name VARCHAR(255) NOT NULL,

status VARCHAR(50)
DEFAULT 'ACTIVE',

created_at TIMESTAMP
DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS organisation_users
(

organisation_id UUID
REFERENCES organisations(id)
ON DELETE CASCADE,


user_id UUID
REFERENCES users(id)
ON DELETE CASCADE,


created_at TIMESTAMP
DEFAULT CURRENT_TIMESTAMP,


PRIMARY KEY
(
organisation_id,
user_id
)

);

