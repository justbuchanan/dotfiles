#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import re
import sys

ICON_COLOR = 'blue'
URGENT_COLOR = 'red'
GRAPH_COLOR = 'green'
GRAPH_BACKGROUND_COLOR = 'black'

# Given the output from xrdb, returns the value(s) for the given property
def xresources_value(xresources_out, propname):
    match = re.search('%s:(.+)' % re.escape(propname), xresources_out)
    result = match.group(1).strip()
    if ' ' in result:
        return result.split(' ')

def reload_xresources():
    global ICON_COLOR, URGENT_COLOR, GRAPH_COLOR, GRAPH_BACKGROUND_COLOR

    # Query xresources for all values
    x = subprocess.check_output(['xrdb', '-query']).decode('utf-8')

    try:
        # Pull colors from xresources values
        ICON_COLOR = xresources_value(x, 'i3wm.bar_colors.focused_workspace')[1]
        URGENT_COLOR = xresources_value(x, 'i3wm.bar_colors.urgent_workspace')[1]
        GRAPH_COLOR = xresources_value(x, 'i3wm.bar_colors.inactive_workspace')[2]
        GRAPH_BACKGROUND_COLOR = xresources_value(x, 'i3wm.bar_colors.inactive_workspace')[1]
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


def pango(text, color, bg_color=None, size=None):
    params = {'foreground': color}
    if bg_color:
        params['bgcolor'] = bg_color
    if size != None: params['font_size'] = size
    p = " ".join("%s='%s'" % (k, v) for k, v in params.items())
    return "<span %s>%s</span>" % (p, text)


## @param frac value from 0-1
def bar(frac):
    square = "■"
    total_squares = 5
    filled = int(round(frac * total_squares))
    return pango(square * filled, GRAPH_COLOR) + pango(square * (
        total_squares - filled), GRAPH_BACKGROUND_COLOR)


def icon(font_awesome):
    return pango(font_awesome, color=ICON_COLOR, size='large')
