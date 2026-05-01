#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
  echo "godotenv installer supports macOS only; skipping"
  exit 0
fi

if command -v godotenv >/dev/null 2>&1 && [ "${FORCE_GODOTENV_INSTALL:-0}" != "1" ]; then
  echo "godotenv already installed at: $(command -v godotenv)"
  echo "Set FORCE_GODOTENV_INSTALL=1 to reinstall"
  exit 0
fi

ARCH="$(uname -m)"
case "$ARCH" in
  arm64|aarch64)
    GODOTENV_ARCH="arm64"
    ;;
  x86_64)
    GODOTENV_ARCH="amd64"
    ;;
  *)
    echo "Unsupported macOS architecture: $ARCH"
    exit 1
    ;;
esac

DOWNLOAD_NAME="godotenv-darwin-${GODOTENV_ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/joho/godotenv/releases/latest/download/${DOWNLOAD_NAME}"

default_install_dir() {
  if command -v brew >/dev/null 2>&1; then
    printf "%s\n" "$(brew --prefix)/bin"
  elif [ -d "/opt/homebrew/bin" ]; then
    printf "%s\n" "/opt/homebrew/bin"
  else
    printf "%s\n" "/usr/local/bin"
  fi
}

INSTALL_DIR="${GODOTENV_INSTALL_DIR:-$(default_install_dir)}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

TMP_ARCHIVE="$TMP_DIR/godotenv.tar.gz"
TMP_BIN="$TMP_DIR/godotenv"

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_ARCHIVE"
tar -xzf "$TMP_ARCHIVE" -C "$TMP_DIR"

if [ ! -f "$TMP_BIN" ]; then
  echo "Downloaded archive did not contain expected binary: $TMP_BIN"
  exit 1
fi

chmod +x "$TMP_BIN"

install_to_dir() {
  local destination_dir="$1"
  mkdir -p "$destination_dir"
  mv "$TMP_BIN" "$destination_dir/godotenv"
  echo "Installed godotenv to: $destination_dir/godotenv"
}

install_with_sudo() {
  local destination_dir="$1"
  sudo mkdir -p "$destination_dir"
  sudo mv "$TMP_BIN" "$destination_dir/godotenv"
  echo "Installed godotenv to: $destination_dir/godotenv"
}

can_write_dir() {
  local destination_dir="$1"
  if [ -d "$destination_dir" ]; then
    [ -w "$destination_dir" ]
    return
  fi

  local parent_dir
  parent_dir="$(dirname "$destination_dir")"
  [ -w "$parent_dir" ]
}

if can_write_dir "$INSTALL_DIR"; then
  install_to_dir "$INSTALL_DIR"
elif command -v sudo >/dev/null 2>&1 && [ -t 0 ]; then
  install_with_sudo "$INSTALL_DIR"
else
  FALLBACK_DIR="$HOME/.local/bin"
  echo "Install dir not writable ($INSTALL_DIR); falling back to $FALLBACK_DIR"
  install_to_dir "$FALLBACK_DIR"
  echo "Add to PATH if needed: export PATH=\"$FALLBACK_DIR:\$PATH\""
fi

if command -v godotenv >/dev/null 2>&1; then
  if godotenv -h >/dev/null 2>&1; then
    echo "godotenv is ready"
  fi
else
  echo "godotenv installed but not yet on PATH in this shell"
fi
