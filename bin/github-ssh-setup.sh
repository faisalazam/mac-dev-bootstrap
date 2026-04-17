#!/usr/bin/env bash
set -e

SSH_DIR="$HOME/.ssh"
KEY="$SSH_DIR/id_ed25519_github"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ -f "$KEY" ]; then
  echo "GitHub SSH key already exists at $KEY"
else
  echo "No GitHub SSH key found at $KEY"
  echo "Creating a new GitHub-specific SSH key"

  read -rp "GitHub email for SSH key: " EMAIL
  ssh-keygen -t ed25519 -f "$KEY" -C "$EMAIL"

  # Add key to ssh-agent and macOS Keychain
  if command -v ssh-add >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add --apple-use-keychain "$KEY"
  fi
fi

echo
echo "Add the following public key to GitHub:"
echo "-------------------------------------"
cat "$KEY.pub"
echo
echo "https://github.com/settings/keys"
