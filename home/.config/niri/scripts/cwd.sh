#!/usr/bin/env bash

# prints the current working directory (cwd) for the currently-focused window

# Get the focused window's PID from niri
focused_window="$(niri msg -j focused-window)"
pid=$(echo "$focused_window" | jq -r '.pid')
app_id=$(echo "$focused_window" | jq -r '.app_id')

# if no pid found, use home dir
if [[ -z $pid ]] || [[ $pid == "null" ]]; then
    echo $HOME
    exit 0
fi

if [[ "$app_id" == "sublime_text" ]]; then
    # for sublime, use the pid directly
    ppid=$pid
else
    # for terminals, and others, use the parent process id
    ppid=$(pgrep --newest --parent $pid)
fi
# if no cwd found, use home dir
readlink /proc/${ppid}/cwd || echo $HOME
