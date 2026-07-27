#!/bin/bash

echo "============================================"
echo " EaaSGrid Role Permission Enforcement Engine"
echo " Module 13"
date
echo "============================================"

ROOT="/data/eaasgrid-platform/apps/dashboard"
MIDDLEWARE="$ROOT/middleware.js"

echo
echo "Backing up middleware..."
cp "$MIDDLEWARE" "$MIDDLEWARE.backup.module13.$(date +%F-%H%M%S)"

cat > "$MIDDLEWARE" <<'EOF'
import { NextResponse } from "next/server";

function decodePayload(token) {
    try {
        const payload = token.split(".")[1];
        const base64 = payload.replace(/-/g, "+").replace(/_/g, "/");
        return JSON.parse(atob(base64));
    } catch (e) {
        return null;
    }
}

const ROLE_ROUTES = {
    ADMIN: [
        "/control-centre",
        "/operations",
        "/partner",
        "/investor",
        "/customer",
        "/collaborator"
    ],

    OPERATIONS: [
        "/operations"
    ],

    PARTNER: [
        "/partner"
    ],

    INVESTOR: [
        "/investor"
    ],

    CUSTOMER: [
        "/customer"
    ],

    COLLABORATOR: [
        "/collaborator"
    ]
};

export function middleware(request) {

    const pathname = request.nextUrl.pathname;

    const protectedRoutes = [
        "/control-centre",
        "/operations",
        "/partner",
        "/investor",
        "/customer",
        "/collaborator"
    ];

    const requiresAuth =
        protectedRoutes.some(route => pathname.startsWith(route));

    if (!requiresAuth) {
        return NextResponse.next();
    }

    const cookie = request.cookies.get("eaasgrid_token");

    if (!cookie) {
        return NextResponse.redirect(
            new URL("/login", request.url)
        );
    }

    const jwt = decodePayload(cookie.value);

    if (!jwt || !jwt.role) {
        return NextResponse.redirect(
            new URL("/login", request.url)
        );
    }

    const role = jwt.role.toUpperCase();

    const allowed = ROLE_ROUTES[role] || [];

    const permitted =
        allowed.some(route => pathname.startsWith(route));

    if (!permitted) {

        return NextResponse.redirect(
            new URL("/unauthorized", request.url)
        );

    }

    return NextResponse.next();

}

export const config = {
    matcher: [
        "/control-centre/:path*",
        "/operations/:path*",
        "/partner/:path*",
        "/investor/:path*",
        "/customer/:path*",
        "/collaborator/:path*"
    ]
};
EOF

echo
echo "Creating Unauthorized page..."

mkdir -p "$ROOT/app/unauthorized"

cat > "$ROOT/app/unauthorized/page.jsx" <<'EOF'
export default function Unauthorized(){

return(

<div
style={{
display:"flex",
justifyContent:"center",
alignItems:"center",
height:"100vh",
background:"#0f172a",
color:"white",
flexDirection:"column"
}}
>

<h1>403</h1>

<h2>Access Denied</h2>

<p>
You do not have permission to access this area.
</p>

</div>

);

}
EOF

echo
echo "============================================"
echo "[PASS] Middleware upgraded"
echo "[PASS] JWT role authorization enabled"
echo "[PASS] Unauthorized page created"
echo "============================================"
