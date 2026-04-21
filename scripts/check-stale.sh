#!/usr/bin/env bash
set -euo pipefail

# check-stale.sh — report MDX pages with last_reviewed > N days ago
# Usage: bash scripts/check-stale.sh [--threshold N] [dir]
# Default threshold: 30 days
# Default dir: .
# macOS (BSD date): uses date -j -f "%Y-%m-%d"

THRESHOLD=30
SCAN_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --threshold) THRESHOLD=$2; shift 2 ;;
    *) SCAN_DIR=$1; shift ;;
  esac
done

today_epoch=$(date +%s)
threshold_seconds=$((THRESHOLD * 86400))
stale_count=0
fresh_count=0
no_date_count=0

echo "Scanning $SCAN_DIR for pages with last_reviewed > $THRESHOLD days ago..."
echo ""

while IFS= read -r -d '' file; do
  case "$file" in
    */node_modules/*|*/.git/*) continue ;;
  esac

  last_reviewed=$(grep -E '^last_reviewed:' "$file" | head -1 | sed 's/^last_reviewed: *//' | sed 's/"//g' | tr -d ' ' || true)

  if [[ -z "$last_reviewed" ]]; then
    no_date_count=$((no_date_count+1))
    continue
  fi

  # Parse date YYYY-MM-DD — BSD date on macOS
  reviewed_epoch=$(date -j -f "%Y-%m-%d" "$last_reviewed" "+%s" 2>/dev/null || echo 0)

  if [[ "$reviewed_epoch" -eq 0 ]]; then
    echo "BAD_DATE: $file (last_reviewed=$last_reviewed)"
    continue
  fi

  age_seconds=$((today_epoch - reviewed_epoch))
  age_days=$((age_seconds / 86400))

  if [[ $age_seconds -gt $threshold_seconds ]]; then
    echo "STALE ($age_days days): $file"
    stale_count=$((stale_count+1))
  else
    fresh_count=$((fresh_count+1))
  fi
done < <(find "$SCAN_DIR" -name "*.mdx" -print0)

echo ""
echo "=== Summary ==="
echo "Fresh (< $THRESHOLD days): $fresh_count"
echo "Stale (> $THRESHOLD days): $stale_count"
echo "No last_reviewed field: $no_date_count"

if [[ $stale_count -gt 0 ]]; then
  echo ""
  echo "HINT: Review stale pages, update content, bump last_reviewed to today."
  exit 1
else
  echo "ALL CONTENT FRESH"
  exit 0
fi
