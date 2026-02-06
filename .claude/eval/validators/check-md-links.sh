#!/bin/bash
# Check for broken relative links in markdown files
set -e

ERRORS=0

for md_file in README.md docs/*.md; do
  if [ ! -f "$md_file" ]; then
    continue
  fi

  # Extract relative links (not http, not anchors)
  links=$(grep -oP '\[([^\]]*)\]\(([^)]*)\)' "$md_file" | grep -oP '\(([^)]*)\)' | tr -d '()' | grep -v '^http' | grep -v '^#' || true)

  dir=$(dirname "$md_file")

  for link in $links; do
    # Resolve relative path
    target="$dir/$link"
    if [ ! -e "$target" ]; then
      echo "FAIL: $md_file has broken link to $link"
      ERRORS=$((ERRORS + 1))
    fi
  done
done

if [ "$ERRORS" -gt 0 ]; then
  echo "FAIL: $ERRORS broken markdown links found"
  exit 1
fi

echo "PASS: No broken relative links in markdown files"
exit 0
