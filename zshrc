# source private exports that includes
source ~/.private

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
