#!/bin/bash

echo "======================================"
echo " XaaSGrid Dashboard Hardening"
echo "======================================"

APP="/data/eaasgrid-platform/apps/dashboard"

cd $APP || exit 1


echo "[1] Backup current middleware"

mkdir -p backups/middleware

cp middleware.js backups/middleware/middleware-$(date +%F-%H%M).js 2>/dev/null


echo "[2] Create Next.js 16 proxy file"


cat > proxy.js <<'EOF'
import { NextResponse } from "next/server";


function decodePayload(token){

    try {

        const payload =
            token.split(".")[1];

        const base64 =
            payload
            .replace(/-/g,"+")
            .replace(/_/g,"/");


        return JSON.parse(
            atob(base64)
        );


    } catch {

        return null;

    }

}



const ROLE_ROUTES = {


ADMIN:[
"/control-centre",
"/operations",
"/partner",
"/investor",
"/customer",
"/collaborator"
],


OPERATIONS:[
"/operations"
],


PARTNER:[
"/partner"
],


INVESTOR:[
"/investor"
],


CUSTOMER:[
"/customer"
],


COLLABORATOR:[
"/collaborator"
]


};



export function proxy(request){


const pathname =
request.nextUrl.pathname;


const protectedRoutes = [

"/control-centre",
"/operations",
"/partner",
"/investor",
"/customer",
"/collaborator"

];



const requiresAuth =
protectedRoutes.some(
route =>
pathname.startsWith(route)
);



if(!requiresAuth){

return NextResponse.next();

}



const cookie =
request.cookies.get(
"eaasgrid_token"
);



if(!cookie){

return NextResponse.redirect(
new URL("/login",request.url)
);

}



const jwt =
decodePayload(cookie.value);



if(!jwt || !jwt.role){

return NextResponse.redirect(
new URL("/login",request.url)
);

}



const role =
jwt.role.toUpperCase();



const allowed =
ROLE_ROUTES[role] || [];



const permitted =
allowed.some(
route =>
pathname.startsWith(route)
);



if(!permitted){

return NextResponse.redirect(
new URL("/unauthorized",request.url)
);

}



return NextResponse.next();


}



export const config = {

matcher:[

"/control-centre/:path*",
"/operations/:path*",
"/partner/:path*",
"/investor/:path*",
"/customer/:path*",
"/collaborator/:path*"

]

};
EOF



echo "[3] Disable old middleware"

if [ -f middleware.js ]; then

mv middleware.js middleware.js.disabled

fi



echo "[4] Remove blurry heading styles"


find app \
-name "page.jsx" \
-exec sed -i \
's/textShadow:[^,}]*/textShadow:"none"/g' {} \;



find app \
-name "page.jsx" \
-exec sed -i \
's/fontWeight:"950"/fontWeight:"900"/g' {} \;



echo "[5] Clear cache"

rm -rf .next



echo "[6] Validate"

npm run lint


echo "======================================"
echo " Dashboard Hardening Completed"
echo "======================================"
