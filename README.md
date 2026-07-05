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
| `packages/` | Homebrew manifests (`Brewfile` shared, `Brewfile.personal`/`Brewfile.work` per profile, `unbrew.txt`) |
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
| `config/mise/config.toml` | `~/.config/mise/config.toml` | Version manager for Go, Node, Python |
| `config/zed/settings.json` | `~/.config/zed/settings.json` | Zed editor settings (theme, fonts, keymap base) |
| `bin/` | `~/bin` | Personal scripts (whole dir symlinked; on PATH) |
| `config/gh/config.yml`, `config/gh/hosts.yml` | `~/.config/gh/` | GitHub CLI account/protocol state |
| `config/claude/settings.json` | `~/.claude/settings.json` | Claude Code user settings |
| `config/claude/agents/` | `~/.claude/agents` | Claude Code subagents (whole dir symlinked) |
| `config/amp/settings.json` | `~/.config/amp/settings.json` | Amp settings |

### AI tooling (`ai/`)

Everything related to AI coding agents lives under `ai/`:

| Path | Description |
|------|-------------|
| `ai/global.md` | Machine-wide agent instructions, symlinked to Claude Code, Codex, and Amp |
| `ai/skills/` | Shared agent skills, symlinked into Claude/Codex/Amp (see [ai/skills/README.md](ai/skills/README.md)) |
| `config/conductor/settings.toml` | Conductor global settings (shared across machines) |
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
   make all                 # prompts for the machine profile on first run
   make all PROFILE=work    # or state it explicitly (work | personal)
   ```

3. Sign in to 1Password CLI:
   ```bash
   op signin
   ```

This will:
- Record the machine profile in `~/.config/dotfiles/profile` (asked once)
- Install Homebrew (if not present)
- Install 1Password CLI (for secrets management)
- Install Oh My Zsh (if not present)
- Create symlinks for all config files
- Generate SSH keys
- Install packages from the shared Brewfile, then the profile's Brewfile

## Machine profiles

Each machine declares itself `personal` or `work` exactly once — bootstrap
prompts (or takes `PROFILE=...`) and stores the answer in
`~/.config/dotfiles/profile`, outside the repo. Everything else keys off that
file rather than hostnames or env vars:

- `packages/Brewfile` holds shared tools; `Brewfile.personal` and
  `Brewfile.work` hold the extras. `setup.sh` applies the shared file, then the
  one matching the profile (or skips extras if no profile is set yet).
- `zshrc` exports `$DOTFILES_PROFILE` so shell config and scripts can branch
  per machine, and sources the untracked `~/.zshrc.local` for machine-only
  env vars.
- `gitconfig` includes the untracked `~/.gitconfig.local` last, so a work
  machine can override `user.email`/`signingKey` without forking the config.

To change a machine's profile, edit `~/.config/dotfiles/profile` (or re-run
`make bootstrap PROFILE=...`) and run `make setup` again.

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

## Homebrew

Packages are split across `packages/Brewfile` (shared), `Brewfile.personal`,
and `Brewfile.work`. Add new entries to the right file by hand — `brew bundle
dump` regenerates a single flat file, so it would merge the profiles back
together (dump to a scratch path if you want to diff against reality).

Install packages for this machine (shared + profile):
```bash
make setup
```

Install a single manifest directly:
```bash
brew bundle --file=./packages/Brewfile
brew bundle --file=./packages/Brewfile.personal
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
