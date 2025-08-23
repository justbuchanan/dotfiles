# NixOS main config file
#
# For documentation on this file, refer to:
# * `man configuration.nix` in the terminal
# * https://search.nixos.org/options
# * NixOS manual (`nixos-help`)

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # before adding this on 10/2, uname -r showed kernel 6.6.35
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  # attempt to allow fingerprint auth for swaylock - not currently working
  # services.fprintd.enable = true;
  # security.pam.services.swaylock = {
  #   text = ''
  #     auth sufficient pam_unix.so try_first_pass likeauth nullok
  #     auth sufficient pam_fprintd.so
  #     auth include login
  #   '';
  # };

  networking.hostName = "framework"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.enable = true;
  services.printing.drivers = [pkgs.gutenprint pkgs.hplip pkgs.cups-dymo];
  services.system-config-printer.enable = true;

  # enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # blueman provides the blueman service and blueman-manager for managing pairing
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # display backlight control
  programs.light.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  programs.dconf.enable = true;

  security.polkit.enable = true;

  # inspired by https://github.com/sjcobb2022/nixos-config/blob/6661447a3feb6bea97eac5dc04d3a82aaa9cdcc9/hosts/common/optional/greetd.nix
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.zsh.enable = true;

  programs.seahorse.enable = true;

  programs.steam.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    # needed for sublime4 as of 6/30/2024
    "openssl-1.1.1w"
    # needed as of ~7/30/2025
    "libsoup-2.74.3"
  ];

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Steam told me to add these
  # TODO: since we're using pipewire and not pulseaudio, we probably don't need the pulseaudio option below
  hardware.graphics.enable32Bit = true;
  services.pulseaudio.support32Bit = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "video" # allow changing screen brightness (among other things) without sudo
      "dialout" # access to /dev/tty* devices without sudo
    ];
    packages = with pkgs; [
      cheese
      # TODO: as of feb 11, expressvpn is broken. temporarily disabling it
      # expressvpn
      transmission_4-qt
      nextcloud-client
    ];
  };

  # font awesome is needed for waybar to work correctly
  fonts.packages = with pkgs; [
    font-awesome
    dejavu_fonts
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # INSERT-NEW-PACKAGES-HERE
    blender
    btop
    # cargo
    clang
    cmake
    cryptsetup
    colordiff
    # # editor for cadquery
    # inputs.cadquery.packages.${pkgs.system}.cq-editor
    curlFull
    darktable
    dmidecode
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
    python312Full
    # rustc
    speedtest-cli
    spotify
    sqlite
    sublime4
    swayest-workstyle
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

  environment.variables = {
    EDITOR = "vim";

    # https://discourse.nixos.org/t/rust-pkg-config-fails-on-openssl-for-cargo-generate/39759/2
    PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
