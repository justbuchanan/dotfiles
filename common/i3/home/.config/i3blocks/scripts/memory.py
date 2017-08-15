#!/usr/bin/env python3

import tools
import psutil
import sys
import time
import fontawesome as fa


def update():
    vmem = psutil.virtual_memory()

    ic = tools.icon(fa.icons['microchip'])
    g = tools.bar(vmem.percent / 100.0)

    used = vmem.used / 10**9
    total = vmem.total / 10**9

    print("%s %s %.1f/%.1fGB" % (ic, g, used, total))
    sys.stdout.flush()


tools.autoreload_xresources_with_callback(update)

while True:
    update()
    time.sleep(20)
