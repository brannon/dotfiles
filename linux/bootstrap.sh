#!/bin/bash
DOTFILES_PATH=$HOME/.dotfiles

#begin_include("scripts/_env.sh")
######################################################################
#
# env setup
#
######################################################################

# ARCH (x86_64, arm)
if [[ ! -z $(which uname) ]]; then
    MACHINE=$(uname -m)
    case $MACHINE in
        arm*)
            ARCH=arm
            ;;
        *)
            ARCH=$MACHINE
            ;;
    esac
fi

#echo "ENV: detected ARCH $ARCH"
#end_include()

#begin_include("scripts/_output.sh")
######################################################################
#
# Output functions
#
######################################################################

term_reset="\033[m"
text_black="\033[0;30m"
text_red="\033[0;31m"
text_green="\033[0;32m"
text_yellow="\033[0;33m"
text_blue="\033[0;34m"
text_purple="\033[0;35m"
text_cyan="\033[0;36m"
text_white="\033[0;37m"
text_light_black="\033[1;30m"
text_light_red="\033[1;31m"
text_light_green="\033[1;32m"
text_light_yellow="\033[1;33m"
text_light_blue="\033[1;34m"
text_light_purple="\033[1;35m"
text_light_cyan="\033[1;36m"
text_light_white="\033[1;37m"

bootstrap_done() {
    echo -e "${text_light_green}\n¤ Bootstrap complete${term_reset}"
}

fatal() {
    echo -e "${text_red}!!! $1 !!!${term_reset}"
    exit 255
}

info() {
    echo -e "${text_white}$1${term_reset}"
}

ok() {
    if [[ -z $1 ]]; then
        echo -e "${text_green}OK${term_reset}"
    else
        echo -e "${text_green}OK ($1)${term_reset}"
    fi
}

operation() {
    echo -e "${text_cyan}==> $1${term_reset}"
}

operation_check_exit() {
    local IGNORED
    IGNORED=${2:-}

    if [[ $1 != 0 ]]; then
        if [[ ! " ${IGNORED[@]} " =~ " $1 " ]]; then
            echo -e "${text_red}Operation failed with exit code $1${term_reset}"
            exit 255
        else
            ok "Ignored exit code $1"
        fi
    else
        ok
    fi
}

operation_group() {
    echo -e "\n${text_light_cyan}»\n» $1\n»${term_reset}"
}

prompt_yn() {
    echo -n -e "${text_light_white}$1 [yn]${term_reset}" >$(tty)
    read -n 1 ANSWER
    echo "" >$(tty)
    echo $ANSWER
}

warn() {
    echo -e "${text_yellow}WARN: $1${term_reset}"
}
#end_include()

#begin_include("scripts/_exec.sh")
######################################################################
#
# Execution functions
#
######################################################################

SUDO() {
    local RC
    if [[ $UID == 0 ]]; then
        eval "$@"
        RC=$?
    else
        eval "sudo $@"
        RC=$?
    fi
    return $RC
}
#end_include()

#begin_include("scripts/_apt.sh")
######################################################################
#
# `apt` package manager functions
#
######################################################################

apt_install() {
    local PACKAGES
    local RC
    local STATUS
    PACKAGES="$*"
    for PACKAGE in $PACKAGES; do
        operation "Install $PACKAGE"
        STATUS=$(dpkg-query --status "$PACKAGE" 2>&1)
        if [[ $STATUS == *"is not installed"* ]]; then
            SUDO apt-get install -y "$PACKAGE"
            operation_check_exit $?
        elif [[ $STATUS == *"install ok installed"* ]]; then
            ok "Package already installed"
        else
            warn "Status of package '$PACKAGE' unknown. Run 'dpkg-query --status $PACKAGE' to see status."
        fi
    done
}

apt_install_optional() {
    local DESC
    local PACKAGES
    DESC="$1"
    shift
    PACKAGES="$*"

    if [[ $(prompt_yn "Install $DESC ($PACKAGES)?") == "y" ]]; then
        apt_install $PACKAGES
    else
        ok "Optional package(s) skipped"
    fi
}

apt_update() {
    SUDO apt-get update
    operation_check_exit $?
}
#end_include()

#begin_include("scripts/_file.sh")
######################################################################
#
# File functions
#
######################################################################

