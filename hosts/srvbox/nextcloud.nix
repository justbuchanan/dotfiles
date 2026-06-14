{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.nextcloud = {
    enable = true;

    # MUST match the existing instance's major version. The old container ran
    # 32.0.8; this package is 32.0.x. Nextcloud refuses to skip a major version,
    # so never bump this past the next major without a deliberate upgrade.
    package = pkgs.nextcloud32;

    hostName = "nextcloud.justbuchanan.com";

    # Reuse the existing docker volume layout in place (see header comment).
    datadir = "/mnt/zpool0/nextcloud";

    config = {
      dbtype = "sqlite";

      # For sqlite the module looks for `${datadir}/data/${dbname}.db`
      dbname = "owncloud";

      # The instance is already installed, so disable initial admin creation
      # (supported on Nextcloud >= 32). The existing admin lives in the DB.
      adminuser = null;
      adminpassFile = null;
    };

    settings = {
      # We sit behind Caddy on droplet2, which terminates TLS and reverse-proxies
      # over the tailnet to srvbox:8989 (hosts/droplet2/webserver.nix). Tell
      # Nextcloud it is actually reached via https so it generates correct URLs.
      overwriteprotocol = "https";
      overwritehost = "nextcloud.justbuchanan.com";
      "overwrite.cli.url" = "https://nextcloud.justbuchanan.com";

      # Only the Caddy proxy (reachable over the tailnet) ever hits the backend.
      # Trust the whole tailscale CGNAT range as the proxy source.
      trusted_proxies = [ "100.64.0.0/10" ];
    };

    # TODO: look into enabling redis and/or postgres (instead of sqlite) for performance
    # configureRedis = true;
  };

  # The module creates an nginx vhost for hostName that listens on :80 by
  # default. Override it to :8989 so the existing Caddy reverse_proxy target
  # (srvbox:8989) and the firewall rule below keep working unchanged.
  services.nginx.virtualHosts."nextcloud.justbuchanan.com".listen = [
    {
      addr = "0.0.0.0";
      port = 8989;
    }
  ];

  # Caddy reaches the backend over the tailnet only. (The old docker setup
  # published 8989 on all interfaces; restricting to tailscale0 is tighter.)
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8989 ];
}
