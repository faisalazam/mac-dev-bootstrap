#!/usr/bin/env bash
set -euo pipefail

NETSKOPE_CERT_SOURCE="/Library/Application Support/Netskope/STAgent/data/nscacert.pem"
OPENSSL_PREFIX="$(brew --prefix openssl@3 2>/dev/null || true)"

if [ -z "$OPENSSL_PREFIX" ]; then
  echo "openssl@3 not found via brew; skipping Netskope CA setup"
  exit 0
fi

TARGET_CERT_DIR="$OPENSSL_PREFIX/certs"
TARGET_CERT_PATH="$TARGET_CERT_DIR/nscacert.pem"

if [ ! -f "$NETSKOPE_CERT_SOURCE" ]; then
  echo "Netskope certificate not found at: $NETSKOPE_CERT_SOURCE"
  echo "Skipping CA bundle update"
  exit 0
fi

mkdir -p "$TARGET_CERT_DIR"
cp "$NETSKOPE_CERT_SOURCE" "$TARGET_CERT_PATH"

REHASH_BIN="$(command -v c_rehash || true)"
if [ -z "$REHASH_BIN" ] && [ -x "$OPENSSL_PREFIX/bin/c_rehash" ]; then
  REHASH_BIN="$OPENSSL_PREFIX/bin/c_rehash"
fi

if [ -n "$REHASH_BIN" ]; then
  "$REHASH_BIN" "$TARGET_CERT_DIR" >/dev/null
else
  echo "c_rehash not found; copied cert but skipped hash refresh"
fi

echo "Netskope cert installed: $TARGET_CERT_PATH"
