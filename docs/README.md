# Slim documentation site (MkDocs Material)

Everything needed to build and lint the site lives under this `docs/` directory:

| Path | Purpose |
|------|---------|
| `index.md`, `slim/*.md`, … | Page content |
| **`docs/.index`** | **Single** navigation file for the left sidebar (`nav:`). Paths are relative to `docs/` (e.g. `slim/overview.md`). Loaded by `mkdocs/hooks.py`. |
| `mkdocs/mkdocs.yml` | MkDocs configuration (`mkdocs.starter.yml` / `mkdocs.template.yml` are templates) |
| `mkdocs/overrides/` | Material theme partials (logo, copyright) |
| `mkdocs/hooks.py` | SSL for `include-markdown` (uses `certifi`) |
| `stylesheets/custom.css` | Source CSS; `install.sh` copies to `agntcy-docs.css` |
| `assets/` | Source logos (`img/`, `logo.svg`); copied into `assets/agntcy/` for the live site |
| `install.sh` | Syncs CSS and logos; creates `mkdocs/mkdocs.yml` from `mkdocs.starter.yml` if missing |
| `Taskfile.yml` | `build`, `run`, `lint`, mike helpers |
| `requirements-agntcy-docs-*.txt` | Python dependencies for build and lint |
| `codespellrc`, `pymarkdown.yaml`, `lychee.toml` | Lint configuration |

CI workflows under `.github/workflows/` run `./docs/install.sh`, install requirements from `docs/requirements-agntcy-docs-theme.txt`, and `task -t docs/Taskfile.yml build`.

## Commands (repository root)

```bash
chmod +x docs/install.sh
./docs/install.sh
./docs/install.sh --with-mike-macros   # optional: create docs/mkdocs/main.py from main.py.example
python3 -m pip install -r docs/requirements-agntcy-docs-theme.txt
task docs:run        # mkdocs serve
task docs:build      # → ../.build/site
task docs:lint       # needs codespell, pymarkdown, lychee on PATH unless using uv in docs/mkdocs
```

Manual serve from `docs/mkdocs/`:

```bash
cd docs/mkdocs && mkdocs serve
```

For versioned GitHub Pages deploys, see `docs/mkdocs/mike_versions.ini` and the `docs:deploy` / `mike:*` tasks in `Taskfile.yml`.
