{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.backblazeBackup;

  # Generate systemd services and timers from job configurations
  jobServices = lib.mapAttrs' (
    name: jobCfg:
    let
      serviceName = "backblaze-backup-${name}";
      excludeFlag = lib.optionalString (jobCfg.excludeRegex != null) "--exclude-regex '${jobCfg.excludeRegex}'";
    in
    lib.nameValuePair serviceName {
      description = "Backblaze B2 backup for ${jobCfg.localPath}";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        EnvironmentFile = cfg.credentialsFile;
        ExecStart = "${pkgs.backblaze-b2}/bin/backblaze-b2 sync ${excludeFlag} ${jobCfg.localPath} b2://${jobCfg.bucketName}";
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
          };
        }
      );
      default = { };
      description = "Backup job configurations";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create systemd services and timers for each job
    systemd.services = jobServices;
    systemd.timers = jobTimers;

    # Ensure backblaze-b2 package is available
    environment.systemPackages = with pkgs; [ backblaze-b2 ];
  };
}
