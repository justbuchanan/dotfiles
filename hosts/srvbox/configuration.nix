{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # zfs wants the hostId set. generated with `head -c 8 /etc/machine-id`.
  networking.hostId = "d94e1d7a";
  boot.zfs.extraPools = [ "zpool0" ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    ./zfs.nix
    ./samba.nix
    ./prometheus.nix
    ./dst-server.nix
    ./factorio.nix
    ./mqtt.nix
    ./homepage.nix
    ../shared/backblaze.nix
    ../shared/prometheus-exporter.nix
    ../shared/base.nix
    ../shared/graphical-and-personal.nix
  ];

  boot = {
    # Use the systemd-boot EFI boot loader instead of grub.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Enable TPM2 for LUKS unlocking of root partition
    initrd.systemd.enable = true;
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

  # secret contents should be of the form:
  #   B2_APPLICATION_KEY_ID=<id>
  #   B2_APPLICATION_KEY=<key>
  age.secrets.backblaze-b2-credentials = {
    file = ../../secrets/backblaze-b2-credentials.age;
    owner = "root";
  };

  # Backblaze B2 backup configuration
  services.backblazeBackup = {
    enable = true;
    credentialsFile = config.age.secrets.backblaze-b2-credentials.path;
    jobs = {
      nextcloud = {
        localPath = "/mnt/zpool0/nextcloud/data";
        bucketName = "justbuchanan-nextcloud-backup";
        periodicity = "weekly";
      };
      photos = {
        localPath = "/mnt/zpool0/photos";
        bucketName = "darktable-backup-august10-2024";
        periodicity = "weekly";
        excludeRegex = "\\\\.Trash-1000.*";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss # using tpm to store key for encrypted root partition
  ];

  # DONT TOUCH THIS
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
