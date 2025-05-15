#!/usr/bin/env bash

set -euo pipefail

echo "🔄 Atualizando dotfiles..."
cd ~/dotfiles

# Atualiza repositório
git pull

# Atualiza Neovim
cd ~/.config/nvim
git pull
cd ~/dotfiles

# Atualiza ambiente Nix
nix flake update
home-manager switch --flake .#$(whoami)

echo "✅ Ambiente atualizado com sucesso!"
