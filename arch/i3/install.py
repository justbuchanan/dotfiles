import os
from install.utils import *

syspkg({'arch': [
    'i3-gaps-git',
    'i3blocks-gaps-git',
    'i3lock-blur',
    'xautolock',
    'perl-anyevent-i3',  # required dependency for savling/loading layouts
    # for launching a terminal in the same directory as the current window
    'xcwd-git',
    'xorg-xprop',
    # hide mouse cursor when not in use
    'unclutter-xfixes-git',

    # used to set the desktop background image
    'feh',

    # transparency and other fanciness
    'compton',
]})

pip3('psutil')  # needed for some system status bar items
pip3('pyalsaaudio') # needed for volume item in status bar
pip3('wifi') # needed for wifi item in status bar
pip3('fontawesome') # needed for wifi item in status bar

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/i3blocks')
symlink_home(base, '.config/i3')

# i3wm theme is configured via xresources
symlink_home(base, '.Xresources.d/i3theme')

# for workspace auto-naming script
pip3('i3ipc')
