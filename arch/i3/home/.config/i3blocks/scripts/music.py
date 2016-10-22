#!/usr/bin/env python3

from gi.repository import Playerctl, GLib
from tools import *

player = Playerctl.Player()

# Font awesome
FA_PLAY = ''
FA_PAUSE = ''

# current state
artist = ''
title = ''
status_icon = ''

def print_status():
    print(icon(status_icon) + ' ' + artist + ' - ' + title)

def on_metadata(player, e):
    global artist
    global title
    if 'xesam:artist' in e.keys():
        artist = e['xesam:artist'][0]
    if 'xesam:title' in e.keys():
        title = e['xesam:title']
    print_status()

def on_play(player):
    global status_icon
    status_icon = FA_PLAY
    # print('Playing at volume {}'.format(player.props.volume))
    print_status()

def on_pause(player):
    global status_icon
    status_icon = FA_PAUSE
    # print('Paused the song: {}'.format(player.get_title()))
    print_status()

player.on('play', on_play)
player.on('pause', on_pause)
player.on('metadata', on_metadata)

print('music!')

# wait for events
main = GLib.MainLoop()
main.run()


# TODO: install python-gobject via pacman