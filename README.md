# Dotfiles

Personal dotfiles for macOS. Includes shell configuration, git settings, and development tools.

## Installation Flow

See [docs/installation-flow.md](docs/installation-flow.md) for a diagram of how
the install scripts and `make` targets fit together.

## Layout

| Path | Description |
|------|-------------|
| `config/` | The actual dotfiles, grouped by tool — each is symlinked into place by `scripts/sync.sh` |
| `scripts/` | Install + maintenance scripts (`bootstrap.sh`, `sync.sh`, `setup.sh`, `macos.sh`) |
| `packages/` | Homebrew manifests (`Brewfile`, `unbrew.txt`) |
| `ai/` | AI tooling — global agent instructions, skills, Conductor config (see below) |
| `docs/` | Diagrams and longer-form docs |
| `AGENTS.md` | Agent instructions specific to this dotfiles repo (stays at root so agents discover it) |

### Configs (`config/`)

Everything under `config/` is symlinked into `$HOME` by `scripts/sync.sh`:

| Path | Symlinked to | Description |
|------|--------------|-------------|
| `config/zsh/zshrc` | `~/.zshrc` | Zsh configuration with Oh My Zsh, aliases, and ordered PATH setup |
| `config/git/gitconfig` | `~/.gitconfig` | Git settings with SSH signing, aliases, and the `hunk` pager |
| `config/git/gitignore` | `~/.gitignore` | Global gitignore patterns |
| `config/psql/psqlrc` | `~/.psqlrc` | PostgreSQL CLI configuration |
| `config/ssh/config` | `~/.ssh/config` | SSH client configuration |
| `config/hunk/config.toml` | `~/.config/hunk/config.toml` | Config for the `hunk` git diff pager |
| `config/ghostty/config` | Ghostty config dir | Ghostty terminal configuration |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | Version manager for Go, Node, Python (opt-in via `USE_MISE=1`) |

### AI tooling (`ai/`)

Everything related to AI coding agents lives under `ai/`:

| Path | Description |
|------|-------------|
| `ai/global.md` | Machine-wide agent instructions, symlinked to Claude Code, Codex, and Amp |
| `ai/skills/` | Shared agent skills, symlinked into Claude/Codex/Amp (see [ai/skills/README.md](ai/skills/README.md)) |
| `ai/conductor/settings.toml` | Conductor global settings (shared across machines) |
| `ai/new-skill.sh` | Skill scaffolder (`make skill`) |

The repo-local `AGENTS.md` stays at the root so agents working *in this repo*
auto-discover it.

## Requirements

- macOS (Apple Silicon or Intel)
- Git

## Install

1. Clone the repository:
   ```bash
   git clone https://github.com/BolajiOlajide/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the install (`make all` runs bootstrap, sync, and setup in order):
   ```bash
   make all
   ```

3. Sign in to 1Password CLI:
   ```bash
   op signin
   ```

This will:
- Install Homebrew (if not present)
- Install 1Password CLI (for secrets management)
- Install Oh My Zsh (if not present)
- Create symlinks for all config files
- Generate SSH keys
- Install packages from Brewfile

## Makefile Targets

```bash
make all        # Full setup (bootstrap + sync + setup)
make bootstrap  # Install Homebrew, 1Password CLI, and Oh My Zsh
make sync       # Symlink all config files (safe: backs up real files)
make setup      # Generate SSH keys, install brew packages
make macos      # Configure macOS system preferences
make skill      # Scaffold + link a new agent skill (interactive prompts)
```

Symlinking is handled entirely by `scripts/sync.sh` (invoked via `make sync`). It is
idempotent and safe to re-run: any existing *real* file at a destination is
moved to `<file>.backup.<timestamp>` before the symlink is created, so a stale
local config is never silently destroyed.

`config/mise/config.toml` is opt-in — it's only linked when `USE_MISE=1` is set,
e.g. `USE_MISE=1 make sync`.

## Homebrew

Update Brewfile from currently installed packages:
```bash
brew bundle dump --force --file=./packages/Brewfile
```

Install packages from Brewfile:
```bash
brew bundle --file=./packages/Brewfile
```

Remove packages not in Brewfile:
```bash
brew bundle cleanup --force --file=./packages/Brewfile
```

## Key Features

- **Apple Silicon compatible** - Uses `$HOMEBREW_PREFIX` for portable paths
- **1Password integration** - Secrets loaded via `op` CLI (no plaintext files)
- **SSH signing** - Git commits signed with SSH key
- **Modern tools** - bat, fzf, ripgrep, hunk, atuin
- **Version management** - mise for Go, Node, Python
- **Docker** - OrbStack integration
- **macOS automation** - System preferences via `defaults` commands

## Shell Aliases

| Alias | Command |
|-------|---------|
| `HEAD` | `git push origin head` |
| `HEAD+` | `git push --force-with-lease origin head` |
| `check` | `git checkout` |
| `gst` | `git status --short` |
| `ga` | `git add` |
| `gd` | `git diff` |
| `glo` | `git log --all --graph` (pretty) |
| `gc` | `git commit` |
| `gs` | `git-spice` |
| `got` | `go test ./...` |
| `cat` | `bat` |
| `ping` | `prettyping` |
| `nuke` | Remove node_modules and reinstall |

## License

MIT
