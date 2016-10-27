#!/usr/bin/env bash

# automatically reload theme whenever xresources change
# useful if you are manually editing xresources
filewatcher $HOME/.Xresources $HOME/.Xresources.d/* \
    'xrdb ~/.Xresources && i3-msg reload && echo reloaded theme'