file_backup() {
    local FILE_PATH
    FILE_PATH=$1

    operation "Backup file $FILE_PATH"
    if [[ -f $FILE_PATH ]]; then
        if [[ ! -f "$FILE_PATH.orig" ]]; then
            mv $FILE_PATH $FILE_PATH.orig
            operation_check_exit $?
        else
            ok "File already backed up"
        fi
    else
        ok "File does not exist"
    fi
}

file_link() {
    local SOURCE_PATH
    local TARGET_PATH
    SOURCE_PATH=$1
    TARGET_PATH=$2

    operation "Link file $TARGET_PATH → $SOURCE_PATH"
    if [[ ! -f $TARGET_PATH ]]; then
        ln -s $SOURCE_PATH $TARGET_PATH
        operation_check_exit $?
    else
        ok "File already linked"
    fi
}
#end_include()

#begin_include("scripts/_git.sh")
######################################################################
#
# Git functions
#
######################################################################
DOTFILES_REPO="https://github.com/brannon/dotfiles"


git_clone_dotfiles_repo() {
    local TARGET_PATH
    TARGET_PATH=$1

    operation "Clone dotfiles repo"
    if [[ ! -d $TARGET_PATH ]]; then
        git clone $DOTFILES_REPO $TARGET_PATH
        operation_check_exit $?
    else
        (cd $TARGET_PATH && git fetch && git log -n 1 && git status --short --branch)
        ok "Repo already cloned"
    fi
}

git_config_include() {
    local INCLUDE_FILE_PATH
    INCLUDE_FILE_PATH=$1

    operation "Add git config include"
    git config --global include.path $INCLUDE_FILE_PATH
    operation_check_exit $?
}
#end_include()

INTERACTIVE=1
CLONE=1
while [ $# -gt 0 ]; do
    case "$1" in
        --non-interactive)
            INTERACTIVE=0
            ;;
        --no-clone)
            CLONE=0
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
    shift
done

operation_group "Configure packages"
#apt_update

operation_group "Install basic packages"
apt_install ca-certificates curl dnsutils gh git jq software-properties-common unzip vim wget zip

operation_group "Configure dotfiles"
if [[ $CLONE == 1 ]]; then
    git_clone_dotfiles_repo $DOTFILES_PATH
fi
file_backup $HOME/.bashrc
file_backup $HOME/.vimrc
file_link $DOTFILES_PATH/.bashrc $HOME/.bashrc
file_link $DOTFILES_PATH/linux/.vimrc $HOME/.vimrc
git_config_include $DOTFILES_PATH/linux/.gitconfig

operation "Install vim plugin manager"
if [[ ! -f $HOME/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    operation_check_exit $?
else
    ok "Already installed"
fi

operation "Install vim plugins"
VIM_IGNORED_EXIT=(1)
vim -T dumb -es -c ":PlugInstall" -c ":q" -c ":q"
operation_check_exit $? $VIM_IGNORED_EXIT

######################################################################

operation_group "Install development tools"
# Install build tools
apt_install build-essential
# Install Python
apt_install python3-full
# Install misc tools
apt_install sqlite3

# Install Go
GO_VERSION=1.24.5
operation "Install Golang $GO_VERSION"
if [[ -z $(which go) || -z $(go version | grep "$GO_VERSION") ]]; then
    [[ -d /usr/local/go ]] && SUDO rm -rf /usr/local/go
    curl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | SUDO tar -C /usr/local -xzf -
    operation_check_exit $?
else
    ok "Already installed"
fi

######################################################################

operation_group "Install optional packages"
if [[ $INTERACTIVE == 1 ]]; then
    # ARM cross-compiler (for non-ARM environments)
    if [[ $ARCH != "arm" ]]; then
        if [[ $(prompt_yn "Install ARM cross-compiler toolchain?") == "y" ]]; then
            apt_install gcc-arm-linux-gnueabihf
        fi
    fi

    # NodeJS
    if [[ $(prompt_yn "Install NodeJS 16.x?") == "y" ]]; then
        operation "Install NodeJS"
        curl -sL https://deb.nodesource.com/setup_16.x | SUDO bash -
        operation_check_exit $?
        SUDO apt-get install -y nodejs
        operation_check_exit $?
    fi
else
    warn "Skipped (non-interactive)"
fi

source $HOME/.bashrc

bootstrap_done
exit 0
