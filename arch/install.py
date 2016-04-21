from install.utils import *
from install.arch import *

symlinks = [
	'.compton.conf',
	'.config/desktop-background.jpeg',
	# '.config/.xdg-config',
	'.fehbg',
	'.profile.d/arch-aliases.sh',
	'.profile.d/arch-monitor.sh',
	'.xinitrc',
    # - .xprofile,
	'.Xmodmap',
	'.Xresources.d/rxvt-unicode',
	'.Xresources.d/rofi',
	'.zlogin',
	'.yaourtrc',

	'.config/dunst',
	'.config/herbstluftwm',
	'.config/vis',
	# 'profile.d',
	# 'Xresources.d',
]

cur_dir = os.path.dirname(os.path.realpath(__file__))
for path in symlinks:
	symlink_home(os.path.join(cur_dir, "home"), path)

import sys
sys.path.append(os.path.dirname(__file__))

import cmdline.install

if linux_is_graphical():
	import i3.install
	import xorg.install
	import gui.install
	import theme.install
else:
	print("No display detected, skipping installation of graphical components")
