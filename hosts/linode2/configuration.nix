# for reference: https://github.com/nix-community/nixos-anywhere-examples/blob/main/flake.nix
# also linode-config.nix from nixpkgs

{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:

{
  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # from nixos-anywhere-examples
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    # (modulesPath + "/virtualisation/linode-config.nix")
    ./disk-config.nix

    # binary cache server
    # ../../nixos/cachix.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;

  # Set time zone
  time.timeZone = "America/Los_Angeles";

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  # services.gnome.gnome-keyring.enable = true;

  networking.hostName = "linode2"; # Define your hostname.
  # networking.networkmanager.enable = true;

  # networking.nameservers = [
  #   "1.1.1.1"
  #   "9.9.9.9"
  # ];
  # networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  # English
  i18n.defaultLocale = "en_US.UTF-8";

  # TODO: needed?
  security.polkit.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # framework pub key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkuyGPOZqQulvy1LzD6Mxxh6RIKoRxXBvgnT4VTDUWh9GlnoAaH3LZvIIs0QWPHycKeg+U0aHv78BJh3zASZrpuj3oBdgItC8vSbzb4ApS1N89i03V6ndrJpBjwPKS6SRFhWmUIxsZffTkPYhZiLRhQvzek/obyyfvQVSODcbOfWR3bIkgULDD1DxcM5I+YGVNVAWDgYpP1NpMG4AgEvGtkYxJ8et/9xtiPX1+xW2D+q79wjvkgbGYEqCaLUBhOYdRPpMvAT9UKWW/nQjXH+4sz/cHNs9+1HT4jccNzLWgreEclf3Wm2tL/P46KRB5mK2MxD+E2dwvJr27CYTiBSPAoiHqIufJ3t9XtGpOwNrELgwWq5Y6/TLiggaNiaAPo1Cd0TG6RbotLxnkoKn4WrL78ATyayTQYvvkWt7wfaZSUBk1cmvPuz1vo8YFd5V8ti6tMT0ebwKtwyAeOmMyEEZJZcafQa3wvAl1adiloUMfR1ID26U/1XAShs4LU3czMT8= justbuchanan+framework_laptop@gmail.com"
    # desktop
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLWMt2PD0SLElE+QP7+kOVTV7w6gU5ufKaHCnavzRJHVsBlTni6LDAzC/rksaSl099QN0Piot3x2dIGVcYpdr4Lsxz1sL86nw80jHiLYwPOsIuNgLuWUdBMMW0qhbP9agh6I7ZdF5DCwSJzJ6F1kYIF09Vs4+s4EVYzc495Pm5GEJTnjYtG9ndaH0k0GVV67VbZ1CjuMwN9/dw7rpC/tNFv2vwTmQyoQdDckAKmjn8yLm80BtGdnC+JAJzie9/Ve3AtOr4Y6qQvQdUQu5ujEdzUKiukGfanPH2aTLdDUP51CN7e3Nq8ufqFOKhKLyvwSlMTQWaSU5N+bxHBh+d2rVE+XRJKZZWTkiQxo/cnCoBRuS6vLs99tAmciC8Wphd65KzVEjuLpXhOU96kxJ9dHBSyubiMrzBDWJi/PoMWo6ypqU2RcKDuxT5K78ZOSZSq1qQKdPpJKEwUoCHBoMfjtylhFrryuLqEfFAV3Up1+hrnfI6J/LMjuFWXyN13yCCQhs= justbuchanan+srvbox@gmail.com"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    cachix
    socat
    cryptsetup
    colordiff
    curlFull
    home-manager
    dmidecode
    fast-cli
    git
    gnumake
    go
    inxi
    jq
    busybox
    # provides `nix-locate` which tells you which package provides which file/binary
    nix-index
    ncdu
    neofetch
    nmap
    openssl
    openssl.dev
    python313
    speedtest-cli
    sqlite
    tig
    tmux
    tree
    wget
    zip
    zsh

    # Install diagnostic tools for Linode support
    inetutils
    mtr
    sysstat
  ];

  # DONT TOUCH THIS
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  # BELOW COPIED FROM linode-config.nix in nixpkgs

  services.openssh = {
    enable = true;

    # settings.PermitRootLogin = "prohibit-password";
    # settings.PasswordAuthentication = false;
    settings.PasswordAuthentication = true;
  };

  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = false;
    interfaces.eth0 = {
      useDHCP = true;

      # Linode expects IPv6 privacy extensions to be disabled, so disable them
      # See: https://www.linode.com/docs/guides/manual-network-configuration/#static-vs-dynamic-addressing
      tempAddress = "disabled";
    };
  };

  # fileSystems."/" = {
  #   fsType = "ext4";
  #   device = "/dev/sda";
  #   autoResize = true;
  # };

  # swapDevices = mkDefault [ { device = "/dev/sdb"; } ];

  # Enable LISH and Linode Booting w/ GRUB
  boot = {
    # Add Required Kernel Modules
    # NOTE: These are not documented in the install guide
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    # Set Up LISH Serial Connection
    kernelParams = [ "console=ttyS0,19200n8" ];
    kernelModules = [ "virtio_net" ];

    loader = {
      # Increase Timeout to Allow LISH Connection
      # NOTE: The image generator tries to set a timeout of 0, so we must force
      timeout = lib.mkForce 10;

      grub = {
        enable = true;
        forceInstall = true;
        # device = "nodev";
        # device = "/dev/sda1";
        # device = "/dev/sda";

        # no need to set devices, disko will add all devices that have a EF02 partition to the list already
        devices = [ ];
        # efiSupport = true;
        # efiInstallAsRemovable = true;

        # Allow serial connection for GRUB to be able to use LISH
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
      };
    };
  };
}
