# tpg

Organization-specific bootstrap overlay for TPG.

## What this layer does

- Applies optional TPG-only Homebrew packages from `Brewfile`
- Installs Netskope CA cert into OpenSSL certs and refreshes hashes
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

## Notes

- Keep credentials and secrets out of git.
- Keep scripts idempotent and non-destructive.
- If cert paths change, update both `scripts/certs.sh` and `zsh/tpg.zsh` together.
