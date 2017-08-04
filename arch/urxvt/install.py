from install.utils import *

# note: the nerd-fonts-git package includes fonts patched with font awesome and other icon sets
syspkg({'arch': ['rxvt-unicode', 'nerd-fonts-git']})

symlink(__file__, 'xresources', '~/.Xresources.d/urxvt')
