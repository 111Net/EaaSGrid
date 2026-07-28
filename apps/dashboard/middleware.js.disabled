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
