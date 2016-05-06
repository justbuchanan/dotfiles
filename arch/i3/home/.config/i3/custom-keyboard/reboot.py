#!/usr/bin/env python3

from collections import OrderedDict
import subprocess as proc


def rofi(options):
    p = proc.Popen(['rofi', '-dmenu'], stdin=proc.PIPE, stdout=proc.PIPE)
    out = p.communicate(input='\n'.join(options).encode('utf-8'))[0]
    return out.decode('utf-8').strip()

choices = OrderedDict([
    ('reboot', lambda: proc.check_call(['reboot'])),
    ('shutdown', lambda: proc.check_call(['shutdown'])),
    ('cancel', lambda: print('')),
])
choice = rofi(choices.keys())
choices[choice]()
