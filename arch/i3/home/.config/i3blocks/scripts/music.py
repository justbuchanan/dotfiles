#!/usr/bin/env python3

## Volume script for i3blocks
#
# This script uses playerctl to update whenever the current song changes, rather
# than polling at a fixed interval.
#
# Dependencies:
# * python-gobject - system package
# * playerctl - system package

import gi
gi.require_version('Playerctl', '1.0')
from gi.repository import Playerctl, GLib

import tools
import sys
import time
import fontawesome as fa
import re

# current state
artist = None
title = None

prev_status = None

def print_status():
    global artist, title, prev_status
    if artist and title:
        status = tools.icon(fa.icons['music']) + ' ' + artist + ' - ' + title
    else:
        status = ''

    if status != prev_status:
        print(status)
        sys.stdout.flush()
        prev_status = status

def on_metadata(player, e):
    global artist
    global title
    try:
        artist, title = e['xesam:artist'][0], filter_title(e['xesam:title'])
    except (IndexError, KeyError) as e:
        artist, title = None, None
    print_status()

def filter_title(title):
    # remove the first '(' and anything after it
    return re.search('(.+)\(?.*', title).group(1)

def on_play(player):
    print_status()

def on_pause(player):
    print_status()

def on_quit(player):
    global artist, title
    artist, title = None, None
    print_status()

main = GLib.MainLoop()

tools.autoreload_xresources_with_callback(print_status)

while True:
    try:
        # note: this will fail if no player is currently running. This is fine -
        # we catch the exception, then try to connect again later.
        player = Playerctl.Player()
        if player.get_property('player-name') == None:
            continue
        player.on('metadata', on_metadata)  
        player.on('exit', on_quit)

        artist = player.get_artist()
        title = filter_title(player.get_title())
        print_status()

        main.run()
    except Exception as e:
        print(e, file=sys.stdout)

    # wait 5 seconds before trying again
    time.sleep(5)
