# Agent Instructions (this repo)

Guidance for working **inside this dotfiles repo**. Machine-wide conventions
(GitHub, branches, commits, PRs) live in `ai/global.md`, which `sync.sh`
symlinks to every agent's global config — edit *that* file for rules that should
apply everywhere, and this file only for dotfiles-specific guidance.

## Symlink workflow

Configs are symlinked into place by `sync.sh` (run via `make sync`). The files
in this repo are the real files; the locations under `$HOME` are symlinks to
them. So:

- Edit the tracked file here, not the symlink target — they're the same inode.
- `safelink()` backs up any real (non-symlink) file to `<file>.backup.<ts>`
  before linking, and is idempotent: a link already pointing at the repo is a
  no-op, and a divergent symlink is relinked with a log line.
- Add new configs by adding a `safelink SRC DST` line, not by hand-linking.

## Shell scripts

- Start with `set -euo pipefail`.
- Keep scripts idempotent and safe to re-run; never clobber a user's real file.
- `bash -n` / `zsh -n` (and `make -n`) before considering a script change done.
