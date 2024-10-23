#!/usr/bin/env bash

# prints the current working directory (cwd) for the currently-focused window

# borrowed from https://www.reddit.com/r/swaywm/comments/ayedi1/opening_terminals_at_the_same_directory/
pid=$(swaymsg --raw -t get_tree | jq '.. | select(.type?) | select(.type=="con") | select(.focused==true).pid')
# if no pid found, use home dir
if [[ -z $pid ]]; then echo $HOME; exit 0; fi

ppid=$(pgrep --newest --parent $pid)
# if no cwd found, use home dir
readlink /proc/${ppid}/cwd || echo $HOME
