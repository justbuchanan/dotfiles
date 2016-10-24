#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import re

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

    # Pull colors from xresources values
    ICON_COLOR = xresources_value(x, 'i3wm.bar_colors.focused_workspace')[1]
    URGENT_COLOR = xresources_value(x, 'i3wm.bar_colors.urgent_workspace')[1]
    # TODO: pull graph colors from xresources theme
    GRAPH_COLOR = '#4C4C4C'
    GRAPH_BACKGROUND_COLOR = '#ababab'

reload_xresources()


def pango(text, color, size=None):
    params = {'foreground': color}
    if size != None: params['font_size'] = size
    p = " ".join("%s='%s'" % (k, v) for k, v in params.items())
    return "<span %s>%s</span>" % (p, text)


## @param frac value from 0-1
def bar(frac=0.5, color=GRAPH_COLOR):
    square = "■"
    total_squares = 5
    filled = int(round(frac * total_squares))
    return pango(square * filled, GRAPH_COLOR) + pango(square * (
        total_squares - filled), GRAPH_BACKGROUND_COLOR)


def icon(font_awesome, color=ICON_COLOR):
    return pango(font_awesome, color, 'large')
