import type { Metadata } from "next";

import "./globals.css";

const title = "Context — Keep it close before you need it";
const description =
  "A small Mac shelf for files, folders, links, images, and text — ready for whatever comes next.";

export const metadata: Metadata = {
  metadataBase: new URL("https://context.haygsiiii.chatgpt.site"),
  title,
  description,
  icons: {
    icon: [{ url: "/context/context-mark.svg", type: "image/svg+xml" }],
    shortcut: ["/context/context-mark.svg"],
  },
  openGraph: {
    title,
    description,
    images: [
      {
        url: "/context/context-og.webp",
        width: 1200,
        height: 630,
        alt: "Context — Keep it close before you need it",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title,
    description,
    images: ["/context/context-og.webp"],
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
