#!/usr/bin/env bash

set -euo pipefail

# Cores e ícones
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
CHECK="✅"
ROCKET="🚀"
GEAR="⚙️"
KEY="🔑"
COMPUTER="💻"
FONT="🔠"

# Coleta informações do usuário
collect_user_info() {
  echo -e "${ROCKET} ${BLUE}Configuração Inicial${NC}"

  local user_name="${1:-"Clayton Garcia"}"
  local user_email="${2:-"tarcios.clay@gmail.com"}"

  if [ -z "${1:-}" ]; then
    read -p "Digite seu nome completo [${user_name}]: " input_name
    user_name="${input_name:-$user_name}"
  fi

  if [ -z "${2:-}" ]; then
    read -p "Digite seu email [${user_email}]: " input_email
    user_email="${input_email:-$user_email}"
  fi

  USER_NAME="$user_name"
  USER_EMAIL="$user_email"
}

# Instala fontes JetBrains Mono Nerd Font
install_fonts() {
  echo -e "${FONT} ${BLUE}Instalando JetBrains Mono Nerd Font...${NC}"
  case "$(uname -s)" in
    Linux*)
      if [ ! -f.local/share/fonts/JetBransMono* ]; then
        mkdir -p ~/.local/share/fonts
        curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
        unzip -q /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
        fc-cache -fv
      fi
      ;;
    Darwin*)
      brew tap homebrew/cask-fonts
      brew install --cask font-jetbrains-mono-nerd-font
      ;;
    CYGWIN*|MINGW*|MSYS*)
      mkdir -p ~/AppData/Local/Microsoft/Windows/Fonts
      curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
      unzip -q /tmp/JetBrainsMono.zip -d ~/AppData/Local/Microsoft/Windows/Fonts/
      ;;
  esac
  echo -e "${CHECK} ${GREEN}Fonte instalada com sucesso!${NC}"
}

# Instala dependências básicas
install_dependencies() {
  echo -e "${GEAR} ${BLUE}Verificando dependências...${NC}"

  case "$(uname -s)" in
    Linux*)
      sudo apt-get update
      sudo apt-get install -y git curl fuse libfuse2t64 unzip tar gzip build-essential fontconfig
      ;;
    Darwin*)
      if ! command -v brew >/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew install git curl tar gzip unzip
      ;;
    CYGWIN*|MINGW*|MSYS*)
      if ! command -v git >/dev/null; then
        echo -e "${RED}Por favor instale o Git for Windows: https://git-scm.com/download/win${NC}"
        exit 1
      fi
      if ! command -v fuse >/dev/null; then
        echo -e "${RED}Por favor instale o WinFsp: https://winfsp.dev/rel/${NC}"
        exit 1
      fi
      ;;
  esac

  # Configura FUSE
  if [ -f /etc/fuse.conf ] && ! grep -q "^user_allow_other" /etc/fuse.conf; then
    echo "user_allow_other" | sudo tee -a /etc/fuse.conf >/dev/null
  fi

  # Baixa dotfiles
  if [ ! -d ~/dotfiles ]; then
    git clone https://github.com/TaRCioS-CLaY/dotfiles.git ~/dotfiles
  fi
}

# Configura SSH
setup_ssh() {
  if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo -e "${KEY} ${BLUE}Configurando SSH...${NC}"
    mkdir -p ~/.ssh
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f ~/.ssh/id_ed25519 -N ""
    echo -e "${CHECK} ${GREEN}Chave SSH gerada! Adicione esta chave pública ao GitHub:${NC}"
    cat ~/.ssh/id_ed25519.pub
    read -p "Pressione Enter para continuar..."
  fi
}

# Instala Nix
install_nix() {
  if ! command -v nix >/dev/null ; then
    echo -e "${GEAR} ${BLUE}Instalando Nix...${NC}"
    mkdir -p ~/.config/nix/
    ln -sf ~/dotfiles/configs/nix.conf ~/.config/nix/
    #curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
    source /etc/profile
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon


    source /etc/profile
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    nix flake show
    nix run github:nix-community/home-manager -- switch --flake ~/dotfiles#$(whoami)
    source /etc/profile
    # . ~/.nix-profile/etc/profile.d/nix.sh
  fi
}

# Configura Neovim do Massolari
setup_neovim() {
  echo -e "${GEAR} ${BLUE}Configurando Neovim...${NC}"
  if [ ! -d ~/.config/nvim ]; then
    git clone https://github.com/Massolari/neovim ~/.config/nvim
    mkdir -p ~/.config/nvim/lua/user
    ln -sf ~/dotfiles/configs/neovim/init.lua ~/.config/nvim/lua/user/init.lua
    echo -e "${CHECK} ${GREEN}Configuração do Neovim instalada!${NC}"
  fi
}

# Configura ambiente
setup_environment() {
  echo -e "${GEAR} ${BLUE}Configurando ambiente...${NC}"


  # Cria symlinks
  ln -sf ~/dotfiles/configs/.gitconfig ~/

  # Instala programas via Nix
  echo -e "${GEAR} ${BLUE}Instalando programas...${NC}"
  nix develop ~/dotfiles --command bash -c "
    home-manager switch --flake ~/dotfiles#$(whoami)
    mkdir -p ~/Applications/bin
    ln -sf ~/.nix-profile/bin/* ~/Applications/bin/
  "
  # Configura zsh como shell padrão
  if [ "$(basename $SHELL)" != "zsh" ]; then
    echo -e "${GEAR} ${BLUE}Configurando Zsh como shell padrão...${NC}"
    command -v zsh | sudo tee -a /etc/shells
    sudo chsh -s $(which zsh)
  fi

}

main() {
  local arg1="${1:-}"
  local arg2="${2:-}"
  collect_user_info "$arg1" "$arg2"
  install_dependencies
  install_fonts
  setup_ssh
  install_nix
  setup_neovim
  setup_environment

  echo -e "${ROCKET} ${GREEN}Ambiente configurado com sucesso!${NC}"
  echo -e "Reinicie seu terminal ou execute: ${YELLOW}source ~/.zshrc${NC}"
  echo -e "Para atualizar no futuro: ${YELLOW}cd ~/dotfiles && ./update.sh${NC}"
  if [ "$(basename $SHELL)" != "zsh" ]; then
    exec zsh
  fi
}

main "$@"
