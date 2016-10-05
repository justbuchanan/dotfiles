from install.utils import *

syspkg({'arch': ['xscreensaver']})

symlink(__file__, 'pixlock.sh', '~/bin/pixlock')
symlink(__file__, '.xscreensaver', '~/.xscreensaver')
symlink(__file__, 'xresources', '~/.Xresources.d/xscreensaver')
