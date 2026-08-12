"use client";

import { useEffect, useState } from "react";
import { getApi } from "../../../lib/api";

export default function Organizations() {
    const [organizations, setOrganizations] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        getApi("/enterprise-control/organizations")
            .then(async (response) => {
                const data = await response.json();

                if (!response.ok || !data.success) {
                    throw new Error(data.message || "Unable to load organizations");
                }

                setOrganizations(data.organizations || []);
            })
            .catch((err) => {
                setError(err.message || "Unable to load organizations");
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    return (
        <section>
            <h1>Organizations</h1>

            <p>
                Create, manage and monitor enterprise organizations.
            </p>

            {loading && <p>Loading organizations...</p>}

            {error && (
                <p>
                    Unable to load organizations: {error}
                </p>
            )}

            {!loading && !error && (
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody>
                        {organizations.map((organization) => (
                            <tr key={organization.id}>
                                <td>{organization.name}</td>
                                <td>{organization.status}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}
        </section>
    );
}
