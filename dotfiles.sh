#!/bin/bash

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
BOLD=$(tput bold)
COL_YELLOW="$(tput setaf 3)"
COL_GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

function bot() {
    echo -e "\n$BOLD\[._.]/ - $1$RESET"
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
    git clone -q https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
cp themes/velter.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/velter.zsh-theme

##############################################################################
bot "creating symlinks for project dotfiles..."
##############################################################################

pushd $SCRIPTPATH/\~ > /dev/null 2>&1
for file in .*; do
    if [[ $file == "." || $file == ".." || $file == ".DS_Store" ]]; then
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

##############################################################################
bot "Security"
##############################################################################

running "Enable firewall"
#   0 = off
#   1 = on for specific sevices
#   2 = on for essential services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1;ok

running "Enable firewall stealth mode (no response to ICMP / ping requests)"
# Source: https://support.apple.com/kb/PH18642
#sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1;ok

#running "Disable remote login"
#sudo systemsetup -setremotelogin off;ok

#running "Disable wake-on LAN"
sudo systemsetup -setwakeonnetworkaccess off;ok

running "Disable guest account login"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false;ok

running "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false;ok

################################################
bot "Standard System Changes"
################################################

running "Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" ";ok

running "Menu bar: disable transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false;ok

running "Save screenshots in PNG format" # (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png";ok

running "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2;ok

running "Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none";ok

running "Show the ~/Library folder"
chflags nohidden ~/Library;ok

running "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;ok

running "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true;ok

running "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false;ok

running "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false;ok

###############################################################################
bot "Trackpad, mouse, keyboard, Bluetooth accessories, and input"
###############################################################################

#running "disable special characters when holding keys"
#defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false; ok

#running "Set a blazingly fast keyboard repeat rate"
#defaults write -g KeyRepeat -float 1.0
#defaults write NSGlobalDomain KeyRepeat -float 1.0
#defaults write -g InitialKeyRepeat -float 10.0
#defaults write NSGlobalDomain InitialKeyRepeat -float 10.0;ok

###############################################################################
bot "Terminal & iTerm2"
###############################################################################

running "Make iTerm2 load new tabs in the same directory"
/usr/libexec/PlistBuddy -c "set \"New Bookmarks\":0:\"Custom Directory\" Recycle" ~/Library/Preferences/com.googlecode.iterm2.plist;ok

printf "\n"
