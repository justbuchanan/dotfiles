import os
from install.utils import *

syspkg({'arch': ['sway-git']})

symlink(__file__, 'config', '~/.config/sway')
