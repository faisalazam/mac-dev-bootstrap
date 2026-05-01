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

mkdir -p "$HOME"
ln -sf "$SCRIPT_DIR/zsh/tpg.zsh" "$HOME/.zsh_tpg"

echo "Organization bootstrap complete: tpg"
