# Context LP media plan

## Goal

Show one complete handoff — from Finder, through Context, into the next app — without making Context look like a notch-only product.

## Media principles

- Menu Bar is the default presentation and leads the story.
- Real screen capture owns every product-behavior claim.
- HyperFrames may compose real UI captures, but must not invent app UI.
- Notch Island is shown as an optional supported-Mac mode.
- Keep the page to one real master take, one composed display-mode loop, and one still image.
- All website media is silent, loops without reversing product behavior, and has a static fallback.

## Deliverables

| Placement | Claim | Source | Duration | Deliverable |
|---|---|---|---:|---|
| Hero showcase | Context carries an item from Finder into the next app | Real master capture | 9–11s | `context-handoff` video + poster |
| i. capture | One shortcut puts the selected item down | Cut from hero master | 3.5–4s | `context-capture` loop |
| ii. hold | The handoff remains visible without taking over the desktop | Real still capture | Static | `context-hold` WebP |
| iii. place | Menu Bar by default; On Screen and Notch Island when wanted | HyperFrames composition using real captures | 5.5–6s | `context-display-modes` loop + poster |
| iv. return | Drag the item into the next app while the original remains untouched | Cut from hero master | 3.5–4s | `context-return` loop |

## Hero master shot

### Setup

- Native capture: 3024×1964, 30 fps.
- Website master: 1920×1080; delivery: 1600×900.
- Use the dedicated dark graphite Context demo background.
- Finder and a local Safari `Project Draft` drop target are visible; Dock, desktop icons, and notifications are hidden.
- The Safari target is an offline demo page with no network requests or personal data.
- Use only the dummy files in `Context Demo`.
- Context starts in Menu Bar mode with an empty shelf.

### Action

1. Hold the clean start frame for about 0.8 seconds.
2. Select `Product brief.md` in Finder.
3. Press Option + Tab.
4. Let the Menu Bar shelf open and visibly show one item.
5. Drag `Product brief.md` from Context into the Safari drop target.
6. Hold the completed handoff for about 0.8 seconds.
7. Return to the start plate with a short dissolve; never reverse the UI action.

### Crop safety

- Keep Finder, the Menu Bar shelf, and the Safari drop target legible inside a mobile-safe center crop.
- Keep the pointer away from product labels during holds.
- Desaturate or soften unrelated menu bar items during post-production, while preserving Context itself.

## Feature assets

### i. capture

- Reuse the hero segment from the Finder selection through the shelf showing one item.
- Hold the accepted state for about 0.6 seconds, then dissolve to the start plate.
- Mobile fallback: the accepted-state poster with a small `Option + Tab` treatment in HTML, not baked into the image.

### ii. hold

- Capture one real On Screen shelf with three harmless dummy items over a still-usable Finder or Safari window.
- No animation is required. This quiet frame prevents every section from competing for attention.

### iii. place

- Use HyperFrames only for this comparison.
- Sequence: Menu Bar (~2.0s) → On Screen (~1.6s) → Notch Island (~1.2s) → Menu Bar (~0.8s).
- Add `OPTIONAL · SUPPORTED MACS` as live site copy or a HyperFrames label for Notch Island.
- Menu Bar remains the largest and first state.
- Every visible mode is sourced from a real Context capture.

### iv. return

- Reuse the hero segment from the shelf drag through the completed drop.
- Show the source item still present in Finder so the non-destructive behavior is visually credible.
- Hold the result, then dissolve to the start plate.

## Background

- Canvas: 3024×1964.
- Base: `#111315` family with a subtle cool field and edge vignette.
- No logo, text, pattern, or decorative object.
- Keep the top center slightly lighter so black Menu Bar and Island surfaces remain visible.
- Use the same background asset in real capture and HyperFrames compositions.

## Web delivery

- Video: WebM/VP9 first, MP4/H.264 fallback.
- Poster: WebP.
- Attributes: `autoplay`, `muted`, `loop`, `playsinline`, `preload="metadata"`.
- `prefers-reduced-motion`: show the poster instead of autoplaying.
- Target hero file size: at most 1.5 MB per format.
- Target feature loop size: at most 400 KB per format.
- Never use a GIF for the final Context loops.

## Review gates

1. Approve this media plan before recording.
2. Review a contact sheet and raw master before any HyperFrames work.
3. Review standalone MP4/WebM/poster candidates before site integration.
4. Review the local desktop and mobile LP before publication.
5. Publish only after explicit approval, then verify the cache-bypassed live page.
