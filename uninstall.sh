#!/bin/bash

echo ""
echo "Removing Bash Config..."
mv ~/.bashrc.old ~/.bashrc
rm ~/.bash_path
rm ~/.bash_aliases
if [ -f ~/.bash_aliases.old ]; then
    mv ~/.bash_aliases.old ~/.bash_aliases
fi
rm -rf ~/.config/powerline

echo ""
echo "Removing VIM Config..."
rm ~/.vimrc
rm ~/.vim
rm ~/.viminfo
if [ -f ~/.viminfo.old ]; then
     mv ~/.viminfo.old ~/.viminfo
fi

echo ""
echo "Shredding Aliases..."
shred server/.bash_aliases
shred desktop/.bash_aliases

echo ""
echo "Removing Server Configs..."
rm -rf server

echo ""
echo "Removing Desktop Configs..."
rm -rf desktop

echo ""
echo "Removing Parent Directory..."
cd ..
rm -rf sysconfig

echo ""
echo "------------------------------"
echo "            DONE              "
echo "------------------------------"
echo ""
