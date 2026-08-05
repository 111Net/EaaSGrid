#!/bin/bash

set -e


echo "=========================================="
echo "XaaSGrid Sprint 43.18"
echo "User Management & Collaboration Portal"
echo "=========================================="


ROOT="/data/eaasgrid-platform"

cd $ROOT



echo "[1] Backup"


mkdir -p backups/sprint43.18

cp -r apps/api/src/routes \
backups/sprint43.18/routes-backup-$(date +%F-%H%M)



echo "[2] Creating user management module"


mkdir -p apps/api/src/users


cat > apps/api/src/users/user.store.js <<'EOF'


let users=[

{
id:1,
name:"XaaSGrid Administrator",
email:"admin@xaasgrid.com",
role:"SUPER_ADMIN",
status:"ACTIVE"
}

];


module.exports={

users

};


EOF



cat > apps/api/src/users/user.service.js <<'EOF'


const store=require("./user.store");


function list(){

return store.users;

}


function create(data){


const user={

id:Date.now(),

name:data.name,

email:data.email,

role:data.role || "CUSTOMER",

status:"ACTIVE"

};


store.users.push(user);


return user;


}


function find(id){

return store.users.find(

u=>u.id==id

);

}


function update(id,data){


const user=find(id);


if(!user)return null;


Object.assign(user,data);


return user;


}



function remove(id){


store.users =
store.users.filter(
u=>u.id!=id
);


return true;


}



module.exports={

list,

create,

find,

update,

remove

};


EOF



echo "[3] Creating user API"


mkdir -p apps/api/src/routes/users



cat > apps/api/src/routes/users/index.js <<'EOF'


const express=require("express");

const router=express.Router();


const service=require("../../users/user.service");



router.get("/",(req,res)=>{


res.json({

success:true,

data:service.list()

});


});




router.post("/",(req,res)=>{


res.json({

success:true,

data:service.create(req.body)

});


});




router.get("/:id",(req,res)=>{


res.json({

success:true,

data:service.find(req.params.id)

});


});




router.put("/:id",(req,res)=>{


res.json({

success:true,

data:service.update(
req.params.id,
req.body
)

});


});




router.delete("/:id",(req,res)=>{


service.remove(req.params.id);


res.json({

success:true

});


});



module.exports=router;


EOF



echo "[4] Register user routes"



grep -q '"/api/users"' apps/api/src/app.js || \

sed -i '/\/\/ =====================================/i \
loadRoute(\
    "/api/users",\
    "./routes/users"\
);\
' apps/api/src/app.js




echo "[5] Collaboration portal APIs"



mkdir -p apps/api/src/routes/collaboration



cat > apps/api/src/routes/collaboration/index.js <<'EOF'


const express=require("express");

const router=express.Router();


router.get("/team",(req,res)=>{

res.json({

success:true,

data:[

{
name:"Platform Administration",
type:"Internal Team"
}

]

});


});



router.get("/partners",(req,res)=>{


res.json({

success:true,

data:[]

});


});



router.get("/investors",(req,res)=>{


res.json({

success:true,

data:[]

});


});



router.get("/customers",(req,res)=>{


res.json({

success:true,

data:[]

});


});


module.exports=router;


EOF



grep -q '"/api/collaboration"' apps/api/src/app.js || \

sed -i '/\/\/ =====================================/i \
loadRoute(\
    "/api/collaboration",\
    "./routes/collaboration"\
);\
' apps/api/src/app.js





echo "[6] Documentation"


mkdir -p docs/collaboration



cat > docs/collaboration/USER_MANAGEMENT.md <<EOF

# XaaSGrid User Management


Users can be:

- Administrators
- Partners
- Customers
- Investors
- Operators


User lifecycle:

Invitation
Activation
Role Assignment
Deactivation


EOF




cat > docs/collaboration/PARTNERS.md <<EOF

# XaaSGrid Partner Portal


Partners can integrate:

- Services
- APIs
- Billing
- Marketplace offerings


EOF




cat > docs/collaboration/INVESTORS.md <<EOF

# XaaSGrid Investor Portal


Investors receive:

- Platform metrics
- Growth information
- Enterprise visibility


EOF




cat > docs/collaboration/CUSTOMERS.md <<EOF

# XaaSGrid Customer Portal


Customers manage:

- Services
- Accounts
- Billing
- Support


EOF





echo "[7] Build API"


docker compose build xaasgrid-api



echo "[8] Restart"


docker compose up -d



sleep 30



echo "[9] Validation"


echo "SYSTEM"

curl -s \
http://localhost:4000/api/system/status


echo


echo "USERS"

curl -s \
http://localhost:4000/api/users


echo


echo "COLLABORATION"

curl -s \
http://localhost:4000/api/collaboration/team



echo


echo "[10] Git staging"



git add \
apps/api/src/users \
apps/api/src/routes/users \
apps/api/src/routes/collaboration \
apps/api/src/app.js \
docs/collaboration \
scripts/sprint43.18



echo


echo "=========================================="
echo "Sprint 43.18 COMPLETE"
echo "=========================================="


echo

echo "Commit:"
echo "git commit -m \"Sprint 43.18 user management collaboration portal\""

echo

echo "Push:"
echo "git push origin main"

