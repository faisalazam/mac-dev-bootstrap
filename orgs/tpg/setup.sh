#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Applying organization bootstrap: tpg"

if [ -f "$SCRIPT_DIR/Brewfile" ]; then
  brew bundle --file="$SCRIPT_DIR/Brewfile"
fi

if [ -x "$SCRIPT_DIR/scripts/certs.sh" ]; then
  "$SCRIPT_DIR/scripts/certs.sh"
fi

if [ "${TPG_SKIP_GODOTENV:-0}" = "1" ]; then
  echo "Skipping godotenv install (TPG_SKIP_GODOTENV=1)"
elif [ -x "$SCRIPT_DIR/scripts/godotenv.sh" ]; then
  "$SCRIPT_DIR/scripts/godotenv.sh"
fi

# shellcheck source=../../bin/org-zsh.sh
source "$SCRIPT_DIR/../../bin/org-zsh.sh"

link_org_zsh "tpg" "$SCRIPT_DIR/zsh/tpg.zsh"

echo "Organization bootstrap complete: tpg"
