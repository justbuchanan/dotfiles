import os
from install.arch import *
from install.utils import *

archpkg('i3-gaps-git')
archpkg('i3blocks-gaps-git')
archpkg('i3lock-blur')
archpkg('xautolock')
pip3('psutil') # needed for some system stats bar items
archpkg('perl-anyevent-i3') # required dependency for savling/loading layouts

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/i3blocks')
symlink_home(base, '.config/i3',)

# for launching a terminal in the same directory as the current window
archpkg('xcwd-git')

# for workspace auto-naming script
pip3('i3ipc')
archpkg('xorg-xprop')

# hide mouse cursor when not in use
archpkg('unclutter-xfixes-git')
