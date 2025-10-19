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
    ./home/programs/hyprland.nix
    ./home/programs/niri.nix
    ./home/programs/starship.nix
    ./home/programs/zsh.nix
    ./home/programs/waybar-niri.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".tigrc".source = ./home/.tigrc;
    ".bashrc".source = ./home/.bashrc;
    ".tmux.conf".source = ./home/.tmux.conf;

    ".profile.d".source = ./home/.profile.d;

    ".config/nixpkgs/config.nix".source = ./home/.config/nixpkgs/config.nix;

    ".config/sway".source = ./home/.config/sway;
    ".config/sworkstyle/config.toml".source = ./home/.config/sworkstyle/config.toml;

    ".config/niri/autoname-workspaces.toml".text = ''
      # # make the focused window icon big and gold/orange
      # focused_format = "<span foreground='#E58606'><big>{}</big></span>"
      focused_format = "<span foreground='#${config.lib.stylix.colors.base09}'>{}</span>"
    '';
  };

  gtk.enable = true;

  home.packages = with pkgs; [
    cheese
    expressvpn
    transmission_4-qt
    wf-recorder
    swayidle
    imagemagick
    nil # nix lsp
    inputs.niri-autoname-workspaces.packages.${pkgs.system}.default
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

  programs.nixvim = {
    enable = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # Options: latte, frappe, macchiato, mocha
      };
    };

    opts = {
      number = true;
      relativenumber = false;
    };

    plugins.gitsigns = {
      enable = true;
    };

    keymaps = [
      {
        mode = "i";
        key = "jj";
        action = "<Esc>";
      }
    ];
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Hack Nerd Font Mono";
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
    image = ./wallpapers/maple_loop_pass.jpg;
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
