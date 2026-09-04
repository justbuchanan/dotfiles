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
    # accessible on the tailnet and over loopback, but we can do better
    # (password file via agenix/sops).
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

  # Reachable from the tailnet. frigate and home-assistant are native services
  # now and connect over 127.0.0.1, which needs no rule ("lo" is trusted). We
  # deliberately do not open 1883 on the LAN.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 1883 ];
}
