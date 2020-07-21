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
	if [[ $distro == "Pop!_OS"* ]] || [[ $distro == "Ubuntu"* ]] || [[ $distro == "Debian"* ]]; then
		dir="debian"
	elif [[ $distro == "Arch"* ]]; then
		dir="arch"
	elif [[ $distro == "Fedora"* ]]; then
		dir="fedora"
	fi
        echo "${bold}Distro:${normal} ${distro}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "${bold}OS:${normal} MacOS"
	echo ""
	distro=$(sw_vers -productVersion)
	echo "${bold}Version:${normal} ${distro}"
	dir="macos"
else
	echo "Unsupported Operation System... Exiting..."
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
ln -s $(pwd)/powerline ~/.config/.

if [ ! -f ~/.profile ]; then
   ln -s $(pwd)/macos/.profile ~/.
fi	

# Tilix
if [ $OSTYPE == "linux-gnu" ]; then
   echo ""
   echo "Configuring Tilix..."
   ln -s $(pwd)/.tilix ~/.
fi

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
