import os
from install.arch import *
from install.utils import *

archpkg('vertex-icons-git')
archpkg('gtk-theme-arc-git')

base = os.path.join(os.path.dirname(os.path.realpath(__file__)), "home")
symlink_home(base, '.gtkrc-2.0')
