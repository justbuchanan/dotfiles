#!/bin/bash
set -e

# This script takes a screenshot and pixellates it, then uses it as the i3lock
# background.  It was borrowed from here:
# https://faq.i3wm.org/question/83/how-to-run-i3lock-after-computer-inactivity.1.html

# Temporary path to store the desktop background image
IMG_PATH=/tmp/i3-pixlock.png

# Take a screenshot and save it
scrot $IMG_PATH

# Pixellate it 10x. Adjust the percentages to change how pixelated / "blurry"
# the image is. The two numbers must multiply to equal 100%.
# For example, 10% * 1000% = 100%.
convert $IMG_PATH -scale 10% -scale 1000% $IMG_PATH

# Lock screen displaying this image.
i3lock -i $IMG_PATH --ignore-empty-password
