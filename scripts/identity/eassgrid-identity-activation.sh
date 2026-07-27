#!/usr/bin/env bash

set -e

ROOT="/data/eaasgrid-platform"
API="$ROOT/apps/api"

echo "===================================="
echo "EaaSGrid Identity Activation"
echo "===================================="

cd "$API"

echo "[1/8] Installing authentication packages"

npm install bcrypt jsonwebtoken


echo "[2/8] Creating folders"

mkdir -p src/auth
mkdir -p src/database


echo "[3/8] Creating PostgreSQL identity schema"

cat > src/database/identity-schema.sql <<'EOF'

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

EOF


echo "[4/8] Creating JWT utility"

cat > src/auth/jwt.js <<'EOF'

const jwt = require("jsonwebtoken");


function createToken(user){

return jwt.sign(

{
 id:user.id,
 email:user.email,
 role:user.role
},

process.env.JWT_SECRET,

{
 expiresIn:"8h"
}

);

}


module.exports={
createToken
};

EOF


echo "[5/8] Creating authentication service"

cat > src/auth/auth.service.js <<'EOF'

const bcrypt=require("bcrypt");

const pool=require("../config/postgres");

const {createToken}=require("./jwt");


async function login(email,password){


const result =
await pool.query(

`
SELECT
u.id,
u.email,
u.password_hash,
r.name as role

FROM users u

LEFT JOIN user_roles ur
ON u.id=ur.user_id

LEFT JOIN roles r
ON r.id=ur.role_id

WHERE u.email=$1
`,
[email]

);


if(result.rows.length===0)
throw new Error("Invalid credentials");


const user=result.rows[0];


const valid =
await bcrypt.compare(
password,
user.password_hash
);


if(!valid)
throw new Error("Invalid credentials");


return {

token:createToken(user),

user:{
id:user.id,
email:user.email,
role:user.role
}

};


}


module.exports={
login
};

EOF


echo "[6/8] Creating auth controller"

cat > src/auth/auth.controller.js <<'EOF'

const service=require("./auth.service");


exports.login=async(req,res)=>{


try{


const result =
await service.login(
req.body.email,
req.body.password
);


res.json(result);


}

catch(error){

res.status(401).json({

message:error.message

});

}


};

EOF


echo "[7/8] Creating auth routes"

cat > src/auth/auth.routes.js <<'EOF'

const router=require("express").Router();

const controller=require("./auth.controller");


router.post(
"/login",
controller.login
);


module.exports=router;

EOF


echo "[8/8] Identity files created"

echo ""
echo "NEXT:"
echo "1. Run database migration"
echo "2. Create admin user"
echo "3. Create operations user"
echo "4. Connect Next.js login form"
echo ""
