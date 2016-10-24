#!/usr/bin/env python3

from tools import *
import psutil
import time
import fontawesome as fa
import sys

INTERVAL = 0.2


# draws a vertical bar graph from a list of values in the range [0, 1]
# returns graph as a string
def graph(values):
    chars = '▁▁▂▃▄▅▆▇█'

    indices = [int(v * (len(chars) - 1)) for v in values]
    return ''.join([chars[i] for i in indices])


ic = icon(fa.icons['microchip'])
while True:
    pcts = [core / 100.0 for core in psutil.cpu_percent(percpu=True)]
    g = pango(graph(pcts), GRAPH_COLOR, 'small')
    print("%s %s" % (ic, g))
    sys.stdout.flush()
    time.sleep(INTERVAL)
