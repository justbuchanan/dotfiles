{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # for mosquitto_sub cli tool
    mosquitto
  ];

  services.mosquitto = {
    enable = true;

    # TODO: make this more secure. it's not terrible since this is only
    # accessible on the tailnet and the smarthome docker bridge, but we can do
    # better (password file via agenix/sops).
    listeners = [
      {
        address = "0.0.0.0";
        port = 1883;
        acl = [ "topic readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  # Reachable from the tailnet and from the smarthome docker-compose containers
  # (frigate, home-assistant) which connect via the bridge gateway. The bridge
  # interface name is pinned to "br-smarthome" in
  # ~/src/smarthome/docker-compose.yml so this rule stays stable across
  # `docker compose down/up`. We deliberately do not open 1883 on the LAN.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 1883 ];
  networking.firewall.interfaces."br-smarthome".allowedTCPPorts = [ 1883 ];
}
