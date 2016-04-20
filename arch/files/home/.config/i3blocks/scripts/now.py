#!/usr/bin/env python3

from tools import *
import datetime

now = datetime.datetime.now()
txt = pango(now.strftime('%a %m/%d %H:%M'))

ic = icon('')

print("%s %s" % (ic, txt))
