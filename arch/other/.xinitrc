#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# load keyboard customizations
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi


# load colors, fonts, etc
xrdb ~/.Xresources

# make touchscreen work on the correct screen
# TODO: only do this on arch laptop
#xinput --map-to-output 9 eDP1

# fix screen resolution if its not right
#if [[ xrandr | grep "Screen 0" | grep -v "current 5120 x 1440"  ]]; then
#~/.screenlayout/default.sh
#fi

exec i3

