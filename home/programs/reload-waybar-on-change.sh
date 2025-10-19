#!/usr/bin/env bash

set -e

while true; do
    inotifywait -r -e modify ./home/.config/waybar
    pkill -USR2 waybar || echo "failed to signal waybar"
    echo "reloaded waybar $(date)"
done