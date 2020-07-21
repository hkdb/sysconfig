#!/bin/bash

echo ""
echo "Removing VIM Config..."
rm ~/.vimrc
rm ~/.vim

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

if [ $OSTYPE == "linux-gnu" ]; then
   rm -rf ~/.tilix
fi

echo ""
echo "Removing Bash Config..."
rm ~/.bash_path
rm ~/.bash_aliases
if [ -f ~/.bash_aliases.old ]; then
    mv ~/.bash_aliases.old ~/.bash_aliases
fi
rm ~/.config/powerline
mv ~/.bashrc.old ~/.bashrc

echo ""
echo "Removing Parent Directory..."
cd ..
rm -rf sysconfig

echo ""
echo "------------------------------"
echo "            DONE              "
echo "------------------------------"
echo ""
