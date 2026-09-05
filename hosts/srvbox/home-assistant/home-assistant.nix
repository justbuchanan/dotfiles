# CONFIG VS DATA: `config` below renders into a read-only configuration.yaml.
# Everything else -- home location, users, registries, dashboards, zigbee.db --
# is data under /var/lib/hass, kept out of this public repo.
#
# `homeassistant.time_zone = null` and the `automation` !include below exist
# only to keep the UI editable. customLovelaceModules forces resource_mode:
# yaml, so frontend resources are declared here; dashboards stay UI-editable.
{ pkgs, ... }:
let
  # Not in nixpkgs. Upstream ships a prebuilt floorplan.js release asset
  # (byte-identical to the copy HACS had installed), so no npm build.
  ha-floorplan = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "ha-floorplan";
    version = "1.1.5";

    src = pkgs.fetchurl {
      url = "https://github.com/ExperienceLovelace/ha-floorplan/releases/download/v${finalAttrs.version}/floorplan.js";
      hash = "sha256-3ysiUqoRMBHuZeUo2t5KLh92mGmySI2u5U96pZ6Zads=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm444 $src $out/floorplan.js
      runHook postInstall
    '';

    # The file is floorplan.js, not ha-floorplan.js (the pname-based default).
    passthru.entrypoint = "floorplan.js";

    meta = {
      description = "Floorplan card for Home Assistant";
      homepage = "https://github.com/ExperienceLovelace/ha-floorplan";
      license = pkgs.lib.licenses.asl20;
    };
  });
in
{
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "default_config"
      "august"
      "cast"
      "cync"
      "dlna_dms"
      "esphome"
      "go2rtc"
      "google_assistant"
      "homeassistant_connect_zbt2"
      "konnected"
      "matter"
      "met"
      "mobile_app"
      "mqtt"
      "nest"
      "roborock"
      "sun"
      "tplink"
      "zha"
    ];

    customComponents = with pkgs.home-assistant-custom-components; [
      frigate
      localtuya
    ];

    # advanced-camera-card is 7.27.4 here vs 8.0.0 under HACS, so card configs
    # may need adjusting.
    customLovelaceModules =
      (with pkgs.home-assistant-custom-lovelace-modules; [
        advanced-camera-card
        light-entity-card
        vacuum-card
      ])
      ++ [ ha-floorplan ];

    config = {
      # Pulls in zeroconf/usb/dhcp/ssdp/bluetooth discovery, which esphome and
      # zha rely on.
      default_config = { };

      # The module defaults this to config.time.timeZone, but any core key
      # under `homeassistant:` makes HA treat core config as YAML-owned and
      # greys out Settings > System > General, home location included.
      homeassistant.time_zone = null;

      # No http: block -- HA migrated it to .storage/http and ignores YAML now.
      # The droplet2 proxy trust lives in Settings > System > Network.

      # Lets the floorplan hide its seasonal markers without editing the SVG.
      input_boolean.christmas_season = {
        name = "Christmas season";
        icon = "mdi:pine-tree";
      };

      # HA merges every `automation*` key and its editor only writes to
      # automations.yaml, so UI-authored automations stay in the untracked data
      # dir and checked-in ones live here. Ids must be unique across both.
      automation = "!include automations.yaml";
      "automation manual" = "!include_dir_merge_list ${./automations}";

      # No scenes.yaml counterpart: nothing has authored a scene in the UI, and
      # an !include of a missing file fails the config check.
      scene = "!include_dir_merge_list ${./scenes}";
    };
  };

  # Encrypted because it maps the house (see secrets/secrets.nix). symlink =
  # false writes plaintext straight into the directory HA serves as /local.
  age.secrets.ha-floorplan-svg = {
    file = ../../../secrets/ha-floorplan.svg.age;
    path = "/var/lib/hass/www/floorplan/home.svg";
    owner = "hass";
    group = "hass";
    mode = "0444";
    symlink = false;
  };

  # The rest of the floorplan assets carry nothing private.
  systemd.tmpfiles.rules =
    map (f: "L+ /var/lib/hass/www/floorplan/${f} - - - - ${./floorplan}/${f}")
      [
        "home.css"
        "light_on.svg"
        "light_off.svg"
        "camera.svg"
      ];

  # All interfaces: the Caddy proxy comes in over tailscale0, direct access to
  # srvbox:8123 over the LAN.
  networking.firewall.allowedTCPPorts = [ 8123 ];

  # python-kasa (tplink) discovers by broadcasting to ports 9999/20002, but
  # devices reply unicast from their own address, so conntrack sees a new
  # inbound flow and default-deny drops it. Matching the reply's source port is
  # much tighter than opening the ephemeral range. No extraStopCommands needed
  # -- the nixos-fw chain is flushed on every start.
  networking.firewall.extraCommands = ''
    for sport in 9999 20002; do
      iptables -w -A nixos-fw -i enp5s0 -s 192.168.68.0/22 \
        -p udp --sport $sport --dport 32768:60999 -j nixos-fw-accept
    done
  '';
}
