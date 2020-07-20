#!/bin/bash

sudo dnf -y check-update
sudo dnf -y install vim tilix powerline powerline-fonts tmux-powerline vim-powerline python-pip
ln -s $(pwd)/powerline ~/.config/
