"use client";

import { useEffect, useState } from "react";
import { getApi } from "../../../lib/api";

export default function Governance() {
    const [security, setSecurity] = useState(null);
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        Promise.all([
            getApi("/enterprise-control/governance/security"),
            getApi("/enterprise-control/governance/audit")
        ])
            .then(async ([securityResponse, auditResponse]) => {
                const securityData = await securityResponse.json();
                const auditData = await auditResponse.json();

                if (
                    !securityResponse.ok ||
                    !securityData.success
                ) {
                    throw new Error(
                        securityData.message || "Unable to load security status"
                    );
                }

                if (
                    !auditResponse.ok ||
                    !auditData.success
                ) {
                    throw new Error(
                        auditData.message || "Unable to load audit events"
                    );
                }

                setSecurity(securityData);
                setEvents(auditData.events || []);
            })
            .catch((err) => {
                setError(err.message || "Unable to load governance data");
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    return (
        <section>
            <h1>Governance</h1>

            <p>
                Enterprise security and administrative governance.
            </p>

            {loading && <p>Loading governance status...</p>}

            {error && (
                <p>
                    Unable to load governance data: {error}
                </p>
            )}

            {!loading && !error && (
                <>
                    <h2>Security</h2>

                    <p>
                        Status:{" "}
                        <strong>
                            {security?.securityStatus || "UNKNOWN"}
                        </strong>
                    </p>

                    <h2>Audit Events</h2>

                    {events.length === 0 ? (
                        <p>No audit events recorded.</p>
                    ) : (
                        <ul>
                            {events.map((event, index) => (
                                <li key={event.id || index}>
                                    {event.action || event.message || JSON.stringify(event)}
                                </li>
                            ))}
                        </ul>
                    )}
                </>
            )}
        </section>
    );
}
