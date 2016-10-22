#!/usr/bin/env python3

# Dependencies:
# * 'python-gobject' - system package

import gi
gi.require_version('Playerctl', '1.0')
from gi.repository import Playerctl, GLib

from tools import *
import sys
import time
import fontawesome as fa

# current state
artist = None
title = None

def print_status():
    if artist and title:
        print(icon(fa.icons['music']) + ' ' + artist + ' - ' + title)
        sys.stdout.flush()

def on_metadata(player, e):
    global artist
    global title
    if 'xesam:artist' in e.keys():
        artist = e['xesam:artist'][0]
    if 'xesam:title' in e.keys():
        title = e['xesam:title']
    print_status()

def on_play(player):
    print_status()

def on_pause(player):
    print_status()



# wait for events
main = GLib.MainLoop()

while True:
    try:
        player = Playerctl.Player()
        player.on('play', on_play)
        player.on('pause', on_pause)
        player.on('metadata', on_metadata)  

        artist = player.get_artist()
        title = player.get_title()
        print_status()

        main.run()
    except Exception as e:
        print(e, file=sys.stdout)

    # wait 5 seconds before trying again
    time.sleep(5)
