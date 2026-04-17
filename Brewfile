# -----------------------
# Core CLI tools
# -----------------------
brew "git"          # Version control
brew "bash"         # Modern Bash (macOS ships Bash 3.2)
brew "uv"           # Fast Python package and environment manager
brew "python"       # System-wide Python runtime
brew "node"         # System-wide Node.js runtime
brew "make"         # Build automation tool
brew "ansible"      # Configuration management and automation

# -----------------------
# DevOps / Platform
# -----------------------
brew "jq"            # JSON processor
brew "yq"            # YAML processor
brew "fzf"           # Fuzzy finder for CLI workflows
brew "wget"          # Non-interactive file downloader
brew "curl"          # HTTP client
brew "ripgrep"       # Fast recursive text search
brew "tree"          # Directory tree viewer
brew "shellcheck"    # Shell script linter
brew "awscli"        # AWS command-line interface

# HashiCorp tooling
tap "hashicorp/tap"
brew "hashicorp/tap/vault"      # Secrets management
brew "hashicorp/tap/packer"     # Machine image builder
brew "hashicorp/tap/terraform"  # Infrastructure as code

# -----------------------
# Java / Build
# -----------------------
# Maven uses JAVA_HOME/java from jenv-managed Temurin versions
# setup-mac.sh sets jenv global to JAVA_DEFAULT (currently 26)
brew "maven"        # Java build and dependency management
brew "jenv"         # Java version manager
# Installed JDKs must stay in sync with JAVA_VERSIONS in setup-mac.sh
cask "temurin"      # JDK version 26
cask "temurin@21"   # JDK version 21

# -----------------------
# Container tooling
# -----------------------
cask "docker-desktop"  # Docker engine and desktop UI

# -----------------------
# Terminal / Shell
# -----------------------
cask "iterm2"                        # Terminal emulator
cask "font-jetbrains-mono-nerd-font" # Font with glyphs for prompts

# -----------------------
# IDEs
# -----------------------
cask "pycharm"        # Python IDE
cask "intellij-idea"  # Java / JVM IDE
