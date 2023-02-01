#!/bin/bash

SCRIPTPATH=$( pwd -P )

bot () {
    echo -e "$BOLD❤ ~/ - $1$RESET"
}


bot "installing dependencies ..."

sudo apt update > /dev/null 2>&1
sudo apt install zsh curl > /dev/null 2>&1

bot "installing 'Oh My Zsh' ..."

if [[ ! -d "$ZSH" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
        git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    cp themes/velter.zsh-theme ~/.oh-my-zsh/custom/themes/velter.zsh-theme
    sed -i 's/plugins=(.*)/plugins=(git autojump zsh-autosuggestions)/' ~/.zshrc
else 
    echo " ⇒ zsh is already installed"
fi


bot "creating generic symlinks..."
shopt -s dotglob
for file in ../\~/*;
do
    link=~$(echo $file | cut -c5-)

    echo " ⇒ link $file to $link"

    # symlink might still exist
    unlink $link > /dev/null 2>&1

    # create the link
    ln -srf $file $link
done

bot "creating os specific symlinks..."
shopt -s dotglob
for file in ./\~/*;
do
    link=~/$(echo $file | cut -c5-)

    echo " ⇒ link $file to $link"

    # symlink might still exist
    unlink $link > /dev/null 2>&1

    # create the link
    ln -sfr $file $link
done

# bot "installing 'nvm' ..."

if [[ ! -d "$NVM_DIR" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash > /dev/null 2>&1
else
    echo " ⇒ nvm is already installed"
fi