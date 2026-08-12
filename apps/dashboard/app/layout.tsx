import "./globals.css";
import AppShell from "../components/layout/AppShell";

export const metadata = {
    title: "XaaSGrid Enterprise Console",
    description: "Everything-as-a-Service Platform"
};

export default function RootLayout({
    children
}: {
    children: React.ReactNode
}) {
    return (
        <html lang="en">
            <body>
                <AppShell>
                    {children}
                </AppShell>
            </body>
        </html>
    );
}
