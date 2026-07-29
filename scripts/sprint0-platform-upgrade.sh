#!/bin/bash

set -e

echo "=========================================="
echo " XaaSGrid Sprint 0 Platform Upgrade"
echo " 0.8 - 0.11 Automation"
echo "=========================================="

ROOT="/data/eaasgrid-platform"

cd "$ROOT" || exit 1


echo ""
echo "[1] Creating dashboard permission engine"

mkdir -p apps/dashboard/lib


cat > apps/dashboard/lib/permissions.js <<'EOF'
export function hasPermission(permission, permissions=[]){

    return permissions.includes(permission);

}


export function canAccess(route, permissions=[]){

    const rules = {

        "/operations":[
            "VIEW_OPERATIONS"
        ],

        "/investor":[
            "VIEW_INVESTOR"
        ],

        "/billing":[
            "VIEW_BILLING"
        ],

        "/users":[
            "MANAGE_USERS"
        ],

        "/security":[
            "MANAGE_SECURITY"
        ]

    };


    const required = rules[route];


    if(!required){
        return true;
    }


    return required.some(
        p=>permissions.includes(p)
    );

}
EOF



cat > apps/dashboard/lib/session.js <<'EOF'
export function getSession(){

    if(typeof window==="undefined"){
        return null;
    }


    const token =
        localStorage.getItem(
            "eaasgrid_token"
        );


    const user =
        localStorage.getItem(
            "eaasgrid_user"
        );


    if(!token || !user){
        return null;
    }


    return {

        token,

        user:
        JSON.parse(user)

    };

}
EOF



echo ""
echo "[2] Creating API user management module"


mkdir -p apps/api/src/users


cat > apps/api/src/users/users.routes.js <<'EOF'
const express=require("express");

const router=express.Router();

const authenticate=
require("../middleware/auth");


router.get(
"/",
authenticate,
(req,res)=>{

res.json({
message:"User management endpoint",
user:req.user
});

});


module.exports=router;
EOF



cat > apps/api/src/users/users.controller.js <<'EOF'
exports.listUsers=function(req,res){

res.json({

success:true,

message:
"User controller ready"

});

};
EOF



cat > apps/api/src/users/users.service.js <<'EOF'
exports.createUser=function(){

return {

status:
"User service ready"

};

};
EOF



echo ""
echo "[3] Creating audit service"


mkdir -p apps/api/src/audit


cat > apps/api/src/audit/audit.service.js <<'EOF'
const pool =
require("../config/postgres");


async function record(
action,
user,
details={}
){

await pool.query(

`
INSERT INTO audit_logs
(
action,
user_id,
details
)

VALUES
($1,$2,$3)
`,

[
action,
user,
JSON.stringify(details)
]

);

}


module.exports={
record
};
EOF



echo ""
echo "[4] Creating organisation foundation migration"


mkdir -p apps/api/src/database


cat > apps/api/src/database/organisation-schema.sql <<'EOF'

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

EOF



echo ""
echo "[5] Applying organisation schema"


sudo -u postgres psql -d eaas_db \
-f apps/api/src/database/organisation-schema.sql



echo ""
echo "[6] Creating reports folder"

mkdir -p reports


echo "
XaaSGrid Sprint 0 Platform Upgrade

0.8 Frontend Permission Engine     COMPLETE
0.9 User Management Foundation     COMPLETE
0.10 Audit Foundation              COMPLETE
0.11 Organisation Foundation      COMPLETE

Timestamp:
$(date)

" > reports/sprint0-platform-upgrade.txt



echo ""
echo "=========================================="
echo " Sprint 0 Platform Upgrade Complete"
echo "=========================================="

echo ""
cat reports/sprint0-platform-upgrade.txt
