#!/usr/bin/env python3

import tools
import fontawesome as fa
import subprocess as proc
import sys
import time

def update():
    pkgs = proc.check_output(['checkupdates']).decode('utf-8')
    count = len(pkgs.split('\n')) - 1

    if count > 0:
        icon = tools.icon(fa.icons['gift'])
        print("%s %d" % (icon, count))
    else:
        print()
    sys.stdout.flush()

while True:
    update()
    time.sleep(60)
