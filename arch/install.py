from install.utils import *
from install.arch import *
import subprocess as proc

print("Updating pacman package databases")
run_cmd(['sudo', 'pacman', '-Sy'])

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
    symlink(__file__, os.path.join('other', path), os.path.join('~', path))

import sys
sys.path.append(os.path.dirname(__file__))

import cmdline.install
import yubikey.install
from .wifi import install

if True:
    from .i3 import install
    import xorg.install
    import gui.install
    import gtk_theme.install
    import photos.install
    import dunst.install
    import cli_visualizer.install
    import rofi.install
    import urxvt.install
    import printer.install
else:
    print("No display detected, skipping installation of graphical components")
