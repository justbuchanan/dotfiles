from install.utils import *
from install.arch import *

symlinks = [
	'.compton.conf',
	'.config/desktop-background.jpeg',
	'.config/sxhkd/sxhkdrc',
	'.config/sxhkd/toggle-mute.sh',
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

	'.config/i3/config',
	'.config/i3/bogus.py',
	'.config/i3/i3status.conf',

	'.config/i3blocks/config',
	'.config/i3blocks/i3blocks-contrib',
	'.config/i3blocks/scripts',
	'.config/bspwm',
	'.config/dunst',
	'.config/i3blocks',
	'.config/i3',
	'.config/herbstluftwm',
	'.config/sxhkd',
	'.config/vis',
	# 'profile.d',
	# 'Xresources.d',
]

cur_dir = os.path.dirname(os.path.realpath(__file__))
for path in symlinks:
	symlink_home(os.path.join(cur_dir, "home", path))
