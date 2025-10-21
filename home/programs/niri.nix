{
  config,
  pkgs,
  inputs,
  ...
}:

let
  lock_cmd = "swaylock -f -c 000000";
in
{
  home.packages = with pkgs; [
    swaybg
    swayidle
    inputs.niri-autoname-workspaces.packages.${pkgs.system}.default
  ];

  programs.niri = {
    settings = {
      hotkey-overlay = {
        skip-at-startup = true;
      };

      input = {
        keyboard = {
          xkb = {
            # Remap caps lock to act as the Super (mod) key
            options = "caps:super";
          };
        };
        touchpad = {
          # disable-while-typing (palm rejection while typing)
          dwt = true;
        };
        focus-follows-mouse.enable = true;
      };

      # disable "client side decorations", including ugly window title bars
      prefer-no-csd = true;

      switch-events = {
        # TODO: fix this. for some reason, it says spawn-sh isn't defined
        # lid-close.action = spawn-sh lock_cmd;
        lid-close.action.spawn = "swaylock";
      };

      spawn-at-startup = [
        # Import environment variables to systemd so services can access WAYLAND_DISPLAY
        {
          argv = [
            "systemctl"
            "--user"
            "import-environment"
            "DISPLAY"
            "WAYLAND_DISPLAY"
          ];
        }
        {
          argv = [
            "systemctl"
            "--user"
            "restart"
            "xdg-desktop-portal-gtk"
          ];
        }
        {
          argv = [
            "systemctl"
            "--user"
            "start"
            "xdg-desktop-portal"
          ];
        }
        {
          argv = [
            "waybar"
          ];
        }
        { argv = [ "nm-applet" ]; }
        {
          argv = [
            "swaybg"
            "--image"
            "/home/justin/src/justin/dotfiles/wallpapers/artist_point.jpg"
          ];
        }
        {
          argv = [ "niri-autoname-workspaces" ];
        }
        {
          # Idle configuration
          # This will lock your screen after 300 seconds of inactivity, then turn off
          # your displays after another 300 seconds, and turn your screens back on when
          # resumed. It will also lock your screen before your computer goes to sleep.
          sh = ''
            exec swayidle -w \
                    timeout 300 'swaylock -f -c 000000' \
                    timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
                    before-sleep 'swaylock -f -c 000000'
          '';
        }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Space".action.spawn = "fuzzel";

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;

        "Mod+BracketLeft".action = focus-workspace-up;
        "Mod+BracketRight".action = focus-workspace-down;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        # Consume one window from the right to the bottom of the focused column.
        "Mod+Comma".action = consume-window-into-column;
        # Expel the bottom window from the focused column to the right.
        "Mod+Period".action = expel-window-from-column;

        # horizontal resizing
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";

        # vertical resizing
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+F".action = fullscreen-window;
        "Mod+Shift+F".action = expand-column-to-available-width;

        "Print".action = screenshot;

        # Volume/mute
        "XF86AudioRaiseVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
        "XF86AudioLowerVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        "XF86AudioMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        # Media keys
        # Note: the `--player` option deprioritizes Chromium. This way if spotify is
        # playing, the play/pause will affect spotify and not some random youtube video you have open.
        "XF86AudioPlay".action = spawn-sh "playerctl --player=%any,chromium play-pause";
        "XF86AudioStop".action = spawn-sh "playerctl --player=%any,chromium stop";
        "XF86AudioPrev".action = spawn-sh "playerctl --player=%any,chromium previous";
        "XF86AudioNext".action = spawn-sh "playerctl --player=%any,chromium next";

        # screen brightness
        "XF86MonBrightnessUp".action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "--class=backlight" "set" "10%-";

        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };

        # launch terminal
        "Mod+Return".action =
          spawn-sh ''ghostty +new-window --working-directory="$(~/src/justin/dotfiles/home/.config/niri/scripts/cwd.sh)"'';

        "Mod+Y".action.spawn-sh = "niri-autoname-workspaces rename";

        "Mod+N".action.spawn = "~/src/justin/dotfiles/home/.config/niri/scripts/focus-last-workspace.sh";
        "Mod+Shift+N".action.spawn-sh =
          "~/src/justin/dotfiles/home/.config/niri/scripts/focus-last-workspace.sh take-window";

        "Mod+X" = {
          repeat = false;
          action = close-window;
        };

        "Mod+Escape".action = spawn-sh lock_cmd;

        "Mod+Shift+Escape".action = quit;
      };
    };
  };

  home.file = {
    ".config/niri/autoname-workspaces.toml".text = ''
      # # make the focused window icon big and gold/orange
      # focused_format = "<span foreground='#E58606'><big>{}</big></span>"
      focused_format = "<span foreground='#${config.lib.stylix.colors.base09}'>{}</span>"
    '';
  };
}
