{
  config,
  lib,
  pkgs,
  ...
}:
{

  age.secrets = {
    grafana-admin-password = {
      file = ../../secrets/grafana-admin-password.age;
      owner = "grafana";
    };
    grafana-secret-key = {
      file = ../../secrets/grafana-secret-key.age;
      owner = "grafana";
    };
  };

  # Prometheus server configuration
  services.prometheus = {
    enable = true;
    # Web UI at 9090
    port = 9090;

    # TODO: how long do we want?
    retentionTime = "30d";

    # Scrape exported nodes
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "srvbox.wampus-newton.ts.net:9100"
              "framework.wampus-newton.ts.net:9100"
              "droplet1.wampus-newton.ts.net:9100"
            ];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        # http_addr = "127.0.0.1";
        http_addr = "0.0.0.0";
        http_port = 3090;
        enforce_domain = true;
        enable_gzip = true;
        # root_url =
        domain = "srvbox";
        # domain = "grafana.justbuchanan.com";
      };

      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.age.secrets.grafana-admin-password.path}}";
        secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
      };

      users = {
        allow_sign_up = false;
      };

      # Prevents Grafana from phoning home
      analytics.reporting_enabled = false;
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    9090 # prometheus
    3090 # grafana
  ];
}
