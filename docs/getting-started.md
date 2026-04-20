# Getting started

The hands-on guide is **[Getting Started (Slim)](slim/slim-howto.md)** — install, build, run the data plane, and try the bindings.

For architecture and components, read **[Overview](slim/overview.md)** and the **[configuration reference](slim/slim-data-plane-config.md)**.

## Build this documentation site locally

From the repository root:

```bash
chmod +x docs/install.sh
./docs/install.sh
python3 -m pip install -r docs/requirements-agntcy-docs-theme.txt
task docs:run
```

Or build static HTML under `.build/site`:

```bash
task docs:build
```

See `docs/README.md` in the repository for layout and tooling.
