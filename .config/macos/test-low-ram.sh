#!/bin/bash
# ABOUTME: Verifies the low-RAM dry run disables macOS session restoration.
# ABOUTME: Run this after changing login or window restoration preferences.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
output="$("$SCRIPT_DIR/low-ram.sh" --dry-run)"

for expected in \
  '+ defaults write com.apple.loginwindow TALLogoutSavesState -bool false' \
  '+ defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false'
do
  if ! grep -Fqx "$expected" <<<"$output"; then
    echo "Missing dry-run command: $expected" >&2
    exit 1
  fi
done

echo "low-ram session restore defaults: OK"
