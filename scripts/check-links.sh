#!/usr/bin/env bash
# check-links.sh — scan MDX files for broken internal path references
# Owner: Win 4 (Reference & QA), Task S2-W4-03
# Usage: bash scripts/check-links.sh [directory]  (default: repo root ".")

set -euo pipefail

# ─── Config ─────────────────────────────────────────────────────────────────
TARGET="${1:-.}"
# Resolve to absolute path so all relative checks work
REPO_ROOT="$(cd "$TARGET" && pwd)"

# ─── Color support (optional, degrades gracefully) ───────────────────────────
if [[ -t 1 ]]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; RESET=''
fi

# ─── Collect all nav paths from documentation.json ───────────────────────────
# These count as valid targets even if the .mdx file has a different location.
# Must be declared before use so set -u doesn't fire on empty-array expansion.
KNOWN_NAV_PATHS=()
DOC_JSON="${REPO_ROOT}/documentation.json"
if [[ -f "$DOC_JSON" ]]; then
  # Extract all "path": "..." values using python3 (available on macOS)
  while IFS= read -r p; do
    KNOWN_NAV_PATHS+=("$p")
  done < <(python3 -c "
import json, sys
data = json.load(open('$DOC_JSON'))
paths = []
def extract(obj):
    if isinstance(obj, dict):
        if 'path' in obj:
            paths.append(obj['path'])
        for v in obj.values():
            extract(v)
    elif isinstance(obj, list):
        for item in obj:
            extract(item)
extract(data)
print('\n'.join(paths))
" 2>/dev/null || true)
fi

# ─── Helper: check if a normalized path resolves to a file ───────────────────
# Returns 0 (found) or 1 (not found)
path_exists() {
  local p="$1"
  # Direct .mdx file
  [[ -f "${REPO_ROOT}/${p}.mdx" ]] && return 0
  # index.mdx in directory
  [[ -f "${REPO_ROOT}/${p}/index.mdx" ]] && return 0
  # Exact file (already has extension)
  [[ -f "${REPO_ROOT}/${p}" ]] && return 0
  # Known in documentation.json nav
  for nav in "${KNOWN_NAV_PATHS[@]+"${KNOWN_NAV_PATHS[@]}"}"; do
    [[ "$nav" == "$p" ]] && return 0
  done
  return 1
}

# ─── Collect MDX files (exclude plans/ as internal-only) ─────────────────────
# Initialize as empty; bash -u treats unset differently from empty array
MDX_FILES=()
while IFS= read -r -d '' f; do
  MDX_FILES+=("$f")
done < <(find "$REPO_ROOT" \
  -name "*.mdx" \
  -not -path "*/plans/*" \
  -print0 2>/dev/null) || true

TOTAL_FILES="${#MDX_FILES[@]}"
TOTAL_LINKS=0
BROKEN_COUNT=0
has_error=0

echo "=== check-links.sh — internal MDX path validation ==="
echo "Scanning: ${REPO_ROOT}"
echo ""

# ─── Process each file ───────────────────────────────────────────────────────
for file in "${MDX_FILES[@]+"${MDX_FILES[@]}"}"; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))

    # ── Pattern 1: Markdown links [text](/path) ──────────────────────────────
    # Regex: \[text\](/path) — captures the /path portion
    while IFS= read -r raw_path; do
      [[ -z "$raw_path" ]] && continue
      TOTAL_LINKS=$((TOTAL_LINKS + 1))

      # Normalize: strip leading slash, strip #anchor, strip .mdx suffix
      norm="${raw_path#/}"          # remove leading /
      norm="${norm%%#*}"            # strip #anchor
      norm="${norm%.mdx}"           # strip .mdx suffix
      norm="${norm%/}"              # strip trailing slash

      if ! path_exists "$norm"; then
        echo -e "${RED}BROKEN${RESET}: ${file}:${line_num} → ${raw_path}"
        BROKEN_COUNT=$((BROKEN_COUNT + 1))
        has_error=1
      fi
    done < <(echo "$line" | grep -oE '\[[^]]*\]\((/[^)]+)\)' | sed 's/.*(\(.*\))/\1/' | grep -v '^https\?://' | grep -v '^mailto:' || true)

    # ── Pattern 2: href="/path" props (Card, Link, a tags) ───────────────────
    while IFS= read -r raw_path; do
      [[ -z "$raw_path" ]] && continue
      TOTAL_LINKS=$((TOTAL_LINKS + 1))

      norm="${raw_path#/}"
      norm="${norm%%#*}"
      norm="${norm%.mdx}"
      norm="${norm%/}"

      if ! path_exists "$norm"; then
        echo -e "${RED}BROKEN${RESET}: ${file}:${line_num} → ${raw_path}"
        BROKEN_COUNT=$((BROKEN_COUNT + 1))
        has_error=1
      fi
    done < <(echo "$line" | grep -oE 'href=["'"'"'][^"'"'"']+["'"'"']' | sed 's/href=["'"'"']\([^"'"'"']*\)["'"'"']/\1/' | grep '^/' | grep -v '^https\?://' | grep -v '^mailto:' || true)

    # ── Pattern 3: path="foo/bar" component props ─────────────────────────────
    # Matches path="..." — these are typically nav paths (no leading slash)
    while IFS= read -r raw_path; do
      [[ -z "$raw_path" ]] && continue
      TOTAL_LINKS=$((TOTAL_LINKS + 1))

      norm="${raw_path#/}"
      norm="${norm%%#*}"
      norm="${norm%.mdx}"
      norm="${norm%/}"

      # Skip empty or single-word values unlikely to be page paths
      [[ "$norm" == *"."* && "$norm" != *"/"* ]] && continue  # skip "foo.bar" (likely not a path)
      [[ ${#norm} -lt 3 ]] && continue  # skip trivially short values

      if ! path_exists "$norm"; then
        echo -e "${RED}BROKEN${RESET}: ${file}:${line_num} → ${raw_path} (path= prop)"
        BROKEN_COUNT=$((BROKEN_COUNT + 1))
        has_error=1
      fi
    done < <(echo "$line" | grep -oE 'path=["'"'"'][^"'"'"']+["'"'"']' | sed 's/path=["'"'"']\([^"'"'"']*\)["'"'"']/\1/' | grep -v '^https\?://' | grep -v '^mailto:' || true)

  done < "$file"
done

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "=== Summary ==="
echo "Checked ${TOTAL_FILES} files, ${TOTAL_LINKS} links, ${BROKEN_COUNT} broken"
echo ""

if [[ $has_error -eq 1 ]]; then
  echo -e "${RED}Broken links found — fix before merge.${RESET}"
  exit 1
else
  echo -e "${GREEN}All ${TOTAL_LINKS} links OK.${RESET}"
  exit 0
fi
