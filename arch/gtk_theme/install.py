import os
from install.utils import *

syspkg({'arch': ['vertex-icons-git', 'gtk-theme-arc-git', 'adapta-gtk-theme']})

symlink(__file__, 'gtkrc-2.0', '~/.gtkrc-2.0')
symlink(__file__, 'gtk3-settings.ini', '~/.config/gtk-3.0/settings.ini')
