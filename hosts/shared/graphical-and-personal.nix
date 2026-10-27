# Some configs for graphical (not terminal-only) systems that I personally own
# (i.e. not a work computer). In practice, these are settings shared between my
# laptop and my desktop.
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./msmtp.nix
    inputs.claude-desktop.nixosModules.default
  ];

  programs.claude-desktop = {
    enable = true;
    cowork.kvmUsers = [ "justin" ];
  };
  # Claude Desktop downloads its own generic-linux claude-code binary into
  # ~/.config/Claude/claude-code/, which can't run without nix-ld (exit 127,
  # "Could not start dynamically linked executable").
  programs.nix-ld.enable = true;

  programs.steam.enable = true;

  networking.networkmanager.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # font awesome is needed for waybar to work correctly
  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "docker"
      "video" # allow changing screen brightness (among other things) without sudo
      "dialout" # access to /dev/tty* devices without sudo
      "gmail-token-access" # allow reading gmail token secret
      "render"
    ];
  };

  # Configure agenix - this is the keyfile for decrypting secrets
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  hardware.gpgSmartcards.enable = true;

  # greetd tui login manager
  # inspired by https://github.com/sjcobb2022/nixos-config/blob/6661447a3feb6bea97eac5dc04d3a82aaa9cdcc9/hosts/common/optional/greetd.nix
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # window manager
  programs.niri.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # protonvpn
  # https://discourse.nixos.org/t/how-to-configure-and-use-proton-vpn-on-nixos/65837/2
  networking.firewall.checkReversePath = false;

  # Printers
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
    pkgs.cups-dymo
  ];
  services.system-config-printer.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    # needed for gpu passthrough
    daemon.settings.features.cdi = true;
  };

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # dev/net tooling kept off the internet-facing droplet
    cachix
    cryptsetup
    dmidecode
    gnumake
    go
    home-manager
    inetutils
    inxi
    nix-index
    nmap
    openssl.dev
    pkg-config
    python313
    socat
    speedtest-cli
    sqlite

    inputs.oasis.packages.${pkgs.stdenv.hostPlatform.system}.oasis-client
    system-config-printer
    lazygit
    google-chrome
    gphoto2
    kdePackages.dolphin
    zenity
    brightnessctl
    evince
    firefox
    foot
    fstl
    fuzzel
    tuigreet
    grim
    imv
    inkscape
    # kdePackages.kdenlive
    kicad
    gnome-mines
    mako
    mpv
    mupdf
    slurp
    networkmanagerapplet
    obsidian
    openscad-unstable
    simple-scan
    spotify
    sublime4
    swaylock
    vscode
    waybar
    thunar
    tumbler # thumbnail generator for thunar
    # weather widget for waybar
    wttrbar
    xwayland-satellite
    # Relicensed unfree in nixpkgs (bundled proprietary network plugin, AGPL
    # violation per SFC: NixOS/nixpkgs#415821), so Hydra no longer builds it
    # and every nixpkgs bump means compiling it locally. Re-enable if upstream
    # or packaging resolves it.
    # bambu-studio
    blender
    prusa-slicer
    vlc
    # gives `wl-copy` and `wl-paste` for copy/pasting
    wl-clipboard
    pulseaudio
    # editor for cadquery
    inputs.cadquery.packages.${pkgs.stdenv.hostPlatform.system}.cq-editor
    # mediaplayer displays spotify current song in waybar
    (pkgs.callPackage ../../packages/mediaplayer.nix { src = inputs.mediaplayer; })
    wev # wev tells you what the keycode/name is for each key you press
    wirelesstools
    playerctl
    cifs-utils
    treefmt
    shfmt
    cargo
    clang
    claude-code
    (pkgs.callPackage ../../packages/kimi-code.nix { })
    cmake
    proton-vpn
    espeak
    ffmpeg
    gcc
    nautilus
    graphviz
    poppler-utils
    rustup
    libnotify
    mediainfo
    nixfmt
    pciutils
    rustc
    backblaze-b2
  ];
}
