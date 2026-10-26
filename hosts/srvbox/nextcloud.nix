{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.nextcloud = {
    enable = true;

    # Nextcloud refuses to skip a major version, so only ever bump this by one.
    package = pkgs.nextcloud34;

    # Tailnet-only, published by tailscale serve (tailscale-serve.nix).
    hostName = "srvbox.wampus-newton.ts.net";

    # Reuse the existing docker volume layout in place (see header comment).
    datadir = "/mnt/zpool0/nextcloud";

    config = {
      dbtype = "sqlite";

      # For sqlite the module looks for `${datadir}/data/${dbname}.db`
      dbname = "owncloud";
    };

    settings = {
      # tailscale serve terminates TLS and proxies to 127.0.0.1:8989. Tell
      # Nextcloud it is actually reached via https so it generates correct URLs.
      overwriteprotocol = "https";
      overwritehost = "srvbox.wampus-newton.ts.net";
      "overwrite.cli.url" = "https://srvbox.wampus-newton.ts.net";

      # tailscale serve connects from loopback.
      trusted_proxies = [
        "127.0.0.1"
        "::1"
      ];
    };

    # TODO: look into enabling redis and/or postgres (instead of sqlite) for performance
    # configureRedis = true;
  };

  # The module creates an nginx vhost for hostName that listens on :80 by
  # default. Move it to loopback :8989; tailscale serve is the only way in from
  # other machines, so no firewall port is opened.
  services.nginx.virtualHosts."srvbox.wampus-newton.ts.net".listen = [
    {
      addr = "127.0.0.1";
      port = 8989;
    }
  ];
}
