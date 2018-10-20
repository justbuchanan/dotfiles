from install.utils import *

syspkg({'arch': ['git']})

symlink(__file__, 'gitconfig', '~/.gitconfig')

# install 'poppler' for pdfinfo support
symlink(__file__, 'attributes', '~/.config/git/attributes')
