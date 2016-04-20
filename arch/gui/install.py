from install.arch import *

pacman('thunar')  # gtk-based file browser
pacman('tumbler') # image thumbnails for thunar
pacman('mupdf') # minimalist pdf viewer
pacman('octave')  # open-source alternative to MATLAB
pacman('transmission-qt') # torrent client
pacman('arandr') # gui for configuring multiple monitors
pacman('cheese') # Picture-taking app comparable to "Photo Booth" on OS X
pacman('rofi')   # window switcher
yaourt('archey3') # show system summary
pacman('scrot') # screenshots
yaourt('playerctl') # command-line program to control a variety of music players
# pacman('libreoffice')
yaourt('sublime-text-dev')
yaourt('google-chrome')

# desktop notifications
pacman('libnotify')
pacman('dunst')

# fonts
yaourt('ttf-dejavu-sans-mono-powerline-git')
yaourt('otf-font-awesome')

# audio
pacman('pulseaudio')
pacman('pulseaudio-alsa')
pacman('alsa-utils')

# bluetooth
pacman('bluez')
pacman('bluez-utils')

# light-weight image viewer
yaourt('imv')
