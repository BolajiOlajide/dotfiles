UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zshrc

# Define the bootstrap target to run the bootstrap.sh script
bootstrap:
	@./bootstrap.sh

setup:
	@./setup.sh

all: bootstrap git psql zsh setup
