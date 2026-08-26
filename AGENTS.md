# Repository guide

This repository contains the standalone Context product for macOS.

## Project map

- `Sources/Context/` and `Tests/ContextTests/`: the macOS app and its Swift tests. `Package.swift`, the root `Makefile`, `Assets/`, and `script/` belong to the app.
- `site/`: the standalone English product site, built with Next.js/vinext and deployed through a Cloudflare Worker.
- `videos/context-hero-montage/`: the editable HyperFrames source for the website hero. Follow its nested `AGENTS.md` when working there.

User-facing product copy should use `Context`.

## Validation

- macOS app: `make check`
- website: from `site/`, run `npm run lint` and `npm test`
- hero video: from `videos/context-hero-montage/`, run `npm run check`

## Working conventions

- Keep app and site changes scoped unless a cross-product release or brand change is explicitly required.
- Do not edit generated or dependency directories such as `.build/`, `node_modules/`, `dist/`, `.vinext/`, or `.wrangler/`.
- Reuse existing scripts and package commands instead of duplicating build or release logic.
