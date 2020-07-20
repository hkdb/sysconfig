# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set GO bin PATH
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi

# set Flutter PATH
if [ -d "$HOME/Development/flutter/bin" ] ; then
    PATH="$HOME/Development/flutter/bin:$PATH"
fi

# set Conda Path
if [ -d "$HOME/Development/miniconda3/bin" ] ; then
    PATH="$HOME/Development/miniconda3/bin:$PATH"
fi

# export GTK_IM_MODULE=ibus
# export QT_IM_MODULE=ibus
# export XMODIFIERS="@im=ibus"

export PATH="$HOME/.cargo/bin:$PATH"
export DEBFULLNAME="hkdb"
export DEBEMAIL="hkdb@3df.io"
