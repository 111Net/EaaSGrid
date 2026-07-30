
SELECT

id,

email,

password_hash,

role,

status

FROM users

WHERE email=$1;

