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

  # nixpkgs.config = {
  #   allowUnfreePredicate =
  #     pkg:
  #     builtins.elem (lib.getName pkg) [
  #       "expressvpn"
  #     ];
  # };

  home.file = {
    ".tigrc".source = ./home/.tigrc;
    ".bashrc".source = ./home/.bashrc;
    ".tmux.conf".source = ./home/.tmux.conf;

    ".profile.d".source = ./home/.profile.d;

    ".config/nixpkgs/config.nix".source = ./home/.config/nixpkgs/config.nix;

    ".config/sway".source = ./home/.config/sway;
    ".config/sworkstyle/config.toml".source = ./home/.config/sworkstyle/config.toml;

    ".config/niri/autoname-workspaces.toml".source = ./home/.config/niri/autoname-workspaces.toml;
  };

  gtk = {
    enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.packages = with pkgs; [
    cheese
    expressvpn
    transmission_4-qt
    wf-recorder
    swayidle
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
    image = ./wallpapers/artist_point.jpg;
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
