#!/usr/bin/env bash

# Query niri for current workspaces and get the highest index
highest_idx=$(niri msg --json workspaces | jq -r 'max_by(.idx) | .idx')

# Check if the take-window option is passed
if [[ "$1" == "take-window" ]]; then
    # Move the focused window to the highest workspace
    niri msg action move-window-to-workspace "$highest_idx"
fi

# Focus the workspace with the highest index
niri msg action focus-workspace "$highest_idx"
