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

# Core CLI tools
brew install \
  git \
  python \
  node \
  uv \
  make \
  ansible

# DevOps / platform tooling
brew tap hashicorp/tap || true

brew install \
  jq \
  wget \
  curl \
  ripgrep \
  tree \
  shellcheck \
  awscli \
  hashicorp/tap/terraform \
  hashicorp/tap/packer \
  hashicorp/tap/vault

# Container tooling
if [ ! -d "/Applications/Docker.app" ] && ! brew list --cask docker >/dev/null 2>&1; then
  brew install --cask docker
fi

# Terminal app
if [ ! -d "/Applications/iTerm.app" ] && ! brew list --cask iterm2 >/dev/null 2>&1; then
  brew install --cask iterm2
fi

# -----------------------------
# Zsh + Powerlevel10k setup
# -----------------------------

# Install Nerd Font (required for Powerlevel10k)
brew install --cask font-jetbrains-mono-nerd-font || true

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

# Java and build tools
brew install maven
brew install --cask temurin

# IntelliJ IDEA
if [ ! -d "/Applications/IntelliJ IDEA.app" ] && ! brew list --cask intellij-idea >/dev/null 2>&1; then
  brew install --cask intellij-idea
fi

# PyCharm
if [ ! -d "/Applications/PyCharm.app" ] && ! brew list --cask pycharm >/dev/null 2>&1; then
  brew install --cask pycharm
fi

# Sanity checks
jq --version
aws --version
terraform version
packer version
vault version
npm install -g npm
java --version
mvn --version

echo
echo "🔐 Checking GitHub SSH access (non-blocking)..."

if command -v ssh >/dev/null 2>&1; then
  SSH_TEST_OUTPUT=$(ssh -T git@github.com -o BatchMode=yes -o ConnectTimeout=5 2>&1 || true)

  if echo "$SSH_TEST_OUTPUT" | grep -q "successfully authenticated"; then
    echo "GitHub SSH access is working"
  else
    echo "GitHub SSH access is NOT configured"
    echo "    Run: ssh -T git@github.com"
    echo "    Or set up SSH keys if this is a new machine"
  fi
else
  echo "ssh not found; skipping GitHub check"
fi

echo "Done"
