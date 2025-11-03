{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  # search for the newest kernel that's compatible with the latest zfs modules
  # https://wiki.nixos.org/wiki/ZFS
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;

  # https://wiki.nixos.org/wiki/ZFS
  # use a kernel that works with the latest zfs modules
  boot.kernelPackages = latestKernelPackage;
  # We're not using zfs to boot, but add it here to ensure the kernel selection above works
  boot.supportedFilesystems = [ "zfs" ];
  # zfs wants the hostId set. generated with `head -c 8 /etc/machine-id`.
  networking.hostId = "d94e1d7a";
  boot.zfs.extraPools = [ "zpool0" ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    # # binary cache server
    # ../../nixos/cachix.nix # TODO: re-enable
    inputs.niri.nixosModules.niri
  ];

  # Set time zone
  time.timeZone = "America/Los_Angeles";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable TPM2 for LUKS unlocking of root partition
  boot.initrd.systemd.enable = true;
  security.tpm2.enable = true;

  programs.zsh.enable = true;
  programs.seahorse.enable = true;

  programs.steam.enable = true;
  # # Steam told me to add these
  # # TODO: since we're using pipewire and not pulseaudio, we probably don't need the pulseaudio option below
  # hardware.graphics.enable32Bit = true;
  # services.pulseaudio.support32Bit = true; # TODO: try removing this

  # https://nixos.wiki/wiki/Nvidia
  hardware.graphics.enable = true;
  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # install firmware updater. Use with `fwupdmgr update`
  services.fwupd.enable = true;

  # Enable periodic SSD TRIM
  services.fstrim.enable = true;

  # configure gnome and x so I can share my entire screen for interview purposes
  # sway doesn't do full screen sharing
  services.xserver.enable = true; # TODO: disable xserver ?
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;

  networking.hostName = "srvbox";
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--ssh" ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Printers
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
    pkgs.cups-dymo
  ];
  services.system-config-printer.enable = true;

  # # enable bluetooth
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  # # blueman provides the blueman service and blueman-manager for managing pairing
  # services.blueman.enable = true;

  # # display backlight control
  # programs.light.enable = true;

  # English
  i18n.defaultLocale = "en_US.UTF-8";

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

  security.polkit.enable = true;

  # # samba configuration
  # services.samba.enable = true;
  # services.gvfs.enable = true;

  # greetd tui login manager
  # inspired by https://github.com/sjcobb2022/nixos-config/blob/6661447a3feb6bea97eac5dc04d3a82aaa9cdcc9/hosts/common/optional/greetd.nix
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session --user-menu";
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

  # window managers
  programs.niri.enable = true;
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

  nixpkgs.config.permittedInsecurePackages = [
    # needed for sublime4 as of 6/30/2024
    "openssl-1.1.1w"
  ];

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

  hardware.coral.usb.enable = true;

  services.expressvpn.enable = true;

  # keyd service for custom keyboard remapping
  services.keyd.enable = true;
  environment.etc."keyd/default.conf".source = ../../etc/keyd/default.conf;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "video" # allow changing screen brightness (among other things) without sudo
      "dialout" # access to /dev/tty* devices without sudo
    ];
  };

  # font awesome is needed for waybar to work correctly
  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tpm2-tss # using tpm to store key for encrypted root partition
    cifs-utils
    treefmt
    shfmt
    xwayland-satellite
    blender
    btop
    cachix
    cargo
    socat
    clang
    claude-code
    cmake
    cryptsetup
    colordiff
    # TODO: re-enable cadquery - there's a hash mismatch preventing building
    # # editor for cadquery
    # inputs.cadquery.packages.${pkgs.system}.cq-editor
    curlFull
    darktable
    home-manager
    dmidecode
    kdePackages.dolphin
    zenity
    espeak
    evince
    fast-cli
    ffmpeg
    firefox
    foot
    fstl
    fuzzel
    gcc
    git
    gnumake
    go
    google-chrome
    gphoto2
    graphviz
    tuigreet
    grim
    htop
    imv
    inkscape
    inxi
    jq
    kdePackages.kdenlive
    kicad
    gnome-mines
    pkg-config
    poppler_utils
    pulseaudio
    rustup
    busybox
    libnotify
    mako
    mediainfo
    mpv
    mupdf
    # provides `nix-locate` which tells you which package provides which file/binary
    nix-index
    ncdu
    neofetch
    slurp
    networkmanagerapplet
    nixfmt-rfc-style
    nmap
    obsidian
    openscad
    openssl
    openssl.dev
    pciutils
    pkg-config
    playerctl
    prusa-slicer
    python313
    rustc
    speedtest-cli
    spotify
    sqlite
    sublime4
    swaylock
    system-config-printer
    tig
    tmux
    tree
    vlc
    vscode
    waybar
    # mediaplayer displays spotify current song in waybar
    inputs.mediaplayer.packages.${pkgs.system}.default
    wev # wev tells you what the keycode/name is for each key you press
    wget
    wirelesstools
    xfce.thunar
    # gives `wl-copy` and `wl-paste` for copy/pasting
    wl-clipboard
    # weather widget for waybar
    wttrbar
    zip
    zsh
  ];

  # environment.variables = {
  #   # https://discourse.nixos.org/t/rust-pkg-config-fails-on-openssl-for-cargo-generate/39759/2
  #   PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  # };

  # DONT TOUCH THIS
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
