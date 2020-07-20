#!/bin/bash

# Setting Text Bolding Variables
bold=$(tput bold)
normal=$(tput sgr0)

echo ""

# Dectect OS/Distro
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	if [ -n "$(command -v lsb_release)" ]; then
		distro=$(lsb_release -s -d)
	elif [ -f "/etc/os-release" ]; then
		distro=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="')
	elif [ -f "/etc/debian_version" ]; then
		distro="Debian $(cat /etc/debian_version)"
	elif [ -f "/etc/redhat-release" ]; then
		distro=$(cat /etc/redhat-release)
	else
		distro="$(uname -s) $(uname -r)"
	fi
	echo "${bold}OS:${normal} Linux"
	echo ""
	# Set Directory based on Distro
	if [[ $distro == "Debian"* ]] || [[ $distro == "Ubuntu"* ]]; then
		dir="debian"
	elif [[ $distro == "Fedora"* ]] || [[ $distro == "Red Hat"* ]] || [[ $distro == "CentOS"* ]]; then
		dir="redhat"
	fi
        echo "${bold}Distro:${normal} ${distro}"
else
	echo "Operating System not supported. Exiting..."
	exit 0
fi

# Install Dependencies
echo ""
echo "Installing Dependencies..."
./${dir}/install-dep.sh
sudo pip3 install --upgrade pip
sudo pip3 install mdv

## Bash
echo ""
echo "Configuring Bash..."
mv ~/.bashrc ~/.bashrc.old
ln -s $(pwd)/${dir}/.bashrc ~/.
ln -s $(pwd)/${dir}/.bash_path ~/.
mv ~/.bash_aliases ~/.bash_aliases.old
ln -s $(pwd)/.bash_aliases ~/.
ln -s $(pwd)/powerline ~/.config/

# Vim
echo ""
echo "Configuring VIM..."
mv ~/.vim ~/.vim.old
ln -s $(pwd)/.vim ~/.
mv ~/.vimrc ~/.vimrc.old
ln -s $(pwd)/.vimrc ~/.

echo ""
echo "---------------------------"
echo "           DONE            "
echo "---------------------------"
echo ""
