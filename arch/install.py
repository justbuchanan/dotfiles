from install.utils import *
from install.arch import *

symlinks = [
	'.compton.conf',
	'.config/desktop-background.jpeg',
	'.fehbg',
	'.profile.d/arch-aliases.sh',
	'.profile.d/arch-monitor.sh',
	'.xinitrc',
	'.Xmodmap',
	'.Xresources.d/rxvt-unicode',
	'.Xresources.d/rofi',
	'.zlogin',
	'.yaourtrc',

	'.config/dunst',
	'.config/herbstluftwm',
	'.config/vis',
]

cur_dir = os.path.dirname(os.path.realpath(__file__))
for path in symlinks:
	symlink_home(os.path.join(cur_dir, "home"), path)

import sys
sys.path.append(os.path.dirname(__file__))

import cmdline.install

if linux_is_graphical():
	from .i3 import install
	import xorg.install
	import gui.install
	import theme.install
else:
	print("No display detected, skipping installation of graphical components")
