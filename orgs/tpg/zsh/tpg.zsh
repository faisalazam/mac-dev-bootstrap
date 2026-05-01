# TPG-specific shell environment.
# Loaded from ~/.zsh_tpg by zsh/zshrc.

if command -v brew >/dev/null 2>&1; then
  TPG_OPENSSL_PREFIX="$(brew --prefix openssl@3 2>/dev/null)"
  if [ -n "$TPG_OPENSSL_PREFIX" ]; then
    export AWS_CA_BUNDLE="$TPG_OPENSSL_PREFIX/cert.pem"
  fi
  unset TPG_OPENSSL_PREFIX
fi
