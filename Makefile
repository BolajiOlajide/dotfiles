UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

.PHONY: all bootstrap sync setup macos skill

.DEFAULT_GOAL := all

# Symlink every config file into place (safe, backs up real files).
sync:
	@./scripts/sync.sh

# Scaffold a new agent skill and link it. Interactive when run bare:
#   make skill
# Or pass args:
#   make skill name=my-skill desc="..."
skill:
	@./ai/new-skill.sh "$(name)" "$(desc)"

# Define the bootstrap target to run the scripts/bootstrap.sh script.
# On a fresh machine pass the profile explicitly: make all PROFILE=work
bootstrap:
	@PROFILE="$(PROFILE)" ./scripts/bootstrap.sh

setup:
	@./scripts/setup.sh

macos:
	@./scripts/macos.sh

all: bootstrap sync setup
