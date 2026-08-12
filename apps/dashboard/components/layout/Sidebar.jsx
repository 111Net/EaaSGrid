"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { getSession } from "../../lib/auth";

function Icon({ type }) {
    const paths = {
        dashboard: (
            <>
                <rect x="3" y="3" width="7" height="7" rx="1" />
                <rect x="14" y="3" width="7" height="7" rx="1" />
                <rect x="3" y="14" width="7" height="7" rx="1" />
                <rect x="14" y="14" width="7" height="7" rx="1" />
            </>
        ),
        enterprise: (
            <>
                <rect x="4" y="3" width="16" height="18" rx="2" />
                <path d="M8 7h3M13 7h3M8 11h3M13 11h3M8 15h3M13 15h3" />
            </>
        ),
        customers: (
            <>
                <circle cx="9" cy="8" r="3" />
                <path d="M3 20c0-3.3 2.7-6 6-6s6 2.7 6 6" />
                <path d="M16 5.5a3 3 0 0 1 0 5.8M18 14c1.8.8 3 2.7 3 6" />
            </>
        ),
        operations: (
            <>
                <path d="M12 3v4M12 17v4M3 12h4M17 12h4" />
                <circle cx="12" cy="12" r="5" />
            </>
        ),
        analytics: (
            <>
                <path d="M4 19V9M10 19V5M16 19v-8M22 19H2" />
            </>
        ),
        marketplace: (
            <>
                <path d="M4 9h16v11H4z" />
                <path d="M3 9l2-5h14l2 5" />
                <path d="M8 13h8M8 17h5" />
            </>
        ),
        security: (
            <>
                <path d="M12 3l8 3v6c0 5-3.4 8-8 9-4.6-1-8-4-8-9V6l8-3z" />
                <path d="M9 12l2 2 4-4" />
            </>
        ),
        activity: (
            <>
                <path d="M4 12h4l2-6 4 12 2-6h4" />
            </>
        )
    };

    return (
        <svg
            viewBox="0 0 24 24"
            width="18"
            height="18"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.7"
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
        >
            {paths[type] || paths.dashboard}
        </svg>
    );
}

const menu = [
    {
        section: "OVERVIEW",
        items: [
            ["Dashboard", "/dashboard", "dashboard"]
        ]
    },
    {
        section: "PLATFORM",
        items: [
            ["Enterprise", "/enterprise", "enterprise"],
            ["Customers", "/customer", "customers"],
            ["Operations", "/operations", "operations"],
            ["Analytics", "/analytics", "analytics"],
            ["Marketplace", "/marketplace", "marketplace"]
        ]
    },
    {
        section: "GOVERNANCE",
        items: [
            ["Security", "/security", "security"],
            ["Administration", "/admin", "security"],
            ["Activity", "/activity", "activity"]
        ]
    }
];

export default function Sidebar() {
    const path = usePathname();
    const session = getSession();
    const role = session?.user?.role || "GUEST";

    return (
        <aside className="sidebar xg-sidebar">
            <div className="xg-brand">
                <div className="xg-brand-mark">
                    X
                </div>

                <div className="xg-brand-copy">
                    <strong>XaaSGrid</strong>
                    <span>Enterprise Platform</span>
                </div>
            </div>

            <div className="xg-console-label">
                <span className="xg-console-dot" />
                CONTROL PLANE
            </div>

            <div className="sidebar-role xg-role">
                <span>Access level</span>
                <strong>{role}</strong>
            </div>

            <nav className="xg-navigation">
                {menu.map((group) => (
                    <div className="xg-nav-group" key={group.section}>
                        <h5>{group.section}</h5>

                        {group.items.map(([label, href, icon]) => {
                            const active =
                                path === href ||
                                (href !== "/dashboard" &&
                                    path.startsWith(href + "/"));

                            return (
                                <Link
                                    key={href}
                                    href={href}
                                    className={
                                        active
                                            ? "menu-link active-link xg-nav-link xg-nav-active"
                                            : "menu-link xg-nav-link"
                                    }
                                >
                                    <span className="xg-nav-icon">
                                        <Icon type={icon} />
                                    </span>

                                    <span>{label}</span>

                                    {active && (
                                        <span className="xg-nav-indicator" />
                                    )}
                                </Link>
                            );
                        })}
                    </div>
                ))}
            </nav>

            <div className="xg-sidebar-footer">
                <div className="xg-environment">
                    <span className="xg-live-dot" />
                    <div>
                        <strong>Production</strong>
                        <span>Platform online</span>
                    </div>
                </div>

                <div className="xg-version">
                    XaaSGrid Enterprise Console
                    <span>v19.1</span>
                </div>
            </div>
        </aside>
    );
}
