import os
from install.utils import *

syspkg({
    'arch': [
        'i3-gaps-next-git',
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
    ],
    'deb': [
        # TODO
    ],
})

pip3('psutil')  # needed for some system status bar items
pip3('pyalsaaudio')  # needed for volume item in status bar
pip3('wifi')  # needed for wifi item in status bar
pip3('fontawesome')  # needed for wifi item in status bar

# Provides themes for i3
npm('i3-style')

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/i3blocks')
symlink_home(base, '.config/i3')

# i3wm theme is configured via xresources
# don't symlink it b/c it's a local symlink to an actual theme file
# if no i3theme is present, set one by using the themeswitcher script in the i3 config directory
# symlink_home(base, '.Xresources.d/i3theme')

# for workspace auto-naming script
pip3('i3ipc')
