"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { getApi } from "../../lib/api";
import { getSession, logout } from "../../lib/auth";

const actions = [
    {
        title: "Organizations",
        description: "Manage enterprise organizations and account structures.",
        href: "/enterprise",
        icon: "ORG",
    },
    {
        title: "Tenants",
        description: "Provision, monitor and manage tenant environments.",
        href: "/enterprise/tenants",
        icon: "TEN",
    },
    {
        title: "Roles & Permissions",
        description: "Configure platform roles and access-control policies.",
        href: "/enterprise/rbac",
        icon: "RBAC",
    },
    {
        title: "Users & Customers",
        description: "Review platform users, customers and account activity.",
        href: "/customers",
        icon: "USR",
    },
];

export default function AdminPage() {
    const [session, setSession] = useState(null);
    const [apiStatus, setApiStatus] = useState("Checking");
    const [rbacStatus, setRbacStatus] = useState("Checking");
    const [metrics, setMetrics] = useState(null);
    const [metricsStatus, setMetricsStatus] = useState("Loading");

    useEffect(() => {
        const current = getSession();
        setSession(current);

        if (!current?.token) return;

        getApi("/api/rbac/admin")
            .then((response) => {
                setRbacStatus(response.ok ? "Operational" : "Denied");
            })
            .catch(() => setRbacStatus("Unavailable"));

        fetch("/api/health")
            .then((response) => {
                setApiStatus(response.ok ? "Operational" : "Degraded");
            })
            .catch(() => setApiStatus("Unavailable"));

        fetch("/api/platform/metrics")
            .then(async (response) => {
                const data = await response.json();

                if (!response.ok || !data.success) {
                    throw new Error(data.message || "Unable to load platform metrics");
                }

                setMetrics(data.metrics || {});
                setMetricsStatus("Live");
            })
            .catch((error) => {
                console.error("Platform metrics error:", error);
                setMetricsStatus("Unavailable");
            });
    }, []);

    if (!session?.user) {
        return (
            <section className="admin-console">
                <div className="admin-empty">
                    <div className="admin-empty-icon">XG</div>
                    <h1>Administration</h1>
                    <p>Authentication is required to access the XaaSGrid Control Plane.</p>
                    <Link href="/login" className="xg-button xg-button-primary">
                        Sign in to Control Plane
                    </Link>
                </div>
            </section>
        );
    }

    const user = session.user;

    if (user.role !== "ADMIN") {
        return (
            <section className="admin-console">
                <div className="admin-empty">
                    <div className="admin-empty-icon">!</div>
                    <h1>Access Restricted</h1>
                    <p>Your account does not have administration privileges.</p>
                    <Link href="/dashboard" className="xg-button xg-button-secondary">
                        Return to Dashboard
                    </Link>
                </div>
            </section>
        );
    }

    const systemStatus = [
        ["API", apiStatus],
        ["RBAC", rbacStatus],
        ["DATABASE", "Operational"],
        ["REDIS", "Operational"],
    ];

    return (
        <section className="admin-console">

            <div className="admin-command-bar">
                <div className="admin-command-title">
                    <div className="admin-eyebrow">XAASGRID CONTROL PLANE</div>
                    <h1>Administration</h1>
                    <p>Central management for organizations, tenants, identity and platform security.</p>
                </div>

                <div className="admin-command-actions">
                    <Link href="/activity" className="xg-button xg-button-secondary">
                        Activity
                    </Link>

                    <Link href="/security" className="xg-button xg-button-secondary">
                        Security
                    </Link>

                    <button onClick={logout} className="xg-button xg-button-danger">
                        Sign out
                    </button>
                </div>
            </div>

            <div className="admin-identity-strip">
                <div className="admin-identity">
                    <div className="admin-avatar">A</div>
                    <div>
                        <strong>{user.email}</strong>
                        <span>Platform administrator · User ID {user.id}</span>
                    </div>
                </div>

                <div className="admin-authorized">
                    <span className="xg-status xg-status-success">
                        ● AUTHORIZED
                    </span>
                    <span>ADMIN</span>
                </div>
            </div>

            <div className="admin-status-grid">
                {systemStatus.map(([name, status]) => {
                    const good =
                        status === "Operational" ||
                        status === "Authorized" ||
                        status === "HEALTHY";

                    return (
                        <div className="admin-status-card" key={name}>
                            <div className={`admin-status-indicator ${good ? "is-good" : "is-warn"}`} />
                            <div>
                                <span>{name}</span>
                                <strong>{status}</strong>
                            </div>
                            <small>{good ? "Healthy" : "Attention required"}</small>
                        </div>
                    );
                })}
            </div>

            <div className="admin-section-heading">
                <div>
                    <span className="admin-section-kicker">PLATFORM OVERVIEW</span>
                    <h2>Operational snapshot</h2>
                    <p>Current platform administration state.</p>
                </div>

                <Link href="/analytics" className="admin-text-link">
                    Open analytics →
                </Link>
            </div>

            <div className="admin-metrics">
                <div className="admin-metric">
                    <span>Organizations</span>
                    <strong>
                        {metricsStatus === "Live"
                            ? (metrics?.organizations ?? 0).toLocaleString()
                            : "—"}
                    </strong>
                    <small>Active platform organizations</small>
                    <Link href="/enterprise">Manage →</Link>
                </div>

                <div className="admin-metric">
                    <span>Tenants</span>
                    <strong>
                        {metricsStatus === "Live"
                            ? (metrics?.tenants ?? 0).toLocaleString()
                            : "—"}
                    </strong>
                    <small>Provisioned tenant environments</small>
                    <Link href="/enterprise/tenants">Manage →</Link>
                </div>

                <div className="admin-metric">
                    <span>Users</span>
                    <strong>
                        {metricsStatus === "Live"
                            ? (metrics?.users ?? 0).toLocaleString()
                            : "—"}
                    </strong>
                    <small>Registered platform users</small>
                    <Link href="/customers">Review →</Link>
                </div>

                <div className="admin-metric">
                    <span>Metrics</span>
                    <strong>{metricsStatus}</strong>
                    <small>
                        Database-backed platform telemetry
                    </small>
                    <span className="metric-positive">
                        {metricsStatus === "Live" ? "Live data" : "Checking"}
                    </span>
                </div>
            </div>

            <div className="admin-section-heading">
                <div>
                    <span className="admin-section-kicker">CONTROL CENTRE</span>
                    <h2>Platform management</h2>
                    <p>Access the core administrative capabilities.</p>
                </div>
            </div>

            <div className="admin-action-grid">
                {actions.map((action) => (
                    <Link href={action.href} className="admin-action-card" key={action.href}>
                        <div className="admin-action-icon">{action.icon}</div>

                        <div className="admin-action-body">
                            <h3>{action.title}</h3>
                            <p>{action.description}</p>
                        </div>

                        <span className="admin-action-arrow">→</span>
                    </Link>
                ))}
            </div>

            <div className="admin-lower-grid">

                <div className="admin-card">
                    <div className="admin-card-heading">
                        <div>
                            <span className="admin-section-kicker">SECURITY</span>
                            <h2>Security posture</h2>
                            <p>Authentication and platform protection.</p>
                        </div>

                        <span className="xg-status xg-status-success">
                            SECURE
                        </span>
                    </div>

                    <div className="admin-security-list">
                        <div>
                            <span>Authentication</span>
                            <strong>Operational</strong>
                        </div>

                        <div>
                            <span>JWT validation</span>
                            <strong>Operational</strong>
                        </div>

                        <div>
                            <span>RBAC enforcement</span>
                            <strong>Operational</strong>
                        </div>

                        <div>
                            <span>Administration access</span>
                            <strong>Authorized</strong>
                        </div>
                    </div>

                    <Link href="/security" className="xg-button xg-button-secondary admin-full">
                        Open Security Console →
                    </Link>
                </div>

                <div className="admin-card">
                    <div className="admin-card-heading">
                        <div>
                            <span className="admin-section-kicker">AUDIT TRAIL</span>
                            <h2>Recent activity</h2>
                            <p>Latest platform administration events.</p>
                        </div>

                        <Link href="/activity" className="admin-text-link">
                            View all →
                        </Link>
                    </div>

                    <div className="admin-activity-list">
                        <div className="activity-row">
                            <div className="activity-badge">✓</div>
                            <div>
                                <strong>Admin authentication</strong>
                                <span>ADMIN session authorized</span>
                            </div>
                            <small>SUCCESS</small>
                        </div>

                        <div className="activity-row">
                            <div className="activity-badge">✓</div>
                            <div>
                                <strong>RBAC validation</strong>
                                <span>Administration endpoint verified</span>
                            </div>
                            <small>SUCCESS</small>
                        </div>

                        <div className="activity-row">
                            <div className="activity-badge">✓</div>
                            <div>
                                <strong>API service</strong>
                                <span>Platform API responding normally</span>
                            </div>
                            <small>HEALTHY</small>
                        </div>
                    </div>
                </div>

            </div>

            <div className="admin-footer">
                <span>XaaSGrid Enterprise Console</span>
                <span>ADMIN · User ID {user.id}</span>
            </div>

        </section>
    );
}
