from install.utils import *

syspkg({'arch': ['git']})

symlink(__file__, 'gitconfig', '~/.gitconfig')
