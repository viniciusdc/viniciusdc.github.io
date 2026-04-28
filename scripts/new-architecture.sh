#!/usr/bin/env bash
set -euo pipefail

SLUG="${1:-}"
if [[ -z "$SLUG" ]]; then
  echo "usage: scripts/new-architecture.sh <slug>"
  echo "  e.g. scripts/new-architecture.sh operator-ownership-boundaries"
  exit 1
fi

DEST="src/pages/architecture/${SLUG}/index.astro"

if [[ -f "$DEST" ]]; then
  echo "error: ${DEST} already exists"
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
cp src/templates/architecture.astro "$DEST"

TODAY=$(date +%Y-%m-%d)
sed -i.bak "s/YYYY-MM-DD/${TODAY}/g" "$DEST" && rm "${DEST}.bak"

echo "created: ${DEST}"
echo "  edit the file, then add it to the essay list in src/pages/architecture/index.astro"
