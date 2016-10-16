from install.utils import *

syspkg({'arch': ['cli-visualizer-git']})

symlink(__file__, 'vis', '~/.config/vis')
