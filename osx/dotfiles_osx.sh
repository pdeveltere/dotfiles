#!/bin/bash

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
BOLD=$(tput bold)
COL_YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

function bot() {
    echo -e "\n$BOLD❤ ~/ - $1$RESET"
}

##############################################################################
bot "installing 'homebrew'..."
##############################################################################
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${COL_YELLOW}You already have homebrew installed.${RESET}"
fi

##############################################################################
bot "configuring 'Oh My Zsh!'"
##############################################################################
if [ -z "$ZSH" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo -e "${COL_YELLOW}You already have oh-my-zsh installed.${RESET}"
fi

# enable autosuggestion and autojump
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    echo " ⇒ installing autosuggestions..."
    git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    sed -i '' 's/plugins=(.*)/plugins=(git zsh-autosuggestions)/' ~/.zshrc
fi

# enable my theme
cp $SCRIPTPATH/themes/velter.zsh-theme ~/.oh-my-zsh/custom/themes/velter.zsh-theme
sed -i '' 's/THEME=\".*\"/THEME=\"velter\"/g' ~/.zshrc > /dev/null 2>&1

##############################################################################
bot "creating symlinks..."
##############################################################################
shopt -s dotglob

for file in $SCRIPTPATH/../~/*;
do
    filename=$(basename $file)
    link="$HOME/$filename"

    echo " ⇒ link $file to $link"

    # symlink might still exist
    unlink $link > /dev/null 2>&1

    # create the link
    ln -sf $file $link
done

for file in $SCRIPTPATH/~/*;
do
    filename=$(basename $file)
    link="$HOME/$filename"

    echo " ⇒ link $file to $link"

    # symlink might still exist
    unlink $link > /dev/null 2>&1

    # create the link
    ln -sf $file $link
done
