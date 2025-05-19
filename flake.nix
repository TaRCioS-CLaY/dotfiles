{
  description = "TaRCioS-CLaY's Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = builtins.currentSystem or "x86_64-linux";
      username = "clayton";
      environment.shells = with pkgs; [zsh];
      users.defaultUserShell = pkgs.zsh;

      homeDirectory =
        if system == "x86_64-linux" then "/home/${username}"
        else if system == "aarch64-darwin" || system == "x86_64-darwin" then "/Users/${username}"
        else throw "Unsupported system: ${system}";

      pkgs = import nixpkgs { inherit system; };

      homeConf = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ {
          home = {
            inherit username homeDirectory;
            stateVersion = "23.11";
          };

          home.packages = with pkgs; [
            git delta fd curl wget zsh fzf kitty lua luarocks
            zoxide lazygit xclip appimage-run fuse neovim fnm
          ];

          programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
            shellAliases = {
              ll = "ls -la";
              update-env = "cd ~/dotfiles && nix flake update && home-manager switch --flake .#${username}";
            };
            initContent = ''
              eval "$(zoxide init zsh)"
              path+=($HOME/Applications/bin)
              path+=($HOME/.local/share/nvim/mason/bin)
              export FZF_DEFAULT_COMMAND='fd --type f'
              zvm_after_init_commands+=('[ $(fzf-share)/key-bindings.zsh ] && source $(fzf-share)/completion.zsh  && source $(fzf-share)/key-bindings.zsh')
              . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
            '';
            zplug = {
              enable = true;
              plugins = [
                { name = "z-shell/F-Sy-H"; }
                { name = "jeffreytse/zsh-vi-mode"; }
                { name = "agnoster/agnoster-zsh-theme"; tags = [ as:theme ];}
                { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
              ];
            };
          };

          programs.kitty = {
            enable = true;
            font = {
              name = "JetBrainsMono Nerd Font";
              size = 14;
            };
            settings = {
              tab_bar_style = "powerline";
              include = "${./kitty-theme.conf}";
            };
            keybindings = {
              "shift+cmd+t" = "new_tab_with_cwd";
              "kitty_mod+j" = "next_tab";
              "kitty_mod+k" = "previous_tab";
              "kitty_mod+enter" = "new_window_with_cwd";
              "kitty_mod+z" = "toggle_layout stack";
            };
            themeFile = "gruvbox-dark";
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
        } ];
      };
    in {
      homeConfigurations = {
        "${username}" = homeConf;
      };

      defaultPackage.${system} = homeConf.activationPackage;

      packages = {
        "${system}" = {
          "${username}" = homeConf.activationPackage;
        };
      };
    };
}
