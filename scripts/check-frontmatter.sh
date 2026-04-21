#!/usr/bin/env bash
set -euo pipefail

# check-frontmatter.sh — validate MDX frontmatter requirements
# Checks: title (3-80 chars), description (50-200 chars), last_reviewed (YYYY-MM-DD)
# Usage: bash scripts/check-frontmatter.sh [dir]

SCAN_DIR="${1:-.}"
has_error=0
checked=0

while IFS= read -r -d '' file; do
  checked=$((checked+1))
  # Skip node_modules and .git
  case "$file" in
    */node_modules/*|*/.git/*) continue ;;
  esac

  # Extract frontmatter (between first --- and second ---)
  # Use || true on grep to avoid pipefail when field missing
  frontmatter=$(awk '/^---$/{flag++; next} flag==1' "$file" | head -n 20)

  title=$(echo "$frontmatter" | grep -E '^title:' | head -1 | sed 's/^title: *//' | sed 's/^"//;s/"$//' || true)
  description=$(echo "$frontmatter" | grep -E '^description:' | head -1 | sed 's/^description: *//' | sed 's/^"//;s/"$//' || true)
  last_reviewed=$(echo "$frontmatter" | grep -E '^last_reviewed:' | head -1 | sed 's/^last_reviewed: *//' | sed 's/^"//;s/"$//' || true)

  # Validate title length 3-80 (use [[ ]] to avoid set -e triggering on (( )) exit 1)
  if [[ -z "$title" ]]; then
    echo "MISSING title: $file"; has_error=1
  elif [[ ${#title} -lt 3 || ${#title} -gt 80 ]]; then
    echo "TITLE LENGTH (${#title}, need 3-80): $file"; has_error=1
  fi

  # Validate description length 50-200
  if [[ -z "$description" ]]; then
    echo "MISSING description: $file"; has_error=1
  elif [[ ${#description} -lt 50 || ${#description} -gt 200 ]]; then
    echo "DESC LENGTH (${#description}, need 50-200): $file"; has_error=1
  fi

  # Validate last_reviewed format YYYY-MM-DD
  if [[ -z "$last_reviewed" ]]; then
    echo "MISSING last_reviewed: $file"; has_error=1
  elif [[ ! "$last_reviewed" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "BAD last_reviewed format ($last_reviewed): $file"; has_error=1
  fi
done < <(find "$SCAN_DIR" -name "*.mdx" -print0)

echo ""
echo "=== Summary ==="
echo "Checked $checked MDX files"
if [[ $has_error -eq 0 ]]; then
  echo "ALL FRONTMATTER VALID"
  exit 0
else
  echo "FAIL — fix issues above"
  exit 1
fi
