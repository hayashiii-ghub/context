import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

async function render(pathname = "/") {
  const workerUrl = new URL("../dist/server/index.js", import.meta.url);
  workerUrl.searchParams.set("test", `${process.pid}-${Date.now()}`);
  const { default: worker } = await import(workerUrl.href);

  return worker.fetch(
    new Request(new URL(pathname, "http://localhost/"), {
      headers: { accept: "text/html" },
    }),
    { ASSETS: { fetch: async () => new Response("Not found", { status: 404 }) } },
    { waitUntil() {}, passThroughOnException() {} },
  );
}

function withoutBreakHints(html) {
  return html
    .replace(/<wbr\s*\/?\s*>/g, "")
    .replace(/<\/?span\b[^>]*>/g, "");
}

test("renders the standalone Context site at the root", async () => {
  const response = await render();
  assert.equal(response.status, 200);
  assert.match(response.headers.get("content-type") ?? "", /^text\/html\b/i);

  const html = await response.text();
  const text = withoutBreakHints(html);

  assert.match(html, /<html lang="en">/);
  assert.match(html, /<title>Context — Keep it close before you need it<\/title>/);
  assert.match(text, /Keep it close/);
  assert.match(text, /From Finder to Context in one shortcut/);
  assert.match(text, /Keep the stack above your work/);
  assert.match(text, /Turn the notch into a drop target/);
  assert.match(text, /Menu Bar stays the default/);
  assert.match(text, /optional Notch Island/);
  assert.match(text, /Local-first, because in-between work is still your work/);
  assert.doesNotMatch(html, /context-workflow\.webp/);
  assert.match(html, /context-capture-poster\.webp/);
  assert.match(html, /context-hold-poster\.webp/);
  assert.match(html, /context-place-poster\.webp/);
  assert.match(html, /context-handoff\.webm/);
  assert.match(html, /context-handoff\.mp4/);
  assert.match(html, /context-handoff-poster\.webp/);
  assert.match(text, /A Finder file is added to the Context menu bar shelf/);
  assert.match(html, /context-mark\.svg/);
  assert.match(html, /property="og:type" content="website"/);
  assert.match(html, /property="og:url" content="https:\/\/context\.haygsiiii\.chatgpt\.site\/"/);
  assert.match(html, /property="og:image" content="https:\/\/context\.haygsiiii\.chatgpt\.site\/context\/context-og\.png"/);
  assert.match(html, /property="og:image:width" content="1200"/);
  assert.match(html, /property="og:image:height" content="630"/);
  assert.match(html, /name="twitter:image" content="https:\/\/context\.haygsiiii\.chatgpt\.site\/context\/context-og\.png"/);
  assert.match(html, /name="twitter:image:alt" content="Context — Keep it close before you need it"/);
  assert.match(html, /rel="icon" href="https:\/\/context\.haygsiiii\.chatgpt\.site\/context\/context-mark\.svg" type="image\/svg\+xml"/);
  assert.doesNotMatch(html, /context-current-icon\.png/);
  assert.match(html, /github\.com\/hayashiii-ghub\/context/);
  assert.match(html, /github\.com\/hayashiii-ghub\/context\/releases/);
  assert.match(html, /releases\/latest\/download\/context-macos\.dmg/);
  assert.match(text, /Open source/);
  assert.match(text, /v0\.2\.0 · macOS 26\+ · Apple Silicon &amp; Intel/);
  assert.match(text, /Context is not yet notarized by Apple/);
  assert.match(text, /Privacy &amp; Security/);
  assert.doesNotMatch(html, /v1\.1\.4|Now becoming Context|Chrome Web Store|CodexIsland/);
});

test("feature demos keep their lightweight formats and lazy playback behavior", async () => {
  const pageSource = await readFile(new URL("../app/page.tsx", import.meta.url), "utf8");
  const demoSource = await readFile(new URL("../app/FeatureDemo.tsx", import.meta.url), "utf8");

  for (const name of ["capture", "hold", "place"]) {
    assert.match(pageSource, new RegExp(`context-${name}\\.webm`));
    assert.match(pageSource, new RegExp(`context-${name}\\.mp4`));
    assert.match(pageSource, new RegExp(`context-${name}-poster\\.webp`));
  }

  assert.match(demoSource, /IntersectionObserver/);
  assert.match(demoSource, /preload="none"/);
  assert.match(demoSource, /prefers-reduced-motion: reduce/);
  assert.match(demoSource, /isInView && !prefersReducedMotion && !isUserPaused/);
  assert.match(demoSource, /setIsUserPaused\(true\)/);
  assert.match(demoSource, /video\.pause\(\)/);
});
