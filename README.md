# Context

Context is a temporary shelf for macOS. Put down files, folders, links, images,
and text while moving between apps, then drag them into place when the next app
is ready.

Context is free, open source, local-first, and built for macOS 26 or later.

This repository contains two parts of the product:

- `Sources/Context/` and `Tests/ContextTests/`: the macOS app and its tests
- `site/`: the standalone English product site

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

## Install

The first public build will be published on
[GitHub Releases](https://github.com/hayashiii-ghub/context/releases). Until
then, build the app locally:

```sh
make package VERSION=v0.1.0
```

Context uses Finder automation only when you explicitly add the current Finder
selection with `Option + Tab`. It does not use accounts, cloud sync, analytics,
or a hosted work history.

## License

MIT
