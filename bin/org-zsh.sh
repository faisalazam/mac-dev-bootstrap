#!/usr/bin/env bash
# bin/org-zsh.sh
#
# Shared contract for org-specific zsh overlay files.
#
# Org setup scripts call link_org_zsh to register their zsh config.
# zsh/zshrc sources all matching files at shell startup.
#
# Contract (overrideable via env vars):
#   ORG_ZSH_DIR    default: ~/.zsh_org.d
#   ORG_ZSH_PREFIX default: .zsh_
#
# Result per org:  ~/.zsh_org.d/.zsh_<org>
# zshrc glob:      ~/.zsh_org.d/.zsh_*

ORG_ZSH_PREFIX="${ORG_ZSH_PREFIX:-.zsh_}"
ORG_ZSH_DIR="${ORG_ZSH_DIR:-$HOME/.zsh_org.d}"

# link_org_zsh <org_name> <source_zsh_file>
# Creates the org zsh dir and symlinks <source_zsh_file> into it.
link_org_zsh() {
  local org_name="$1"
  local src="$2"
  mkdir -p "$ORG_ZSH_DIR"
  ln -sf "$src" "$ORG_ZSH_DIR/${ORG_ZSH_PREFIX}${org_name}"
  echo "Linked org zsh: $ORG_ZSH_DIR/${ORG_ZSH_PREFIX}${org_name} -> $src"
}
