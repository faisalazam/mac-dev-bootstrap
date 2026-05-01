#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Applying organization bootstrap: tpg"

if [ -f "$SCRIPT_DIR/Brewfile" ]; then
  brew bundle --file="$SCRIPT_DIR/Brewfile"
fi

echo "Organization bootstrap complete: tpg"
