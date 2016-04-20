#!/usr/bin/env python3

from tools import *
import alsaaudio

mixer = alsaaudio.Mixer('Master')

volumes = mixer.getvolume()
pct = sum(volumes) / len(volumes)

mutes = mixer.getmute()
muted = sum(mutes) != 0

if muted:
    ic = icon('')
elif pct < 30:
    ic = icon('')
else:
    ic = icon('')

print("%s %d%%" % (ic, int(pct)))
