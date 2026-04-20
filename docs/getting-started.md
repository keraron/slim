# Getting started

Use this page for onboarding material (install, first message, cluster layout).

For the canonical guides today, see:

- [Slim how-to (docs.agntcy.org)](https://docs.agntcy.org/slim/slim-howto)
- [Overview — components and architecture](https://docs.agntcy.org/slim/overview/)

## Build this site locally

From the repository root (Python 3 with `pip`):

```bash
chmod +x docs/install.sh
./docs/install.sh
python3 -m pip install -r docs/requirements-agntcy-docs-theme.txt
task docs:run
```

Or build a static copy under `.build/site`:

```bash
task docs:build
```

See `docs/README.md` in the repository for layout, linting, and GitHub Pages (mike).
