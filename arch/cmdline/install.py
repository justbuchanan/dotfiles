from install.utils import *

syspkg({'arch': [
    'tmux',
    'zsh',
    'rxvt-unicode',
    'wget',
    'tree',
    'psmisc',  # contains pstree and some other utils
    'git',
    'ncdu',   # ncurses-based disk usage analyzer
    'unzip',
    'htop-vim-solarized-git',
    'tig', # nifty curses-based git viewer
    'openssh',
    'cowsay',
    'fortune-mod',
    'sl', # command-line train!
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
]})
