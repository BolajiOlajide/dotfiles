# Installation Flow

How the install scripts and `make` targets fit together, from `git clone` to a
ready environment. See the [README](../README.md) for usage.

```mermaid
flowchart TD
    A[git clone dotfiles] --> J[make all]

    subgraph makefile["make all — bootstrap, sync, setup in order"]
        J --> B[make bootstrap]

        subgraph bootstrap["scripts/bootstrap.sh"]
            B --> PR{Machine profile?}
            PR -->|Stored / PROFILE env| C
            PR -->|Neither| PR2[Prompt work or personal]
            PR2 --> PR3[Save to ~/.config/dotfiles/profile]
            PR3 --> C
            C{Homebrew?}
            C -->|No| D[Install Homebrew]
            C -->|Yes| E{1Password CLI?}
            D --> E
            E -->|No| F[Install 1Password CLI]
            E -->|Yes| G{Oh My Zsh?}
            F --> G
            G -->|No| H[Install Oh My Zsh]
            G -->|Yes| I[Bootstrap done]
            H --> I
        end

        I --> SY[make sync]

        subgraph sync["scripts/sync.sh — safelink (backs up real files)"]
            SY --> BN[~/bin]
            SY --> K1[~/.gitconfig, ~/.gitignore]
            SY --> L1[~/.psqlrc]
            SY --> M1[~/.zshrc]
            SY --> H1[~/.config/hunk/config.toml, ~/.config/zed/settings.json]
            SY --> GH[~/.config/gh/config.yml, hosts.yml]
            SY --> G1[ghostty config — App Support on macOS / XDG on Linux]
            SY --> SC[~/.ssh/config]
            SY --> CD[~/.conductor/settings.toml]
            SY --> CL[~/.claude/settings.json, ~/.claude/agents]
            SY --> AM[~/.config/amp/settings.json]
            SY --> MI[~/.config/mise/config.toml]
            SY --> AG[ai/global.md → Claude / Codex / Amp]
            SY --> SK[ai/skills/* → Claude / Codex / Amp]
        end

        SY --> N[make setup]

        subgraph setup["scripts/setup.sh"]
            N --> O[Generate SSH Keys]
            O --> O1[~/.ssh/git]
            O --> O2[~/.ssh/id_ed25519]
            O --> O3[~/.ssh/git_rsa]
            O --> P[brew bundle — shared Brewfile]
            P --> P1[brew bundle — Brewfile.personal or Brewfile.work per profile]
        end
    end

    P1 --> T[Done]
    T --> U[op signin]
    U --> V[Ready!]

    W[make macos] -.->|Optional| X[Configure macOS defaults]
```
