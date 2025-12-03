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
  services.caddy = {
    enable = true;

    virtualHosts = {
      # Home Assistant
      "home.justbuchanan.com".extraConfig = ''
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

      # immich image viewer
      "photos.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:2283
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

      "influxdb.justbuchanan.com".extraConfig = ''
        reverse_proxy ${homeserver}:8086
      '';

      "cctv.justbuchanan.com".extraConfig = ''
        forward_auth ${authelia} {
            uri /api/verify?rd=https://auth.justbuchanan.com
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
        }
        reverse_proxy ${homeserver}:5000
      '';

      "ls.justbuchanan.com".extraConfig = ''
        forward_auth ${authelia} {
            uri /api/verify?rd=https://auth.justbuchanan.com
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
        }
        reverse_proxy ${homeserver}:3456
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
  virtualisation.oci-containers.containers = {
    justbuchanan_com = {
      image = "justbuchanan/justbuchanan.com";
      ports = [ "127.0.0.1:3000:3000" ];
    };

    oasis_terrarium_com = {
      image = "ghcr.io/justbuchanan/oasis-terrarium.com";
      ports = [ "127.0.0.1:3001:80" ];
    };

    thegrove_us = {
      image = "ghcr.io/justbuchanan/thegrove.us";
      ports = [ "127.0.0.1:3002:3000" ];
    };
  };
}
