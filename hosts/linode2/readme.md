# Linode $12/mo instance

Started with Arch linux

ssh root@172.238.40.177

no user accounts besides root

build user with:

$ home-manager build --flake .#justin@linode2

build machine with:

$ nixos-rebuild build --flake .#linode2

## First time install

dotfiles ❄️ ❯ nix run github:nix-community/nixos-anywhere -- --flake .#linode --target-host root@172.238.40.177

dotfiles ❄️ ❮ nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake .#linode2 --target-host root@172.238.40.177

no cpio found, it failed

https://github.com/nix-community/nixos-anywhere/issues/419

ran pacman -Syu cpio on the linode while ssh'd in

run it again...

### first attempt...

(after installing cpio)

nixos-anywhere said it worked

vps rebooted

no response to ping or ssh...

unable to login with lish console because it wants a password... and we've disabled password-based auth

### second attempt...

wiped the vps. trying debian 13 as a target instead

regenerated the hardware-config.nix again and it was the same as lasat time

failed again

was able to lish (using linode.com password, not ssh password), which showed it was stuck at grub bootloader

### 3rd attempt

wiped it again, rebuilt with debian 13 (it comes with cpio installed)

...



### 4th attempt

disabled a couple efi-related things in nix config b/c linode is bios only.

...

https://www.linode.com/community/questions/20139/how-to-use-nixos-on-zfs-on-a-linode

## later updates

nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"
