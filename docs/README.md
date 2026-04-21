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

## Versioning (mike)

The site uses [mike](https://github.com/jimporter/mike) with MkDocs Material’s **`extra.version.provider: mike`**. The **published** docs on `gh-pages` are what populate the version selector; both **1.3.0** and **1.3.1** must be deployed as separate mike versions.

| Item | Role |
|------|------|
| `docs/mkdocs/mike_versions.ini` | **local** / **release** labels (default **1.3.1** for the primary deploy) |
| `docs/mkdocs/mike_ghpages_extra_versions.txt` | Extra mike labels deployed **before** `release` on Pages (e.g. **1.3.0** beside **1.3.1**). CI uses **`task docs:mike:deploy-pages`**. |
| `docs/mkdocs/publish-versioned-docs.sh` | One-shot **push** of **1.3.0** then **1.3.1** (same idea as deploy-pages) |
| `docs/mkdocs/mike_retired_versions.txt` | Versions **removed** from the live dropdown on each deploy (`mike delete` in CI + `delete-retired-mike-versions.sh`) |

**Test both versions locally (no push):** from repo root, after `./docs/install.sh` and `pip install …` / `uv` per table above:

```bash
task docs:mike:deploy-local-versions   # 1.3.0 + 1.3.1 on local gh-pages
task docs:mike:serve
# Open http://127.0.0.1:8000/ and use the version menu.
```

**Push both versions to GitHub Pages** (needs push access to `origin`):

```bash
./docs/mkdocs/publish-versioned-docs.sh
```

Use **`task docs:mike:deploy-pages`** to push what GitHub Pages should show when the menu lists more than one version (extra lines in `mike_ghpages_extra_versions.txt` + `release`). Use **`task docs:mike:deploy`** only when you want a **single** version + `latest` on `gh-pages`.

**404 when choosing a version in the menu:** that label is still listed in mike metadata but was **never deployed** (or the deploy only published `release`). Fix by running **`mike:deploy-pages`** or `./docs/mkdocs/publish-versioned-docs.sh`, or add the missing label to `mike_ghpages_extra_versions.txt` and redeploy.

For other CI or one-off deploys, see `docs/mkdocs/mike_versions.ini` and `docs/Taskfile.yml` (`mike:*` tasks).

## GitHub Pages (live site)

Publishing uses [mike](https://github.com/jimporter/mike): CI pushes built docs to the **`gh-pages`** branch; GitHub Pages serves that branch.

**One-time repository setup**

1. **GitHub repo → Settings → Pages** (under *Code and automation*).
2. **Build and deployment**: Source **Deploy from a branch**.
3. **Branch**: **`gh-pages`** → folder **`/`** (root) → Save.

After the first successful deploy, the site is available at **`https://<owner>.github.io/<repo>/`** ( trailing slash matters for some links). Ensure `site_url` in `mkdocs/mkdocs.yml` matches that URL (for AGNTCY it is `https://agntcy.github.io/slim/`).

**CI workflows**

| Workflow | When |
|----------|------|
| **Deploy GitHub Pages** (`.github/workflows/deploy-github-pages.yml`) | Push to **`main`** or **`docs-migration`** that touches `docs/**` (or this workflow file), or **Actions → Run workflow** manually. Runs **`task docs:mike:deploy-pages`**. |
| **Docs release** (`docs-release.yml`) | Manual **Docs release** workflow: build, mike → `gh-pages`, git tag, optional GitHub Release. |

Local one-shot matching CI: **`task docs:mike:deploy-pages`** (push), or **`./docs/mkdocs/publish-versioned-docs.sh`**.
