#!/bin/bash

set -ex

# Set the file path for the SSH key for git
SSH_KEY_PATH="$HOME/.ssh/git"
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



ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "$SSH_EMAIL" <<< y >/dev/null 2>&1

# setup brew
brew bundle --file=./Brewfile

eval "$(ssh-agent -s)"

cp ./ssh-config ~/.ssh/config

if [[ -n "$USE_MISE" && "$USE_MISE" -eq 1 ]]; then
    mkdir -p ~/.config/mise
    ln -s "$(pwd)/mise.toml" ~/.config/mise/config.toml
fi