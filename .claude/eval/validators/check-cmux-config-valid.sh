#!/bin/bash
# Validate the cmux config, which is JSONC (comments and trailing commas allowed)
set -e

FILE="configs/cmux/cmux.json"

if [ ! -f "$FILE" ]; then
  echo "FAIL: $FILE does not exist"
  exit 1
fi

python3 -c "
import json, re, sys

with open('$FILE') as f:
    raw = f.read()

# Strip // line comments outside strings, then trailing commas
stripped = re.sub(r'^\s*//.*$', '', raw, flags=re.MULTILINE)
stripped = re.sub(r',(\s*[}\]])', r'\1', stripped)

try:
    config = json.loads(stripped)
except json.JSONDecodeError as e:
    print(f'FAIL: $FILE is not valid JSONC: {e}')
    sys.exit(1)

if 'schemaVersion' not in config:
    print('FAIL: $FILE missing schemaVersion')
    sys.exit(1)

print('PASS: $FILE is valid JSONC')
"
