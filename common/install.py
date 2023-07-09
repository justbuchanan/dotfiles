from install.utils import *
from install.arch import *

syspkg({
    'arch': [
        'ranger',
        'tmux',
        'zsh',
        'wget',
        'tree',
        'psmisc',  # contains pstree and some other utils
        'git',
        'ncdu',  # ncurses-based disk usage analyzer
        'unzip',
        #'htop-vim-solarized-git',
        'openssh',
        'cowsay',
        'fortune-mod',
        'sl',  # command-line train!
        'nmap',
        # contains netstat, arp, etc
        'net-tools',
        # contains nslookup and others
        'bind-tools',
        # python
        'python',
        'python-pip',
        'python2',
        'python2-pip',
        # Example: traceroute google.com
        'traceroute',
    ],
    'deb': [
        'htop',
        'tree',
        'python3-pip',
        'tree',
        'ranger',
    ],
})

symlinks = [
    '.ansible.cfg',
    '.tmux.conf',
    '.profile.d/aliases.sh',
    '.profile.d/transfer.sh',
    '.profile.d/n.sh',
    '.profile.d/homebin.sh',
]

cur_dir = os.path.dirname(os.path.realpath(__file__))
for path in symlinks:
    symlink_home(os.path.join(cur_dir, "other"), path)

from .vim import install
from .zsh import install
from .bash import install
from .tig import install
from .git import install
from .golang import install
from .ranger import install

if detect_mac_osx() or linux_is_graphical():
    from .sublime_text import install

if linux_is_graphical():
    from .i3 import install
