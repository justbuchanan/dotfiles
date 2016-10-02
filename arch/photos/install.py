from install.utils import *

# utility to import pictures from camera
# do `gphoto2 --get-all-files` to get all camera pics
syspkg({'arch': [
    'gphoto2'
]})
