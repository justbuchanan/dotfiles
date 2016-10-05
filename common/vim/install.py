from install.utils import *

syspkg({'arch': ['vim']})

symlink(__file__, 'vimrc', '~/.vimrc')
symlink(__file__, 'Vundle.vim', '~/.vim/bundle/Vundle.vim')
symlink(__file__, 'colors', '~/.vim/colors')
