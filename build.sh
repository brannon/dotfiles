#!/bin/bash
set -xe

./build-script.py macos/bootstrap.sh
./build-script.py pi/bootstrap.sh
