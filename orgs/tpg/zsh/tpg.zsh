# TPG-specific shell environment.
# Loaded from ~/.zsh_org.d/.zsh_tpg by zsh/zshrc.
if command -v brew >/dev/null 2>&1; then
  TPG_OPENSSL_ETC="$(brew --prefix)/etc/openssl@3"
  TPG_AWS_CA_BUNDLE="$TPG_OPENSSL_ETC/cert.pem"

  if [ -f "$TPG_AWS_CA_BUNDLE" ]; then
    export AWS_CA_BUNDLE="$TPG_AWS_CA_BUNDLE"
  fi

  unset TPG_OPENSSL_ETC TPG_AWS_CA_BUNDLE
fi
