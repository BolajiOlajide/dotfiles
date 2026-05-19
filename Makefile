UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

.PHONY: all bootstrap setup macos git psql zsh hunk

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zshrc
hunk:
	mkdir -p $(HOME)/.config/hunk
	ln -sf $(DOTFILE_PATH)/hunk.config.toml $(HOME)/.config/hunk/config.toml

# Define the bootstrap target to run the bootstrap.sh script
bootstrap:
	@./bootstrap.sh

setup:
	@./setup.sh

macos:
	@./macos.sh

all: bootstrap git psql zsh setup hunk
