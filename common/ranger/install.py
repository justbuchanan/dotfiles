from install.utils import *

syspkg({'arch': ['ranger']})

symlink(__file__, 'ranger.sh', '~/.profile.d/ranger.sh')
