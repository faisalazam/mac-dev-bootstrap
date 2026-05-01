#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=./org-zsh.sh
source "$SCRIPT_DIR/org-zsh.sh"

echo "Bootstrapping dotfiles..."

# -----------------------
# Git
# -----------------------
echo "Configuring Git"
ln -sf "$REPO_ROOT/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$REPO_ROOT/git/gitignore_global" "$HOME/.gitignore_global"

# -----------------------
# Git identity (local-only)
# -----------------------
GIT_LOCAL="$HOME/.gitconfig.local"

create_or_update_git_identity() {
  read -rp "Git user.name: " GIT_NAME
  read -rp "Git user.email: " GIT_EMAIL

  cat > "$GIT_LOCAL" <<EOF
[user]
  name = $GIT_NAME
  email = $GIT_EMAIL
EOF

  chmod 600 "$GIT_LOCAL"
}

echo
echo "Checking Git identity"

if [ ! -f "$GIT_LOCAL" ]; then
  echo "No local Git identity found. Setting it up."
  create_or_update_git_identity
else
  echo "Local Git identity already exists:"
  git config --file "$GIT_LOCAL" user.name 2>/dev/null | sed 's/^/   user.name  = /'
  git config --file "$GIT_LOCAL" user.email 2>/dev/null | sed 's/^/   user.email = /'

  read -rp "Do you want to update git identity? (y/N): " UPDATE_ID
  if [[ "$UPDATE_ID" =~ ^[Yy]$ ]]; then
    create_or_update_git_identity
    echo "Git identity stored in ~/.gitconfig.local (delete it to reset)"
  fi
fi

# -----------------------
# Zsh
# -----------------------
echo
echo "Configuring Zsh"
ln -sf "$REPO_ROOT/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$REPO_ROOT/zsh/p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$REPO_ROOT/zsh/zsh_aliases" "$HOME/.zsh_aliases"

# Create org zsh overlay dir so zshrc glob runs cleanly even with no org installed
mkdir -p "$(get_org_zsh_dir)"

# -----------------------
# SSH (config only)
# -----------------------
echo
echo "Configuring SSH"
mkdir -p "$HOME/.ssh"
if [ -f "$REPO_ROOT/ssh/config" ]; then
  ln -sf "$REPO_ROOT/ssh/config" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
fi

echo
echo "Dotfiles bootstrapped successfully"
