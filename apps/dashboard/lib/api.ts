"use client";

const API_URL =
    process.env.NEXT_PUBLIC_API_URL || "/api";

function resolveEndpoint(endpoint: string) {
    if (endpoint.startsWith("http://") || endpoint.startsWith("https://")) {
        return endpoint;
    }

    if (endpoint.startsWith("/api/")) {
        return endpoint;
    }

    const base = API_URL.endsWith("/")
        ? API_URL.slice(0, -1)
        : API_URL;

    const path = endpoint.startsWith("/")
        ? endpoint
        : `/${endpoint}`;

    return `${base}${path}`;
}

export async function apiRequest(
    endpoint: string,
    options: RequestInit = {}
) {
    const token =
        typeof window !== "undefined"
            ? localStorage.getItem("xaasgrid_token")
            : null;

    const headers: Record<string, string> = {
        "Content-Type": "application/json",
        ...(options.headers as Record<string, string> || {})
    };

    if (token) {
        headers.Authorization = `Bearer ${token}`;
    }

    return fetch(
        resolveEndpoint(endpoint),
        {
            ...options,
            headers
        }
    );
}

export async function getApi(endpoint: string) {
    return apiRequest(endpoint, {
        method: "GET"
    });
}

export async function postApi(
    endpoint: string,
    body: unknown
) {
    return apiRequest(endpoint, {
        method: "POST",
        body: JSON.stringify(body)
    });
}

export async function deleteApi(endpoint: string) {
    return apiRequest(endpoint, {
        method: "DELETE"
    });
}
