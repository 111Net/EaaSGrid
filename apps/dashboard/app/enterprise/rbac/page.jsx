"use client";

import { useEffect, useState } from "react";
import { getApi } from "../../../lib/api";

export default function RBAC() {
    const [roles, setRoles] = useState([]);
    const [permissions, setPermissions] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        Promise.all([
            getApi("/enterprise-control/rbac/roles"),
            getApi("/enterprise-control/rbac/permissions")
        ])
            .then(async ([rolesResponse, permissionsResponse]) => {
                const rolesData = await rolesResponse.json();
                const permissionsData = await permissionsResponse.json();

                if (
                    !rolesResponse.ok ||
                    !rolesData.success
                ) {
                    throw new Error(
                        rolesData.message || "Unable to load roles"
                    );
                }

                if (
                    !permissionsResponse.ok ||
                    !permissionsData.success
                ) {
                    throw new Error(
                        permissionsData.message || "Unable to load permissions"
                    );
                }

                setRoles(rolesData.roles || []);
                setPermissions(permissionsData.permissions || []);
            })
            .catch((err) => {
                setError(err.message || "Unable to load RBAC data");
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    return (
        <section>
            <h1>Role Based Access Control</h1>

            {loading && <p>Loading RBAC configuration...</p>}

            {error && (
                <p>
                    Unable to load RBAC configuration: {error}
                </p>
            )}

            {!loading && !error && (
                <>
                    <h2>Roles</h2>

                    <ul>
                        {roles.map((role) => (
                            <li key={role}>{role}</li>
                        ))}
                    </ul>

                    <h2>Permissions</h2>

                    <ul>
                        {permissions.map((permission) => (
                            <li key={permission}>{permission}</li>
                        ))}
                    </ul>
                </>
            )}
        </section>
    );
}
