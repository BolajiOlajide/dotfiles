##############
# BASIC SETUP
##############

typeset -U PATH
autoload -Uz colors && colors

setopt pushdsilent              # setopt needed to silence pushd/popd messages
setopt extended_glob            # enable zsh style globbing
setopt no_nomatch               # proceed with cmd even if glob does not match

# Homebrew prefix (Apple Silicon vs Intel)
if [[ -z "$HOMEBREW_PREFIX" ]]; then
    if [[ -d "/opt/homebrew" ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
    else
        export HOMEBREW_PREFIX="/usr/local"
    fi
fi

# ===========================================================
# =              PATH SETUP (consolidated)                  =
# ===========================================================

# GOLANG
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
PATH="$GOBIN:$PATH"

# ANDROID / JAVA
PATH="$HOMEBREW_PREFIX/opt/openjdk@17/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"
PATH="$PATH:$ANDROID_HOME/emulator"
PATH="$PATH:$ANDROID_HOME/platform-tools"

# Homebrew packages
PATH="$PATH:$HOMEBREW_PREFIX/opt/postgresql@16/bin"
PATH="$PATH:$HOMEBREW_PREFIX/opt/libpq/bin"
PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"

# Applications
PATH="$PATH:/Applications/GoLand.app/Contents/MacOS"

# PNPM
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) PATH="$PNPM_HOME:$PATH" ;;
esac

# Tools
PATH="$HOME/.amp/bin:$PATH"
PATH="$PATH:$HOME/.local/bin"
PATH="$HOME/.antigravity/antigravity/bin:$PATH"
PATH="$HOME/.bun/bin:$PATH"

# Ruby
export GEM_HOME="$HOME/.gem"
PATH="$GEM_HOME/bin:$PATH"

export PATH

# ===========================================================
# =              EXPORTS                                    =
# ===========================================================

export USE_MISE=1
export DOCKER_BUILDKIT=1

# JAVA
if [[ "$OSTYPE" == "darwin"* ]] && command -v /usr/libexec/java_home &> /dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
fi

# Python - require virtualenv for pip
# https://daniel.feldroy.com/posts/til-2023-12-forcing-pip-to-use-virtualenv
export PIP_REQUIRE_VIRTUALENV=true

# Docker (OrbStack)
export DOCKER_HOST="unix://$HOME/.orbstack/run/docker.sock"

# Homebrew
export HOMEBREW_NO_ANALYTICS=1

# FZF - add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# ===========================================================
# =              HISTORY                                    =
# ===========================================================

HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY          # share history across sessions
setopt HIST_IGNORE_ALL_DUPS   # don't save duplicates
setopt HIST_REDUCE_BLANKS     # remove extra blanks
setopt HIST_VERIFY            # show command before executing from history

# ===========================================================
# =              OH-MY-ZSH                                  =
# ===========================================================

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="eastwood"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# ===========================================================
# =              ALIASES                                    =
# ===========================================================

# Git aliases
alias HEAD="git push origin head"
alias HEAD+="git push --force-with-lease origin head"  # safer than -f
alias check="git checkout"
alias gst="git status --short"
alias ga="git add"
# alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
alias gd="git diff"
alias glo="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"
alias gc="git commit"
alias gren="git branch -M"

# CLI tool replacements
# Note: aliasing cat to bat may break scripts expecting standard cat output
# Consider using `bat` explicitly instead, or uncomment the alias below
alias cat="bat"
alias ping="prettyping --nolegend"
alias preview="fzf --preview 'bat --color \"always\" {}'"

# Development
alias got="go test ./..."
alias ppm="pnpm"
alias gs="git-spice"

# Nuke node modules and reinstall
alias nuke='rm -rf node_modules ; if [ -f yarn.lock ]; then yarn install; elif [ -f pnpm-lock.yaml ]; then pnpm install; else npm install; fi;'

# Safety - make rm interactive (only in interactive shells)
if [[ -o interactive ]]; then
  rm() {
    command rm -i "$@"
  }
fi

# ===========================================================
# =              FUNCTIONS                                  =
# ===========================================================

# Docker exec into container
dex() {
  if [ -z "$1" ]; then
    echo -e "\033[31mError: No container ID provided.\033[0m"
    return 1
  fi
  docker exec -it "$1" sh
}

# ===========================================================
# =              TOOL INITIALIZATION                        =
# ===========================================================

# mise (version manager)
if [[ -n "$USE_MISE" && "$USE_MISE" -eq 1 ]]; then
  command -v mise &>/dev/null && eval "$(mise activate zsh)"
fi

# direnv
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# Atuin shell history
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  eval "$(atuin init zsh)"
fi

# Bun completions
[[ -s "$HOMEBREW_PREFIX/share/zsh/site-functions/_bun" ]] && source "$HOMEBREW_PREFIX/share/zsh/site-functions/_bun"

# gcloud init
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
export CLOUDSDK_PYTHON=$(which python3)

# bun completions
[ -s "/Users/bolajiolajide/.bun/_bun" ] && source "/Users/bolajiolajide/.bun/_bun"

export RAILWAY_NO_TELEMETRY=1

# opencode
export PATH=/Users/bolajiolajide/.opencode/bin:$PATH
