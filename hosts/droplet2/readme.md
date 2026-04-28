# Digitalocean droplet setup

### Initial setup

nix run github:nix-community/nixos-anywhere -- --flake .#droplet2 --generate-hardware-config nixos-generate-config ./hosts/droplet2/hardware-configuration.nix --target-host root@droplet2

#### assign password to user acct

ssh root@droplet2

> passwd justin

#### Tailscale

nix installs and enables tailscale, but you still have to login. ssh into droplet and run `sudo tailscale up`.

note: once tailscale is setup, you can ssh from other computers on the tailnet via `ssh droplet2`.

### Subsequent updates

nixos-rebuild switch --flake .#droplet2 --target-host root@droplet2

If the switch happens, but stuff is broken, rollback with

nixos-rebuild switch --flake .#droplet2 --rollback --target-host root@droplet2
