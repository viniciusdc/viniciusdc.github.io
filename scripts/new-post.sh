#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/new-post.sh <title> [tag] [type]
# Called by: make post TITLE="..." TAG="..." TYPE=note|arch|project

TITLE="${1:-}"
TYPE="${3:-note}"

# Default tag is type-aware if not provided
if [[ -n "${2:-}" ]]; then
  TAG="$2"
elif [[ "$TYPE" == arch || "$TYPE" == architecture ]]; then
  TAG="architecture"
elif [[ "$TYPE" == project || "$TYPE" == proj ]]; then
  TAG=""   # projects don't use the tag field; metadata.label takes its place
else
  TAG="field note"
fi

if [[ -z "$TITLE" ]]; then
  echo "usage: make post TITLE=\"my title\" TAG=\"debugging\""
  echo "       make post TITLE=\"my essay\" TYPE=arch"
  echo "       make post TITLE=\"my tool\" TYPE=project"
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
    DEST_DIR="src/pages/writing"
    ;;
  arch|architecture)
    TEMPLATE="src/templates/architecture.mdx"
    TITLE_PLACEHOLDER="The decision or system being described"
    DEST_DIR="src/pages/writing"
    ;;
  project|proj)
    TEMPLATE="src/templates/project.mdx"
    TITLE_PLACEHOLDER="Project name"
    DEST_DIR="src/pages/projects"
    ;;
  *)
    echo "error: TYPE must be 'note', 'arch', or 'project'"
    exit 1
    ;;
esac

DEST="${DEST_DIR}/${SLUG}/index.mdx"

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
# Only notes/architecture have a `tag:` line in their frontmatter
if [[ -n "$TAG" ]]; then
  sed -i '' "s|tag: \"[^\"]*\"|tag: \"${TAG}\"|" "$DEST"
fi

echo ""
echo "  created  ${DEST}"
echo "  title    ${TITLE}"
[[ -n "$TAG" ]] && echo "  tag      ${TAG}"
echo "  date     ${TODAY}"
echo ""
