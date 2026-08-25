import Image from "next/image";

import ContextDemo from "./ContextDemo";
import styles from "./context.module.css";

const repositoryUrl = "https://github.com/hayashiii-ghub/context";
const releasesUrl = `${repositoryUrl}/releases`;
const downloadUrl = `${repositoryUrl}/releases/latest/download/context-macos.dmg`;

const features = [
  {
    index: "i. capture",
    title: "Put it down before the thought moves on.",
    body: "Select something in Finder and press Option + Tab, or drag it in. Files, folders, links, images, and text all land on the same small shelf.",
    image: "/context/context-workflow.webp",
    width: 1716,
    height: 916,
    alt: "A file moving from Finder into Context and then into another Mac app",
    className: styles.workflowCrop,
  },
  {
    index: "ii. hold",
    title: "A Mac utility, not another window.",
    body: "Context stays above your work without turning into a workspace of its own. It keeps the handoff visible and the rest of your desktop usable.",
    image: "/context/context-display-modes.webp",
    width: 1782,
    height: 883,
    alt: "Context floating above a macOS desktop in On Screen mode",
    className: styles.onScreenCrop,
  },
  {
    index: "iii. place",
    title: "Menu bar by default. More when you want it.",
    body: "Context starts tucked into the menu bar. Keep the shelf on screen for longer handoffs, or enable the optional Notch Island on supported Macs.",
    image: "/context/context-display-modes.webp",
    width: 1782,
    height: 883,
    alt: "Context open from the macOS menu bar",
    className: styles.menuBarCrop,
  },
  {
    index: "iv. return",
    title: "Drag it back when the next place is ready.",
    body: "Take one item or a stack and drop it into the app, folder, message, or document that needs it. The originals stay exactly where they were.",
    image: "/context/context-workflow.webp",
    width: 1716,
    height: 916,
    alt: "Items leaving the Context shelf for another application",
    className: styles.returnCrop,
  },
];

const faqs = [
  ["What problem is Context solving?", "Small handoffs break focus. Context keeps the files, folders, links, images, and text you are about to use in one temporary shelf, ready for the next app."],
  ["What can I put on the shelf?", "Files, folders, images, URLs, and text. Finder selections can also be added with Option + Tab."],
  ["Does Context copy my files?", "Items added from Finder remain references to their originals. Data received directly from another app may be stored temporarily in Context's local working area."],
  ["Does removing an item delete the original?", "No. Removing something from the shelf does not remove the original file from its location."],
  ["What happens when I quit Context?", "The shelf and Context-managed temporary copies are cleared. Only your chosen display mode is remembered."],
  ["Does Context upload anything?", "No. There is no Context account, cloud sync, analytics SDK, or hosted work history. The shelf stays on your Mac."],
  ["Does it work on a Mac without a notch?", "Yes. The menu bar shelf is the default, On Screen remains available, and Notch Island is an optional display mode on supported Macs."],
  ["Can I use it on Intel Macs?", "Yes. The current universal build supports both Apple Silicon and Intel Macs running macOS 26 or later."],
];

