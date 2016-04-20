#!/usr/bin/env python3

from tools import *
import psutil
import time

time.sleep(0.01)

pct = float(psutil.cpu_percent())

ic = icon('')
g = bar(pct / 100.0)

print("%s %s %0.f%%" % (ic, g, pct))
