import os
from install.arch import *
from install.utils import *

yaourt('sway-git')

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.config/sway')

