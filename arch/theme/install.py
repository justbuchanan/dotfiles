import os
from install.utils import *

syspkg({'arch': ['vertex-icons-git', 'gtk-theme-arc-git', 'adapta-gtk-theme']})

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.gtkrc-2.0')
symlink_home(base, '.config/gtk-3.0/settings.ini')
