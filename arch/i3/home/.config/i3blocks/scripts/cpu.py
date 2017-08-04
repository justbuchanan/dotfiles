#!/usr/bin/env python3

import tools
import psutil
import time
import sys
import fontawesome as fa

INTERVAL = 0.5

def update():
    pct = float(psutil.cpu_percent())

    ic = tools.icon(fa.icons['tachometer'])
    g = tools.bar(pct / 100.0)

    print("%s %s %0.f%%" % (ic, g, pct))
    sys.stdout.flush()

tools.autoreload_xresources_with_callback(update)

while True:
    update()
    time.sleep(INTERVAL)

