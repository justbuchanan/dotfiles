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

4. After installation, you'll need to:
   - Regenerate hardware-configuration.nix with nixos-generate-config
   - Enroll TPM2: systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7
     /dev/nvme0n1p2
   - Set a recovery password: cryptsetup luksAddKey /dev/nvme0n1p2
5. Optional improvements:


    - Boot timeout: Add boot.loader.timeout = 1; for faster boots
    - Consider removing Steam/gaming stuff if this is purely a server
