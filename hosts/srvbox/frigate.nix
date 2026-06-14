{
  config,
  lib,
  pkgs,
  ...
}:

let
  # go2rtc stream definitions, shared between the standalone services.go2rtc
  # (the actual streaming process — Frigate's package does NOT bundle go2rtc and
  # expects an external one on :1984) and Frigate's own go2rtc block (which just
  # gives Frigate awareness of the stream names for live view).
  #
  # These use go2rtc's native `${VAR}` env-var syntax (NOT Frigate's `{VAR}`),
  # because go2rtc — not Frigate — expands them. go2rtc strictly URL-parses, so
  # passwords with reserved chars must be percent-ENCODED here (the _ENC vars).
  # `\${` escapes Nix interpolation so the literal `${...}` reaches go2rtc.
  go2rtcStreams = {
    garage = [
      "rtsp://admin:\${FRIGATE_CAM_GARAGE_PW_ENC}@192.168.68.75:554/cam/realmonitor?channel=1&subtype=0"
      "ffmpeg:garage#audio=aac"
    ];
    frontdoor = [
      "rtsp://admin:\${FRIGATE_CAM_FRONTDOOR_PW}@192.168.68.60:554//Streaming/Channels/1"
    ];
    backyard = [
      "rtsp://admin:\${FRIGATE_CAM_BACKYARD_PW_ENC}@192.168.68.57:554/cam/realmonitor?channel=1&subtype=0"
    ];
    garden = [
      "rtsp://admin:\${FRIGATE_CAM_GARDEN_PW}@192.168.68.56:554/cam/realmonitor?channel=1&subtype=0"
    ];
  };
in

# Frigate NVR, migrated from the ~/src/smarthome docker-compose setup to the
# native NixOS module. Same upstream version (0.17.1). Notable differences from
# the docker setup, all forced by going native:
#
#   * MQTT host is now 127.0.0.1 (the broker is a native service on this host,
#     see mqtt.nix). Under docker it was "mqtt" via host-gateway.
#   * Camera RTSP passwords come from agenix (secrets/frigate-env.age) via
#     Frigate's {FRIGATE_*} env-var substitution, instead of being inline.
#   * The UI is fronted by nginx (the module's only supported topology) and
#     exposed on :8971 instead of the old :5000. Frigate's own unauthenticated
#     endpoint still lives on 127.0.0.1:5000 (used internally by nginx).
#   * Recordings/clips/db/config all live under /var/lib/frigate (the nixpkgs
#     package patches Frigate's hardcoded /media/frigate and /config to point
#     there). We bind that onto the existing /mnt/zpool0/frigate so no
#     recordings are lost and the data stays on the ZFS pool.
#
# Coral USB + NVIDIA hwaccel: the module auto-detects the edgetpu/usb detector
# and wires up hardware.coral.usb (udev rules, libedgetpu, the coral group).
# preset-nvidia-h264 works with the module's default ffmpeg-headless, which
# nixpkgs builds with nvcodec/cuvid/nvdec + cuda-llvm and an addDriverRunpath so
# it finds libcuda/libnvcuvid from /run/opengl-driver/lib at runtime.

