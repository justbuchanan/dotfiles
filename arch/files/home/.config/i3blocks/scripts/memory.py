#!/usr/bin/env python3

from tools import *
import psutil


pct = psutil.virtual_memory().percent

ic = icon('')
g = bar(pct / 100.0)

print("%s %s %0.f%%" % (ic, g, pct))
