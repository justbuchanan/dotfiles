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
    # binary cache server
    ../../nixos/cachix.nix
    ../shared/base.nix
    ../shared/graphical-and-personal.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # install firmware updater. Use with `fwupdmgr update`
  services.fwupd.enable = true;

  # Enable periodic SSD TRIM
  services.fstrim.enable = true;

  # configure gnome and x so I can share my entire screen for interview purposes
  # sway doesn't do full screen sharing
  # TODO: remove this - I think screensharing works in niri, but test it
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable fingerprint authentication for swaylock
  services.fprintd.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth sufficient pam_fprintd.so
      auth include login
    '';
  };

  networking.hostName = "framework"; # Define your hostname.

  # enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # blueman provides the blueman service and blueman-manager for managing pairing
  services.blueman.enable = true;

  # display backlight control
  programs.light.enable = true;

  # configure suspend and hibernate
  # TODO: test that this actually works
  # TODO: `systemctl suspend` works. `systemctl hibernate` seems to just shut it down completely
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    IdleAction = "hibernate";
    IdleActionSec = "30min";
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=2h
  '';
  # enable swap to allow hibernate
  swapDevices = [
    # make swapfile at least as big as physical RAM
    {
      device = "/swapfile";
      size = 32768;
    }
  ];
  # TODO: is this needed?
  # boot.kernelParams = [ "resume=UUID=<swap-uuid>" "resume_offset=<offset>" ];

  # samba client configuration
  services.samba.enable = true;
  fileSystems."/mnt/srvbox_samba_justin" = {
    device = "//srvbox.wampus-newton.ts.net/justin";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets" ];
  };
  fileSystems."/mnt/srvbox_darktable_justin" = {
    device = "//srvbox.wampus-newton.ts.net/justin-darktable";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets" ];
  };
  services.gvfs.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    # needed for sublime4 as of 6/30/2024
    "openssl-1.1.1w"
  ];

  # TODO: remove - these should be in graphical-base.nix unless this laptop specifically needs these settings.
  # Steam told me to add these
  # TODO: since we're using pipewire and not pulseaudio, we probably don't need the pulseaudio option below
  hardware.graphics.enable32Bit = true;
  services.pulseaudio.support32Bit = true; # TODO: try removing this

  # TODO: remove this
  environment.variables = {
    # https://discourse.nixos.org/t/rust-pkg-config-fails-on-openssl-for-cargo-generate/39759/2
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # DONT TOUCH THIS
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
