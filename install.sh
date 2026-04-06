#!/bin/bash
set -e

# Setting Text Bolding Variables
bold=$(tput bold)
normal=$(tput sgr0)
CYAN='\033[0;36m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "${GREEN}
________              _________            ____________         
__  ___/____  __________  ____/_______________  __/__(_)______ _
_____ \__  / / /_  ___/  /    _  __ \_  __ \_  /_ __  /__  __ \`/
____/ /_  /_/ /_(__  )/ /___  / /_/ /  / / /  __/ _  / _  /_/ / 
/____/ _\__, / /____/ \____/  \____//_/ /_//_/    /_/  _\__, /  
       /____/                                          /____/
${NC}"

echo ""

case "$1" in
  "help" | "server" | "desktop") 
    ;;
  *)
    echo -e "\n${RED}Unrecognized argument.${NC} sysconfig install.sh only accepts \"server\", \"desktop\", \"help\" as argument... Try \"$CONTAINER\" help to learn more...\n"
    exit 1
    ;;
esac

if [[ $1 == "help" ]]; then
  echo -e "\nsysconfig: ${GREEN}install.sh${NC}\n"
  echo -e "\targuments:"
  echo -e "\t\t- server\n\t\t- desktop\n\t\t- help\n"
  exit 0
fi

# Dectect OS/Distro
USEROS=""
echo -e "🐧️ Detecting OS..."
if [[ "$OSTYPE" == "linux"* ]]; then
  USEROS="linux"
  echo -e "\n🐧️ Linux\n"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  USEROS="freebsd"
  echo -e "\n🅱️  FreeBSD\n"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  USEROS="darwin"
  echo -e "\n🍎️ MacOS"
else
  echo -e "❌️ Operating System not supported... Exiting...\n"
  exit 1
fi

echo -e "💻️ Detecting CPU arch...\n"

CPUARCH=""
UNAMEM=$(uname -m)
echo -e "🏰️: $UNAMEM\n"

if [[ "$UNAMEM" == "x86_64" ]] || [[ "$UNAMEM" == "amd64" ]]; then
  CPUARCH="amd64"
elif [[ "$UNAMEM" == "arm" ]]; then
  CPUARCH="arm64"
elif [[ "$UNAMEM" == "aarch64" ]]; then
  CPUARCH="arm64"
else
  echo -e "❌️ CPU Architecture not supported... Exiting...\n"
  exit 1
fi

# Detect package manager
if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &>/dev/null; then
  PKG_MANAGER="brew"
elif command -v apt-get &>/dev/null; then
  PKG_MANAGER="apt-get"
elif command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
elif command -v yum &>/dev/null; then
  PKG_MANAGER="yum"
elif command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
elif command -v zypper &>/dev/null; then
  PKG_MANAGER="zypper"
elif [[ "$OSTYPE" == "freebsd"* ]] && command -v pkg &>/dev/null; then
  PKG_MANAGER="pkg"
else
  echo -e "❌️ No supported package manager available... Exiting..."
  exit 1
fi

install_if_missing() {
  local PACKAGE="$1"
  local PCHECK
  PCHECK="$(whereis "$PACKAGE")"
  local PL=${#PCHECK}

  if [[ $PL -lt $((${#PACKAGE} + 2)) ]]; then
    echo -e "\n⚠️  $PACKAGE is not installed. Do you want to install it now? (y/n): \c"
    read -r ANSWER
    if [[ "$ANSWER" =~ ^[Yy]$ ]]; then
      if [[ -z "$PKG_MANAGER" ]]; then
        echo -e "\n❌️ Could not detect a supported package manager. Please install $PACKAGE manually and run again.\n"
        exit 1
      fi
      case "$PKG_MANAGER" in
        pacman) sudo pacman -S --noconfirm "$PACKAGE" ;;
        brew)   brew install "$PACKAGE" ;;
        *)      sudo $PKG_MANAGER install -y "$PACKAGE" ;;
      esac || { echo -e "\n❌️ Failed to install $PACKAGE. Please install it manually and run again.\n"; exit 1; }
      echo -e "✅️ $PACKAGE installed successfully.\n"
    else
      echo -e "\n❌️ $PACKAGE is required. Install it and run the install command again.\n"
      exit 1
    fi
  fi
}

if [[ "$OSTYPE" == "freebsd"* ]] && [[ "$SHELL_NAME" == "csh" || "$SHELL_NAME" == "tcsh" ]]; then
  echo -e "ℹ️  FreeBSD detected. Current shell is $SHELL_NAME."
  echo -e "⚠️  Starship works best with zsh. Do you want to permanently switch to zsh? (y/n): \c"
  read -r ANSWER
  if [[ "$ANSWER" =~ ^[Yy]$ ]]; then
    install_if_missing "zsh"
    chsh -s "$(command -v zsh)"
    SHELL_NAME="zsh"
    echo -e "✅️ Default shell changed to zsh.\n"
  else
    echo -e "⚠️  Keeping $SHELL_NAME. Note that a some auto-configs in this script may not work correctly.\n"
  fi
fi

echo ""
echo -e "✅️ Dependencies check...\n"
echo -e "\n"
install_if_missing "unzip"
install_if_missing "curl"
install_if_missing "wget"
get_gpg_package() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "gnupg"
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "gnupg"
  elif command -v apt-get &>/dev/null; then
    echo "gnupg2"
  elif command -v dnf &>/dev/null || command -v yum &>/dev/null; then
    echo "gnupg2"
  elif command -v pacman &>/dev/null; then
    echo "gnupg"
  else
    echo ""
  fi
}
GPG_PACKAGE="$(get_gpg_package)"
install_if_missing "$GPG_PACKAGE"

echo -e "🚀 Installing Starship...\n"
curl -sS https://starship.rs/install.sh | sh -s -- -y || {
  echo -e "\n❌️ Starship installation failed.\n"
  exit 1
}
echo -e "\n✅️ Starship installed successfully.\n"

# Configure shell
SHELL_NAME="$(basename "$SHELL")"
case "$SHELL_NAME" in
  bash)
    SHELL_RC="$HOME/.bashrc"
    INIT_LINE='eval "$(starship init bash)"'
    ;;
  zsh)
    SHELL_RC="$HOME/.zshrc"
    INIT_LINE='eval "$(starship init zsh)"'
    ;;
  fish)
    SHELL_RC="$HOME/.config/fish/config.fish"
    INIT_LINE="starship init fish | source"
    ;;
  *)
    echo -e "⚠️  Unsupported shell '$SHELL_NAME'. Exiting..."
    exit 1
    ;;
esac

if grep -qF "starship init" "$SHELL_RC" 2>/dev/null; then
  echo -e "ℹ️  Starship init already present in $SHELL_RC, skipping.\n"
else
  echo -e "\n$INIT_LINE" >> "$SHELL_RC"
  echo -e "✅️ Starship init added to $SHELL_RC.\n"
fi

echo -e "🚀 Starship customizations"
mkdir -p $HOME/.config
cp $1/user_starship.toml $HOME/.config/starship.toml
sudo mkdir -p /root/.config
sudo cp $1/root_starship.toml /root/.config/starship.toml

# Glow
echo ""
echo -e "🚀 Install and configure Glow...\n"
if [[ "$PKG_MANAGER" == "apt-get" ]]; then
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo apt update && sudo apt install glow
fi
if [[ "$PKG_MANAGER" == "dnf" ]]; then
  echo '[charm]
  name=Charm
  baseurl=https://repo.charm.sh/yum/
  enabled=1
  gpgcheck=1
  gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
  sudo yum install glow
fi
if [[ "$PKG_MANAGER" == "pacman" ]]; then
  pacman -S glow
fi
if [[ "$PKG_MANAGER" == "brew" && "$USEROS" == "darwin" ]]; then
  brew install glow
fi

# Vim
echo ""
echo "🚀 Install and configuring Neovim...\n"
if [[ "$PKG_MANAGER" == "apt-get" ]]; then
  echo "Removing vim first...\n"
  sudo apt purge vim -y
  NVIM_LINK=https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  if [[ "$CPUARCH" == "arm64" ]]; then 
    NVIM_LINK=https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
  fi
  curl -L -o nvim.tar.gz $NVIM_LINK
  tar -xzvf nvim.tar.gz
  if [[ "$CPUARCH" == "amd64" ]]; then
    sudo mv nvim-linux-x86_64 /opt/
    sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/bin/nvim
  else
    sudo mv nvim-linux-arm64 /opt/
    sudo ln -s /opt/nvim-linux-arm64/bin/nvim /usr/bin/nvim
  fi
  sudo ln -s /usr/bin/nvim /usr/bin/vim
else
  install_if_missing "neovim"
fi
git clone https://github.com/NvChad/starter ~/.config/nvim && sed -i 's/theme = "onedark",/theme = "onedark",\n\ttransparency = true,/' ~/.config/nvim/lua/chadrc.lua && nvim

# Zellij
echo ""
echo "🚀 Installing Zellij..."
if [[ "$PKG_MANAGER" == "apt-get" ]]; then
  zellij_link=https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
  if [[ "$CPUARCH" == "arm64" ]]; then
    zellij_link=https://github.com/zellij-org/zellij/releases/latest/download/zellij-aarch64-unknown-linux-musl.tar.gz
  fi
  wget $zellij_link
  tar -xzvf zellij*.tar.gz
  if [ ! -d "$HOME/.local/bin" ]; then
     mkdir -p $HOME/.local/bin
  fi
  mv zellij $HOME/.local/bin/
  mkdir -p ~/.config/zellij
  $HOME/.local/bin/zellij setup --dump-config > ~/.config/zellij/config.kdl

  if [[ -n "$WAYLAND_DISPLAY" ]]; then
    install_if_missing "wl-copy"
    sed -i 's|//copy_command: "wl-copy"|copy_command: "wl-copy"|' ~/.config/zellij/config.kdl
  else
    install_if_missing "xclip"
    sed -i 's|//copy_command: "xclip"|copy_command: "xclip"|' ~/.config/zellij/config.kdl
  fi
else
  install_if_missing "zellij"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
   sed -i 's/\/\/copy_command: "xclip/copy_command: "pbcopy/' ~/Library/Application Support/org.Zellij-Contributors.Zellij/config.kdl
fi

if [[ "$1" ==  "desktop" ]]; then
  # Ghostty
  echo ""
  echo -e "🚀 Install and configure Ghostty...\n"
  if [[ "$PKG_MANAGER" == "apt-get" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  fi
  if [[ "$PKG_MANAGER" == "dnf" ]]; then
    sudo dnf copr enable scottames/ghostty
    sudo dnf install ghostty
  fi
  if [[ "$PKG_MANAGER" == "pacman" ]]; then
    pacman -S ghostty
  fi
  if [[ "$PKG_MANAGER" == "brew" && "$USEROS" == "darwin" ]]; then
    brew install --cask ghostty
  fi
fi

# Glow
echo ""
echo -e "🚀 Install app - X-Platform Package Manager...\n"
curl -sL https://hkdb.github.io/app/getapp.sh | bash

echo ""
