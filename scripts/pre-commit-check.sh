#!/usr/bin/env bash
# pre-commit-check.sh — validate MDX content before push
# Owner: Win 4 (Reference & QA)
# Usage: bash scripts/pre-commit-check.sh [path]  (default: repo root)

set -u

TARGET="${1:-.}"
ERRORS=0

echo "=== Pre-commit check for: $TARGET ==="

# Strip fenced code blocks AND inline code spans before pattern-matching.
# Docs about bad patterns (like mdx-gotchas.mdx) intentionally contain example
# bad strings inside code fences/spans — those should not be flagged.
strip_code_content() {
  awk 'BEGIN{in_block=0}
    /^```/{in_block=!in_block; next}
    !in_block{gsub(/`[^`]*`/, "INLINE_CODE"); print}' "$1"
}

# Build list of all mdx files once
MDX_FILES=()
while IFS= read -r -d '' f; do
  MDX_FILES+=("$f")
done < <(find "$TARGET" -name "*.mdx" -print0 2>/dev/null)

# Gotcha 1 — Unicode checkbox characters
echo ""
echo "[1/4] Checking for Unicode checkboxes..."
HITS=""
for f in "${MDX_FILES[@]}"; do
  MATCH=$(strip_code_content "$f" | grep -nE "☐|□" || true)
  if [ -n "$MATCH" ]; then
    while IFS= read -r line; do
      HITS="${HITS}${f}:${line}"$'\n'
    done <<< "$MATCH"
  fi
done
if [ -n "$HITS" ]; then
  echo "FAIL: Found Unicode checkbox characters — replace with '- [ ]':"
  echo "$HITS"
  ERRORS=$((ERRORS + 1))
else
  echo "PASS: No Unicode checkboxes."
fi

# Gotcha 2 — <NUMBER% parsed as JSX
echo ""
echo "[2/4] Checking for <NUMBER patterns..."
HITS=""
for f in "${MDX_FILES[@]}"; do
  MATCH=$(strip_code_content "$f" | grep -nE "<[0-9]" || true)
  if [ -n "$MATCH" ]; then
    while IFS= read -r line; do
      HITS="${HITS}${f}:${line}"$'\n'
    done <<< "$MATCH"
  fi
done
if [ -n "$HITS" ]; then
  echo "FAIL: Found <NUMBER patterns — rephrase 'under N' or 'duoi N':"
  echo "$HITS"
  ERRORS=$((ERRORS + 1))
else
  echo "PASS: No <NUMBER patterns."
fi

# Gotcha 3 — Missing frontmatter (title or description)
echo ""
echo "[3/4] Checking frontmatter (title + description required)..."
MISSING=()
for f in "${MDX_FILES[@]}"; do
  HEAD=$(head -10 "$f")
  if ! echo "$HEAD" | grep -q "^title:"; then
    MISSING+=("$f: missing 'title:'")
  fi
  if ! echo "$HEAD" | grep -q "^description:"; then
    MISSING+=("$f: missing 'description:'")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "FAIL: Missing frontmatter fields:"
  printf '  %s\n' "${MISSING[@]}"
  ERRORS=$((ERRORS + 1))
else
  echo "PASS: All MDX files have title + description."
fi

# Gotcha 4 — Vietnamese ASCII (heuristic: warning only, does not fail build)
echo ""
echo "[4/4] Quick heuristic for ASCII-only Vietnamese (low-confidence)..."
WARN=""
for f in "${MDX_FILES[@]}"; do
  MATCH=$(strip_code_content "$f" | grep -nE "phong ngu|Ho tro|Tu [A-Z]|Gia [0-9]" || true)
  if [ -n "$MATCH" ]; then
    while IFS= read -r line; do
      WARN="${WARN}${f}:${line}"$'\n'
    done <<< "$MATCH"
  fi
done
if [ -n "$WARN" ]; then
  echo "WARN: Possible ASCII-only Vietnamese (verify manually):"
  echo "$WARN"
else
  echo "PASS: No obvious ASCII Vietnamese patterns."
fi

echo ""
echo "=== Summary ==="
if [ $ERRORS -eq 0 ]; then
  echo "ALL CHECKS PASSED — safe to commit/push."
  exit 0
else
  echo "FAILED: $ERRORS check(s) failed — fix before commit/push."
  exit 1
fi
