#!/usr/bin/env python3

import tools

import wifi
import re
import os
import sys
import time
import fontawesome as fa

interface = os.environ['BLOCK_INSTANCE']

def update():
    try:
        connections = list(wifi.Cell.all(interface))
    except wifi.exceptions.InterfaceError as e:
        connections = []

    if len(connections) == 0:
        icon = tools.icon(fa.icons['wifi'])  # TODO: get a wifi off icon
        text = "No WiFi"
    elif len(connections) == 1:
        icon = tools.icon(fa.icons['wifi'])
        qual_str = connections[0].quality
        vals = re.match(r"^(\d+)/(\d+)", qual_str).groups()
        percent = int(float(vals[0]) / float(vals[1]) * 100)
        text = "%s %d%%" % (connections[0].ssid, percent)
    else:
        icon = tools.icon(fa.icons['wifi']) # TODO: scanning icon?
        text = "Scanning..."

    print("%s %s" % (icon, text))
    sys.stdout.flush()

tools.autoreload_xresources_with_callback(update)

while True:
    update()
    time.sleep(20)
