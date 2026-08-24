import type { Metadata } from "next";

import "./globals.css";

const title = "Context — Keep it close before you need it";
const description =
  "A small Mac shelf for files, folders, links, images, and text — ready for whatever comes next.";

export const metadata: Metadata = {
  title,
  description,
  icons: {
    icon: "/context/context-current-icon.png",
  },
  openGraph: {
    title,
    description,
    images: ["/context/context-workflow.webp"],
  },
  twitter: {
    card: "summary_large_image",
    title,
    description,
    images: ["/context/context-workflow.webp"],
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
