#!/bin/bash
# Verify version number is consistent across all files that reference it
set -e

# Extract version from install.sh (source of truth)
VERSION=$(grep 'DENDRITE_VERSION=' install.sh | head -1 | sed 's/.*"\(.*\)".*/\1/')

if [ -z "$VERSION" ]; then
  echo "FAIL: Could not extract DENDRITE_VERSION from install.sh"
  exit 1
fi

ERRORS=0

# Check index.html version badge
if grep -q "v${VERSION}" index.html; then
  echo "OK: index.html has v${VERSION}"
else
  echo "FAIL: index.html version does not match v${VERSION}"
  ERRORS=$((ERRORS + 1))
fi

# Check index.html terminal title
if grep -q "v${VERSION}" index.html; then
  echo "OK: index.html terminal title has v${VERSION}"
else
  echo "FAIL: index.html terminal title missing v${VERSION}"
  ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "FAIL: Version inconsistency detected (expected $VERSION)"
  exit 1
fi

echo "PASS: Version $VERSION is consistent across all files"
exit 0
