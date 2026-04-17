# -----------------------
# Core CLI tools
# -----------------------
brew "git"
brew "python"
brew "node"
brew "uv"
brew "make"
brew "ansible"

# -----------------------
# DevOps / Platform
# -----------------------
brew "jq"
brew "wget"
brew "curl"
brew "ripgrep"
brew "tree"
brew "shellcheck"
brew "awscli"

tap "hashicorp/tap"
brew "hashicorp/tap/terraform"
brew "hashicorp/tap/packer"
brew "hashicorp/tap/vault"

# -----------------------
# Java / Build
# -----------------------
# Maven uses JAVA_HOME/java from jenv-managed Temurin versions
# setup-mac.sh sets jenv global to JAVA_DEFAULT (currently 26)
brew "maven"
# Installed JDKs must stay in sync with JAVA_VERSIONS in setup-mac.sh
brew "jenv"
# "temurin" is the latest version, i.e. 26
cask "temurin"
cask "temurin@21"

# -----------------------
# Container tooling
# -----------------------
cask "docker-desktop"

# -----------------------
# Terminal / Shell
# -----------------------
cask "iterm2"
cask "font-jetbrains-mono-nerd-font"

# -----------------------
# IDEs
# -----------------------
cask "intellij-idea"
cask "pycharm"
