import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "EaaSGrid | Energy-as-a-Service for Nigeria",
  description:
    "Reliable, managed energy solutions for businesses and organisations across Nigeria.",
  metadataBase: new URL("https://eaas.xaasgrid.com"),
  openGraph: {
    title: "EaaSGrid | Energy-as-a-Service for Nigeria",
    description: "Power designed around your business, delivered as a service.",
    url: "https://eaas.xaasgrid.com",
    siteName: "EaaSGrid EaaS",
    type: "website",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
