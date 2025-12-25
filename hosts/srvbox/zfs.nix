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

  # Function to create ZFS snapshot systemd service and timer
  # Parameters:
  #   pool: ZFS pool name
  #   dataset: dataset name (without pool prefix)
  #   period: systemd timer OnCalendar format (e.g., "weekly", "monthly", "daily")
  mkZfsSnapshotJob =
    {
      pool,
      dataset,
      period,
    }:
    let
      fullDataset = "${pool}/${dataset}";
      # Sanitize dataset name for use in systemd unit names
      sanitizedName = builtins.replaceStrings [ "/" ] [ "-" ] dataset;
      serviceName = "zfs-snapshot-${sanitizedName}";
    in
    {
      systemd.services.${serviceName} = {
        description = "ZFS snapshot for ${fullDataset}";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.zfs}/bin/zfs snapshot ${fullDataset}@auto-$(date +%%Y-%%m-%%d-%%H%%M%%S)'";
        };
      };

      systemd.timers.${serviceName} = {
        description = "Timer for ZFS snapshots of ${fullDataset}";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = period;
          Persistent = true;
        };
      };
    };

  # Merge all snapshot jobs
  snapshotJobs = lib.mkMerge [
    (mkZfsSnapshotJob {
      pool = "zpool0";
      dataset = "photos";
      period = "weekly";
    })
    (mkZfsSnapshotJob {
      pool = "zpool0";
      dataset = "nextcloud";
      period = "daily";
    })
  ];
in
lib.mkMerge [
  snapshotJobs
  {
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
]
