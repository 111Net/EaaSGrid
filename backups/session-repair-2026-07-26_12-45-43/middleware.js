import { NextResponse } from "next/server";


export function middleware(request) {

    const token =
        request.cookies.get(
            "eaasgrid_token"
        );


    const pathname =
        request.nextUrl.pathname;


    const protectedRoutes = [
        "/control-centre",
        "/operations",
        "/partner",
        "/investor",
        "/customer"
    ];


    const requiresAuth =
        protectedRoutes.some(
            route =>
            pathname.startsWith(route)
        );


    if (
        requiresAuth &&
        !token
    ) {

        return NextResponse.redirect(
            new URL(
                "/login",
                request.url
            )
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
        "/customer/:path*"
    ]

};
