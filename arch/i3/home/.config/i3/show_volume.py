#!/usr/bin/env python3

import subprocess
import alsaaudio

mixer = alsaaudio.Mixer("Master")

muted = sum(mixer.getmute()) != 0

# show popup/HUD for volume
if muted:
    subprocess.check_call(['volnoti-show', '--mute'])
else:
    # average left/right channels
    stereo = mixer.getvolume()
    vol = float(sum(stereo)) / len(stereo)

    subprocess.check_call(['volnoti-show', str(int(vol))])
