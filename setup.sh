#!/bin/bash

if [ $(uname) == 'Linux' ]; then
    linux/bootstrap.sh --silent --no-clone 2>&1 | tee $HOME/.setup.log
else
    echo "Unexpected platform: $(uname)"
    exit 1
fi
