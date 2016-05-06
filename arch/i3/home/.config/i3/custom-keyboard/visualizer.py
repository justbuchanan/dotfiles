#!/usr/bin/env python3

"""
Launches cli-visualizer and fullscreens it globally.
"""

import time
import subprocess as proc

import i3ipc
i3 = i3ipc.Connection()

win_title = 'vis2'
i3.command('exec urxvt -title %s -e vis' % win_title)
time.sleep(0.1)
i3.command('[title=%s] fullscreen toggle global' % win_title)
