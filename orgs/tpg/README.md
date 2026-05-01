# tpg

Organization-specific bootstrap overlay for TPG.

## What this layer does

- Applies optional TPG-only Homebrew packages from `Brewfile`
- Installs Netskope CA cert into OpenSSL certs and refreshes hashes
- Installs `godotenv` CLI from GitHub releases for macOS
- Links TPG shell exports from `zsh/tpg.zsh` to `~/.zsh_tpg`

## Usage

Run the base setup with the org overlay enabled:

```bash
ORG_BOOTSTRAP=tpg ./setup-mac.sh
```

You can rerun only the org layer safely:

```bash
./orgs/tpg/setup.sh
```

To force a specific `godotenv` install location:

```bash
GODOTENV_INSTALL_DIR=/opt/homebrew/bin ./orgs/tpg/setup.sh
```

To run cert setup without touching `godotenv`:

```bash
TPG_SKIP_GODOTENV=1 ./orgs/tpg/setup.sh
```

## Notes

- Keep credentials and secrets out of git.
- Keep scripts idempotent and non-destructive.
- If cert paths change, update both `scripts/certs.sh` and `zsh/tpg.zsh` together.
