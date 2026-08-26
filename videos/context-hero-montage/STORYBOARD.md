---
format: 1920x1080
duration: 10.8s
message: "Context keeps the next handoff close as work moves between apps"
arc: Capture → Hold → Place → Return
audience: new Context visitors
mode: autonomous
music: none
---

## Frame 1 — Capture

- status: animated
- src: index.html#capture-layer
- duration: 3.00s
- transition_in: cut
- scene: A Finder item is captured into Context from the menu bar.
- poster: 1.80s
- source: assets/segments/capture.mp4
- timeline_start: 0.00s
- motion_rule: viewport-change

Start inside the action rather than on an idle desktop. Preserve the menu bar and
Notch by cropping from the top edge of the recording.

## Frame 2 — Hold

- status: animated
- src: index.html#hold-layer
- duration: 3.30s
- transition_in: crossfade-0.16s
- scene: The On Screen shelf stays available while work continues in Finder.
- poster: 1.80s
- source: assets/segments/hold.mp4
- timeline_start: 2.50s
- motion_rule: viewport-change

Pre-roll the incoming clip invisibly for 0.10 seconds, then let the shelf
movement carry the fast dissolve beginning at 2.60 seconds.

## Frame 3 — Place

- status: animated
- src: index.html#place-layer
- duration: 3.50s
- transition_in: crossfade-0.16s
- scene: A Finder item is dragged into the Notch Island and accepted.
- poster: 2.10s
- source: assets/segments/place.mp4
- timeline_start: 5.30s
- motion_rule: viewport-change

Keep the actual Notch interaction centered horizontally while retaining the full
menu-bar edge. Pre-roll for 0.10 seconds before the dissolve begins at 5.40.

## Frame 4 — Return

- status: animated
- src: index.html#return-layer
- duration: 2.50s
- transition_in: crossfade-0.16s
- scene: The stored file is returned from Context into the waiting app.
- poster: 1.45s
- source: assets/segments/return.mp4
- loop_source: assets/segments/loop.mp4
- timeline_start: 8.30s
- motion_rule: viewport-change

Complete the handoff without a static end card. Pre-roll the tracked loop segment
invisibly, then dissolve from 10.45–10.61 so the final frame meets the opening
Capture frame with no unrelated desktop jump.
