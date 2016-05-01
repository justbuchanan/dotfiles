from install.arch import *

pacman('tmux')
pacman('zsh')
pacman('rxvt-unicode')
pacman('wget')
pacman('tree')
pacman('psmisc')  # contains pstree and some other utils
pacman('git')
pacman('ncdu')   # ncurses-based disk usage analyzer
pacman('unzip')
yaourt('htop-vim-solarized-git')
yaourt('tig') # nifty curses-based git viewer
pacman('openssh')
pacman('cowsay')
pacman('fortune-mod')
pacman('sl') # command-line train!

# contains netstat, arp, etc
pacman('net-tools')

# python
pacman('python')
pacman('python-pip')
pacman('python2')
pacman('python2-pip')

# run `inxi -F` to show a list of the computer's hardware and related info
pacman('inxi')
