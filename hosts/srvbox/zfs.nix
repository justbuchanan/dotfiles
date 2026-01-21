{
  lib,
  config,
  pkgs,
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

  snapshotJobs = [
    { pool = "zpool0"; dataset = "photos"; period = "weekly"; }
    { pool = "zpool0"; dataset = "nextcloud"; period = "daily"; }
  ];

  mkServiceName = job: "zfs-snapshot-${builtins.replaceStrings [ "/" ] [ "-" ] job.dataset}";
  mkFullDataset = job: "${job.pool}/${job.dataset}";
in
{
  systemd.services = builtins.listToAttrs (map (job: {
    name = mkServiceName job;
    value = {
      description = "ZFS snapshot for ${mkFullDataset job}";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.zfs}/bin/zfs snapshot ${mkFullDataset job}@auto-$(date +%%Y-%%m-%%d-%%H%%M%%S)'";
      };
    };
  }) snapshotJobs);

  systemd.timers = builtins.listToAttrs (map (job: {
    name = mkServiceName job;
    value = {
      description = "Timer for ZFS snapshots of ${mkFullDataset job}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = job.period;
        Persistent = true;
      };
    };
  }) snapshotJobs);

  # zfs scrub checks for and repairs disk errors. enabling the service makes
  # sure this runs periodically (every 2 weeks?)
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

  boot = {
    # https://wiki.nixos.org/wiki/ZFS
    # use a kernel that works with the latest zfs modules
    kernelPackages = latestKernelPackage;
    # We're not using zfs to boot, but add it here to ensure the kernel
    # selection above works
    supportedFilesystems = [ "zfs" ];
  };
}
