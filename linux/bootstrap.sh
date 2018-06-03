#!/bin/bash

set -e

step() {
    local MSG=$1

    echo "> $MSG"
}

step "Installing basic packages"

sudo apt-get update
sudo apt-get install curl git jq unzip vim wget zip

if [[ ! -d $HOME/.dotfiles ]]; then
    step "Cloning dotfiles repo"
    git clone https://github.com/brannon/dotfiles $HOME/.dotfiles

    step "Linking .bashrc"
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.orig

    step "Update .gitconfig"
    git config --global include.path $HOME/.dotfiles/.gitconfig

    if [[ -z "$(git config --global --get user.email)" ]]; then
        read -p "Enter the email to use for Git commits: " GIT_EMAIL
        git config --global user.email "$GIT_EMAIL"
    fi

    source $HOME/.bashrc
fi

step "Installing development packages"

sudo apt-get install build-essentials python2.7 python3.5 sqlite3

step "Installing Golang"

step "Install NodeJS"


