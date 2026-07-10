import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

import Navbar from "./components/Navbar";
import Footer from "./components/Footer";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});


export const metadata: Metadata = {
  title: "EaaSGrid Dashboard",
  description:
    "Operational monitoring dashboard for EaaSGrid distributed renewable energy infrastructure, pilot deployments and Energy-as-a-Service performance.",

  keywords: [
    "EaaSGrid",
    "Energy-as-a-Service",
    "Renewable Energy",
    "Solar Infrastructure",
    "Battery Storage",
    "Energy Dashboard",
    "Africa"
  ],

  authors: [
    {
      name: "EaaSGrid Platform Ltd",
    },
  ],

  creator: "EaaSGrid Platform Ltd",
  publisher: "EaaSGrid Platform Ltd",

  robots: {
    index: false,
    follow: false,
  },

  icons: {
    icon: "/favicon.ico",
  },
};


export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {

  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >

      <body className="min-h-full flex flex-col">

        <Navbar />

        <main className="flex-1">
          {children}
        </main>

        <Footer />

      </body>

    </html>
  );
}
