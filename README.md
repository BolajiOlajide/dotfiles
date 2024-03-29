# Dotfiles

Inspired by [@mrnugget's Dotfiles](https://github.com/mrnugget/dotfiles) - this is a rework for my specific usecase. It includes all configuration and tools I use on both my personal and work laptop.

## Requirements

* git

## Install

To set up all of the files as symlinks in your home directory, just run this:

```
./bootstrap.sh && make all
```

## Installing apps / tools via Homebrew

```
brew bundle --file=~/.dotfiles/Brewfile
```

and

```
brew bundle --force cleanup --file=~/.dotfiles/Brewfile
```

The brew file is generated using the command `brew bundle -f dump`.
