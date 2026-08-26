# Context hero montage

This directory contains the editable HyperFrames composition for the 10.8-second silent hero on the Context website.

The tracked `assets/segments/` clips are the approved public demo takes required to render the composition. High-resolution raw recordings stay local under `assets/source/` and are intentionally ignored. Generated renders, media indexes, thumbnails, snapshots, and audit output are ignored as well.

To prepare a new recording, start with [`../../docs/capture-kit/README.md`](../../docs/capture-kit/README.md). To validate or render the current composition:

```sh
npm run check
npm run render
```

The optimized files served by the website live separately under `site/public/context/context-hero.*`.

The project pins HyperFrames 0.8.15. The composition loads GSAP 3.14.2 from jsDelivr during validation and rendering, so those commands require network access.
