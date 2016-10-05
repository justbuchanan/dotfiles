from install.utils import *
from install.arch import *
import subprocess as proc

print("Updating pacman package databases")
proc.check_call(['sudo', 'pacman', '-Sy'])

symlinks = [
    '.compton.conf',
    '.config/desktop-background.jpeg',
    '.profile.d/arch-aliases.sh',
    '.profile.d/arch-monitor.sh',
    '.xinitrc',
    '.Xmodmap',
    '.zlogin',
]

for path in symlinks:
    symlink(__file__, os.path.join('home', path), os.path.join('~', path))

import sys
sys.path.append(os.path.dirname(__file__))

import cmdline.install

if linux_is_graphical():
    from .i3 import install
    import xorg.install
    import gui.install
    import gtk_theme.install
    import photos.install
    import dunst.install
    import cli_visualizer.install
    import rofi.install
    import urxvt.install
else:
    print("No display detected, skipping installation of graphical components")
