from install.utils import *

syspkg({'arch': ['atom']})

for f in ['config.cson', 'keymap.cson', 'packages.cson']:
    symlink(__file__, f, '~/.atom/%s' % f)

if linux_is_graphical():
    # note: parcel is a program to sync atom packages via the packages.cson file
    apm('parcel')
