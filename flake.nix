{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Demora para instalar
    # nixpkgs.url = "github:nixos/nixpkgs/staging";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";
      # system = "aarch64-darwin";
      username = "claytongarcia";

      pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
      };


      homePackages = with pkgs; [
        bitwarden-cli
        elmPackages.elm-language-server
        fd
        fswatch
        fnlfmt
        neovim
        # nodejs
        # fnm
        ripgrep
        rsync
        wget
        yarn
        nodePackages.ionic
        emacs
        kitty
        postman
        nodePackages.prettier
      ];

    in {
      homeConfigurations.claytongarcia = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = {
              stateVersion = "22.11";
              inherit username;
              homeDirectory = "/Users/${username}";

              file.".config/nix/nix.conf".text = ''
                experimental-features = nix-command flakes
                '';
              # file.".npmrc".text = "prefix=~/.npm \nregistry=https://registry.npmjs.org/";

  # Install MacOS applications to the user environment.
              file."Applications/Home Manager Apps".source = let
                apps = pkgs.buildEnv {
                  name = "home-manager-applications";
                  paths = homePackages;
                  pathsToLink = "/Applications";
                };
              in "${apps}/Applications";

              packages = homePackages;
            };

            programs = {
              home-manager.enable = true;

              bat.enable = true;

              fzf.enable = true;

              git = {
                enable = true;
                userName = "Clayton Garcia";
                userEmail = "tarcios.clay@gmail.com";
                includes = [
                {
                  path = "~/tweag/.gitconfig";
                  condition = "gitdir:~/tweag/";
                }
                ];
                extraConfig = {
                  core.editor = "nvim";
                  init.defaultBranch = "main";
                  pull.ff = "only";
                  http.sslVerify = false;
                };
                delta = {
                  enable = true;
                  options.light = true;
                };
              };

              gh = {
                enable = true;
                settings = {
                  git_protocol = "ssh";
                  editor = "nvim";
                  prompt = "enable";
                };
              };

               kitty = {
                 enable = true;
                 font = {
                  name = "JetBrainsMono Nerd Font";
                  size = 14;
                };
                keybindings = {
                  "shift+cmd+t" = "new_tab_with_cwd";
                  "kitty_mod+j" = "next_tab";
                  "kitty_mod+k" = "previous_tab";
                  "kitty_mod+enter" = "new_window_with_cwd";
                  "kitty_mod+z" = "toggle_layout stack";
                };
                settings = {
                  tab_bar_style = "powerline";
                  watcher = "/Users/${username}/.fig/tools/kitty-integration.py";
                  include = "${./kitty-theme.conf}";
                };
              };

               lazygit = {
                 enable = true;
                 settings.gui.theme.lightTheme = false;
               };

               starship.enable = true;

              zsh = {
                enable = true;
                enableAutosuggestions = true;
                initExtra = ''
                    eval "$(fnm env --use-on-cd)"
                    '';
                zplug = {
                  enable = true;
                  plugins = [
                  { name = "z-shell/F-Sy-H"; }
                  { name = "jeffreytse/zsh-vi-mode"; }
                  { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
                  ];
                };
                localVariables = {
                  ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
                };
                shellAliases = {
                  lg = "lazygit";
                  nvid = "/Users/${username}/neovide/target/release/neovide";
                  ll = "ls -l";
                  ".." = "cd ..";
                  "nsx" = "nix-shell --system x86_64-darwin";
                };
              };
            };
          }
        ];
      };
  };
}
