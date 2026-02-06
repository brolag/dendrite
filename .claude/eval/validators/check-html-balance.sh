#!/bin/bash
# Check that HTML has balanced opening/closing tags
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

tags_to_check = ['div', 'section', 'nav', 'footer', 'ul', 'li', 'script', 'style', 'pre', 'span']
errors = []

for tag in tags_to_check:
    open_count = len(re.findall(r'<' + tag + r'[\s>]', content))
    close_count = len(re.findall(r'</' + tag + r'>', content))
    if open_count != close_count:
        errors.append(f'{tag}: {open_count} open vs {close_count} close')

if errors:
    for e in errors:
        print(f'FAIL: Tag mismatch - {e}')
    sys.exit(1)
else:
    print('PASS: All HTML tags balanced')
"
