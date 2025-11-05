{ ... }:
{
  # samba file sharing
  # beyond this config, a password for each user must be set with:
  # smbpasswd -a <user>
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "server string" = "smbnix";
        "server role" = "standalone server";
        "disable netbios" = "yes";
        "smb ports" = "445";
        "logging" = "systemd";

        # server-side copy for macOS users - https://wiki.archlinux.org/title/Samba
        "fruit:copyfile" = "yes";

        # performance tuning
        # https://www.reddit.com/r/OpenMediaVault/comments/11gwi1g/significant_samba_speedperformance_improvement_by/
        "min receivefile size" = "16384";
        "use sendfile" = "yes";
        "vfs objects" = "io_uring";
        "aio read size" = "16384";
        "aio write size" = "16384";
      };
      justin = {
        "path" = "/mnt/zpool0/samba/justin";
        "browsable" = "true";
        "read only" = "false";
        "force create mode" = "0660";
        "force directory mode" = "2770";
        "valid users" = "justin";
      };
      justin-darktable = {
        "path" = "/mnt/zpool0/photos/darktable";
        "browsable" = "true";
        "read only" = "false";
        "force create mode" = "0660";
        "force directory mode" = "2770";
        "valid users" = "justin";
      };
      avani = {
        "path" = "/mnt/zpool0/samba/avani";
        "browsable" = "true";
        "read only" = "false";
        "force create mode" = "0660";
        "force directory mode" = "2770";
        "valid users" = "avani";
      };
    };
  };
}
