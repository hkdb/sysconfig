# System
alias shellrefresh="source .bashrc"
alias bssid="sudo iwlist scanning"
# alias gsr="gnome-shell --mode=user --replace &"
alias gsr="gnome-shell --replace &"
alias unet="sudo QT_X11_NO_MITSHM=1 unetbootin"
alias rusb="sudo service usbmuxd restart"
alias bleon="sudo service bluetooth start"
alias bleoff="sudo service bluetooth stop"
alias fdns="sudo systemd-resolve --flush-caches"
alias clearswap="sudo swapoff -a && sudo swapon -a"
alias vram='LC_ALL=C lspci -v | grep -EA10 "3D|VGA" | grep prefetchable'
alias sshfs='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3'
alias cappnet='sudo netstat -taucp | grep'
alias ipinfo='curl ipinfo.io'

# Git Identities
alias osigit='git config user.name "hkdb" && git config user.email "hkdb@m3df.io"' 
