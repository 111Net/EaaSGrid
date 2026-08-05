"use client";


const API_URL =
process.env.NEXT_PUBLIC_API_URL || "/api";



export async function apiRequest(
    endpoint:string,
    options:RequestInit = {}
){

    const token =
        typeof window !== "undefined"
        ? localStorage.getItem("xaasgrid_token")
        : null;



    const headers:any = {

        "Content-Type":
        "application/json",

        ...(options.headers || {})

    };



    if(token){

        headers.Authorization =
        `Bearer ${token}`;

    }



    return fetch(

        `${API_URL}${endpoint}`,

        {

            ...options,

            headers

        }

    );

}




export async function getApi(
endpoint:string
){

    return apiRequest(

        endpoint,

        {

            method:"GET"

        }

    );

}




export async function postApi(
endpoint:string,
body:any
){

    return apiRequest(

        endpoint,

        {

            method:"POST",

            body:
            JSON.stringify(body)

        }

    );

}




export async function deleteApi(
endpoint:string
){

    return apiRequest(

        endpoint,

        {

            method:"DELETE"

        }

    );

}
