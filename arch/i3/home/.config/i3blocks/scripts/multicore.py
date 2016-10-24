#!/usr/bin/env python3

import tools
import psutil
import time
import fontawesome as fa
import sys
import signal

INTERVAL = 0.2


# draws a vertical bar graph from a list of values in the range [0, 1]
# returns graph as a string
def graph(values):
    chars = '▁▁▂▃▄▅▆▇█'

    indices = [int(v * (len(chars) - 1)) for v in values]
    return ''.join([chars[i] for i in indices])

# reload colors when signalled
signal.signal(signal.SIGRTMIN + 1, lambda: tools.reload_xresources())

ic = tools.icon(fa.icons['microchip'])
while True:
    pcts = [core / 100.0 for core in psutil.cpu_percent(percpu=True)]
    g = tools.pango(graph(pcts), tools.GRAPH_COLOR, 'small')
    print("%s %s" % (ic, g))
    sys.stdout.flush()
    time.sleep(INTERVAL)
