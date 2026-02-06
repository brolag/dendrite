#!/bin/bash
# Verify install.sh references all 12 tools in the Dendrite stack
set -e

SCRIPT="install.sh"
MISSING=0

TOOLS=(
  "ghostty"
  "neovim:nvim"
  "lazygit"
  "starship"
  "fzf"
  "zoxide"
  "eza"
  "bat"
  "fd"
  "ripgrep:rg"
  "claude-monitor"
  "ccm:claude-code-monitor"
)

for tool_entry in "${TOOLS[@]}"; do
  IFS=':' read -r name alt <<< "$tool_entry"
  if grep -q "$name" "$SCRIPT" 2>/dev/null; then
    continue
  elif [ -n "$alt" ] && grep -q "$alt" "$SCRIPT" 2>/dev/null; then
    continue
  else
    echo "MISSING: $name not found in $SCRIPT"
    MISSING=$((MISSING + 1))
  fi
done

if [ "$MISSING" -gt 0 ]; then
  echo "FAIL: $MISSING tools missing from install.sh"
  exit 1
fi

echo "PASS: All 12 tools referenced in install.sh"
exit 0
