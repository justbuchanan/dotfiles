#!/usr/bin/env bash

# prints the current working directory (cwd) for the currently-focused window

# Get the focused window's PID from niri
pid=$(niri msg -j focused-window | jq -r '.pid')

# if no pid found, use home dir
if [[ -z $pid ]] || [[ $pid == "null" ]]; then
    echo $HOME
    exit 0
fi

ppid=$(pgrep --newest --parent $pid)
# if no cwd found, use home dir
readlink /proc/${ppid}/cwd || echo $HOME
