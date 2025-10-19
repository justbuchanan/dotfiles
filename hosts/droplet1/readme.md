# Digitalocean droplet setup

### Initial setup

nix run github:nix-community/nixos-anywhere -- --flake .#droplet1 --generate-hardware-config nixos-generate-config ./hosts/droplet1/hardware-configuration.nix --target-host root@165.22.138.57

ssh root@165.22.138.57

> passwd justin

### Subsequent updates

nixos-rebuild switch --flake .#droplet1 --target-host root@165.22.138.57
