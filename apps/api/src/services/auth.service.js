
const pool =
require("../config/postgres");

const {
comparePassword
}
=
require("../utils/password");


const {
generateToken
}
=
require("../utils/jwt");


async function login(email,password)
{

const result =
await pool.query(
`
SELECT
users.*,
roles.name AS role
FROM users
LEFT JOIN roles
ON roles.id=users.role_id
WHERE users.email=$1
`,
[email]
);


if(result.rows.length===0)
{
throw new Error("User not found");
}


const user=result.rows[0];


const valid =
await comparePassword(
password,
user.password_hash
);


if(!valid)
{
throw new Error("Invalid password");
}


const token =
generateToken(
{
id:user.id,
email:user.email,
role:user.role
});


return {
token,
user:
{
id:user.id,
email:user.email,
role:user.role
}
};

}


module.exports={
login
};

