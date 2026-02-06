#!/bin/bash
# Validate YAML config files using python
set -e

FILE="configs/lazygit/config.yml"

if [ ! -f "$FILE" ]; then
  echo "FAIL: $FILE does not exist"
  exit 1
fi

# Use Python to validate YAML
python3 -c "
import yaml, sys
try:
    with open('$FILE') as f:
        yaml.safe_load(f)
    print('PASS: $FILE is valid YAML')
except yaml.YAMLError as e:
    print(f'FAIL: $FILE has YAML errors: {e}')
    sys.exit(1)
except Exception as e:
    print(f'FAIL: Could not read $FILE: {e}')
    sys.exit(1)
"
