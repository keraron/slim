#!/usr/bin/env bash
# Build and push two mike versions (1.3.0 and 1.3.1) to branch gh-pages.
# Run from repo root: ./docs/mkdocs/publish-versioned-docs.sh
# Requires: mike, MkDocs deps (pip install -r docs/requirements-agntcy-docs-theme.txt),
#           git remote with push access, and theme assets: ./docs/install.sh --with-mike-macros
#
# For production, check out each product release tag before deploying so docs match releases.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MKDOCS="$ROOT/docs/mkdocs"
cd "$MKDOCS"

"$ROOT/docs/install.sh" --with-mike-macros
git fetch origin gh-pages --depth=1 2>/dev/null || true

if [[ -f uv.lock ]] || [[ -f pyproject.toml ]]; then
  UV=(uv run)
else
  UV=()
fi

# Older version first; 1.3.1 gets the `latest` alias (Material default in selector).
"${UV[@]}" mike deploy --push 1.3.0
"${UV[@]}" mike deploy --push --update-aliases 1.3.1 latest
"${UV[@]}" mike set-default --push 1.3.1
"${UV[@]}" mike list

echo "Done. GitHub Pages should list 1.3.0, 1.3.1, and latest → 1.3.1."
