import os
from install.arch import *
from install.utils import *

archpkg('sway-git')

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/sway')

