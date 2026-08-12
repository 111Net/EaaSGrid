"use client";

import { useEffect, useState } from "react";
import { getApi } from "../../../lib/api";

export default function Tenants() {
    const [tenants, setTenants] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        getApi("/enterprise-control/tenants")
            .then(async (response) => {
                const data = await response.json();

                if (!response.ok || !data.success) {
                    throw new Error(data.message || "Unable to load tenants");
                }

                setTenants(data.tenants || []);
            })
            .catch((err) => {
                setError(err.message || "Unable to load tenants");
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    return (
        <section>
            <h1>Tenant Management</h1>

            <p>
                Manage tenant lifecycle, resources and status.
            </p>

            {loading && <p>Loading tenants...</p>}

            {error && (
                <p>
                    Unable to load tenants: {error}
                </p>
            )}

            {!loading && !error && (
                <ul>
                    {tenants.map((tenant) => (
                        <li key={tenant.id}>
                            {tenant.name} — {tenant.status}
                        </li>
                    ))}
                </ul>
            )}
        </section>
    );
}
