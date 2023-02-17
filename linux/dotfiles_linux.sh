#!/bin/bash

bot () {
    echo -e "$BOLD❤ ~/ - $1$RESET"
}

bot "installing dependencies ..."

sudo apt update > /dev/null 2>&1
sudo apt -y install curl > /dev/null 2>&1

bot "installing 'Oh My Zsh' ..."

if [[ ! -d "$ZSH" ]]; then
    echo " ⇒ running apt install..."
    sudo apt -y install zsh > /dev/null 2>&1
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    echo " ⇒ installing autosuggestions..."
    git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    sed -i 's/plugins=(.*)/plugins=(git zsh-autosuggestions)/' ~/.zshrc
fi

# if [[ ! -f ~/.oh-my-zsh/custom/themes/velter.zsh-theme ]]; then
#     echo " ⇒ installing theme..."
#     cp ./linux/themes/velter.zsh-theme ~/.oh-my-zsh/custom/themes/velter.zsh-theme
#     sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"velter\"/g ~/.zshrc
# fi

echo " ⇒ installing random theme..."
sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"random\"/g ~/.zshrc

shopt -s dotglob

bot "creating generic symlinks..."
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
for file in ./\~/*;
do
    link=~/$(echo $file | cut -c5-)

    echo " ⇒ link $file to $link"

    # symlink might still exist
    unlink $link > /dev/null 2>&1

    # create the link
    ln -sfr $file $link
done

