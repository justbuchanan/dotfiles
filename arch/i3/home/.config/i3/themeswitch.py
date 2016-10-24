#!/usr/bin/env python3

import subprocess as proc
import os

"""
Presents a menu (via rofi) to select a new i3 theme. When a selection is made,
the them is converted from i3-style yml format to xresources and saved to
~/.Xresources/i3style.  Xresources are then updated via xrdb and i3 is reloaded
for the changes to take effect.
"""

I3_STYLE_DIR = '/usr/lib/node_modules/i3-style/themes'

builtin_themes = [
    'archlinux',
    'base16-tomorrow',
    'debian',
    'deep-purple',
    'default',
    'flat-gray',
    'gruvbox',
    'lime',
    'okraits',
    'purple',
    'seti',
    'slate',
    'solarized',
    'tomorrow-night-80s',
    'ubuntu',
]

local_themes = [
    'google'
]


def rofi_choose(items):
    rofi = proc.Popen(['rofi', '-dmenu'], stdin=proc.PIPE, stdout=proc.PIPE)
    rofi.stdin.write('\n'.join(items).encode('utf-8'))
    rofi.stdin.close()
    choice = rofi.stdout.read().decode('utf-8').strip('\n')
    return choice


if __name__ == '__main__':
    choice = rofi_choose(builtin_themes + local_themes)
    if choice == "":
        print('No selection, exiting...')
        exit(0)

    if choice in local_themes:
        theme_path = os.path.expanduser('~/.config/i3/%s.yml' % choice)
    else:
        theme_path = os.path.join(I3_STYLE_DIR, choice)

    cmd = [os.path.join(os.path.dirname(__file__), 'i3style2xresources/i3style2xresources.py'), theme_path]
    print(' '.join(cmd))
    xresources_theme = proc.check_output(cmd)

    output_path = os.path.expanduser('~/.Xresources.d/i3theme')

    with open(output_path, 'w') as f:
        f.write(xresources_theme.decode('utf-8'))

    print('wrote theme to %s' % output_path)

    print("Reloading xresources...")
    proc.check_call(['xrdb', os.path.expanduser('~/.Xresources')])
    print("Reloading i3...")
    proc.check_call(['i3-msg', 'reload'])
