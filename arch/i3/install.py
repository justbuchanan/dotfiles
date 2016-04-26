import os
from install.arch import *
from install.utils import *

yaourt('i3-gaps-git')
yaourt('i3blocks-gaps-git')
yaourt('i3lock-blur')
pacman('xautolock')
pip3('psutil') # needed for some system stats bar items
pacman('perl-anyevent-i3') # required dependency for savling/loading layouts

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/i3blocks')
symlink_home(base, '.config/i3',)

# for launching a terminal in the same directory as the current window
yaourt('xcwd-git')
