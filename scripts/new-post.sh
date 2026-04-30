#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/new-post.sh <title> [tag] [type]
# Called by: make post TITLE="..." TAG="..." TYPE=note|arch

TITLE="${1:-}"
TYPE="${3:-note}"

# Default tag is type-aware if not provided
if [[ -n "${2:-}" ]]; then
  TAG="$2"
elif [[ "$TYPE" == arch || "$TYPE" == architecture ]]; then
  TAG="architecture"
else
  TAG="field note"
fi

if [[ -z "$TITLE" ]]; then
  echo "usage: make post TITLE=\"my title\" TAG=\"debugging\""
  echo "       make post TITLE=\"my essay\" TAG=\"architecture\" TYPE=arch"
  exit 1
fi

# Derive slug: lowercase, strip non-alphanumeric, collapse hyphens
SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9 ]//g' \
  | tr ' ' '-' \
  | sed 's/-\{2,\}/-/g; s/^-//; s/-$//')

case "$TYPE" in
  note)
    TEMPLATE="src/templates/note.mdx"
    TITLE_PLACEHOLDER="Short, specific title describing the exact problem"
    ;;
  arch|architecture)
    TEMPLATE="src/templates/architecture.mdx"
    TITLE_PLACEHOLDER="The decision or system being described"
    ;;
  *)
    echo "error: TYPE must be 'note' or 'arch'"
    exit 1
    ;;
esac

DEST="src/pages/writing/${SLUG}/index.mdx"

if [[ -f "$DEST" ]]; then
  echo "error: ${DEST} already exists"
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
cp "$TEMPLATE" "$DEST"

TODAY=$(date +%Y-%m-%d)

# Substitute placeholders (macOS-compatible sed with no backup extension)
sed -i '' "s|${TITLE_PLACEHOLDER}|${TITLE}|g" "$DEST"
sed -i '' "s/YYYY-MM-DD/${TODAY}/" "$DEST"
sed -i '' "s|tag: \"[^\"]*\"|tag: \"${TAG}\"|" "$DEST"

echo ""
echo "  created  ${DEST}"
echo "  title    ${TITLE}"
echo "  tag      ${TAG}"
echo "  date     ${TODAY}"
echo ""
