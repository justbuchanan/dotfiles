#!/usr/bin/env python3

## Dependencies:
# * acpi - system package
# * fontawesome - install with pip

import tools
import fontawesome as fa
import re
import sys
import subprocess as proc


def is_charging():
    return 'on-line' in proc.check_output(['acpi', '-a']).decode('utf-8')


output = proc.check_output(['acpi', 'battery']).decode('utf-8')

# Acpi prints a message to stderr and nothing to stdout if the sytstem doesn't
# have a battery.  This happens when this script is run on a desktop system
if len(output) == 0:
    sys.exit(1)

pct = int(re.search('(\d+)%', output).group(1))

icons = [
    fa.icons['battery-empty'],  # 0%-12.5%
    fa.icons['battery-quarter'],  # 12.5%-37.5%
    fa.icons['battery-half'],
    fa.icons['battery-three-quarters'],
    fa.icons['battery-full'],
]

i = round(pct / 25)

# urgent color if battery is very low
foreground = tools.URGENT_COLOR if i == 0 else tools.ICON_COLOR

ic = tools.icon(icons[i], foreground=foreground)

if is_charging():
    ic = tools.icon(fa.icons['bolt'], foreground=foreground) + ' ' + ic

print("%s %d%%" % (ic, pct))
