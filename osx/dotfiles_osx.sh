#!/bin/bash

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
BOLD=$(tput bold)
COL_YELLOW="$(tput setaf 3)"
COL_GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

function bot() {
    echo -e "\n$BOLD❤ ~/ - $1$RESET"
}

function action() {
    echo -en " ⇒ $1..."
}

function running() {
echo -en "$COL_YELLOW ⇒ $RESET"$1": "
}

function ok() {
echo -e "$COL_GREEN[ok]$RESET "$1
}

##############################################################################
bot "installing 'homebrew'..."
##############################################################################

brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
        error "unable to install homebrew, script $0 abort!"
        exit 2
    fi
else
    echo -e "${COL_YELLOW}You already have homebrew installed.${RESET}"
fi

action "brew install git";ok
action "brew install ruby";ok
action "brew install node";ok

##############################################################################
bot "installing 'Oh My Zsh!'"
##############################################################################

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# copy the theme
cp themes/velter.zsh-theme ~/.oh-my-zsh/custom/themes/velter.zsh-theme

# enable the theme
sed -i 's/_THEME=\"robbyrussel\"/_THEME=\"velter\"/g' ~/.zshrc > /dev/null 2>&1

##############################################################################
bot "creating symlinks for project dotfiles..."
##############################################################################

pushd $SCRIPTPATH/\~ > /dev/null 2>&1
for file in .*; do
    if [[ $file == "." || $file == ".." || $file == ".DS_Store" || -d $file ]]; then
        continue
    fi
    echo " ⇒ ~/$file"
    # symlink might still exist
    unlink ~/$file > /dev/null 2>&1
    # create the link
    ln -sf $SCRIPTPATH/\~/$file ~
done
popd > /dev/null 2>&1

echo " ⇒ ~/Library/Application\ Support/Code/User/settings.json"
ln $SCRIPTPATH/\~/.config/Code/User/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
