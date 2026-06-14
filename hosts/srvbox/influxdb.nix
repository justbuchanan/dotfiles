# InfluxDB 2.x, migrated off the smarthome docker-compose stack
# (was the `influxdb:2.2.0` container). All orgs/buckets/tokens live inside
# influxd.bolt, so we just carry the existing data directory over -- nothing
# needs reprovisioning.
#
# Writers reach it exclusively through the droplet2 Caddy proxy
# (influxdb.justbuchanan.com -> srvbox.wampus-newton.ts.net:8086 over
# tailscale), so the API only needs to be reachable on the tailscale interface.
{ ... }:
{
  services.influxdb2.enable = true;
  # No `provision` block: the existing influxd.bolt already holds the org,
  # buckets and API tokens.

  # The package serves data from /var/lib/influxdb2 (default StateDirectory).
  # Bind the existing docker data dir onto it in place -- no copy, no move.
  fileSystems."/var/lib/influxdb2" = {
    device = "/home/justin/src/smarthome/influxdb";
    fsType = "none";
    options = [ "bind" ];
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8086 ];
}
