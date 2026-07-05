#!/bin/bash

set -euo pipefail

log() {
    echo "🚨🚨🚨🚨 ---> $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Homebrew is installed
if command_exists brew; then
    log "Homebrew is already installed."
else
    log "Homebrew is not installed. Installing Homebrew..."
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # add homebrew to PATH (prefix differs on Apple Silicon vs Intel)
    BREW_BIN=/opt/homebrew/bin/brew
    [ -x "$BREW_BIN" ] || BREW_BIN=/usr/local/bin/brew
    (echo; echo "eval \"\$(${BREW_BIN} shellenv)\"") >> ~/.zprofile
    eval "$("$BREW_BIN" shellenv)"


    # Check if installation was successful
    if command_exists brew; then
        log "Homebrew installed successfully."
    else
        log "Failed to install Homebrew."
        exit 1
    fi
fi

# Install 1Password CLI early (required for secrets management)
if command_exists op; then
    log "1Password CLI is already installed."
else
    log "Installing 1Password CLI..."
    brew install --cask 1password-cli

    if command_exists op; then
        log "1Password CLI installed successfully."
        log "Run 'op signin' to authenticate with your 1Password account."
    else
        log "Failed to install 1Password CLI."
        exit 1
    fi
fi

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed."
else
    log "Oh My Zsh is not installed. Installing Oh My Zsh..."
    # Install Oh My Zsh (--unattended skips prompts and shell change)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Check if installation was successful
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log "Oh My Zsh installed successfully."
    else
        log "Failed to install Oh My Zsh."
        exit 1
    fi
fi

# Note: ~/.zshrc (and every other config) is replaced safely by sync.sh /
# `make sync`, which backs up any real file before symlinking. Bootstrap no
# longer touches it, so `make all` stays idempotent.

log "Bootstrap: All done!"