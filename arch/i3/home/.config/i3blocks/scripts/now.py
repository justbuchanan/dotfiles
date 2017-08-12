#!/usr/bin/env python3

import tools
import datetime
import time
import sys


def update():
    now = datetime.datetime.now()
    txt = now.strftime('%a %m/%d %H:%M')

    ic = tools.icon('')

    print("%s %s" % (ic, txt))
    sys.stdout.flush()


tools.autoreload_xresources_with_callback(update)

while True:
    update()
    time.sleep(30)
