#!/usr/bin/env python3

from tools import *
import psutil

vmem = psutil.virtual_memory()

ic = icon('')
g = bar(vmem.percent / 100.0)

used = vmem.used / 10**9
total = vmem.total / 10**9

print("%s %s %.1f/%.1fGB" % (ic, g, used, total))
