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
local private="${HOME}/.zsh.d/private.sh"
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

# ANDROID / JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

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
alias ping="~/prettyping --nolegend"
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias got="go test ./..."

##########
# HISTORY
##########

HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000