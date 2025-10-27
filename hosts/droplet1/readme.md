# Digitalocean droplet setup

### Initial setup

nix run github:nix-community/nixos-anywhere -- --flake .#droplet1 --generate-hardware-config nixos-generate-config ./hosts/droplet1/hardware-configuration.nix --target-host root@165.22.138.57

#### assign password to user acct

ssh root@165.22.138.57

> passwd justin

#### Tailscale

nix installs and enables tailscale, but you still have to login. ssh into droplet and run `sudo tailscale up`.

note: once tailscale is setup, you can ssh from other computers on the tailnet via `ssh droplet1`.

### Subsequent updates

nixos-rebuild switch --flake .#droplet1 --target-host root@165.22.138.57

If the switch happens, but stuff is broken, rollback with

nixos-rebuild switch --flake .#droplet1 --rollback --target-host root@droplet1
