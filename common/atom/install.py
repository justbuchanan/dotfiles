from install.utils import *


for f in ['config.cson', 'keymap.cson', 'packages.cson']:
    symlink(__file__, f, '~/.atom/%s' % f)

