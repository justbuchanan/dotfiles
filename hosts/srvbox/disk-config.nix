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
# TODO: luks
# TODO: efi vs bios partitions? /boot vs ESP?
#
{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02"; # TODO:?
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00"; # TODO:?
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
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
            size = "100%FREE";
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
