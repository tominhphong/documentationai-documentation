#!/bin/bash
# bump-last-reviewed.sh
# Bump last_reviewed + data_freshness frontmatter to a given date on all MDX files.
# Only touches files already having these fields; does not add them.
# Usage: bash scripts/bump-last-reviewed.sh [YYYY-MM-DD]
# Default: today

set -euo pipefail

TODAY="${1:-$(date +%Y-%m-%d)}"
MONTH="${TODAY%-*}"  # YYYY-MM
SPRINT_TAG="${2:-$MONTH (Sprint 5)}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR"

UPDATED=0
while IFS= read -r file; do
  changed=0
  # Update last_reviewed (only first occurrence within frontmatter block)
  if grep -qE '^last_reviewed:' "$file"; then
    sed -i '' -E "s/^last_reviewed: *\"?[0-9]{4}-[0-9]{2}-[0-9]{2}\"?/last_reviewed: $TODAY/" "$file"
    changed=1
  fi
  # Update data_freshness
  if grep -qE '^data_freshness:' "$file"; then
    sed -i '' -E "s|^data_freshness: *\".*\"|data_freshness: \"$SPRINT_TAG\"|" "$file"
    changed=1
  fi
  [[ $changed -eq 1 ]] && UPDATED=$((UPDATED + 1))
done < <(find . -name '*.mdx' -not -path './node_modules/*' -not -path './.git/*' -not -path './plans/*')

echo "Updated last_reviewed/data_freshness on $UPDATED files (date: $TODAY, tag: $SPRINT_TAG)"
