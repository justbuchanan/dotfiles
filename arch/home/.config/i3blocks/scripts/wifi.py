#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from tools import *

from pythonwifi.iwlibs import Wireless
import re

interface = 'wlp2s0'
wifi = Wireless(interface)

# try:
#     connections = list(wifi.scan.Cell.all(interface))
# except wifi.exceptions.InterfaceError as e:
#     connections = []

# if len(connections) == 0:
#     icon = icon('') # TODO: get a wifi off icon
#     text = "No WiFi"
# elif len(connections) == 1:
#     icon = icon('')
#     # qual_str = connections[0].quality
#     # vals = re.match(r"^(\d+)/(\d+)", qual_str).groups()
#     # percent = int(float(vals[0]) / float(vals[1]) * 100)
#     # text = "%d%%" % percent
#     text = connections[0].ssid
# else:
#     icon = icon('') # TODO: scanning icon?
#     text = "Scanning..."

ic = icon('') # TODO: scanning icon?
text = wifi.getEssid()

print("%s %s" % (ic, pango(text)))
