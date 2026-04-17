#!/usr/bin/env zsh

#set -e

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -d /opt/homebrew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

brew update

# Install packages from Brewfile
if [ -f "$HOME/orgs/personal/dotfiles/Brewfile" ]; then
  brew bundle --file="$HOME/orgs/personal/dotfiles/Brewfile"
fi

# Apply dotfiles
if [ -x "$HOME/orgs/personal/dotfiles/bin/bootstrap.sh" ]; then
  "$HOME/orgs/personal/dotfiles/bin/bootstrap.sh"
fi

# -----------------------------
# Zsh + Powerlevel10k setup
# -----------------------------
# Install Oh My Zsh (only if not installed)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Enable Powerlevel10k in .zshrc (idempotent)
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$HOME/.zshrc" 2>/dev/null; then
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc" 2>/dev/null \
    || echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi

# Sanity checks
jq --version
aws --version
terraform version
packer version
vault version
java --version
mvn --version

echo
echo "Checking GitHub SSH access"

if command -v ssh >/dev/null 2>&1; then
  SSH_TEST_OUTPUT=$(ssh -T git@github.com -o BatchMode=yes -o ConnectTimeout=5 2>&1 || true)

  if echo "$SSH_TEST_OUTPUT" | grep -q "successfully authenticated"; then
    echo "GitHub SSH access is working"
  else
    echo "GitHub SSH access is NOT configured"
    echo "    Test: ssh -T git@github.com"
    echo "    Setup: bin/github-ssh-setup.sh"
  fi
else
  echo "ssh not found; skipping GitHub check"
fi

echo
echo "Done"
echo "Restart your terminal to apply Zsh and Powerlevel10k configuration"
