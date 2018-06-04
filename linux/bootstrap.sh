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

info() {
    local MSG
    MSG=$1
    echo -e "${text_yellow}==> $MSG${term_reset}"
}

step() {
    local MSG
    MSG=$1
    echo -e "${text_purple}»\n» $MSG\n»${term_reset}"
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
SUDO apt-get install -y ca-certificates apt-transport-https curl dnsutils git jq software-properties-common unzip vim wget zip

if [[ ! -d $HOME/.dotfiles ]]; then
    step "Cloning dotfiles repo"
    git clone https://github.com/brannon/dotfiles $HOME/.dotfiles

    info "Linking .bashrc"
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.orig
    ln -s $HOME/.dotfiles/.bashrc $HOME/.bashrc

    info "Update .gitconfig"
    git config --global include.path $HOME/.dotfiles/.gitconfig

    if [[ -z "$(git config --global --get user.email)" ]]; then
        echo -en "${color_yellow}Enter the email to use for Git commits: "
        read GIT_EMAIL
        git config --global user.email "$GIT_EMAIL"
    fi
fi

step "Configuring Docker"

if [[ -z "$(which docker)" ]]; then
    info "Add Docker package repository"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | SUDO apt-key add -
    SUDO add-apt-repository "\"deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable\""
    SUDO apt-get update
fi
info "Install Docker CE"
SUDO apt-get install -y docker-ce
SUDO usermod -aG docker "$(whoami)"

step "Installing development tools"

info "Install build tools"
SUDO apt-get install -y build-essential

info "Install Python"
SUDO apt-get install -y python2.7 python3.5

info "Install misc tools"
SUDO apt-get install -y sqlite3

info "Installing Golang"
curl https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz | SUDO tar -C /usr/local -xzf -

info "Install NodeJS"
curl -sL https://deb.nodesource.com/setup_10.x | SUDO bash -
SUDO apt-get install -y nodejs

echo -e "${text_green}¤ Bootstrap complete${term_reset}"

set +e
source $HOME/.bashrc
exit 0