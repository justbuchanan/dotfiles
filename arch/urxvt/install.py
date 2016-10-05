from install.utils import *

syspkg({'arch': ['rxvt-unicode']})

symlink(__file__, 'xresources', '~/.Xresources.d/urxvt')
