#!/bin/bash
# Check that all internal nav anchors (#something) point to existing section IDs
set -e

FILE="index.html"

if [ ! -f "$FILE" ]; then
  echo "FAIL: $FILE does not exist"
  exit 1
fi

python3 -c "
import re, sys

with open('$FILE') as f:
    content = f.read()

# Find all anchor hrefs that start with #
anchors = re.findall(r'href=\"#([^\"]+)\"', content)
# Find all element IDs
ids = re.findall(r'id=\"([^\"]+)\"', content)

missing = []
for anchor in anchors:
    if anchor not in ids:
        missing.append(anchor)

if missing:
    for m in missing:
        print(f'FAIL: Nav anchor #{m} has no matching id in HTML')
    sys.exit(1)
else:
    print(f'PASS: All {len(anchors)} internal anchors resolve to valid IDs')
"
