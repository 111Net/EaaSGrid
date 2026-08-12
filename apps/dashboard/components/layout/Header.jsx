"use client";

import { getSession, logout } from "../../lib/auth";

function Icon({ children }) {
    return (
        <svg
            viewBox="0 0 24 24"
            width="18"
            height="18"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.8"
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
        >
            {children}
        </svg>
    );
}

export default function Header() {
    const session = getSession();
    const user = session?.user;

    return (
        <header className="header xg-header">
            <div className="xg-header-left">
                <button
                    type="button"
                    className="xg-icon-button"
                    aria-label="Navigation"
                >
                    <Icon>
                        <path d="M4 6h16M4 12h16M4 18h16" />
                    </Icon>
                </button>

                <div className="xg-breadcrumb">
                    <span className="xg-breadcrumb-muted">XaaSGrid</span>
                    <span className="xg-breadcrumb-separator">/</span>
                    <strong>Enterprise Console</strong>
                </div>
            </div>

            <div className="xg-header-right">
                <div className="xg-system-state">
                    <span className="xg-live-dot" />
                    <span>Systems operational</span>
                </div>

                {user?.email && (
                    <div className="xg-user">
                        <div className="xg-avatar">
                            {(user.email[0] || "X").toUpperCase()}
                        </div>

                        <div className="xg-user-copy">
                            <strong>{user.email}</strong>
                            <span>{user.role || "User"}</span>
                        </div>
                    </div>
                )}

                <button
                    type="button"
                    className="xg-signout"
                    onClick={logout}
                >
                    <Icon>
                        <path d="M10 17l5-5-5-5" />
                        <path d="M15 12H3" />
                        <path d="M21 3v18" />
                    </Icon>
                    <span>Sign out</span>
                </button>
            </div>
        </header>
    );
}
