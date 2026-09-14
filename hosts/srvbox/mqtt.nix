{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # for mosquitto_sub cli tool
    mosquitto
  ];

  # Read by systemd as a credential, so root-only is fine.
  age.secrets.mqtt-homeassistant-password.file = ../../secrets/mqtt-homeassistant-password.age;
  age.secrets.mqtt-frigate-password.file = ../../secrets/mqtt-frigate-password.age;

  services.mosquitto = {
    enable = true;

    listeners = [
      {
        address = "0.0.0.0";
        port = 1883;
        settings.allow_anonymous = false;
        users = {
          # Broker settings live in HA's UI config entry, not in nix.
          homeassistant = {
            passwordFile = config.age.secrets.mqtt-homeassistant-password.path;
            acl = [ "readwrite #" ];
          };
          # Same password as FRIGATE_MQTT_PASSWORD in frigate-env.age.
          frigate = {
            passwordFile = config.age.secrets.mqtt-frigate-password.path;
            acl = [ "readwrite frigate/#" ];
          };
        };
      }
    ];
  };

  # Reachable from the tailnet; frigate and home-assistant connect over lo.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 1883 ];
}
