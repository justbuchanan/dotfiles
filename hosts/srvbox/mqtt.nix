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
    # accessible on the tailnet, but we can do better
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 1883 ];
}
