#!/usr/bin/env python3

import tools
import fontawesome as fa
import alsaaudio
import subprocess
import os
import sys

# Dependencies:
# * alsaaudio - install with pip
# * alsactl - part of the alsa-utils package


def update():
    mixer = alsaaudio.Mixer('Master')

    volumes = mixer.getvolume()
    pct = sum(volumes) / len(volumes)

    mutes = mixer.getmute()
    muted = sum(mutes) != 0

    # TODO: pull these from fontawesome
    if muted:
        ic = tools.icon(fa.icons['volume-off'])
    elif pct < 30:
        ic = tools.icon(fa.icons['volume-down'])
    else:
        ic = tools.icon(fa.icons['volume-up'])

    print("%s %d%%" % (ic, int(pct)))
    sys.stdout.flush()


update()

tools.autoreload_xresources_with_callback(update)

# update() every time the volume changes
# stdbuf is used bc otherwise alsactl doesn't output after each line
# see: http://askubuntu.com/questions/630564/cant-redirect-stdout-of-alsactl-monitor
alsactl = subprocess.Popen(
    ['stdbuf', '-oL', 'alsactl', 'monitor'],
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL)
for _ in alsactl.stdout:
    update()
