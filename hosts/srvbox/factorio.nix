# Factorio server hosting config
#
# External access requires exposing the port in this machine's firewall and
# forwarding that port in home router settings

{ config, ... }:
{
  # configure secret file for reading auth token and game password
  users.groups.factorio-secrets-access = { };
  age.secrets.factorio-server-settings = {
    file = ../../secrets/factorio-server-settings.age;
    group = "factorio-secrets-access";
    mode = "0440";
  };
  systemd.services.factorio.serviceConfig.SupplementaryGroups = [ "factorio-secrets-access" ];

  services.factorio = {
    enable = true;

    openFirewall = true;

    description = "Justin's factorio server";
    game-name = "CDeez Factories";
    public = true; # shows up on factorio matching server
    username = "justbuchanan";
    admins = [ "justbuchanan" ];

    loadLatestSave = true;
    extraSettings = {
      only_admins_can_pause_the_game = false;
    };

    # extraSettingsFile contains game-password, token
    extraSettingsFile = config.age.secrets.factorio-server-settings.path;
  };
}
