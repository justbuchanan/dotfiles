#!/usr/bin/env python3

import tools
import psutil
import time
import fontawesome as fa
import sys

INTERVAL = 0.1


# draws a vertical bar graph from a list of values in the range [0, 1]
# returns graph as a string
def graph(values):
    chars = ' ▁▂▃▄▅▆▇█'

    indices = [round(v * (len(chars) - 1)) for v in values]
    return ''.join([chars[i] for i in indices])


# read per-core cpu usage and print a graph of it
def update():
    ic = tools.icon(fa.icons['tachometer-alt'])

    pcts = [core / 100.0 for core in psutil.cpu_percent(percpu=True)]
    g = tools.pango(
        graph(pcts),
        foreground=tools.GRAPH_COLOR,
        background=tools.GRAPH_BACKGROUND_COLOR,
        font_size='small')
    print("%s %s" % (ic, g))
    sys.stdout.flush()

# update on a fixed interval and also when bar config changes
tools.autoreload_xresources_with_callback(update)
while True:
    update()
    time.sleep(INTERVAL)
