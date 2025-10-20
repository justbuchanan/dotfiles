{ config, pkgs, ... }:

let
  style_icon = icon: "<span foreground='#${config.lib.stylix.colors.base09}'>${icon}</span>";
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;

        modules-left = [
          # "custom/nixos-logo"
          "niri/workspaces"
          "custom/media"
        ];

        modules-center = [ ];

        modules-right = [
          "custom/weather"
          "idle_inhibitor"
          "pulseaudio"
          "memory"
          "battery"
          "clock"
          "network"
          "tray"
          "custom/logout"
        ];

        "idle_inhibitor" = {
          format = style_icon "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip-format-activated = "idle inhibitor ON";
          tooltip-format-deactivated = "idle inhibitor OFF";
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          format = "{:%H:%M %a %m/%d}";
          tooltip = false;
        };

        "cpu" = {
          format = "${style_icon ""} {usage}%";
          tooltip = false;
        };

        "memory" = {
          format = "${style_icon ""} {}%";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "${style_icon "{icon}"} {capacity}%";
          # format-full = "{capacity}% {icon}";
          format-charging = "${style_icon ""} {capacity}%";
          format-plugged = "${style_icon ""} {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "network" = {
          format-wifi = "${style_icon ""} {essid} ({signalStrength}%)";
          format-ethernet = "${style_icon ""}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)  ";
          format-disconnected = "${style_icon "󰖪"} Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "${style_icon "{icon}"} {volume}% {format_source}";
          format-bluetooth = "{icon}${style_icon ""} {volume}% {format_source}";
          format-bluetooth-muted = "${style_icon ""} {icon} {format_source}";
          format-muted = "${style_icon ""} {format_source}";
          format-source = "${style_icon ""} {volume}%";
          format-source-muted = style_icon "";
          format-icons = {
            # car= """;
            # hands-free = "";
            # headphone = "";
            # headset = "";
            # phone = "";
            # portable = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        "custom/media" = {
          format = "{}";
          return-type = "json";
          max-length = 40;
          escape = true;
          exec = "mediaplayer --player spotify";
        };

        "custom/weather" = {
          format = "{}°";
          tooltip = true;
          interval = 3600;
          exec = "wttrbar --fahrenheit";
          return-type = "json";
        };

        "custom/nixos-logo" = {
          format = "";
          tooltip = false;
        };

        "niri/workspaces" = {
          format = "{value}";
        };

        "custom/logout" = {
          format = style_icon "";
          tooltip = false;
          on-click = "niri msg action quit";
        };

        "custom/multicore_cpu" = {
          format = "  {}";
          exec = "~/src/justin/dotfiles/home/.config/waybar/cpugraph.sh";
        };
      };
    };

    style = ''
      * {
          font-family: Hack Nerd Font Propo;
          font-size: 14px;
      }

      /*window#waybar {
        background: alpha(@base00, 0.5);
      }*/

      #workspaces button {
        border-radius: 0;
        /* text color - TODO
        color: black; */
      }

      .modules-left #workspaces button.focused {
        background: @base03;
        border-bottom: 0px;
      }

      #custom-nixos-logo {
        background-image: url("/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg");
        background-size: 16px;
        background-repeat: no-repeat;
        background-position: center;
        min-width: 24px;
        margin-left: 8px;
        margin-right: 8px;
        font-size: 0;
      }

      #tray, #custom-logout {
        margin-right: 10px;
      }
    '';
  };
}
