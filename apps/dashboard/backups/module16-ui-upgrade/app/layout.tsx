import "./globals.css";

export const metadata = {
  title: "EaaSGrid Platform",
  description: "Everything as a Service Platform",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {

  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );

}
