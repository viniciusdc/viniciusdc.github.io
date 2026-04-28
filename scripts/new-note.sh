#!/usr/bin/env bash
set -euo pipefail

SLUG="${1:-}"
if [[ -z "$SLUG" ]]; then
  echo "usage: scripts/new-note.sh <slug>"
  echo "  e.g. scripts/new-note.sh k3s-coredns-loop"
  exit 1
fi

DEST="src/pages/notes/${SLUG}/index.astro"

if [[ -f "$DEST" ]]; then
  echo "error: ${DEST} already exists"
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
cp src/templates/note.astro "$DEST"

TODAY=$(date +%Y-%m-%d)
sed -i.bak "s/YYYY-MM-DD/${TODAY}/g" "$DEST" && rm "${DEST}.bak"

echo "created: ${DEST}"
echo "  edit the file, then add it to the note list in src/pages/notes/index.astro"
echo "  and to latestNotes in src/pages/index.astro if it should appear on the homepage"
