from install.utils import *

syspkg({'arch': [
    'yubikey-personalization-gui-git',
    'libu2f-host',
]})

if linux_is_graphical():
    syspkg({'arch': ['yubikey-manager-qt']})
