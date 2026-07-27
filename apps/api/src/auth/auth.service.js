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


    if (result.rows.length === 0) {
        throw new Error("Invalid credentials");
    }


    const user = result.rows[0];


    const valid = await bcrypt.compare(
        password,
        user.password_hash
    );


    if (!valid) {
        throw new Error("Invalid credentials");
    }


    return {

        token: createToken(user),

        user: {
            id: user.id,
            email: user.email,
            role: user.role
        }

    };

}


module.exports = {
    login
};
