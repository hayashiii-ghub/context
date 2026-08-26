---
workflow: general-video
flow: automation
storyboard: no
message: "Context keeps the next handoff close as work moves between apps"
destination: website-hero
aspect: 1920x1080
language: en
audience: new Context visitors
length: 10.8s
narration: no
---

## Intent

Create one quiet, polished hero loop from the existing real Context recordings.
The montage should make Capture, Hold, Place, and Return feel like one continuous
workflow rather than a four-clip compilation.

## Assets

- assets/segments/capture.mp4 — Finder selection and shortcut capture beat.
- assets/segments/hold.mp4 — On Screen shelf movement beat.
- assets/segments/place.mp4 — Notch Island drop and confirmation beats.
- assets/segments/return.mp4 — Final return-to-app beat.
- assets/segments/loop.mp4 — Short bridge back to the opening frame.

High-resolution raw takes remain local and are intentionally excluded from Git. Use the reusable capture kit in `../../docs/capture-kit/` when new footage is needed.

## Customizations

- Keep the footage full-frame at 16:9, aligned to the top edge so the menu bar and
  Notch remain visible, with only a restrained maximum 1.02x push-in.
- Use 0.16-second dissolves between the four related actions, with a short hidden
  pre-roll so incoming footage is decoded before it becomes visible.
- Build a deliberate loop handoff instead of leaving a visible end-to-start jump.

## Notes

- Silent: no narration, music, sound effects, captions, or baked-in labels.
- Preserve the authenticity of the real macOS UI; do not invent or redraw product UI.
- The current cut renders from the tracked normalized segments. When preparing a new cut, create those segments from high-resolution raw takes rather than the compressed website delivery files.
- Normalize only the selected raw windows to 1920x1080, constant 30 fps H.264
  intermediates before assembly so browser seeking never exposes a blank frame.
- Build a separate candidate first. Do not replace the current website hero before review.
