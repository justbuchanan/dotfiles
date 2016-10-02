import os
from install.utils import *

syspkg({'arch': ['sway-git']})

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/sway')
