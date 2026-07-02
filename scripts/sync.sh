#!/usr/bin/env bash

# Symlink all config files into place. Safe to re-run: existing real files are
# backed up (not clobbered) before being replaced with a symlink.

set -euo pipefail

# This script lives in scripts/; the repo root (where config sources live) is
# its parent directory.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
REPO=$(pwd -P)

# safelink SRC DST
#   SRC is relative to the repo root, DST is an absolute path.
#   - errors if SRC is missing
#   - backs up DST to DST.backup.<timestamp> if it's a real (non-symlink) file
#   - creates parent dirs as needed, then symlinks SRC -> DST
safelink() {
    local src="$REPO/$1" dst="$2"
    if [ ! -e "$src" ]; then
        echo "Error: $src does not exist"
        return 1
    fi
    # Already points where we want — nothing to do.
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return 0
    fi
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        # Pick a backup path that doesn't already exist (avoid clobbering an
        # earlier backup made in the same second).
        local ts backup i=1
        ts=$(date +%Y%m%d%H%M%S)
        backup="$dst.backup.$ts"
        while [ -e "$backup" ] || [ -L "$backup" ]; do
            backup="$dst.backup.$ts.$i"
            i=$((i + 1))
        done
        mv "$dst" "$backup"
        echo "Backed up $dst -> $backup"
    elif [ -L "$dst" ]; then
        echo "Replacing symlink $dst: $(readlink "$dst") -> $src"
    fi
    rm -f "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -vs "$src" "$dst"
}

# Home-directory dotfiles
safelink config/git/gitconfig "$HOME/.gitconfig"
safelink config/git/gitignore "$HOME/.gitignore"
safelink config/psql/psqlrc   "$HOME/.psqlrc"
safelink config/zsh/zshrc     "$HOME/.zshrc"

# ~/.config files
safelink config/amp/settings.json "$HOME/.config/amp/settings.json"
safelink config/hunk/config.toml  "$HOME/.config/hunk/config.toml"
safelink config/zed/settings.json "$HOME/.config/zed/settings.json"

# GitHub CLI. hosts.yml tracks which account/protocol is active; the auth token
# itself lives in the macOS keychain, not in this file, so it's safe to track.
safelink config/gh/config.yml "$HOME/.config/gh/config.yml"
safelink config/gh/hosts.yml  "$HOME/.config/gh/hosts.yml"

# Ghostty: on macOS the app reads ~/Library/Application Support/...ghostty/config
# and that location overrides the XDG path, so link it there. Elsewhere (Linux)
# Ghostty uses the XDG path.
case "$OSTYPE" in
    darwin*) safelink config/ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config" ;;
    *)       safelink config/ghostty/config "$HOME/.config/ghostty/config" ;;
esac

# SSH config (was previously copied with a manual backup; now symlinked)
safelink config/ssh/config "$HOME/.ssh/config"

# Conductor global settings (shared across machines; ~/.conductor/projects is
# per-machine state and intentionally left untracked).
safelink config/conductor/settings.toml "$HOME/.conductor/settings.toml"

# Claude Code user settings (theme, TUI mode, attribution). Note: Claude Code
# writes this file in place (e.g. /config), so edits flow back into the repo via
# the symlink. Auth/credentials live elsewhere, not here.
safelink config/claude/settings.json "$HOME/.claude/settings.json"

# mise (opt-in via USE_MISE, matching setup.sh's previous behavior)
if [[ ${USE_MISE:-} == 1 ]]; then
    safelink config/mise/config.toml "$HOME/.config/mise/config.toml"
fi

# Shared *global* agent instructions: one source of truth, applied to every repo
# on this machine. (The repo-local AGENTS.md is dotfiles-specific and is NOT
# symlinked anywhere — it only governs work inside this repo.)
safelink ai/global.md "$HOME/.claude/CLAUDE.md"     # Claude Code
safelink ai/global.md "$HOME/.codex/AGENTS.md"      # Codex
safelink ai/global.md "$HOME/.config/amp/AGENTS.md" # Amp

# Shared agent skills: each skill subdir is linked into every provider's skills
# directory. Conductor inherits skills from the Claude/Codex agents it runs, so
# it needs no separate target.
for skill in ai/skills/*/; do
    [ -d "$skill" ] || continue                    # no skills yet -> skip
    [ -f "$skill/SKILL.md" ] || continue           # only real skills (need SKILL.md)
    name=$(basename "$skill")
    safelink "ai/skills/$name" "$HOME/.claude/skills/$name"        # Claude Code
    safelink "ai/skills/$name" "$HOME/.codex/skills/$name"         # Codex
    safelink "ai/skills/$name" "$HOME/.config/agents/skills/$name" # Amp
done
