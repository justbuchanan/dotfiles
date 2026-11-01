{
  config,
  pkgs,
  inputs,
  ...
}:
let
  homeserver = "srvbox.wampus-newton.ts.net";
in
{
  # SITE_PASSWORD=… for the mexico2026 container
  age.secrets.mexico2026-env.file = ../../secrets/mexico2026-env.age;
  # read:packages token for pulling private images from ghcr.io
  age.secrets.ghcr-pull-token.file = ../../secrets/ghcr-pull-token.age;
  # HA_FLOORPLAN_KEY=… for the home.justbuchanan.com floorplan URL
  age.secrets.ha-floorplan-key = {
    file = ../../secrets/ha-floorplan-key.age;
    owner = "caddy";
  };

  services.caddy = {
    enable = true;
    environmentFile = config.age.secrets.ha-floorplan-key.path;

    # Enable admin API on all interfaces so it's accessible via Tailscale
    globalConfig = ''
      admin :2019

      servers {
        metrics
      }
    '';

    virtualHosts = {
      # Home Assistant. /local has no auth and the card fetches the floorplan
      # without a token, so its URL in the dashboard carries a key instead.
      "home.justbuchanan.com".extraConfig = ''
        @floorplan {
          path_regexp home\.svg
          not expression `{query.k} != "" && {query.k} == {env.HA_FLOORPLAN_KEY}`
        }
        respond @floorplan 404
        reverse_proxy ${homeserver}:8123
      '';

      # Jellyfin
      "media.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:8096
      '';

      # NextCloud
      "nextcloud.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:8989
      '';

      "justbuchanan.com".extraConfig = ''
        reverse_proxy localhost:3000
      '';

      "oasis-terrarium.com".extraConfig = ''
        reverse_proxy localhost:3001
      '';

      # Trip site; has its own password page.
      "mexico2026.justbuchanan.com".extraConfig = ''
        reverse_proxy localhost:3003
      '';

      # Sensors only write. The UI and the rest of the API stay on the tailnet.
      "influxdb.justbuchanan.com".extraConfig = ''
        @write {
          method POST
          path /api/v2/write
        }
        handle @write {
          reverse_proxy ${homeserver}:8086
        }
        handle {
          respond 404
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Keep the containers off the tailnet and the cloud metadata service. raw runs
  # ahead of ts-forward, which accepts everything going out tailscale0.
  networking.firewall.extraCommands = ''
    for dst in 100.64.0.0/10 169.254.169.254; do
      iptables -w -t raw -D PREROUTING -i podman+ -d "$dst" -j DROP 2>/dev/null || true
      iptables -w -t raw -A PREROUTING -i podman+ -d "$dst" -j DROP
    done
  '';

  # Docker containers for websites we're serving
  # Note: the 127.0.0.1 makes the container port accessible to the local machine
  # only. External access goes through caddy, which proxies to the container.
  # All containers run as nobody. The images expect root, so the dirs they
  # write at runtime are replaced with world-writable tmpfs.
  virtualisation.oci-containers.containers = {
    # GitHub Actions rebuilds this on every push to master, and the autoupdate
    # label deploys it the same way as mexico2026 below.
    justbuchanan_com = {
      image = "ghcr.io/justbuchanan/justbuchanan.com:latest";
      ports = [ "127.0.0.1:3000:3000" ];
      user = "nobody";
      labels."io.containers.autoupdate" = "registry";
      extraOptions = [ "--read-only" ];
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
