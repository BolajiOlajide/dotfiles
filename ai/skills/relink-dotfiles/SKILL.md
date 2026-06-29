---
name: relink-dotfiles
description: Use when the user asks to install, re-link, re-sync, or repair their dotfiles symlinks.
---

# Relink dotfiles

The user's dotfiles live in `~/dotfiles` and are symlinked into place by `sync.sh` (also exposed as `make sync`).

To (re-)link everything:

```bash
cd ~/dotfiles && make sync
```

`sync.sh` is idempotent and safe to re-run: any existing *real* file at a destination is moved to `<file>.backup.<timestamp>` before the symlink is
created, so a local config is never silently destroyed. Links that already point at the repo are left untouched.

After running, the destinations (`~/.gitconfig`, `~/.zshrc`, `~/.ssh/config`, the `~/.config/*` entries, and the shared `AGENTS.md` / `skills/*`) all point
back into `~/dotfiles`. Report any files that were backed up.
