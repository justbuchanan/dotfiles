# initially copied from nixos-anywhere-examples repo
#
# Notes:
# * *WARNING* be very careful not touch /dev/{sda,sdb,sdc,sdd} - these are an existing zfs array that we don't want to touch.
# * no swap partition
#   * we have lots of RAM
#   * we have no plans to enable hibernation
#     * the computer is always busy with server stuff, recording security cam videos, etc
#     * hibernation with zfs is potentially dangerous
#
{ lib, ... }:
{
  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "NIXBOOT";
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
