from install.utils import *

syspkg({'arch': [
    'tmux',
    'zsh',
    'wget',
    'tree',
    'psmisc',  # contains pstree and some other utils
    'git',
    'ncdu',  # ncurses-based disk usage analyzer
    'unzip',
    'htop-vim-solarized-git',
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
    # run `inxi -F` to show a list of the computer's hardware and related info
    'inxi',

    # script to update arch package mirrors based on speed
    'reflector',
]})
