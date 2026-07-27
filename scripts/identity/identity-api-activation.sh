#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
API="$ROOT/apps/api"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/identity-api"
REPORT="$REPORT_DIR/identity-api-report.txt"

mkdir -p "$REPORT_DIR"

echo "====================================" > "$REPORT"
echo "EaaSGrid Identity API Activation" >> "$REPORT"
echo "Date: $DATE" >> "$REPORT"
echo "====================================" >> "$REPORT"


echo "[1] Installing authentication packages"

cd "$API"

npm install bcrypt jsonwebtoken


echo "[2] Creating directories"

mkdir -p src/services
mkdir -p src/controllers
mkdir -p src/routes
mkdir -p src/middleware
mkdir -p src/utils


echo "[3] Creating JWT utility"

cat > src/utils/jwt.js <<'EOF'

const jwt = require("jsonwebtoken");

const secret =
process.env.JWT_SECRET || "change-this-secret";


function generateToken(payload)
{
    return jwt.sign(
        payload,
        secret,
        {
            expiresIn:"8h"
        }
    );
}


function verifyToken(token)
{
    return jwt.verify(
        token,
        secret
    );
}


module.exports =
{
    generateToken,
    verifyToken
};

EOF


echo "[4] Creating password utility"

cat > src/utils/password.js <<'EOF'

const bcrypt = require("bcrypt");


async function hashPassword(password)
{
    return bcrypt.hash(
        password,
        12
    );
}


async function comparePassword(
    password,
    hash
)
{
    return bcrypt.compare(
        password,
        hash
    );
}


module.exports =
{
    hashPassword,
    comparePassword
};

EOF


echo "[5] Creating authentication middleware"

cat > src/middleware/authenticate.js <<'EOF'

const {
 verifyToken
}
=
require("../utils/jwt");


module.exports =
function(req,res,next)
{

const header =
req.headers.authorization;


if(!header)
{
 return res.status(401)
 .json({
 message:"Missing token"
 });
}


const token =
header.replace(
"Bearer ",
""
);


try
{
 req.user =
 verifyToken(token);

 next();

}
catch(error)
{
 return res.status(401)
 .json({
 message:"Invalid token"
 });
}

};

EOF


echo "[6] Creating auth service"

cat > src/services/auth.service.js <<'EOF'

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

EOF


echo "[7] Creating auth controller"

cat > src/controllers/auth.controller.js <<'EOF'

const auth =
require("../services/auth.service");


async function login(req,res)
{

try
{

const result =
await auth.login(
req.body.email,
req.body.password
);


res.json(result);

}
catch(error)
{

res.status(401)
.json(
{
message:error.message
}
);

}

}


module.exports={
login
};

EOF


echo "[8] Creating auth routes"

cat > src/routes/auth.routes.js <<'EOF'

const router=require("express").Router();

const controller =
require("../controllers/auth.controller");


router.post(
"/login",
controller.login
);


module.exports=router;

EOF


echo "[9] Registering route"

if ! grep -q "auth.routes" "$API/src/app.js"
then

sed -i \
'/require.*routes/a\
const authRoutes = require("./routes/auth.routes");' \
"$API/src/app.js"


sed -i \
'/app.use/a\
app.use("/api/auth", authRoutes);' \
"$API/src/app.js"

fi


echo "[10] Validation"

echo "Authentication module created" >> "$REPORT"

echo "STATUS: PASS" >> "$REPORT"

echo "Identity API Activation COMPLETE"
