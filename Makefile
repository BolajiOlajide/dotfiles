UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zshrc

priv: $(HOME)/.private.sh

all: priv git psql zsh
