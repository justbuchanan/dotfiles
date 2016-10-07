from install.utils import *

syspkg({'arch': ['go']})
symlink(__file__, 'profile.sh', '~/.profile.d/golang.sh')
