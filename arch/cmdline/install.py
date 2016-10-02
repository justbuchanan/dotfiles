from install.arch import *

archpkg('tmux')
archpkg('zsh')
archpkg('rxvt-unicode')
archpkg('wget')
archpkg('tree')
archpkg('psmisc')  # contains pstree and some other utils
archpkg('git')
archpkg('ncdu')   # ncurses-based disk usage analyzer
archpkg('unzip')
archpkg('htop-vim-solarized-git')
archpkg('tig') # nifty curses-based git viewer
archpkg('openssh')
archpkg('cowsay')
archpkg('fortune-mod')
archpkg('sl') # command-line train!
archpkg('nmap')

# contains netstat, arp, etc
archpkg('net-tools')

# contains nslookup and others
archpkg('bind-tools')

# python
archpkg('python')
archpkg('python-pip')
archpkg('python2')
archpkg('python2-pip')

# run `inxi -F` to show a list of the computer's hardware and related info
archpkg('inxi')
