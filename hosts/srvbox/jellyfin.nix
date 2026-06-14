{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.jellyfin = {
    enable = true;

    openFirewall = true;

    configDir = "/mnt/zpool0/media/jellyfin_config";
    dataDir = "/mnt/zpool0/media/jellyfin_config/data";
    cacheDir = "/mnt/zpool0/media/jellyfin_config/cache";
    logDir = "/mnt/zpool0/media/jellyfin_config/log";

    # hardwareAcceleration is intentionally left at its default (off). The
    # existing encoding.xml has HardwareAccelerationType=none, matching how the
    # container actually ran, and leaving this off means the module won't touch
    # encoding.xml. To enable GPU transcoding later, set
    # `hardwareAcceleration.enable = true` (the user is already in the video and
    # render groups below for /dev/dri access).
  };

  # Allow the jellyfin service user to reach the GPU render nodes if/when
  # hardware transcoding is turned on. Harmless while accel is off.
  users.users.jellyfin.extraGroups = [
    "video"
    "render"
  ];
}
