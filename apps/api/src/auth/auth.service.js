const bcrypt = require("bcrypt");

const pool = require("../config/postgres");

const { createToken } = require("./jwt");


async function login(email, password) {

    const result = await pool.query(
`
SELECT

    u.id,
    u.email,
    u.password_hash,

    r.name AS role

FROM users u

LEFT JOIN roles r

ON u.role_id = r.id

WHERE u.email = $1

`,
[email]
    );


    if(result.rows.length === 0){

        throw new Error("Invalid credentials");

    }


    const user = result.rows[0];


    const valid =
    await bcrypt.compare(
        password,
        user.password_hash
    );


    if(!valid){

        throw new Error("Invalid credentials");

    }


    const permissionResult =
    await pool.query(
`
SELECT

p.name

FROM permissions p

JOIN role_permissions rp

ON p.id = rp.permission_id

JOIN roles r

ON r.id = rp.role_id

WHERE r.name = $1

ORDER BY p.name

`,
[user.role]
    );


    const permissions =
    permissionResult.rows.map(
        p => p.name
    );


    const token =
    createToken({

        id:user.id,

        email:user.email,

        role:user.role,

        permissions

    });


    return {

        token,

        user:{

            id:user.id,

            email:user.email,

            role:user.role,

            permissions

        }

    };

}


module.exports = {
    login
};
