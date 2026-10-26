{
  config,
  pkgs,
  inputs,
  ...
}:
let
  homeserver = "srvbox.wampus-newton.ts.net";
  authelia = "localhost:9091";
in
{
  # SITE_PASSWORD=… for the mexico2026 container
  age.secrets.mexico2026-env.file = ../../secrets/mexico2026-env.age;
  # read:packages token for pulling private images from ghcr.io
  age.secrets.ghcr-pull-token.file = ../../secrets/ghcr-pull-token.age;

  services.caddy = {
    enable = true;

    # Enable admin API on all interfaces so it's accessible via Tailscale
    globalConfig = ''
      admin :2019

      servers {
        metrics
      }
    '';

    virtualHosts = {
      # Home Assistant
      "home.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:8123
      '';

      # Jellyfin
      "media.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:8096
      '';

      "justbuchanan.com".extraConfig = ''
        reverse_proxy localhost:3000
      '';

      "oasis-terrarium.com".extraConfig = ''
        reverse_proxy localhost:3001
      '';

      "thegrove.us".extraConfig = ''
        reverse_proxy localhost:3002
      '';

      # Trip site; has its own password page, so no authelia here.
      "mexico2026.justbuchanan.com".extraConfig = ''
        reverse_proxy localhost:3003
      '';

      "influxdb.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:8086
      '';

      "homepage.justbuchanan.com".extraConfig = ''
        forward_auth ${authelia} {
            uri /api/verify?rd=https://auth.justbuchanan.com
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
        }
        reverse_proxy ${homeserver}:8083
      '';

      "auth.justbuchanan.com".extraConfig = ''
        reverse_proxy ${authelia}
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Docker containers for websites we're serving
  # Note: the 127.0.0.1 makes the container port accessible to the local machine
  # only. External access goes through caddy, which proxies to the container.
  # All containers run as nobody. The images expect root, so the dirs they
  # write at runtime are replaced with world-writable tmpfs.
  virtualisation.oci-containers.containers = {
    justbuchanan_com = {
      image = "justbuchanan/justbuchanan.com";
      ports = [ "127.0.0.1:3000:3000" ];
      # gems live under /root (0750), so keep gid 0 until the image is rebuilt
      user = "nobody:0";
      environment.HOME = "/root";
      extraOptions = [ "--tmpfs=/site/_site:mode=1777" ];
    };

    oasis_terrarium_com = {
      image = "ghcr.io/justbuchanan/oasis-terrarium.com";
      ports = [ "127.0.0.1:3001:80" ];
      user = "nobody";
      extraOptions = [
        "--tmpfs=/var/cache/nginx:mode=1777"
        "--tmpfs=/run:mode=1777"
        "--sysctl=net.ipv4.ip_unprivileged_port_start=0"
      ];
    };

    thegrove_us = {
      image = "ghcr.io/justbuchanan/thegrove.us";
      ports = [ "127.0.0.1:3002:3000" ];
      user = "nobody";
      extraOptions = [
        "--tmpfs=/site/_site:mode=1777"
        "--tmpfs=/site/.jekyll-cache:mode=1777"
      ];
    };

    # Private image that GitHub Actions rebuilds on every push to main. The
    # autoupdate label opts it into podman-auto-update (below), which deploys
    # new versions without touching this file.
    mexico2026 = {
      image = "ghcr.io/justbuchanan/mexico2026:latest";
      login = {
        registry = "ghcr.io";
        username = "justbuchanan";
        passwordFile = config.age.secrets.ghcr-pull-token.path;
      };
      ports = [ "127.0.0.1:3003:8080" ];
      user = "nobody";
      environmentFiles = [ config.age.secrets.mexico2026-env.path ];
      labels."io.containers.autoupdate" = "registry";
      extraOptions = [ "--read-only" ];
    };
  };

  # Pull newer images for containers labelled io.containers.autoupdate and
  # restart them (podman rolls back if the new one fails to start). Podman's
  # stock timer runs daily with up to 15 min of jitter; check every 5 minutes.
  systemd.timers.podman-auto-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = [
        ""
        "*:0/5"
      ];
      RandomizedDelaySec = 0;
    };
  };

  # expose caddy admin api over tailnet
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 2019 ];
}
