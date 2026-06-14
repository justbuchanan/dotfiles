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

    # Hardware transcoding on the NVIDIA GTX 1070 Ti (NVENC/NVDEC). srvbox has
    # no Intel iGPU, so the old container's VaapiDevice=/dev/dri/renderD128 was a
    # no-op (renderD128 is actually the nvidia render node); nvenc is the real
    # path here.
    hardwareAcceleration = {
      enable = true;
      type = "nvenc";
      # Only used to satisfy the module's `device != null` assertion and its
      # single-entry DeviceAllow; nvenc does not write a device into
      # encoding.xml. The full set of nvidia nodes is allowed via DeviceAllow
      # below.
      device = "/dev/nvidia0";
    };

    # The existing encoding.xml has HardwareAccelerationType=none, and the module
    # refuses to overwrite a differing encoding.xml unless forced. Force it so the
    # nvenc settings below are actually applied (the old file is backed up to
    # encoding.xml.backup-<timestamp> on first apply).
    forceEncodingConfig = true;

    transcoding = {
      enableHardwareEncoding = true;
      # Pascal NVENC encodes H.264 (always on) + HEVC, incl. 10-bit. No AV1.
      hardwareEncodingCodecs.hevc = true;
      # Pascal NVDEC decode support. AV1 decode is unsupported on this GPU.
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        hevc10bit = true;
        vp9 = true;
        vc1 = true;
        mpeg2 = true;
      };
    };
  };

  # NVENC needs the nvidia userspace driver libraries (libnvidia-encode,
  # libnvcuvid, libcuda), which NixOS exposes here, plus access to all the nvidia
  # device nodes. The module only allows the single `device` above, so override
  # DeviceAllow with the full set (its DeviceAllow makes systemd switch the unit
  # to a device allowlist, so anything not listed is blocked).
  systemd.services.jellyfin = {
    environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    serviceConfig.DeviceAllow = lib.mkForce [
      "/dev/nvidia0 rw"
      "/dev/nvidiactl rw"
      "/dev/nvidia-uvm rw"
      "/dev/nvidia-uvm-tools rw"
      "/dev/nvidia-modeset rw"
    ];
  };

  # Allow the jellyfin service user to reach the GPU device nodes.
  users.users.jellyfin.extraGroups = [
    "video"
    "render"
  ];
}
