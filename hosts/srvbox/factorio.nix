# Factorio server hosting config
#
# Defines two separate server configs ("cdeez" and "22nd-crew"), each with its
# own state directory under /var/lib, so they have independent save games and
# settings. Only one can run at a time (NixOS exposes a single `services.factorio`
# instance). Pick which one to run by setting `factorioServer.active` in
# configuration.nix; leave it null to keep Factorio off.
#
# External access requires exposing the port in this machine's firewall (handled
# by openFirewall below) and forwarding that port in home router settings.

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.factorioServer;

  # Mod directory with mod-list.json that disables Space Age DLC mods
  vanillaModDir = pkgs.writeTextDir "mod-list.json" (
    builtins.toJSON {
      mods = [
        {
          name = "base";
          enabled = true;
        }
        {
          name = "elevated-rails";
          enabled = false;
        }
        {
          name = "quality";
          enabled = false;
        }
        {
          name = "space-age";
          enabled = false;
        }
      ];
    }
  );

  # Map generation settings: increase ore presence.
  #
  # NOTE: i couldn't get map-gen-settings to apply through this nix config.
  # The way to use it: turn off factorio, delete the old save game, and run e.g.:
  #   sudo factorio --config=<factorio.conf> \
  #     --create=/var/lib/factorio-22nd/saves/default.zip \
  #     --map-gen-settings=${mapGenSettings}
  mapGenSettings = pkgs.writeText "map-gen-settings.json" (
    builtins.toJSON {
      autoplace_controls =
        let
          rich = {
            frequency = "very-high";
            size = "very-big";
            richness = "very-high";
          };
        in
        {
          iron-ore = rich;
          copper-ore = rich;
          coal = rich;
          stone = rich;
          crude-oil = rich;
          uranium-ore = rich;
        };
    }
  );

  # Settings shared by every server config.
  common = {
    enable = true;
    openFirewall = true;
    public = true; # shows up on factorio matching server
    username = "justbuchanan";
    admins = [ "justbuchanan" ];
    loadLatestSave = true;
    description = "Justin's factorio server";
    extraSettings = {
      only_admins_can_pause_the_game = false;
    };
    # extraSettingsFile contains game-password, token
    extraSettingsFile = config.age.secrets.factorio-server-settings.path;
  };

  # The two server configs. Each uses a distinct stateDirName so their save
  # games and settings live in separate /var/lib directories.
  servers = {
    cdeez = common // {
      # Keep the historical default dir name so the existing save is preserved.
      stateDirName = "factorio";
      game-name = "CDeez Factories";
    };

    "22nd-crew" = common // {
      stateDirName = "factorio-22nd";
      game-name = "22nd Crew";
      extraArgs = [ "--mod-directory=${vanillaModDir}" ];
    };
  };

  # Guard the lookup so it never evaluates `servers.${null}` when disabled.
  selected = if cfg.active == null then { } else servers.${cfg.active};
in
{
  options.factorioServer.active = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum (builtins.attrNames servers));
    default = null;
    example = "22nd-crew";
    description = ''
      Which Factorio server config to run. null disables Factorio entirely.
    '';
  };

  config = lib.mkIf (cfg.active != null) {
    # configure secret file for reading auth token and game password
    users.groups.factorio-secrets-access = { };
    age.secrets.factorio-server-settings = {
      file = ../../secrets/factorio-server-settings.age;
      group = "factorio-secrets-access";
      mode = "0440";
    };
    systemd.services.factorio.serviceConfig.SupplementaryGroups = [ "factorio-secrets-access" ];

    services.factorio = selected;
  };
}
