from install.utils import *

syspkg({'arch': ['rofi']})

symlink(__file__, 'xresources', '~/.Xresources.d/rofi')
