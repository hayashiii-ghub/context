# Context

Context is a temporary shelf for macOS. Put down files, folders, links, images,
and text while moving between apps, then drag them into place when the next app
is ready.

Context is free, open source, local-first, and built for macOS 26 or later.

Context starts in the menu bar. From **Shelf Location**, you can keep the shelf
on screen or enable the optional Notch Island on supported Macs.

This repository contains three parts of the product:

- `Sources/Context/` and `Tests/ContextTests/`: the macOS app and its tests
- `site/`: the standalone English product site
- `videos/context-hero-montage/`: the editable source for the website hero video

## Development

Validate the macOS app and its packaging scripts:

```sh
make check
```

Validate the site:

```sh
cd site
npm ci
npm run lint
npm test
```

Validate the HyperFrames hero composition:

```sh
cd videos/context-hero-montage
npm run check
```

## Install

Download the latest
[DMG](https://github.com/hayashiii-ghub/context/releases/latest/download/context-macos.dmg)
or browse [GitHub Releases](https://github.com/hayashiii-ghub/context/releases).

Context is not yet notarized by Apple. macOS may block it the first time you
open it. To continue, open **System Settings → Privacy & Security** and click
**Open Anyway**.

Context uses Finder automation only when you explicitly add the current Finder
selection with `Option + Tab`. It does not use accounts, cloud sync, analytics,
or a hosted work history.

## License

MIT
