#!/bin/bash

set -e


echo "=========================================="
echo "XaaSGrid Sprint 43.20"
echo "Website Factory & Public Portal Activation"
echo "=========================================="


ROOT="/data/eaasgrid-platform"

cd $ROOT



echo "[1] Backup"

mkdir -p backups/sprint43.20

cp apps/api/src/app.js \
backups/sprint43.20/app-before-43.20.js



echo "[2] Creating website content factory"


mkdir -p content/website



cat > content/website/homepage.json <<EOF
{
"title":"XaaSGrid",
"tagline":
"Enterprise Everything-as-a-Service Platform",
"features":[
"Enterprise Service Delivery",
"Automation",
"Intelligence",
"Operations"
]
}
EOF



cat > content/website/products.json <<EOF
{
"products":[
"Energy-as-a-Service",
"Infrastructure-as-a-Service",
"Platform-as-a-Service",
"Digital Operations"
]
}
EOF



cat > content/website/solutions.json <<EOF
{
"solutions":[
"Enterprise Automation",
"Cloud Infrastructure",
"Digital Transformation"
]
}
EOF



cat > content/website/partners.json <<EOF
{
"title":"Partner Ecosystem",
"features":[
"API Integration",
"Marketplace",
"Collaboration"
]
}
EOF



cat > content/website/investors.json <<EOF
{
"title":"Investor Platform",
"features":[
"Enterprise Growth",
"Analytics",
"Market Expansion"
]
}
EOF



cat > content/website/customers.json <<EOF
{
"title":"Customer Platform",
"features":[
"Services",
"Billing",
"Support"
]
}
EOF



cat > content/website/security.json <<EOF
{
"title":"Enterprise Security",
"features":[
"Authentication",
"Role Management",
"Secure APIs"
]
}
EOF



cat > content/website/contact.json <<EOF
{
"channels":[
"Sales",
"Partners",
"Investors",
"Support"
]
}
EOF




echo "[3] Creating public API"



mkdir -p apps/api/src/routes/public



cat > apps/api/src/routes/public/index.js <<'EOF'


const express=require("express");

const router=express.Router();

const fs=require("fs");

const path=require("path");



function load(name){

return JSON.parse(

fs.readFileSync(

path.join(
process.cwd(),
"content/website",
name+".json"
)

)

);

}



router.get("/:page",(req,res)=>{


try{


res.json({

success:true,

data:load(req.params.page)

});


}

catch(e){


res.status(404).json({

success:false,

message:"Content not found"

});


}


});





router.post("/contact",(req,res)=>{


res.json({

success:true,

message:"Contact request received",

data:req.body

});


});



module.exports=router;

EOF




echo "[4] Register public API"


grep -q '"/api/public"' apps/api/src/app.js || \

sed -i '/\/\/ =====================================/i \
loadRoute(\
    "/api/public",\
    "./routes/public"\
);\
' apps/api/src/app.js





echo "[5] Dashboard public pages"



mkdir -p apps/dashboard/app/products
mkdir -p apps/dashboard/app/partners
mkdir -p apps/dashboard/app/investors
mkdir -p apps/dashboard/app/customers
mkdir -p apps/dashboard/app/security
mkdir -p apps/dashboard/app/contact



cat > apps/dashboard/app/page.jsx <<'EOF'

export default function Home(){

return (

<main>

<h1>XaaSGrid</h1>

<h2>
Enterprise Everything-as-a-Service Platform
</h2>


<p>
Automation, intelligence and enterprise service delivery.
</p>


</main>

)

}

EOF




cat > apps/dashboard/app/products/page.jsx <<'EOF'

export default function Products(){

return (

<main>

<h1>
XaaSGrid Products
</h1>

<p>
Enterprise service solutions.
</p>

</main>

)

}

EOF




cat > apps/dashboard/app/partners/page.jsx <<'EOF'

export default function Partners(){

return (

<main>

<h1>
Partner Ecosystem
</h1>

<p>
Integration and collaboration platform.
</p>

</main>

)

}

EOF




cat > apps/dashboard/app/investors/page.jsx <<'EOF'

export default function Investors(){

return (

<main>

<h1>
Investor Portal
</h1>

<p>
Growth and enterprise metrics.
</p>

</main>

)

}

EOF




cat > apps/dashboard/app/customers/page.jsx <<'EOF'

export default function Customers(){

return (

<main>

<h1>
Customer Portal
</h1>

<p>
Manage services and operations.
</p>

</main>

)

}

EOF




cat > apps/dashboard/app/security/page.jsx <<'EOF'

export default function Security(){

return (

<main>

<h1>
Enterprise Security
</h1>

<p>
Secure platform operations.
</p>

</main>

)

}

EOF




echo "[6] Build dashboard"

docker compose build xaasgrid-dashboard



echo "[7] Build API"

docker compose build xaasgrid-api



echo "[8] Restart platform"

docker compose up -d


sleep 40



echo "[9] Validation"


echo "SYSTEM"

curl -s \
http://localhost:4000/api/system/status


echo


echo "PUBLIC WEBSITE"

curl -s \
http://localhost:4000/api/public/homepage


echo


echo "PRODUCTS"

curl -s \
http://localhost:4000/api/public/products


echo


echo "DASHBOARD"

curl -I \
http://localhost:3000





echo "[10] Git staging"



git add \
content/website \
apps/api/src/routes/public \
apps/api/src/app.js \
apps/dashboard/app \
scripts/sprint43.20



echo


echo "=========================================="
echo "Sprint 43.20 COMPLETE"
echo "=========================================="


echo

echo "Commit:"
echo "git commit -m \"Sprint 43.20 website factory public portal activation\""


echo

echo "Push:"
echo "git push origin main"

