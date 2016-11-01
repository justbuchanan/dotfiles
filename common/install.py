from install.utils import *
from install.arch import *

symlinks = [
    '.ansible.cfg',
    '.tmux.conf',
    '.profile.d/aliases.sh',
    '.profile.d/robocup.sh',
    '.profile.d/transfer.sh',
    '.profile.d/n.sh',
]

cur_dir = os.path.dirname(os.path.realpath(__file__))
for path in symlinks:
    symlink_home(os.path.join(cur_dir, "other"), path)

from .sublime_text import install
from .atom import install
from .vim import install
from .zsh import install
from .bash import install
from .tig import install
from .git import install
from .golang import install
from .ranger import install
