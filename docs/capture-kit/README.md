# Context capture kit

This folder keeps the small, reusable pieces needed to record Context product demos without preserving a dedicated recording desktop.

The published, compressed demo videos stay in `site/public/context/`. Raw recordings are intentionally excluded from Git.

## Contents

- `context-demo-background.png` and `.svg`: the neutral recording wallpaper at 3024 × 1964.
- `demo-files/`: fictional files that are safe to show in public recordings.
- `local-drop-target.html`: an offline visual drop target for handoff shots. It is not a product verification tool.
- `scripts/`: coordinate-specific macOS helpers used during the original recording session.

## Before recording

1. Create or reuse a clean macOS Space with no unrelated or private windows.
2. Set `context-demo-background.png` as the wallpaper for that Space.
3. In System Settings → Desktop & Dock, move the Dock to the **bottom** and enable **Automatically hide and show the Dock**.
4. Hide notifications and close unrelated apps, Finder windows, and desktop items.
5. Use the Menu Bar shelf as the default product presentation. Enable Notch Island only for the demo that specifically introduces it.
6. Copy `demo-files/` to a temporary folder and record with those fictional files only.

## Recording and export

- Capture the 3024 × 1964 display at 30 fps.
- Compose or crop to 1920 × 1080, then deliver 1600 × 900 MP4, WebM, and poster assets.
- Keep the full 16:9 frame on narrow screens; the site should scale it without cropping.
- Review every take for notifications, private content, unexpected Finder windows, and cursor mistakes before publishing.

The Swift helpers post synthetic pointer and keyboard events. Their coordinates were tuned for a 3024 × 1964 display and may not match another setup. Inspect them before use, and grant Accessibility or Screen Recording access only when macOS requests it for the tool you intentionally run.

`local-drop-target.html` runs locally and does not make network requests. Its visual attached state is useful for composition, but browser drop acceptance was not used to verify Context behavior.

## After recording

Return the Mac to the state that existed before this recording setup:

1. Move the Dock back to the **right** and keep **Automatically hide and show the Dock** enabled.
2. Keep recent applications hidden in the Dock.
3. Restore the built-in **Macintosh** wallpaper.
4. Restore Focus and notification settings to their previous values.
5. Close the clean recording Space after confirming it contains no needed windows.
6. Remove temporary copies of the demo files, background, previews, caches, and intermediate exports.

## Recording cautions

- Keep only the intended `Context Demo` Finder window in frame.
- Do not drag shelf content back into the same `Context Demo` folder if Finder asks to replace `Brand assets`.
- Avoid touching the physical top edge while dragging to Notch Island; macOS may open Mission Control.
- Treat the scripts as optional capture helpers, not automated product tests.
