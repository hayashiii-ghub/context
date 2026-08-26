# Context LP media plan

## Goal

Show one complete handoff — from Finder, through Context, into the next app — without making Context look like a notch-only product.

## Media principles

- Menu Bar is the default presentation and leads the story.
- Real screen capture owns every product-behavior claim.
- HyperFrames may compose real UI captures, but must not invent app UI.
- Notch Island is shown as an optional supported-Mac mode.
- Keep the page to one real master take, three focused feature loops, and one return still.
- All website media is silent, loops without reversing product behavior, and has a static fallback.

## Deliverables

| Placement | Claim | Source | Duration | Deliverable |
|---|---|---|---:|---|
| Hero showcase | Context carries an item from Finder into the next app | Real master capture | 9–11s | `context-handoff` video + poster |
| i. capture | Selected items are ready to add without opening another workspace | Real feature capture | 4.1s | `context-capture` video + poster |
| ii. hold | The handoff remains visible without taking over the desktop | Real feature capture | 6.8s | `context-hold` video + poster |
| iii. place | Notch Island is available as an optional drop target | Real feature capture | 8.7s | `context-place` video + poster |
| iv. return | Drag the item into the next app while the original remains untouched | Existing workflow still | Static | `context-workflow.webp` |

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

- Show harmless demo items selected in Finder and ready for Context.
- Keep the interaction readable without baking labels into the video.
- Use the matching WebP frame as the lazy and reduced-motion fallback.

### ii. hold

- Show a real Context shelf holding three harmless dummy items above a still-usable Finder window.
- Let the shelf remain steady long enough to read without competing with the page copy.

### iii. place

- Use a real Finder-to-Notch interaction on a clean demo desktop.
- Sequence: drag one dummy file to Notch Island, show accepted feedback, then expand to confirm the item.
- Keep the surrounding page copy responsible for explaining that Notch Island is optional.

### iv. return

- Keep the existing workflow still because the hero already demonstrates the complete handoff.
- Preserve its source aspect ratio on narrow screens.

## Background

- Canvas: 3024×1964.
- Base: `#111315` family with a subtle cool field and edge vignette.
- No logo, text, pattern, or decorative object.
- Keep the top center slightly lighter so black Menu Bar and Island surfaces remain visible.
- Use the same background asset in real capture and HyperFrames compositions.

## Web delivery

- Video: WebM/VP9 first, MP4/H.264 fallback.
- Poster: WebP.
- Attributes: `autoplay`, `muted`, `loop`, `playsinline`, `preload="none"` for feature loops.
- Insert feature video sources only when their frame approaches the viewport, and pause playback off screen.
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
