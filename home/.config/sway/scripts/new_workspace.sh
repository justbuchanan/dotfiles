#!/usr/bin/env bash
set -e

# find the number of the rightmost workspace, then switch to a new one right of it
old_num=$(swaymsg --raw -t get_workspaces | jq '.[].num' | sort -n | tail -1)
next_num=$old_num+1
swaymsg workspace "$next_num"
