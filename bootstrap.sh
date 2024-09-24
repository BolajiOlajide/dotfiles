#!/bin/bash

#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Homebrew is installed
if command_exists brew; then
    echo "Homebrew is already installed."
else
    echo "Homebrew is not installed. Installing Homebrew..."
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Check if installation was successful
    if command_exists brew; then
        echo "Homebrew installed successfully."
    else
        echo "Failed to install Homebrew."
        exit 1
    fi
fi

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
else
    echo "Oh My Zsh is not installed. Installing Oh My Zsh..."
    # Install Oh My Zsh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    # Check if installation was successful
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh installed successfully."
    else
        echo "Failed to install Oh My Zsh."
        exit 1
    fi
fi

echo "All done!"
