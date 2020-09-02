#!/bin/bash

SCRIPTPATH=$( pwd -P )

bot () {
    echo -e "$BOLD❤ ~/ - $1$RESET"
}


##############################################################################
bot "installing dependencies ..."
##############################################################################

sudo apt update > /dev/null 2>&1
sudo apt install zsh > /dev/null 2>&1
sudo apt install curl > /dev/null 2>&1

##############################################################################
bot "installing 'Oh My Zsh' ..."
##############################################################################

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi
cp themes/velter.zsh-theme ~/.oh-my-zsh/custom/themes/velter.zsh-theme
sed -i 's/plugins=(.*)/plugins=(git autojump zsh-autosuggestions)/' ~/.zshrc

##############################################################################
bot "creating symlinks for project dotfiles ..."
##############################################################################

find ./\~ -type f -print0 | while IFS= read -r -d $'\0' file;
do
    if [[ $file == "." || $file == ".." || $file == ".DS_Store" ]]
    then
        continue
    fi
    link=$(echo $file | cut -c5-)

    echo " ⇒ link $file to ~/$link"

    # symlink might still exist
    unlink ~/$link > /dev/null 2>&1

    # create the link
    ln -sf $SCRIPTPATH/~/$link ~/$link
done

##############################################################################
bot "installing 'nvm' ..."
##############################################################################

curl -o- -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh > /dev/null 2>&1
