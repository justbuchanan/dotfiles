from install.utils import *
from install.arch import *

symlinks = [
    '.ansible.cfg',
    '.vimrc',
    '.vim',
    '.zshrc',
    '.bashrc',
    '.gitconfig',
    '.tigrc',
    '.tmux.conf',
    '.profile.d/aliases.sh',
    '.profile.d/ranger.sh',
    '.profile.d/robocup.sh',
    '.profile.d/transfer.sh',
    '.profile.d/golang.sh',
    '.atom/config.cson',
    '.atom/keymap.cson',
    '.atom/packages.cson',
    # 'vromerc',
    '.config/zsh',
    '.config/sublime-text-3/Packages/User/clang_format.sublime-settings',
    '.config/sublime-text-3/Packages/User/clang_format_custom.sublime-settings',
    '.config/sublime-text-3/Packages/User/Default.sublime-keymap',
    '.config/sublime-text-3/Packages/User/Package Control.sublime-settings',
    '.config/sublime-text-3/Packages/User/Preferences.sublime-settings',
]

cur_dir = os.path.dirname(os.path.realpath(__file__))
for path in symlinks:
    symlink_home(os.path.join(cur_dir, "home"), path)

if linux_is_graphical():
    # note: parcel is a program to sync atom packages via the packages.cson file
    apm('parcel')
