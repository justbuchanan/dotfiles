#!/usr/bin/env python3

from tools import *
import os
import re

output = run(['acpi', 'battery'])
pct = int(re.search('(\d+)%', output).group(1))

icons = [
    '', # 0-12.5
    '', # 12-5-37.5
    '',
    '',
    '',
]

i = round(pct / 25)

ic = icon(icons[i], color = URGENT_COLOR if i == 0 else ICON_COLOR)

print("%s %d%%" % (ic, pct))
