#!/usr/bin/env bash
# Copy theme CSS and logos into this docs/ tree (MkDocs serves extra_css and theme static files from docs_dir).
# Bootstraps docs/mkdocs/mkdocs.yml from mkdocs.starter.yml and stub pages when those files are missing.
# From repo root: ./docs/install.sh
# Optional: ./docs/install.sh --with-mike-macros  → creates docs/mkdocs/main.py from main.py.example if missing
set -euo pipefail

SHARED_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS="$SHARED_ROOT"
MKDOCS="$DOCS/mkdocs"

mkdir -p "$DOCS/stylesheets" "$DOCS/assets/agntcy/img" "$MKDOCS"
cp -f "$DOCS/stylesheets/custom.css" "$DOCS/stylesheets/agntcy-docs.css"
if [[ -f "$DOCS/assets/favicon.ico" ]]; then
  cp -f "$DOCS/assets/favicon.ico" "$DOCS/assets/agntcy/"
fi
cp -f "$DOCS/assets/img/"*.svg "$DOCS/assets/agntcy/img/"
if [[ -f "$DOCS/assets/logo.svg" ]]; then
  cp -f "$DOCS/assets/logo.svg" "$DOCS/assets/agntcy/"
fi

echo "Docs theme assets installed under $DOCS (stylesheets/agntcy-docs.css, assets/agntcy/)."

created_mkdocs=0
if [[ ! -f "$MKDOCS/mkdocs.yml" ]]; then
  cp -f "$MKDOCS/mkdocs.starter.yml" "$MKDOCS/mkdocs.yml"
  created_mkdocs=1
  echo "Created $MKDOCS/mkdocs.yml from mkdocs.starter.yml."
else
  echo "Leaving existing $MKDOCS/mkdocs.yml unchanged."
fi

if [[ "$created_mkdocs" -eq 1 ]]; then
  if [[ ! -f "$DOCS/index.md" ]]; then
    cp -f "$DOCS/docs-stub/index.md" "$DOCS/index.md"
    echo "Created $DOCS/index.md (placeholder)."
  else
    echo "Leaving existing $DOCS/index.md unchanged."
  fi
  if [[ ! -f "$DOCS/getting-started.md" ]]; then
    cp -f "$DOCS/docs-stub/getting-started.md" "$DOCS/getting-started.md"
    echo "Created $DOCS/getting-started.md (placeholder)."
  else
    echo "Leaving existing $DOCS/getting-started.md unchanged."
  fi
fi

if [[ "${1:-}" == "--with-mike-macros" ]]; then
  if [[ ! -f "$MKDOCS/main.py" ]]; then
    cp -f "$MKDOCS/main.py.example" "$MKDOCS/main.py"
    echo "Created $MKDOCS/main.py from main.py.example"
  else
    echo "Leaving existing $MKDOCS/main.py unchanged."
  fi
fi
