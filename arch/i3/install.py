import os
from install.utils import *

syspkg({'arch': [
    'i3-gaps-git',
    'i3blocks-gaps-git',
    'i3lock-blur',
    'xautolock',

    'perl-anyevent-i3', # required dependency for savling/loading layouts
    # for launching a terminal in the same directory as the current window
    'xcwd-git',

    'xorg-xprop',

    # hide mouse cursor when not in use
    'unclutter-xfixes-git',
]})

pip3('psutil') # needed for some system status bar items

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/i3blocks')
symlink_home(base, '.config/i3',)

# for workspace auto-naming script
pip3('i3ipc')
