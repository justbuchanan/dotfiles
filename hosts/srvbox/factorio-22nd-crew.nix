# TODO: refactor and merge with factorio.nix
# Factorio server hosting config
#
# External access requires exposing the port in this machine's firewall and
# forwarding that port in home router settings
#
# Factorio server save game state lives in /var/lib/factorio

{ config, pkgs, lib, ... }:
let
  # Mod directory with mod-list.json that disables Space Age DLC mods
  modDir = pkgs.writeTextDir "mod-list.json" (builtins.toJSON {
    mods = [
      { name = "base"; enabled = true; }
      { name = "elevated-rails"; enabled = false; }
      { name = "quality"; enabled = false; }
      { name = "space-age"; enabled = false; }
    ];
  });

  # Map generation settings: increase iron ore presence
  mapGenSettings = pkgs.writeText "map-gen-settings.json" (builtins.toJSON {
    autoplace_controls = {
      iron-ore = { frequency = "very-high"; size = "very-big"; richness = "very-high"; };
      copper-ore = { frequency = "very-high"; size = "very-big"; richness = "very-high"; };
      coal = { frequency = "very-high"; size = "very-big"; richness = "very-high"; };
      stone = { frequency = "very-high"; size = "very-big"; richness = "very-high"; };
      crude-oil = { frequency = "very-high"; size = "very-big"; richness = "very-high"; };
      uranium-ore = { frequency = "very-high"; size = "very-big"; richness = "very-high"; };
    };
  });
in
{
  # configure secret file for reading auth token and game password
  users.groups.factorio-secrets-access = { };
  age.secrets.factorio-server-settings = {
    file = ../../secrets/factorio-server-settings.age;
    group = "factorio-secrets-access";
    mode = "0440";
  };
  systemd.services.factorio.serviceConfig.SupplementaryGroups = [ "factorio-secrets-access" ];

  # # Write map-gen-settings.json before map creation in preStart
  # systemd.services.factorio.preStart = lib.mkBefore ''
  #   cp ${mapGenSettings} /var/lib/factorio-22nd/map-gen-settings.json
  # '';
  # NOTE: i couldn't get map-get-settings to work with this nix config.
  # ended up turning off factorio, deleting the old save game, and running this:
  # sudo /nix/store/3fw110vx6gxczwwsa784ak7gdvnvvwdm-factorio-headless-2.0.73/bin/factorio --config=/nix/store/a0w985lvzxal5yap718pk95k2gr0lbsr-factorio.conf --create=/var/lib/factorio-22nd/saves/default.zip  --map-gen-settings=/nix/store/6qrk0xxy3vhi59m0ahi4wwnx5v4p3rmv-map-gen-settings.json


  services.factorio = {
    enable = true;

    openFirewall = true;

    # can use different values here to separate different factorio servers
    stateDirName = "factorio-22nd";

    description = "Justin's factorio server";
    game-name = "22nd Crew";
    public = true; # shows up on factorio matching server
    username = "justbuchanan";
    admins = [ "justbuchanan" ];

    loadLatestSave = true;
    extraSettings = {
      only_admins_can_pause_the_game = false;
    };

    # extraSettingsFile contains game-password, token
    extraSettingsFile = config.age.secrets.factorio-server-settings.path;

    extraArgs = [ "--mod-directory=${modDir}" ];
  };
}