{
  # Camera RTSP passwords. Decrypted to /run/agenix/frigate-env, owned by the
  # frigate system user the module creates. Group-readable (0440) so the
  # standalone go2rtc service can read it too via SupplementaryGroups (it runs
  # as a DynamicUser, so it can't own the file).
  age.secrets.frigate-env = {
    file = ../../secrets/frigate-env.age;
    owner = "frigate";
    group = "frigate";
    mode = "0440";
  };

  services.frigate = {
    enable = true;

    # nginx vhost server_name. Reachable on the LAN as http://srvbox:8971/ (see
    # the listen override below).
    hostname = "srvbox";

    # Run the build-time `frigate --validate-config` check with dummy values for
    # the secrets, which aren't available in the build sandbox.
    preCheckConfig = ''
      export FRIGATE_RTSP_PASSWORD=x
      export FRIGATE_CAM_GARAGE_PW=x
      export FRIGATE_CAM_FRONTDOOR_PW=x
      export FRIGATE_CAM_BACKYARD_PW=x
      export FRIGATE_CAM_GARDEN_PW=x
    '';

    settings = {
      auth.enabled = false;
      tls.enabled = false;

      mqtt = {
        enabled = true;
        host = "127.0.0.1"; # native broker on this host (mqtt.nix)
        port = 1883;
      };

      # Google Coral USB accelerator for object detection.
      detectors.coral = {
        type = "edgetpu";
        device = "usb";
      };

      # NVIDIA hardware-accelerated decode (GTX 1070 Ti).
      ffmpeg.hwaccel_args = "preset-nvidia-h264";

      birdseye = {
        enabled = true;
        mode = "continuous";
      };

      # Mirror the stream names so Frigate knows about them for live view.
      # The actual streaming is done by services.go2rtc (below); Frigate does
      # not run go2rtc itself and never dials these URLs.
      go2rtc.streams = go2rtcStreams;

      record = {
        enabled = true;
        continuous.days = 14;
        motion.days = 14;
      };

      objects.track = [
        "car"
        "person"
        "motorcycle"
        "dog"
        "cat"
        "bird"
      ];

      snapshots = {
        enabled = true;
        timestamp = true;
        bounding_box = true;
        crop = false;
        retain.default = 100; # days
      };

      detect.enabled = true;

      camera_groups.birdseye = {
        order = 1;
        icon = "LuBird";
        cameras = "birdseye";
      };

      cameras = {
        garage = {
          ffmpeg = {
            inputs = [
              {
                # Pull from Frigate's own go2rtc restream (better live quality + audio).
                path = "rtsp://127.0.0.1:8554/garage?video=copy&audio=aac";
                input_args = "preset-rtsp-restream";
                roles = [
                  "record"
                  "audio"
                ];
              }
              {
                # Lower-res substream for detection.
                path = "rtsp://admin:{FRIGATE_CAM_GARAGE_PW}@192.168.68.75:554/cam/realmonitor?channel=1&subtype=1";
                roles = [ "detect" ];
              }
            ];
            output_args.record = "preset-record-generic-audio-aac";
          };
          audio = {
            enabled = true;
            listen = [
              "bark"
              "fire_alarm"
              "scream"
              "speech"
              "yell"
              "gunshot"
              "fireworks"
              "boom"
              "glass"
              "shatter"
              "machine_gun"
            ];
          };
        };

        frontdoor = {
          ffmpeg.inputs = [
            {
              path = "rtsp://admin:{FRIGATE_CAM_FRONTDOOR_PW}@192.168.68.60:554//Streaming/Channels/1";
              roles = [ "record" ];
            }
          ];
          detect = {
            enabled = true;
            width = 2688;
            height = 1512;
          };
          record = {
            alerts.retain = { };
            detections.retain.days = 1;
          };
          motion = {
            threshold = 140;
            mask = "0.158,0.194,0.401,0.183,0.593,0.202,1,0.196,1,0,0,0,0,0.222";
          };
          zones.frontdoor_zone = {
            coordinates = "0.024,0.25,0,0.327,0,1,1,1,0.995,0.225,0.638,0.221,0.438,0.187,0.173,0.2,0.061,0.218";
            inertia = 3;
            loitering_time = 0;
          };
          review.alerts.required_zones = [ "frontdoor_zone" ];
        };

        backyard = {
          ffmpeg.inputs = [
            {
              path = "rtsp://admin:{FRIGATE_CAM_BACKYARD_PW}@192.168.68.57:554/cam/realmonitor?channel=1&subtype=0";
              roles = [ "record" ];
            }
          ];
          record = {
            alerts.retain = { };
            detections.retain.days = 1;
          };
          zones = {
            backyard_zone.coordinates = "2592,431,2052,353,1847,367,1670,537,1170,625,1100,670,473,591,717,1151,0,1359,0,1944,2592,1944";
            alley_zone.coordinates = "1308,523,1825,488,1842,785,1157,819,1116,616";
          };
          motion.threshold = 50;
          review.alerts.required_zones = [
            "alley_zone"
            "backyard_zone"
          ];
        };

        garden = {
          ffmpeg.inputs = [
            {
              path = "rtsp://admin:{FRIGATE_CAM_GARDEN_PW}@192.168.68.56:554/cam/realmonitor?channel=1&subtype=0";
              roles = [ "record" ];
            }
          ];
          record = {
            alerts.retain = { };
            detections.retain = { };
          };
          motion.threshold = 50;
        };
      };
    };
  };

  # Feed the agenix-decrypted secrets to Frigate. Keep the module's own
  # ffmpeg-env file (it carries the detected libavformat version) and append ours.
  systemd.services.frigate.serviceConfig.EnvironmentFile = lib.mkForce [
    "-/run/frigate/ffmpeg-env"
    config.age.secrets.frigate-env.path
  ];

  # Standalone go2rtc: provides live-view streams (proxied by Frigate's nginx to
  # 127.0.0.1:1984) and the RTSP restream on :8554 that the garage camera's
  # record/audio input reads from. Frigate's package expects this external
  # process; the frigate module already orders itself after go2rtc.service.
  services.go2rtc = {
    enable = true;
    settings.streams = go2rtcStreams;
    # api.listen defaults to :1984 (what Frigate's nginx proxies to); go2rtc's
    # built-in defaults bind RTSP :8554 and WebRTC :8555.
  };

  # go2rtc reads the same camera-password secret (it expands the ${FRIGATE_*_ENC}
  # refs at runtime). It runs as a DynamicUser, so grant it group access to the
  # frigate-owned secret and load it as its environment.
  systemd.services.go2rtc.serviceConfig = {
    EnvironmentFile = [ config.age.secrets.frigate-env.path ];
    SupplementaryGroups = lib.mkForce [
      "video" # kept from the module default (v4l2 devices)
      "frigate" # to read /run/agenix/frigate-env
    ];
  };

  # nvidia-smi for the UI's GPU stats panel. Decode itself works without this.
  systemd.services.frigate.path = [ config.hardware.nvidia.package.bin ];

  # Keep recordings/clips/db/config on the ZFS pool where they already live.
  # The package points Frigate at /var/lib/frigate, so bind that onto the
  # existing data dir. System-level mount so nginx (serving /recordings, /clips
  # from /var/lib/frigate) sees it too.
  fileSystems."/var/lib/frigate" = {
    device = "/mnt/zpool0/frigate";
    fsType = "none";
    options = [ "bind" ];
  };

  # Expose the nginx-fronted UI on the LAN (replaces the old docker :5000).
  services.nginx.virtualHosts."srvbox".listen = [
    {
      addr = "0.0.0.0";
      port = 8971;
    }
  ];
  networking.firewall.allowedTCPPorts = [ 8971 ];
}
