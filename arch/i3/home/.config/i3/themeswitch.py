#!/usr/bin/env python3

import subprocess as proc
import os

themes = [
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

def rofi_choose(items):
    rofi = proc.Popen(['rofi', '-dmenu'], stdin=proc.PIPE, stdout=proc.PIPE)
    rofi.stdin.write('\n'.join(items).encode('utf-8'))
    rofi.stdin.close()
    choice = rofi.stdout.read().decode('utf-8').strip('\n')
    return choice


if __name__ == '__main__':
    choice = rofi_choose(themes)
    if choice == "":
        print('No selection, exiting...')
        exit(0)

    i3_config_path = os.path.expanduser('~/.config/i3/config')
    cmd = ['i3-style', '-o', i3_config_path, '--reload', choice]
    print(' '.join(cmd))
    proc.check_call(cmd, stdout=proc.DEVNULL)
