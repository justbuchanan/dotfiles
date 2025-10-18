{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    # Enable hyprpm for plugin management
    extraConfig = ''
      exec-once = hyprpm reload -n
      exec-once = nm-applet &
      exec-once = waybar --config ~/src/justin/dotfiles/home/.config/waybar/config-hyprland & hyprpaper
    '';
    # plugin = ${pkgs.hyprlandPlugins.hy3.x86_64-linux.hy3}/lib/libhy3.so

    # Add hy3 as a plugin
    plugins = [
      # Assuming hy3 is available in your Nixpkgs or a custom overlay
      pkgs.hyprlandPlugins.hy3 # Or the correct path to hy3 if it's from an overlay/flake
    ];

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      # "$fileManager" = "dolphin";
      "$menu" = "fuzzel | xargs hyprctl exec --";
      input = {
        kb_options = "caps:super";
        touchpad = {
          natural_scroll = true;
        };
      };
      monitor = "eDP-1,2256x1504,auto,1.175";
      bind = [
        # navigate with hjkl (vim) shortcuts
        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"

        "$mainMod, Return, exec, $terminal"
        "$mainMod, Space, exec, $menu"

        "$mainMod, F, fullscreen"
        "$mainMod, M, fullscreen, 1"
        "$mainMod, X, hy3:killactive"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # switch to next available empty workspace
        "$mainMod, N, workspace, emptyn"
        # switch to next available empty workspace
        "$mainMod SHIFT, N, hy3:movetoworkspace, emptyn"

        # switch to prev/next workspace
        "$mainMod, bracketright, workspace, +1"
        "$mainMod, bracketleft, workspace, -1"

        # move window to prev/next workspace
        "$mainMod SHIFT, bracketright, hy3:movetoworkspace, +1"
        "$mainMod SHIFT, bracketleft, hy3:movetoworkspace, -1"

        "$mainMod SHIFT, H, hy3:movewindow, l"
        "$mainMod SHIFT, L, hy3:movewindow, r"
        "$mainMod SHIFT, K, hy3:movewindow, u"
        "$mainMod SHIFT, J, hy3:movewindow, d"

        # comparable to i3/sway splitv,splith
        "$mainMod, U, hy3:makegroup, v"
        "$mainMod, I, hy3:makegroup, h"
        # tab/untab, v/h
        "$mainMod, W, hy3:changegroup, toggletab"
        "$mainMod, S, hy3:changegroup, toggletab"
        "$mainMod, E, hy3:changegroup, opposite"

        # cycle through tabs in the rightward direction
        "$mainMod, T, hy3:focustab, r, wrap"

        # select parent container
        "$mainMod, A, hy3:changefocus, raise"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, hy3:movetoworkspace, 1"
        "$mainMod SHIFT, 2, hy3:movetoworkspace, 2"
        "$mainMod SHIFT, 3, hy3:movetoworkspace, 3"
        "$mainMod SHIFT, 4, hy3:movetoworkspace, 4"
        "$mainMod SHIFT, 5, hy3:movetoworkspace, 5"
        "$mainMod SHIFT, 6, hy3:movetoworkspace, 6"
        "$mainMod SHIFT, 7, hy3:movetoworkspace, 7"
        "$mainMod SHIFT, 8, hy3:movetoworkspace, 8"
        "$mainMod SHIFT, 9, hy3:movetoworkspace, 9"
        "$mainMod SHIFT, 0, hy3:movetoworkspace, 10"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, hy3:movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      general = {
        layout = "hy3";
      };
      # 3-finger swipe to switch workspaces
      gesture = "3, horizontal, workspace";
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];
      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
