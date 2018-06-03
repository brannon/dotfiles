#!/bin/bash

set -e

bg_blue="$(tput setab 4)"
term_reset="$(tput sgr0)"
text_bold="$(tput bold)"
text_dim="$(tput dim)"
text_black="$(tput setaf 0)"
text_red="$(tput setaf 1)"
text_green="$(tput setaf 2)"
text_yellow="$(tput setaf 3)"
text_blue="$(tput setaf 4)"
text_purple="$(tput setaf 5)"
text_cyan="$(tput setaf 6)"
text_white="$(tput setaf 7)"

step() {
    local MSG=$1

    echo -e "${text_purple}» $MSG ${term_reset}"
}

SUDO() {
    if [[ $UID == 0 ]]; then
        eval "$@"
    else
        eval "sudo $@"
    fi
}

step "Installing basic packages"

SUDO apt-get update
SUDO apt-get install -y curl git jq unzip vim wget zip

if [[ ! -d $HOME/.dotfiles ]]; then
    step "Cloning dotfiles repo"
    git clone https://github.com/brannon/dotfiles $HOME/.dotfiles

    step "Linking .bashrc"
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.orig
    ln -s $HOME/.dotfiles/.bashrc $HOME/.bashrc

    step "Update .gitconfig"
    git config --global include.path $HOME/.dotfiles/.gitconfig

    if [[ -z "$(git config --global --get user.email)" ]]; then
        read -p "Enter the email to use for Git commits: " GIT_EMAIL
        git config --global user.email "$GIT_EMAIL"
    fi
fi

step "Installing development packages"

SUDO apt-get install -y build-essential python2.7 python3.5 sqlite3

#step "Installing Golang"

#step "Install NodeJS"

echo -e "${text_green}¤ Bootstrap complete${term_reset}"

set +e
source $HOME/.bashrc
exit 0