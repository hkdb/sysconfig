# System
alias shellrefresh="source .bashrc"
alias bssid="sudo iwlist scanning"
alias rusb="sudo service usbmuxd restart"
alias fdns="sudo systemd-resolve --flush-caches"
alias clearswap="sudo swapoff -a && sudo swapon -a"
alias vram='LC_ALL=C lspci -v | grep -EA10 "3D|VGA" | grep prefetchable'
alias sshfs='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3'
alias cappnet='sudo netstat -taucp | grep'
alias ipinfo='curl ipinfo.io'
alias z='zellij'
alias scode='grep -rn --include'
alias plk="powerline-daemon -k"

# DNS Toys
alias wsea="dig seattle.weather @dns.toys"
alias whkg="dig hongkong.weather @dns.toys"
alias tnyc="dig newyork.time @dns.toys"
alias tsea="dig seattle.time @dns.toys"
alias thkg="dig hongkong.time @dns.toys"
alias mydnsip="dig ip @dns.toys"

# Git Identities
alias osigit='git config user.name "hkdb" && git config user.email "hkdb@m3df.io"' 
