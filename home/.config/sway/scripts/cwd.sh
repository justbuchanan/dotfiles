#!/usr/bin/env bash

# prints the current working directory (cwd) for the currently-focused window

# borrowed from https://www.reddit.com/r/swaywm/comments/ayedi1/opening_terminals_at_the_same_directory/
pid=$(swaymsg --raw -t get_tree | jq '.. | select(.type?) | select(.type=="con") | select(.focused==true).pid')
ppid=$(pgrep --newest --parent $pid)
readlink /proc/${ppid}/cwd || echo $HOME
