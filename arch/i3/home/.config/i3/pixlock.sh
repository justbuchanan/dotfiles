#!/bin/bash

# This script takes a screenshot and pixellates it, then uses it as the i3lock
# background.  It was borrowed from here:
# https://faq.i3wm.org/question/83/how-to-run-i3lock-after-computer-inactivity.1.html

set -e

IMG_PATH=/tmp/i3-pixlock.png

scrot $IMG_PATH

# Pixellate it 10x
convert $IMG_PATH -scale 10% -scale 1000% $IMG_PATH

# Lock screen displaying this image.
i3lock -i $IMG_PATH
