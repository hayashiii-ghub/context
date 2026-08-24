import assert from "node:assert/strict";
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
  assert.match(text, /Put it down before the thought moves on/);
  assert.match(text, /On Screen or in the menu bar/);
  assert.match(text, /Local-first, because in-between work is still your work/);
  assert.match(html, /context-workflow\.png/);
  assert.match(html, /context-display-modes\.png/);
  assert.match(html, /context-current-icon\.png/);
  assert.match(html, /github\.com\/hayashiii-ghub\/context/);
  assert.match(html, /github\.com\/hayashiii-ghub\/context\/releases/);
  assert.match(html, /releases\/latest\/download\/context-macos\.dmg/);
  assert.match(text, /Open source/);
  assert.match(text, /v0\.1\.0 · macOS 26\+ · Apple Silicon &amp; Intel/);
  assert.match(text, /Context is not yet notarized by Apple/);
  assert.match(text, /Privacy &amp; Security/);
  assert.doesNotMatch(html, /v1\.1\.4|Now becoming Context|Chrome Web Store|CodexIsland/);
});
