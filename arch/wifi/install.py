from install.utils import *

syspkg({'arch': [
    'wpa_supplicant',
    'wpa_actiond',
    'dialog', # needed for wifi-menu
]})
