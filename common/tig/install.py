from install.utils import *

syspkg({'arch': ['tig']})

symlink(__file__, 'tigrc', '~/.tigrc')
