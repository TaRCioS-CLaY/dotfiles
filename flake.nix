{
  description = "TaRCioS-CLaY's Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # system = "x86_64-darwin";
      system = "x86_64-linux";
      username = "$(whoami)";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations.username = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [{
          home = {
            inherit username;
            homeDirectory = "/Users/${username}";
            stateVersion = "23.11";
          };

          home.packages = with pkgs; [
            git
            delta
            fd
            curl
            wget
            zsh
            fzf
            kitty
            lua
            luarocks
            zoxide
            lazygit
            xclip
            appimage-run
            fuse
            neovim
          ];

          programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;
            shellAliases = {
              ll = "ls -la";
              update-env = "cd ~/dotfiles && nix flake update && home-manager switch --flake .#$(whoami)";
            };
            initExtra = ''
              eval "$(zoxide init zsh)"
              path+=($HOME/Applications/bin)
              path+=($HOME/.local/share/nvim/mason/bin)
              export FZF_DEFAULT_COMMAND='fd --type f'
            '';
          };

          programs.zplug = {
            enable = true;
            plugins = [
              { name = "z-shell/F-Sy-H"; }
              { name = "jeffreytse/zsh-vi-mode"; }
              { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
            ];
          };

          programs.kitty = {
            enable = true;
            font = {
              name = "JetBrainsMono Nerd Font";
              size = 14;
            };
            settings = {
              # enabled_layouts = "stack";
              # window_padding_width = 10;
              # background_opacity = "0.9";
              tab_bar_style = "powerline";
              # watcher = "/Users/${username}/.fig/tools/kitty-integration.py";
              include = "${./kitty-theme.conf}";
            };
            keybindings = {
              "shift+cmd+t" = "new_tab_with_cwd";
              "kitty_mod+j" = "next_tab";
              "kitty_mod+k" = "previous_tab";
              "kitty_mod+enter" = "new_window_with_cwd";
              "kitty_mod+z" = "toggle_layout stack";
            };
            theme = "Gruvbox Dark";
          };

          programs.lazygit = {
            enable = true;
            settings = {
              gui.theme = {
                lightTheme = false;
                activeBorderColor = ["#fabd2f" "bold"];
                inactiveBorderColor = ["#665c54"];
              };
            };
          };
        }];
      };
    };
}
