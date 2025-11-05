{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./home/programs/git.nix
    ./home/programs/niri.nix
    ./home/programs/starship.nix
    ./home/programs/zsh.nix
    ./home/programs/vim.nix
    ./home/programs/waybar-niri.nix
    ./home/programs/sway.nix
    ./home/programs/darktable.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".tigrc".source = ./home/.tigrc;
    ".bashrc".source = ./home/.bashrc;
    ".tmux.conf".source = ./home/.tmux.conf;

    ".profile.d".source = ./home/.profile.d;

    ".config/nixpkgs/config.nix".source = ./home/.config/nixpkgs/config.nix;

    ".config/sublime-text/Packages/User/clang_format_custom.sublime-settings".source =
      ./home/.config/sublime-text-3/Packages/User/clang_format_custom.sublime-settings;
    ".config/sublime-text/Packages/User/clang_format.sublime-settings".source =
      ./home/.config/sublime-text-3/Packages/User/clang_format.sublime-settings;
    ".config/sublime-text/Packages/User/Default.sublime-keymap".source =
      ./home/.config/sublime-text-3/Packages/User/Default.sublime-keymap;
    #".config/sublime-text/Packages/User/Package Control.sublime-settings".source = (./home/.config/sublime-text-3/Packages/User + "/Package Control.sublime-settings");
    ".config/sublime-text/Packages/Declarative/Preferences.sublime-settings".source =
      ./home/.config/sublime-text-3/Packages/User/Preferences.sublime-settings;
    ".config/sublime-text/Packages/User/Python.sublime-settings".source =
      ./home/.config/sublime-text-3/Packages/User/Python.sublime-settings;
    ".config/sublime-text/Packages/User/RustFmt.sublime-settings".source =
      ./home/.config/sublime-text-3/Packages/User/RustFmt.sublime-settings;
  };

  gtk.enable = true;

  home.packages = with pkgs; [
    age
    inputs.agenix.packages.${pkgs.system}.default
    baobab
    cheese
    expressvpn
    transmission_4-qt
    darktable
    docker-compose
    wf-recorder
    systemctl-tui
    imagemagick
    nil # nix lsp
    yazi # tui file manager
    # gopsuinfo for waybar system monitoring
    (callPackage ./packages/gopsuinfo.nix { })
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # TODO: https://tip.ghostty.org/docs/linux/systemd
  # tl;dr: running the systemd service, then launching ghostty with +new-window
  # makes it much faster.
  programs.ghostty = {
    # systemd activation is buggy - see https://github.com/nix-community/home-manager/issues/8027
    systemd.enable = false;
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "Hack Nerd Font Mono";
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
      # https://ghostty.org/docs/help/terminfo#ssh
      # https://ghostty.org/docs/config/reference#shell-integration-features
      # shell-integration-features = "ssh-terminfo, ssh-env";
      shell-integration-features = "ssh-env";
    };
  };

  programs.zed-editor = {
    enable = true;

    userSettings = {
      vim_mode = true;
      base_keymap = "SublimeText";

      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };
  };

  programs.ssh.enableDefaultConfig = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.gnome-keyring.enable = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    image = ./home/wallpapers/maple_loop_pass.jpg;
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
    };
  };

  home.stateVersion = "24.05";
}
