from install.utils import *

syspkg({'arch': ['bash']})

symlink(__file__, 'bashrc', '~/.bashrc')
