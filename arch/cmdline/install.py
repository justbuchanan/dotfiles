from install.utils import *

syspkg({'arch': [
    # run `inxi -F` to show a list of the computer's hardware and related info
    'inxi',
    # script to update arch package mirrors based on speed
    'reflector',
]})

symlink(__file__, '.makepkg.conf', '~/.makepkg.conf')
