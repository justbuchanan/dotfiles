from install.utils import *

syspkg({'arch': ['herbstluftwm']})

symlink(__file__, 'panel.sh', '~/.config/herbstluftwm/panel.sh')
symlink(__file__, 'autostart', '~/.config/herbstluftwm/autostart')
