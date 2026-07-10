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
  title: "EaaSGrid Investor Portal",
  description:
    "EaaSGrid delivers distributed renewable energy infrastructure through an Energy-as-a-Service business model for businesses, institutions and communities across Africa.",
  keywords: [
    "EaaSGrid",
    "Energy-as-a-Service",
    "Renewable Energy",
    "Distributed Energy Infrastructure",
    "Africa",
    "Nigeria"
  ],
  authors: [
    {
      name: "EaaSGrid Platform Ltd",
    },
  ],
  creator: "EaaSGrid Platform Ltd",
  publisher: "EaaSGrid Platform Ltd",
  robots: {
    index: true,
    follow: true,
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
