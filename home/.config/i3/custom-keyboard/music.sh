#!/bin/bash

# if spotify isn't running, playerctl will give a nonzero exit code
playerctl status

if [[ $? -eq 0 ]]; then
    i3-msg '[class="Spotify"] focus'
else
    i3-msg 'workspace number 10; exec spotify'
fi