export default function ContextPage() {
  return (
    <div className={styles.page} lang="en">
      <a className={styles.skipLink} href="#content">Skip to content</a>

      <nav className={styles.navPill} aria-label="Primary">
        <a className={styles.brand} href="#top">
          <Image src="/context/context-mark.svg" width={20} height={20} alt="" unoptimized />
          <span>Context</span>
        </a>
        <a className={styles.navHow} href="#how">How it works</a>
        <a href="#install">Install</a>
        <a href={repositoryUrl}>GitHub</a>
      </nav>

      <main id="content">
        <section className={styles.hero} id="top" aria-labelledby="context-title">
          <a className={styles.releaseChip} href={repositoryUrl}>
            <span>Open source</span>
            <span>Built for macOS</span>
          </a>
          <h1 id="context-title">Keep it close<br />before you need it.</h1>
          <p className={styles.heroSubtitle}>
            Context keeps files, folders, links, images, and text on a small Mac shelf, so you can move between apps without losing the next thing you need.
          </p>
          <div className={styles.heroActions}>
            <a className={`${styles.button} ${styles.buttonPrimary}`} href="#install">Install</a>
            <a className={`${styles.button} ${styles.buttonSecondary}`} href={repositoryUrl}>View on GitHub</a>
          </div>
          <p className={styles.heroMeta}>Free · Open source · local-first · macOS</p>
        </section>

        <section className={styles.showcaseSection} aria-label="Context in motion">
          <div className={styles.showcase}>
            <div className={styles.showcaseFrame}>
              <ContextDemo />
            </div>
          </div>
        </section>

        <section className={`${styles.section} ${styles.features}`} id="how" aria-label="How Context works">
          {features.map((feature, index) => (
            <article className={`${styles.featureRow} ${index % 2 ? styles.flip : ""}`} key={feature.index}>
              <div className={styles.featureCopy}>
                <p className={styles.eyebrow}>— {feature.index}</p>
                <h2>{feature.title}</h2>
                <p>{feature.body}</p>
              </div>
              <div className={`${styles.featureVisual} ${feature.className}`}>
                <Image
                  src={feature.image}
                  width={feature.width}
                  height={feature.height}
                  unoptimized
                  alt={feature.alt}
                  sizes="(max-width: 900px) calc(100vw - 48px), 542px"
                />
              </div>
            </article>
          ))}
        </section>

        <section className={`${styles.section} ${styles.privacy}`} aria-labelledby="privacy-title">
          <div className={styles.sectionNarrow}>
            <p className={styles.eyebrow}>— Privacy</p>
            <h2 id="privacy-title">Local-first, because in-between work is still your work.</h2>
            <ul className={styles.privacyMarks} aria-label="What Context does not do">
              <li>No Context account</li>
              <li>No cloud sync</li>
              <li>No app telemetry</li>
              <li>No work history</li>
            </ul>
            <p className={styles.centerCopy}>
              Context holds the current shelf in memory and clears it when the app quits. It does not send your files, clipboard contents, or shelf activity anywhere.
            </p>
          </div>
        </section>

        <section className={`${styles.section} ${styles.installSection}`} id="install" aria-labelledby="install-title">
          <div className={styles.sectionNarrow}>
            <p className={styles.eyebrow}>— Install</p>
            <h2 id="install-title">One DMG. Then drag to Applications.</h2>
            <p className={styles.centerCopy}>Download Context, open the DMG, then drag the app to Applications.</p>
            <div className={styles.installBar}>
              <div className={styles.installName}>
                <Image src="/context/context-mark.svg" width={40} height={40} alt="Context mark" unoptimized />
                <span>Context for macOS</span>
              </div>
              <a className={`${styles.button} ${styles.buttonPrimary}`} href={downloadUrl}>Download for macOS</a>
            </div>
            <p className={styles.installMeta}>v0.2.0 · macOS 26+ · Apple Silicon &amp; Intel</p>
            <p className={styles.installNote}>
              Context is not yet notarized by Apple. macOS may block it the first time you open it. To continue, open System Settings → Privacy &amp; Security and click “Open Anyway.”
            </p>
          </div>
        </section>

        <section className={`${styles.section} ${styles.faq}`} aria-labelledby="faq-title">
          <div className={styles.sectionNarrow}>
            <p className={styles.eyebrow}>— FAQ</p>
            <h2 id="faq-title">Questions, answered honestly.</h2>
            <div className={styles.faqList}>
              {faqs.map(([question, answer]) => (
                <details className={styles.faqItem} key={question}>
                  <summary>{question}</summary>
                  <p>{answer}</p>
                </details>
              ))}
            </div>
          </div>
        </section>

        <section className={styles.finalCta} aria-labelledby="final-title">
          <h2 id="final-title">Keep it close before you need it.</h2>
          <div className={styles.heroActions}>
            <a className={`${styles.button} ${styles.buttonPrimary}`} href={downloadUrl}>Download for macOS</a>
            <a className={`${styles.button} ${styles.buttonSecondary}`} href={repositoryUrl}>View on GitHub</a>
          </div>
        </section>
      </main>

      <footer className={styles.footer}>
        <div className={styles.footerMeta}>
          <Image src="/context/context-mark.svg" width={20} height={20} alt="" unoptimized />
          <span>Context</span><span className={styles.dot} /><span>Open source</span>
        </div>
        <div className={styles.footerLinks}>
          <a href={repositoryUrl}>GitHub</a>
          <a href={releasesUrl}>Releases</a>
          <a href={`${repositoryUrl}/issues`}>Issues</a>
        </div>
      </footer>
    </div>
  );
}
