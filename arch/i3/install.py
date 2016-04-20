import os
from install.arch import *
from install.utils import *

yaourt('i3-gaps-git')
yaourt('i3blocks-gaps-git')
yaourt('i3lock-blur')
pacman('xautolock')

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/i3blocks')
symlink_home(base, '.config/i3',)
