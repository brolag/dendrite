#!/bin/bash
# Scan for potential secrets, API keys, tokens, or passwords in the codebase
set -e

PATTERNS=(
  'AKIA[0-9A-Z]{16}'           # AWS Access Key
  'sk-[a-zA-Z0-9]{20,}'        # OpenAI/Anthropic API Key
  'ghp_[a-zA-Z0-9]{36}'        # GitHub Personal Token
  'password\s*=\s*["\x27][^"\x27]+'  # Hardcoded passwords
  'secret\s*=\s*["\x27][^"\x27]+'    # Hardcoded secrets
  'token\s*=\s*["\x27][^"\x27]+'     # Hardcoded tokens
)

ERRORS=0

for pattern in "${PATTERNS[@]}"; do
  matches=$(grep -rn --include='*.sh' --include='*.html' --include='*.md' --include='*.yml' --include='*.toml' -E "$pattern" . 2>/dev/null | grep -v '.claude/eval/' | grep -v 'check-no-secrets' || true)
  if [ -n "$matches" ]; then
    echo "FAIL: Potential secret found matching pattern '$pattern':"
    echo "$matches"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ "$ERRORS" -gt 0 ]; then
  echo "FAIL: $ERRORS potential secrets found"
  exit 1
fi

echo "PASS: No secrets detected in codebase"
exit 0
