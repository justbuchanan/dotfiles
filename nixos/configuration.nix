# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # before adding this on 10/2, uname -r showed kernel 6.6.35
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  networking.hostName = "framework"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;

  # display backlight control
  programs.light.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  programs.sway.enable = true;

  programs.zsh.enable = true;




  # needed for sublime4 as of 6/30/2024
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;


  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  virtualisation.docker.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "video" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      gnome.cheese
      expressvpn
      transmission_4-qt
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
    btop
    cargo
    clang
    pulseaudio
    pkg-config
    cmake
    darktable
    dmidecode
    evince
    ffmpeg
    rustup
    fast-cli
    firefox
    fstl
    fuzzel
    gcc
    git
    gnumake
    go
    google-chrome
    gphoto2
    graphviz
    htop
    imv
    inkscape
    inxi
    jq
    kicad
    busybox
    rxvt-unicode
    mpv
    mupdf
    ncdu
    networkmanagerapplet
    nmap
    pciutils
    prusa-slicer
    rustc
    speedtest-cli
    spotify
    sublime4
    tmux
    tree
    curlFull
    vim
    vlc
    waybar
    wget
    wirelesstools
    # gives `wl-copy` and `wl-paste` for copy/pasting
    wl-clipboard
    # TODO: do we need xrdb on wayland? how to set urxvt font size?
    xorg.xrdb
    zsh
  ];

  environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

