#!/usr/bin/env bash
#
# A script that automatically types the infamous golang error handling snippet

set -e

# TODO: fix this, it doesn't work

sleep 0.002
xdotool type "if err != nil {"
xdotool key KP_Enter
xdotool type "return err;"
xdotool key KP_Enter
# xdotool type "}"