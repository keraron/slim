#!/usr/bin/env bash
# Copy theme CSS and logos into this docs/ tree (MkDocs serves extra_css and theme static files from docs_dir).
# If docs/mkdocs/mkdocs.yml is missing, copies it from mkdocs.starter.yml.
# From repo root: ./docs/install.sh
# Optional: ./docs/install.sh --with-mike-macros  → creates docs/mkdocs/main.py from main.py.example if missing
set -euo pipefail

SHARED_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS="$SHARED_ROOT"
MKDOCS="$DOCS/mkdocs"

mkdir -p "$DOCS/stylesheets" "$DOCS/assets/agntcy/img" "$MKDOCS"
cp -f "$DOCS/stylesheets/custom.css" "$DOCS/stylesheets/agntcy-docs.css"
cp -f "$DOCS/assets/img/"*.svg "$DOCS/assets/agntcy/img/"
if [[ -f "$DOCS/assets/logo.svg" ]]; then
  cp -f "$DOCS/assets/logo.svg" "$DOCS/assets/agntcy/"
fi

echo "Docs theme assets installed under $DOCS (stylesheets/agntcy-docs.css, assets/agntcy/)."

if [[ ! -f "$MKDOCS/mkdocs.yml" ]]; then
  cp -f "$MKDOCS/mkdocs.starter.yml" "$MKDOCS/mkdocs.yml"
  echo "Created $MKDOCS/mkdocs.yml from mkdocs.starter.yml."
else
  echo "Leaving existing $MKDOCS/mkdocs.yml unchanged."
fi

if [[ "${1:-}" == "--with-mike-macros" ]]; then
  if [[ ! -f "$MKDOCS/main.py" ]]; then
    cp -f "$MKDOCS/main.py.example" "$MKDOCS/main.py"
    echo "Created $MKDOCS/main.py from main.py.example"
  else
    echo "Leaving existing $MKDOCS/main.py unchanged."
  fi
fi
