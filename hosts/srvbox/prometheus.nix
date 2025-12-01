{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Prometheus server configuration
  services.prometheus = {
    enable = true;
    # Web UI at 9090
    port = 9090;

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

  networking.firewall.allowedTCPPorts = [ 9090 ];
}
