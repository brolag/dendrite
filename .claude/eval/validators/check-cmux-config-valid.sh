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

# Shape of what Dendrite ships. cmux publishes a full JSON schema, but fetching
# it would make the eval suite depend on the network.
EXPECTED = {
    'schemaVersion': int,
    'app': dict,
    'terminal': dict,
    'browser': dict,
}
BOOLS = [
    ('terminal', 'copyOnSelect'),
    ('terminal', 'showScrollBar'),
    ('browser', 'openTerminalLinksInCmuxBrowser'),
]

errors = []
for key, expected_type in EXPECTED.items():
    if key not in config:
        errors.append(f'missing key: {key}')
    elif not isinstance(config[key], expected_type):
        errors.append(f'{key} must be {expected_type.__name__}, got {type(config[key]).__name__}')

for section, key in BOOLS:
    value = config.get(section)
    if isinstance(value, dict) and key in value and not isinstance(value[key], bool):
        errors.append(f'{section}.{key} must be a boolean')

if errors:
    for e in errors:
        print(f'FAIL: $FILE {e}')
    sys.exit(1)

print('PASS: $FILE is valid JSONC with the expected shape')
"
