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
  # zfs wants the hostId set. generated with `head -c 8 /etc/machine-id`.
  networking.hostId = "d94e1d7a";
  boot.zfs.extraPools = [ "zpool0" ];
  services.zfs.autoScrub.enable = true;

  # Configure ZED to send email notifications
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "justbuchanan@gmail.com" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "-a default";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    # ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  services.zfs.zed.enableMail = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    ./samba.nix
    ../shared/base.nix
    ../shared/graphical-and-personal.nix
    # binary cache server
    ../../nixos/cachix.nix
    inputs.niri.nixosModules.niri
  ];

  boot = {
    # Use the systemd-boot EFI boot loader instead of grub.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Enable TPM2 for LUKS unlocking of root partition
    initrd.systemd.enable = true;

    # https://wiki.nixos.org/wiki/ZFS
    # use a kernel that works with the latest zfs modules
    kernelPackages = latestKernelPackage;
    # We're not using zfs to boot, but add it here to ensure the kernel selection above works
    supportedFilesystems = [ "zfs" ];
  };
  security.tpm2.enable = true;

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

  # open up ports for don't starve together
  networking.firewall.allowedTCPPorts = [
    10998
    10999
    11000
  ];
  networking.firewall.allowedUDPPorts = [
    10998
    10999
    11000
  ];

  # Enable periodic SSD TRIM
  services.fstrim.enable = true;

  networking.hostName = "srvbox";

  # # enable bluetooth
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  # # blueman provides the blueman service and blueman-manager for managing pairing
  # services.blueman.enable = true;

  # # display backlight control
  # programs.light.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    # needed for sublime4 as of 6/30/2024
    "openssl-1.1.1w"
  ];

  hardware.nvidia-container-toolkit.enable = true;

  hardware.coral.usb.enable = true;

  # keyd service for custom keyboard remapping
  services.keyd.enable = true;
  environment.etc."keyd/default.conf".text = ''
    # The config below is needed to appropriately map the media keys on my
    # WASD V2 keyboard
    [ids]
    *
    [main]
    insert = playpause
    delete = previoussong
    end = nextsong
    pause = mute
    pageup = volumeup
    pagedown = volumedown
  '';

  # define avani's account for use with samba shared drives
  users.users.avani = {
    isNormalUser = true;
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss # using tpm to store key for encrypted root partition
  ];

  # DONT TOUCH THIS
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
