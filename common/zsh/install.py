from install.utils import *

syspkg({'arch': ['zsh']})

symlink(__file__, 'zshrc', '~/.zshrc')
symlink(__file__, 'antigen.zsh', '~/.config/zsh/antigen.zsh')
symlink(__file__, 'justin.zsh-theme', '~/.config/zsh/justin.zsh-theme')
