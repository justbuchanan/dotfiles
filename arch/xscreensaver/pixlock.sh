#!/usr/bin/env python2.7

# Borrowed from py3lock gist on GitHub
# https://gist.github.com/Airblader/3a96a407e16dae155744

# Takes a screenshot and pixellates the window contents before displaying it with
# xscreensaver-getimage.  This script can be called directly from xscreensaver
# by placing it in the "programs" list in ~/.xscreensaver

import os
import xcb
from xcb.xproto import * # must installl 'xpyb' to use this
from PIL import Image

XCB_MAP_STATE_VIEWABLE = 2


OUTPUT_PATH = '/tmp/screenlock.png'


def screenshot():
    os.system('import -window root %s' % OUTPUT_PATH)

def xcb_fetch_windows():
    """ Returns an array of rects of currently visible windows. """

    x = xcb.connect()
    root = x.get_setup().roots[0].root

    rects = []

    # iterate through top-level windows
    for child in x.core.QueryTree(root).reply().children:
        # make sure we only consider windows that are actually visible
        attributes = x.core.GetWindowAttributes(child).reply()
        if attributes.map_state != XCB_MAP_STATE_VIEWABLE:
            continue

        rects += [x.core.GetGeometry(child).reply()]

    return rects

def obscure_image(image):
    """ Obscures the given image. """
    size = image.size
    pixel_size = 7

    image = image.resize((size[0] / pixel_size, size[1] / pixel_size), Image.LANCZOS)
    image = image.resize((size[0], size[1]), Image.NEAREST)

    return image

def obscure(rects):
    """ Takes an array of rects to obscure from the screenshot. """
    image = Image.open(OUTPUT_PATH)

    for rect in rects:
        area = (
            rect.x, rect.y,
            rect.x + rect.width,
            rect.y + rect.height
        )

        cropped = image.crop(area)
        cropped = obscure_image(cropped)
        image.paste(cropped, area)

    image.save(OUTPUT_PATH)


if __name__ == '__main__':
    # 1: Take a screenshot.
    screenshot()

    # 2: Get the visible windows.
    rects = xcb_fetch_windows()

    # 3: Process the screenshot.
    obscure(rects)

    # Show pixellated screenshot
    os.system('xscreensaver-getimage -file %s -root' % OUTPUT_PATH)
