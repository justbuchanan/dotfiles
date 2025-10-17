{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./home/programs/niri.nix
    ./home/programs/hyprland.nix
    ./home/programs/git.nix
  ];

  home.file = {
    ".tigrc".source = ./home/.tigrc;
    ".vimrc".source = ./home/.vimrc;
    ".vim".source = ./home/.vim;
    ".bashrc".source = ./home/.bashrc;
    ".zshrc".source = ./home/.zshrc;
    ".p10k.zsh".source = ./home/.p10k.zsh;
    ".tmux.conf".source = ./home/.tmux.conf;

    ".config/foot/foot.ini".source = ./home/.config/foot/foot.ini;

    ".profile.d".source = ./home/.profile.d;

    ".config/nixpkgs/config.nix".source = ./home/.config/nixpkgs/config.nix;

    ".config/sway".source = ./home/.config/sway;
    ".config/sworkstyle/config.toml".source = ./home/.config/sworkstyle/config.toml;

    ".config/niri/autoname-workspaces.toml".source = ./home/.config/niri/autoname-workspaces.toml;

    ".config/gtk-3.0/settings.ini".source = ./home/.config/gtk-3.0/settings.ini;
    ".gtkrc-2.0".source = ./home/.gtkrc-2.0;
  };

  home.packages = with pkgs; [
    cheese
    expressvpn
    transmission_4-qt
    wf-recorder
    swayidle
    nil # nix lsp
    inputs.niri-autoname-workspaces.packages.${pkgs.system}.default
    inputs.ghostty.packages.${pkgs.system}.default
    # gopsuinfo for waybar system monitoring
    (callPackage ./packages/gopsuinfo.nix { })
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.05";
}
