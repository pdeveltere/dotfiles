#############################################################
# Generic configuration that applies to all shells
#############################################################

export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$HOME/Library/flutter/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

source $HOME/.bash_secrets

#############################################################
# Aliases
#############################################################

alias kb="kubectl -n clue"
alias g=git
