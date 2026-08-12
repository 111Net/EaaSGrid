"use client";

import Sidebar from "./Sidebar";
import Header from "./Header";

export default function AppShell({ children }) {
    return (
        <div className="app-shell xg-shell">
            <Sidebar />

            <div className="workspace xg-workspace">
                <Header />

                <main className="content xg-content">
                    {children}
                </main>
            </div>
        </div>
    );
}
