#!/usr/bin/env python3

from tools import *

import wifi
import re
import os

interface = os.environ['BLOCK_INSTANCE']

try:
    connections = list(wifi.Cell.all(interface))
except wifi.exceptions.InterfaceError as e:
    connections = []

if len(connections) == 0:
    icon = icon('')  # TODO: get a wifi off icon
    text = "No WiFi"
elif len(connections) == 1:
    icon = icon('')
    qual_str = connections[0].quality
    vals = re.match(r"^(\d+)/(\d+)", qual_str).groups()
    percent = int(float(vals[0]) / float(vals[1]) * 100)
    text = "%s %d%%" % (connections[0].ssid, percent)
else:
    icon = icon('') # TODO: scanning icon?
    text = "Scanning..."

print("%s %s" % (icon, text))
