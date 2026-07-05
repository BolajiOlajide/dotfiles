#!/bin/bash

set -euo pipefail

# This script lives in scripts/; resolve the repo root so paths like the
# Brewfile work regardless of the caller's working directory.
REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)

# brew may not be on PATH yet: `make` runs each recipe in its own shell, so the
# PATH export from `make bootstrap` doesn't carry into this process. Re-source
# the shellenv line bootstrap wrote to ~/.zprofile instead of hardcoding a prefix.
if ! command -v brew >/dev/null 2>&1 && [ -f "$HOME/.zprofile" ]; then
    eval "$(grep -h 'brew shellenv' "$HOME/.zprofile")"
fi

SSH_EMAIL="25608335+BolajiOlajide@users.noreply.github.com"

ssh_keys_name=(git id_ed25519)

# create a loop and create an ssh key with the path `$HOME/.ssh/{name}`
for name in "${ssh_keys_name[@]}"; do
    key_path="$HOME/.ssh/$name"
    if [ ! -f "$key_path" ]; then
        ssh-keygen -t ed25519 -f "$key_path" -N "" -C "$SSH_EMAIL" <<< y >/dev/null 2>&1
        echo "SSH key '$name' generated at $key_path"
    else
        echo "SSH key '$name' already exists at $key_path"
    fi
done



# Generate RSA key only if it doesn't already exist
RSA_KEY_PATH="$HOME/.ssh/git_rsa"
if [ ! -f "$RSA_KEY_PATH" ]; then
    ssh-keygen -t rsa -b 4096 -f "$RSA_KEY_PATH" -N "" -C "$SSH_EMAIL" <<< y >/dev/null 2>&1
    echo "RSA SSH key generated at $RSA_KEY_PATH"
else
    echo "RSA SSH key already exists at $RSA_KEY_PATH"
fi

# setup brew
brew bundle --file="$REPO/packages/Brewfile"

eval "$(ssh-agent -s)"

# Note: symlinking of config files (ssh config, mise, etc.) is handled by
# sync.sh / `make sync`.