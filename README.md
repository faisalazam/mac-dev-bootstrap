# mac-dev-bootstrap

Docs: https://faisalazam.github.io/mac-dev-bootstrap/

This repo bootstraps a macOS dev machine with Homebrew + symlinked dotfiles.
It is safe to rerun, and it keeps personal identity and secrets out of git.

## What this sets up

- Installs/updates Homebrew and applies the `Brewfile`
- Links repo-managed config into your home directory
    - `git/gitconfig` -> `~/.gitconfig`
    - `git/gitignore_global` -> `~/.gitignore_global`
    - `zsh/zshrc` -> `~/.zshrc`
    - `zsh/p10k.zsh` -> `~/.p10k.zsh`
    - `zsh/zsh_aliases` -> `~/.zsh_aliases`
    - `ssh/config` -> `~/.ssh/config`
- Installs Oh My Zsh + Powerlevel10k (if missing)
- Prompts for Git identity and writes it to `~/.gitconfig.local`
- Configures Java via `jenv` and checks Java/Maven version alignment

## Full setup (new machine)

```bash
git clone git@github.com:faisalazam/mac-dev-bootstrap.git ~/orgs/personal/mac-dev-bootstrap
cd ~/orgs/personal/mac-dev-bootstrap
./setup-mac.sh
```

`setup-mac.sh` is the main entry point. It installs dependencies, applies dotfiles, and runs sanity checks.

## Reapply dotfiles only

```bash
cd ~/orgs/personal/mac-dev-bootstrap
./bin/bootstrap.sh
```

Use this when you only want to relink configs or update Git identity.

## GitHub SSH setup

If `ssh -T git@github.com` fails, run:

```bash
cd ~/orgs/personal/mac-dev-bootstrap
./bin/github-ssh-setup.sh
ssh -T git@github.com
```

This script creates `~/.ssh/id_ed25519_github` and prints the public key so you can add it in GitHub settings.

## Java and Maven versions

Java is managed with `jenv`.

- Installed JDKs are Temurin 26 and 21 (from `Brewfile`)
- Default global Java is set to 26 in `setup-mac.sh`
- `~/.zshrc` exports `JAVA_HOME` from `jenv prefix`, so `java` and `mvn` stay aligned

To switch versions later:

```bash
jenv local 21
jenv global 21
```

## Safety notes

- Do not commit private keys or machine-specific secrets
- `~/.gitconfig.local` stays local and is intentionally not tracked
- If you change SSH key naming or Java versions, update related files together:
    - SSH: `ssh/config` and `bin/github-ssh-setup.sh`
    - Java: `Brewfile` and `setup-mac.sh`

## Terminal Colors (iTerm2)

This setup intentionally does not override shell-level color variables (`LSCOLORS`, `LS_COLORS`). Terminal appearance is
expected to be managed via the iTerm2 profile.

For best readability with Powerlevel10k and common CLI tools, use a dark color preset in iTerm2:

**iTerm2 → Settings → Profiles → Colors → Color Preset**

Recommended presets:

- Dark Background
- Smoooooth
- Solarized Dark
- Tango Dark

If colors look hard to read after setup, adjusting the iTerm2 color preset is usually sufficient.
