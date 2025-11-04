# current setup

root partition is encrypted. key is at /boot/keyfile.bin

note /etc/fstab

TODO: what specifies the zfs mount
  - zfs-mount.service in systemd

TODO: nvidia drivers
TODO: google coral drivers

ssd nvme0n1 has

- a /boot formatted as vfat FAT16
- second partition is crypto_LUKS
  - cryptlvm LVM2_member LVM2
    - vg0-root ext4 ~1T

- do i have any swap?

# NixOS

- does google coral work?

TODO:

- pros and cons of zfs root partition?

- some files on my root ssd got corrupted. very low corruption rate, but nonzero. how to prevent?
