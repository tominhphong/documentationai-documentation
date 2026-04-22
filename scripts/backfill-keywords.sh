#!/bin/bash
# backfill-keywords.sh
# Add `keywords: [...]` frontmatter to MDX files that are missing it.
# Keywords are inferred from directory + title + known domain terms.
# Usage: bash scripts/backfill-keywords.sh [--dry-run]
# Idempotent: skips files that already have a keywords: line.

set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Directory → base keyword mapping (bash 3 compatible case statement)
dir_keywords() {
  case "$1" in
    01-sales-crm)            echo "sales, crm, pipeline, realtor, lead management" ;;
    02-marketing-content)    echo "marketing, content, social media, realtor, branding" ;;
    03-market-intelligence)  echo "market intelligence, real estate data, dfw, sherman tx, texas" ;;
    04-operations-workflow)  echo "operations, workflow, realtor sop, transaction management" ;;
    05-finance-accounting)   echo "finance, accounting, realtor commission, taxes" ;;
    06-legal-compliance)     echo "legal, compliance, texas real estate, trec, realtor" ;;
    07-client-communication) echo "client communication, relationship, realtor, vietnamese community" ;;
    08-listing-marketing)    echo "listing, seller, marketing, real estate, texas" ;;
    09-buyer-journey)        echo "buyer journey, home buying, vietnamese buyer, texas, dfw" ;;
    10-quality-reviews)      echo "quality review, realtor performance, lessons learned" ;;
    help-center)             echo "help, faq, troubleshooting, starter kit, documentation" ;;
    components)              echo "mdx components, mintlify, documentation, ui patterns" ;;
    *)                       echo "real estate, realtor, knowledge base" ;;
  esac
}

extract_title() {
  grep -m1 -E '^title:' "$1" | sed -E 's/^title: *"?([^"]*)"?.*/\1/' | tr -d '"'
}

already_has_keywords() {
  grep -qE '^keywords:' "$1"
}

build_keywords() {
  local file="$1"
  local rel_path="${file#./}"
  local dir="${rel_path%%/*}"
  local base_kw
  base_kw=$(dir_keywords "$dir")

  # Common terms in every file (Phong branding)
  local phong_kw="phong to realtor, exp realty, dfw, sherman tx"

  # Merge base + Phong (dedup via keeping simple)
  echo "$base_kw, $phong_kw"
}

FILE_COUNT=0
SKIPPED=0
ADDED=0

while IFS= read -r file; do
  FILE_COUNT=$((FILE_COUNT + 1))

  if already_has_keywords "$file"; then
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  kw=$(build_keywords "$file")

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "ADD ($file): keywords: [$kw]"
    ADDED=$((ADDED + 1))
    continue
  fi

  # Insert keywords line before closing --- of frontmatter.
  # Find line number of 2nd '---' (closing frontmatter).
  close_line=$(awk '/^---[[:space:]]*$/{n++; if(n==2){print NR; exit}}' "$file")
  [[ -z "$close_line" ]] && { echo "SKIP (no frontmatter close): $file"; continue; }

  # Build keywords line as YAML array string
  kw_line="keywords: [$kw]"

  # Insert before close_line
  tmp="$(mktemp)"
  awk -v line="$close_line" -v kw="$kw_line" 'NR==line{print kw} {print}' "$file" > "$tmp"
  mv "$tmp" "$file"
  ADDED=$((ADDED + 1))
done < <(find . -name '*.mdx' -not -path './node_modules/*' -not -path './.git/*' -not -path './plans/*')

echo "Processed $FILE_COUNT files: $ADDED keywords added, $SKIPPED already had keywords (dry-run: $DRY_RUN)"
