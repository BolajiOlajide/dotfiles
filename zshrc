##############
# BASIC SETUP
##############

typeset -U PATH
autoload colors; colors;

setopt pushdsilent              # setopt needed to silence pushd/popd messages
setopt extended_glob            # enable zsh style globbing
setopt no_nomatch               # proceed with cmd even if glob does not match

#############
## PRIVATE ##
#############
# Include private stuff that's not supposed to show up
# in the dotfiles repo
local private="${HOME}/.private.sh"
if [ -e ${private} ]; then
  . ${private}
fi

# ===========================================================
# =              EXPORTS                                    =
# ===========================================================

# GOLANG
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH=$GOBIN:$PATH
export GO111MODULE=on

# ANDROID / JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# FZF
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# ===========================================================
# =              ALIASES                                    =
# ===========================================================

alias HEAD="git push origin head"
alias HEAD+="git push -f origin head"
alias check="git checkout"
alias gpr="git pull --rebase origin"
alias annie="ssh bolaji@$ANNIE_DROPLET_IP_ADDRESS"
alias dyon="ssh bolaji@$DYON_DROPLET_IP_ADDRESS"
alias cat="bat"
alias ping="prettyping --nolegend"
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias got="go test ./..."
alias ppm="pnpm"
alias gst="git status"
alias ga="git add"
alias check="git checkout"
alias gd="git diff"
alias gc="git commit"
# Nuke node modules
alias nuke='rm -rf node_modules ; if [ -f yarn.lock ]; then yarn install; elif [ -f pnpm-lock.yaml ]; then pnpm install; else npm install; fi;'

##########
# HISTORY
##########

HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# PNPM THINGS
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

## Postgres Stuff
export PATH="$PATH:/usr/local/opt/libpq/bin" # https://www.cyberithub.com/how-to-install-pg_dump-and-pg_restore-on-macos-using-7-easy-steps/

## NVM Stuff
export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm