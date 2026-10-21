---
name: deploy-droplet2
description: Deploy this repo's NixOS config to droplet2 (the DigitalOcean VPS running Caddy, Authelia, and site containers like mexico2026). Use when asked to deploy, push config, or apply a change to droplet2, including after editing hosts/droplet2/* or a secret droplet2 uses.
---

# Deploying to droplet2

droplet2 is `nixosConfigurations.droplet2` in `flake.nix`, built from
`hosts/droplet2/`. It's reached over Tailscale as `root@droplet2`.

## Steps

1. Commit and push first so the deployed config matches `main`.

2. Check SSH. Tailscale SSH sometimes requires a browser check:
   ```sh
   timeout 15 ssh -o BatchMode=yes root@droplet2 true
   ```
   If it prints `Tailscale SSH requires an additional check` with a
   `login.tailscale.com` URL (or just hangs), give the URL to the user and
   wait for them to say they've authenticated. You can't do this step yourself.

3. Deploy from the repo root (this builds locally, then copies the closure
   and activates it on droplet2):
   ```sh
   nixos-rebuild switch --flake .#droplet2 --target-host root@droplet2
   ```
   - Don't pass `--build-host localhost`. srvbox doesn't run sshd, so that
     fails with `connect to host localhost port 22: Connection refused`.
   - If activation restarts `tailscaled`/`sshd`, the command often ends with
     `returned non-zero exit status 255` after the switch-to-configuration
     line. That's just the SSH connection dropping. The switch runs under
     `systemd-run` on droplet2 and usually finishes anyway. Check it (step 4)
     before retrying.

4. Verify (SSH may need a few seconds, or another Tailscale check, after
   tailscaled restarts):
   ```sh
   ssh root@droplet2 'readlink /run/current-system; systemctl is-system-running; systemctl --failed --no-legend'
   ```
   `/run/current-system` should match the store path the deploy printed.
   Sites can briefly return 502 or refuse connections while services restart.

## Secrets

Secrets are agenix files in `secrets/`. Recipients are listed in
`secrets/secrets.nix`, and srvbox's user key can decrypt the droplet2 ones.
To change one non-interactively:
```sh
cd secrets && printf 'KEY=value\n' | EDITOR='cp /dev/stdin' agenix -e <name>.age
```
Activation decrypts secrets to `/run/agenix/`. Containers that use a secret
via `environmentFiles` (e.g. mexico2026) get restarted during the switch.
Confirm with `systemctl show -p ActiveEnterTimestamp podman-<name>`, and
restart by hand if the timestamp is older than the deploy.

## Not deployed this way

The `mexico2026` image (`ghcr.io/justbuchanan/mexico2026:latest`) is rebuilt
by GitHub Actions in that repo. droplet2's `podman-auto-update` timer pulls
new images every 5 minutes, so code changes to the site don't need a
nixos-rebuild. Only config or secret changes in this repo do.
