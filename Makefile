UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zshrc

priv: $(HOME)/.private.sh

# Define the bootstrap target to run the bootstrap.sh script
bootstrap:
	@./bootstrap.sh

all: bootstrap priv git psql zsh
