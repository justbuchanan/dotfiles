#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import re
import sys

ICON_COLOR = 'blue'
URGENT_COLOR = 'red'
GRAPH_COLOR = 'green'
GRAPH_BACKGROUND_COLOR = 'black'
BAR_BACKGROUND_COLOR = 'black'

# Given the output from xrdb, returns the value(s) for the given property
# @return list of color value strings
def xresources_value(xresources_out, propname):
    match = re.search('%s:(.+)' % re.escape(propname), xresources_out)
    result = match.group(1).strip()
    if ' ' in result:
        result = result.split(' ')
    else:
        result = [result]
    return result

def reload_xresources():
    global ICON_COLOR, URGENT_COLOR, GRAPH_COLOR, GRAPH_BACKGROUND_COLOR, BAR_BACKGROUND_COLOR

    # Query xresources for all values
    x = subprocess.check_output(['xrdb', '-query']).decode('utf-8')

    try:
        # Pull colors from xresources values
        ICON_COLOR = xresources_value(x, 'i3wm.bar_colors.icon')[0]
        URGENT_COLOR = xresources_value(x, 'i3wm.bar_colors.urgent_workspace')[1]
        GRAPH_COLOR = xresources_value(x, 'i3wm.bar_colors.graph')[0]
        GRAPH_BACKGROUND_COLOR = xresources_value(x, 'i3wm.bar_colors.graph')[1]
        BAR_BACKGROUND_COLOR = xresources_value(x, 'i3wm.bar_colors.background')[0]
    except Exception as e:
        print('Error reloading xresources: %s' % str(e), file=sys.stderr)
      
reload_xresources()

# Registers a listener for i3's 'barconfig_update' event
# When received, it reloads xresources and calls an optional callback
def autoreload_xresources_with_callback(cbk=None):
    # reload colors when signaled
    def barconfig_update(i3, e):
        reload_xresources()
        if cbk:
            cbk()

    import i3ipc
    i3 = i3ipc.Connection()
    i3.on('barconfig_update', barconfig_update)

    import threading
    t = threading.Thread(target=lambda: i3.main())
    t.start()


# Example: pango('hello', font_size='large', foreground='#ffffff)
# -> "<span font_size=large, foreground=#ffffff>hello</span>""
def pango(text, **kwargs):
    p = " ".join("%s='%s'" % (k, v) for k, v in kwargs.items())
    for k in kwargs.keys():
        # This list can be expanded to include other valid attributes. These are
        # just the ones that my bar scripts use and it helps to have a check in
        # place in case I mess it up.  If an invalid attribute is used without
        # this check, nothing gets shown in i3bar and it's hard to track down
        # where the error is.
        if k not in ['font_size', 'foreground', 'background']:
            raise RuntimeError("Unknown pango attribute: '%s'" % k)
    return "<span %s>%s</span>" % (p, text)


## @param frac value from 0-1
def bar(frac):
    square = "■"
    total_squares = 5
    filled = int(round(frac * total_squares))
    return pango(square * filled, foreground=GRAPH_COLOR) + pango(square * (
        total_squares - filled), foreground=GRAPH_BACKGROUND_COLOR)


def icon(font_awesome):
    return pango(font_awesome, foreground=ICON_COLOR, font_size='large')
