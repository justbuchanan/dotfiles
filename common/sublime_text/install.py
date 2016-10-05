from install.utils import *

syspkg({'arch': ['sublime-text-dev']})

files = [
    'clang_format_custom.sublime-settings',
    'clang_format.sublime-settings',
    'Default.sublime-keymap',
    'install.py',
    'Package Control.sublime-settings',
    'Preferences.sublime-settings',
]
for f in files:
    symlink(__file__, f, '~/.config/sublime-text-3/Packages/User/%s' % f)
