{ config, ... }:

# Publish tailnet-only web UIs over HTTPS with tailscale's own certs for
# srvbox.wampus-newton.ts.net. The backends listen on loopback only, so they're
# reachable from srvbox itself and (through this) the tailnet, but not the LAN
# or the internet. This is `serve`, not `funnel`, so nothing is made public.
#
#   https://srvbox.wampus-newton.ts.net/       -> Nextcloud (nextcloud.nix)
#   https://srvbox.wampus-newton.ts.net:8443/  -> Frigate (frigate.nix)
#
# Serve config is stored in tailscaled's state; this just (re)applies it.
let
  tailscale = "${config.services.tailscale.package}/bin/tailscale";
in
{
  systemd.services.tailscale-serve-web = {
    description = "Publish Nextcloud and Frigate on the tailnet";
    after = [
      "tailscaled.service"
      "network-online.target"
    ];
    wants = [
      "tailscaled.service"
      "network-online.target"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # tailscaled may not be logged in yet right after boot.
      Restart = "on-failure";
      RestartSec = 10;
    };
    script = ''
      ${tailscale} serve --bg --https=443 http://127.0.0.1:8989
      ${tailscale} serve --bg --https=8443 http://127.0.0.1:8971
    '';
  };
}
