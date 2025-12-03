{ ... }:
{
  # Prometheus node exporter
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "systemd" ];
  };

  # Only allow access from Tailscale
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 9100 ];
}
