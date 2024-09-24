#!/bin/bash

log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S"):  💩💩💩💩💩💩💩💩] $1"
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
    
    # Check if installation was successful
    if command_exists brew; then
        log "Homebrew installed successfully."
    else
        log "Failed to install Homebrew."
        exit 1
    fi
fi

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed."
else
    log "Oh My Zsh is not installed. Installing Oh My Zsh..."
    # Install Oh My Zsh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    # Check if installation was successful
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log "Oh My Zsh installed successfully."
    else
        log "Failed to install Oh My Zsh."
        exit 1
    fi
fi

if [ ! -e "private.sh" ]; then
    log "private.sh not found. Exiting...."
    exit 1
fi

log "Bootstrap: All done!"