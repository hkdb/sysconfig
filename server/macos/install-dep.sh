#!/bin/bash

if [ ! -d /usr/local/Cellar ]; then
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew install vim
pip3 install powerline-shell powerline-status powerline-gitstatus
