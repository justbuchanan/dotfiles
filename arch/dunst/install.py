import os
from install.utils import *

syspkg({'arch': ['dunst']})

symlink(__file__, 'dunstrc', '~/.config/dunstrc')
