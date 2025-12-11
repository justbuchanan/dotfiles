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
  ];

  programs.steam.enable = true;
  # # Steam told me to add these
  # # TODO: since we're using pipewire and not pulseaudio, we probably don't need the pulseaudio option below
  # hardware.graphics.enable32Bit = true;
  # services.pulseaudio.support32Bit = true; # TODO: try removing this

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

  services.expressvpn.enable = true;

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

  # Gmail token is viewable by users in the gmail-token-access group
  users.groups.gmail-token-access = { };
  age.secrets.buchanan-smarthome-gmail-token = {
    file = ../../secrets/buchanan-smarthome-gmail-token.age;
    owner = "root";
    group = "gmail-token-access";
    mode = "0440";
  };

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

  # Printers
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
    pkgs.cups-dymo
  ];
  services.system-config-printer.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

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
    (pkgs.callPackage ../../packages/gmail-send.nix { inherit config; })
    inputs.oasis.packages.${pkgs.stdenv.hostPlatform.system}.oasis-client
    system-config-printer
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
    kdePackages.kdenlive
    kicad
    gnome-mines
    mako
    mpv
    mupdf
    slurp
    networkmanagerapplet
    obsidian
    openscad
    spotify
    sublime4
    swaylock
    vscode
    waybar
    xfce.thunar
    xfce.tumbler # thumbnail generator for thunar
    # weather widget for waybar
    wttrbar
    xwayland-satellite
    blender
    prusa-slicer
    vlc
    # gives `wl-copy` and `wl-paste` for copy/pasting
    wl-clipboard
    pulseaudio
    # editor for cadquery
    inputs.cadquery.packages.${pkgs.stdenv.hostPlatform.system}.cq-editor
    # mediaplayer displays spotify current song in waybar
    inputs.mediaplayer.packages.${pkgs.stdenv.hostPlatform.system}.default
    wev # wev tells you what the keycode/name is for each key you press
    wirelesstools
    playerctl
    cifs-utils
    treefmt
    shfmt
    cargo
    clang
    claude-code
    cmake
    espeak
    ffmpeg
    gcc
    gnumake
    graphviz
    poppler-utils
    rustup
    libnotify
    mediainfo
    nixfmt-rfc-style
    pciutils
    rustc
  ];
}
