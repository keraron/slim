#!/usr/bin/env bash
# Remove versions listed in mike_retired_versions.txt from the mike/gh-pages history.
# Syncs local gh-pages to origin/gh-pages first so deletes match what GitHub Pages serves.
#
# Usage from repo root:
#   ./docs/mkdocs/delete-retired-mike-versions.sh
#   ./docs/mkdocs/delete-retired-mike-versions.sh --push
#
# Or from this directory (docs/mkdocs):
#   ./delete-retired-mike-versions.sh --push
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MKDOCS="$SCRIPT_DIR"
FILE="$MKDOCS/mike_retired_versions.txt"
cd "$MKDOCS"

if [[ ! -f "$FILE" ]]; then
  echo "No $FILE; nothing to do."
  exit 0
fi

if ! grep -v '^[[:space:]]*#' "$FILE" | grep -v '^[[:space:]]*$' | grep -q .; then
  echo "No retired versions listed in $FILE."
  exit 0
fi

# Match local gh-pages to origin (so mike sees the same versions as GitHub Pages).
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git fetch origin gh-pages --depth=1 2>/dev/null || true
  if git show-ref --verify --quiet refs/remotes/origin/gh-pages 2>/dev/null; then
    git branch -f gh-pages refs/remotes/origin/gh-pages 2>/dev/null || \
      git update-ref refs/heads/gh-pages refs/remotes/origin/gh-pages 2>/dev/null || true
  fi
fi

mike_list_raw="$(mike list 2>/dev/null || true)"

# First column of mike list is the version id (exact match; avoid grep regex issues with dots).
listed() {
  local ver="$1"
  echo "$mike_list_raw" | awk -v ver="$ver" 'NF >= 1 && $1 == ver { exit 0 } END { exit 1 }'
}

do_delete() {
  local v="$1"
  if listed "$v"; then
    if [[ "${2:-}" == "--push" ]]; then
      mike delete "$v" --push
    else
      mike delete "$v"
    fi
  else
    echo "Skip $v (not in mike list — already removed or not on gh-pages)."
  fi
}

PUSH_FLAG="${1:-}"
while read -r v; do
  [[ -z "$v" ]] && continue
  do_delete "$v" "$PUSH_FLAG"
done < <(grep -v '^[[:space:]]*#' "$FILE" | grep -v '^[[:space:]]*$')

echo "Done."
