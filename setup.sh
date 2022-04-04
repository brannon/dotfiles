#!/bin/bash

export DOTFILES_REPO=$(dirname $0)

if [ $(uname) == 'Linux' ]; then
    $DOTFILES_REPO/linux/bootstrap.sh --silent --no-clone 2>&1 | tee $HOME/.setup.log
else
    echo "Unexpected platform: $(uname)"
    exit 1
fi
