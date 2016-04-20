#!/usr/bin/env python3
# -*- coding: utf-8 -*-

ICON_COLOR = '#4C88B3'
TEXT_COLOR = '#010100'
URGENT_COLOR = '#a0a0a0'
GRAPH_COLOR = '#4C4C4C'
GRAPH_BACKGROUND_COLOR = '#ababab'


import subprocess
def run(args=[]):
    proc = subprocess.Popen(args, stdout=subprocess.PIPE)
    out, err = proc.communicate()
    return out.decode('utf-8')


def pango(text, color=TEXT_COLOR, size=None):
    params = {'foreground': color}
    if size != None: params['font_size'] = size
    p = " ".join("%s='%s'" % (k,v) for k, v in params.items())
    return "<span %s>%s</span>" % (p, text)


## @param frac value from 0-1
def bar(frac=0.5, color=GRAPH_COLOR):
    square = "■"
    total_squares = 5
    filled = round(frac * total_squares)
    return pango(square*filled, GRAPH_COLOR) + pango(square*(total_squares-filled), GRAPH_BACKGROUND_COLOR)


def icon(font_awesome, color=ICON_COLOR):
    return pango(font_awesome, color, 'large')
