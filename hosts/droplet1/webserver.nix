{
  config,
  pkgs,
  inputs,
  ...
}:
let
  homeserver = "srvbox.wampus-newton.ts.net";
  linode1 = "castle.wampus-newton.ts.net";
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

      # cctv.justbuchanan.com {
      #     forward_auth authelia:9091 {
      #         uri /api/verify?rd=https://auth.justbuchanan.com
      #         copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
      #     }

      #     reverse_proxy 10.0.1.3:5000
      # }

      # ls.justbuchanan.com {
      #     forward_auth authelia:9091 {
      #         uri /api/verify?rd=https://auth.justbuchanan.com
      #         copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
      #     }
      #     reverse_proxy 10.0.1.3:3456
      # }

      # auth.justbuchanan.com {
      #     reverse_proxy authelia:9091
      # }
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.oci-containers.containers = {
    justbuchanan_com = {
      image = "justbuchanan/justbuchanan.com";
      ports = [ "3000:3000" ];
    };

    oasis_terrarium_com = {
      image = "ghcr.io/justbuchanan/oasis-terrarium.com";
      ports = [ "3001:80" ];
    };

    thegrove_us = {
      image = "ghcr.io/justbuchanan/thegrove.us";
      ports = [ "3002:3000" ];
    };
  };
}
