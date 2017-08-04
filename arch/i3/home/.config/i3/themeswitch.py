#!/usr/bin/env python3

import subprocess as proc
import os
import sys

"""
Presents a menu (via rofi) to select a new i3 theme. When a selection is made,
the theme is converted from i3-style yaml format to xresources and saved to
~/.Xresources/i3style.  Xresources are then updated via xrdb and i3 is reloaded
for the changes to take effect.
"""

I3_STYLE_DIR = '/usr/lib/node_modules/i3-style/themes'
LOCAL_THEME_DIR = os.path.expanduser('~/.config/i3/themes')

OUTPUT_PATH = os.path.expanduser('~/.Xresources.d/i3theme')

# detect themes in local and i3-style directories

try:
    builtin_themes = sorted(os.listdir(I3_STYLE_DIR))
except FileNotFoundError:
    print("Can't find i3-style themes, install i3-style with npm", file=sys.stderr)
    builtin_themes = []

try:
    local_themes = sorted(os.listdir(LOCAL_THEME_DIR))
except FileNotFoundError:
    local_themes = []



def rofi_choose(items):
    rofi = proc.Popen(['rofi', '-dmenu'], stdin=proc.PIPE, stdout=proc.PIPE)
    rofi.stdin.write('\n'.join(items).encode('utf-8'))
    rofi.stdin.close()
    choice = rofi.stdout.read().decode('utf-8').strip('\n')
    return choice

def rofi_menu(theme_names):
    choice = rofi_choose(theme_names)
    if choice == "":
        print('No selection, exiting...')
        exit(0)
    return choice


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="Switch i3 themes - wrapper around i3-style to use xresources themes.")
    parser.add_argument('--rofi', action='store_true', help="Display a theme menu with rofi.")
    parser.add_argument('--theme', help='The name of a theme to use.')
    args = parser.parse_args()

    themes = builtin_themes + local_themes

    if args.rofi:
        choice = rofi_menu(themes)
    else:
        choice = args.theme
        if choice == None:
            parser.print_usage()
            sys.exit(1)

    if choice in local_themes:
        theme_path = os.path.join(LOCAL_THEME_DIR, choice)
    else:
        theme_path = os.path.join(I3_STYLE_DIR, choice)

    if not os.path.isfile(theme_path):
        print("Invalid theme: '%s'" % theme_path)
        sys.exit(1)

    cmd = [os.path.join(os.path.dirname(__file__), 'i3style2xresources/i3style2xresources.py'), theme_path]
    print(' '.join(cmd))
    xresources_theme = proc.check_output(cmd)

    with open(OUTPUT_PATH, 'w') as f:
        f.write(xresources_theme.decode('utf-8'))

    print('wrote theme to %s' % OUTPUT_PATH)

    print("Reloading xresources...")
    proc.check_call(['xrdb', os.path.expanduser('~/.Xresources')])
    print("Reloading i3...")
    proc.check_call(['i3-msg', 'reload'])
