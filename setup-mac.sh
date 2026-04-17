#!/usr/bin/env bash

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

# Java versions to manage via jenv (must match Brewfile temurin casks)
JAVA_DEFAULT=26
JAVA_VERSIONS=(26 21)

# Install packages from Brewfile
if [ -f "$REPO_ROOT/Brewfile" ]; then
  brew bundle --file="$REPO_ROOT/Brewfile"
fi

# Enforce that all configured Temurin versions exist after brew bundle
for version in "${JAVA_VERSIONS[@]}"; do
  java_home="/Library/Java/JavaVirtualMachines/temurin-${version}.jdk/Contents/Home"
  if [ ! -d "$java_home" ]; then
    echo "Expected Temurin ${version} not found at: $java_home"
    echo "Brewfile and JAVA_VERSIONS are out of sync, or Homebrew latest temurin is no longer ${JAVA_DEFAULT}."
    echo "Update JAVA_VERSIONS/JAVA_DEFAULT and Brewfile casks together."
    exit 1
  fi
done

# Export JAVA_HOME explicitly for non-interactive setup script execution
# (zshrc handles this for interactive shells)
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-${JAVA_DEFAULT}.jdk/Contents/Home"

# Initialize jenv and register configured Temurin JDKs
if command -v jenv >/dev/null 2>&1; then
  # Register each configured Java version with jenv
  for version in "${JAVA_VERSIONS[@]}"; do
    jenv add "/Library/Java/JavaVirtualMachines/temurin-${version}.jdk/Contents/Home" 2>/dev/null || true
  done

  # Set default to the specified version
  jenv global "$JAVA_DEFAULT"
fi

# -----------------------------
# Zsh + Powerlevel10k setup
# -----------------------------
# Install Oh My Zsh (only if not installed)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # KEEP_ZSHRC=yes prevents Oh My Zsh installer from overwriting repo-managed .zshrc
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Apply dotfiles
if [ -x "$REPO_ROOT/bin/bootstrap.sh" ]; then
  "$REPO_ROOT/bin/bootstrap.sh"
fi

# Sanity checks
jq --version
aws --version
terraform version
packer version
vault version

# Enforce Java major version alignment for both java and Maven
EXPECTED_JAVA_MAJOR="${JAVA_DEFAULT%%.*}"
JAVA_VERSION_LINE="$(java -version 2>&1 | head -1)"
MVN_VERSION_OUTPUT="$(mvn --version 2>&1 || true)"
MVN_VERSION_LINE="$(echo "$MVN_VERSION_OUTPUT" | grep 'Java version:' | head -1)"

JAVA_ACTUAL="$(echo "$JAVA_VERSION_LINE" | sed -E 's/.*"([0-9]+)(\.[0-9]+.*)?".*/\1/')"
MVN_ACTUAL="$(echo "$MVN_VERSION_LINE" | sed -E 's/.*Java version: ([0-9]+)(\.[0-9]+.*)?[, ].*/\1/')"

if [ "$JAVA_ACTUAL" != "$EXPECTED_JAVA_MAJOR" ]; then
  echo "Java version enforcement failed: expected major $EXPECTED_JAVA_MAJOR, got $JAVA_ACTUAL"
  echo "Line: $JAVA_VERSION_LINE"
  exit 1
fi

if [ -z "$MVN_VERSION_LINE" ]; then
  echo "Maven version enforcement failed: could not parse 'Java version:' from mvn output"
  echo "$MVN_VERSION_OUTPUT"
  exit 1
fi

if [ "$MVN_ACTUAL" != "$EXPECTED_JAVA_MAJOR" ]; then
  echo "Maven Java version enforcement failed: expected major $EXPECTED_JAVA_MAJOR, got $MVN_ACTUAL"
  echo "Line: $MVN_VERSION_LINE"
  exit 1
fi

echo "Java version enforcement passed: java=$JAVA_ACTUAL, maven=$MVN_ACTUAL"

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
