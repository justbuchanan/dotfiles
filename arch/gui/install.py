from install.utils import *

syspkg({'arch': [
    'thunar',  # gtk-based file browser
    'tumbler', # image thumbnails for thunar
    'mupdf', # minimalist pdf viewer
    'octave',  # open-source alternative to MATLAB
    'transmission-qt', # torrent client
    'arandr', # gui for configuring multiple monitors
    'cheese', # Picture-taking app comparable to "Photo Booth" on OS X
    'rofi',   # window switcher
    'archey3', # show system summary
    'scrot', # screenshots
    'playerctl', # command-line program to control a variety of music players
    'cli-visualizer', # command-line visualizer
    # 'libreoffice',
    'sublime-text-dev',
    'google-chrome',
    'spotify',

    # desktop notifications
    'libnotify',
    'dunst',

    # fonts
    'ttf-dejavu-sans-mono-powerline-git',
    'otf-font-awesome',

    # audio
    'pulseaudio',
    'pulseaudio-alsa',
    'alsa-utils',

    # bluetooth
    'bluez',
    'bluez-utils',

    # light-weight image viewer
    'imv',

    'gcolor2', # color picker/pipette

    # video player
    'vlc',

    # show system stats
    'conky',
]})
