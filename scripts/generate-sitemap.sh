#!/bin/bash
# generate-sitemap.sh
# Generate sitemap.xml from all MDX files in the repo.
# Usage: bash scripts/generate-sitemap.sh [BASE_URL]
# Default BASE_URL: https://phong-to.documentationai.com

set -euo pipefail

BASE_URL="${1:-https://phong-to.documentationai.com}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT="$ROOT_DIR/sitemap.xml"

cd "$ROOT_DIR"

echo '<?xml version="1.0" encoding="UTF-8"?>' > "$OUTPUT"
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> "$OUTPUT"

# Find all .mdx files, exclude node_modules/.git/plans/scripts
while IFS= read -r file; do
  # Strip leading ./ and trailing .mdx
  path="${file#./}"
  path="${path%.mdx}"

  # Extract last_reviewed from frontmatter (fallback to current date)
  lastmod=$(grep -E '^last_reviewed:' "$file" 2>/dev/null | head -1 | sed -E 's/last_reviewed: *"?([0-9]{4}-[0-9]{2}-[0-9]{2})"?.*/\1/')
  if [[ -z "$lastmod" ]]; then
    lastmod=$(date +%Y-%m-%d)
  fi

  # Homepage: index.mdx at root maps to /
  if [[ "$path" == "index" ]]; then
    loc="$BASE_URL/"
  else
    loc="$BASE_URL/$path"
  fi

  cat >> "$OUTPUT" <<EOF
  <url>
    <loc>$loc</loc>
    <lastmod>$lastmod</lastmod>
    <changefreq>weekly</changefreq>
  </url>
EOF
done < <(find . -name '*.mdx' -not -path './node_modules/*' -not -path './.git/*' -not -path './plans/*' | sort)

echo '</urlset>' >> "$OUTPUT"

COUNT=$(grep -c '<url>' "$OUTPUT")
echo "Generated $OUTPUT with $COUNT URLs (base: $BASE_URL)"
