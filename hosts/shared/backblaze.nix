{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.backblazeBackup;
  zfs = "${config.boot.zfs.package}/bin/zfs";

  snapshotName = jobCfg: "${jobCfg.zfsDataset}@b2-backup";

  # Extra args (the exclude flag) come through "$@" so systemd parses them
  # exactly as it did when b2 was invoked from ExecStart directly.
  backupScript =
    name: jobCfg:
    let
      dest = lib.escapeShellArg "b2://${jobCfg.bucketName}";
      localPath = lib.escapeShellArg jobCfg.localPath;
    in
    pkgs.writeShellScript "backblaze-backup-${name}" (
      if jobCfg.zfsDataset == null then
        ''
          exec ${pkgs.backblaze-b2}/bin/backblaze-b2 sync "$@" ${localPath} ${dest}
        ''
      else
        ''
          set -euo pipefail
          mnt=$(${zfs} get -H -o value mountpoint ${lib.escapeShellArg jobCfg.zfsDataset})
          path=${localPath}
          if [[ $path != "$mnt" && $path != "$mnt"/* ]]; then
            echo "$path is not inside $mnt" >&2
            exit 1
          fi
          src="$mnt/.zfs/snapshot/b2-backup''${path#"$mnt"}"
          exec ${pkgs.backblaze-b2}/bin/backblaze-b2 sync "$@" "$src" ${dest}
        ''
    );

  # Generate systemd services and timers from job configurations
  jobServices = lib.mapAttrs' (
    name: jobCfg:
    let
      serviceName = "backblaze-backup-${name}";
      excludeFlag = lib.optionalString (
        jobCfg.excludeRegex != null
      ) "--exclude-regex '${jobCfg.excludeRegex}'";
    in
    lib.nameValuePair serviceName {
      description = "Backblaze B2 backup for ${jobCfg.localPath}";
      onFailure = lib.optional (cfg.notifyEmail != null) "backblaze-backup-failed@%n.service";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        EnvironmentFile = cfg.credentialsFile;
        ExecStart = "${backupScript name jobCfg} ${excludeFlag}";
      }
      // lib.optionalAttrs (jobCfg.zfsDataset != null) {
        # Sync from a snapshot so live files (e.g. a sqlite db) are uploaded
        # as one consistent point in time. "-" drops a stale leftover.
        ExecStartPre = [
          "-${zfs} destroy ${snapshotName jobCfg}"
          "${zfs} snapshot ${snapshotName jobCfg}"
        ];
        ExecStopPost = "-${zfs} destroy ${snapshotName jobCfg}";
      };
    }
  ) cfg.jobs;

  jobTimers = lib.mapAttrs' (
    name: jobCfg:
    let
      serviceName = "backblaze-backup-${name}";
    in
    lib.nameValuePair serviceName {
      description = "Timer for Backblaze B2 backup of ${jobCfg.localPath}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = jobCfg.periodicity;
        Persistent = true;
      };
    }
  ) cfg.jobs;
in
{
  options.services.backblazeBackup = {
    enable = lib.mkEnableOption "Backblaze B2 backup service";

    credentialsFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to credentials file containing B2_APPLICATION_KEY_ID and B2_APPLICATION_KEY";
    };

    notifyEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Address to email, via the default msmtp account, when a backup job fails";
    };

    jobs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            localPath = lib.mkOption {
              type = lib.types.str;
              description = "Local directory path to backup";
              example = "/mnt/zpool0/nextcloud";
            };

            bucketName = lib.mkOption {
              type = lib.types.str;
              description = "Backblaze B2 bucket name";
              example = "my-backup-bucket";
            };

            periodicity = lib.mkOption {
              type = lib.types.str;
              default = "weekly";
              description = "Systemd timer schedule (OnCalendar format)";
              example = "daily";
            };

            excludeRegex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Optional regex pattern to exclude files from backup";
              example = "\\.Trash-1000.*";
            };

            zfsDataset = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "ZFS dataset containing localPath. If set, sync from a temporary snapshot of it instead of the live files";
              example = "zpool0/nextcloud";
            };
          };
        }
      );
      default = { };
      description = "Backup job configurations";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.notifyEmail == null || config.programs.msmtp.enable;
        message = "services.backblazeBackup.notifyEmail needs programs.msmtp";
      }
    ];

    # Create systemd services and timers for each job
    systemd.services = jobServices // {
      "backblaze-backup-failed@" = lib.mkIf (cfg.notifyEmail != null) {
        description = "Email about failed backup %i";
        scriptArgs = "%i";
        serviceConfig.Type = "oneshot";
        script = ''
          {
            printf 'To: %s\nSubject: %s\n\n' ${lib.escapeShellArg cfg.notifyEmail} \
              "Backblaze backup failed on ${config.networking.hostName}: $1"
            ${config.systemd.package}/bin/journalctl -u "$1" -n 100 --no-pager
          } | ${pkgs.msmtp}/bin/msmtp -a default -t
        '';
      };
    };
    systemd.timers = jobTimers;

    # Ensure backblaze-b2 package is available
    environment.systemPackages = with pkgs; [ backblaze-b2 ];
  };
}
