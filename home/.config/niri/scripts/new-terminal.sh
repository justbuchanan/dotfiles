#!/usr/bin/env bash

# Opens a Ghostty window in the working directory of the currently-focused
# window. Ghostty runs as a single-instance daemon (see home.nix) so its windows
# share one PID and /proc can't tell them apart, but it tracks the focused
# window's cwd itself: a new-window action with no directory inherits it.
# `ghostty +new-window` can't be used for that since it always passes its own
# cwd, and it's most of the latency anyway.

set -euo pipefail

APP_ID="com.mitchellh.ghostty"
DEFAULT_DIR="$HOME"

activate() {
    busctl --user call -- "$APP_ID" "/${APP_ID//.//}" org.gtk.Actions Activate 'sava{sv}' "$@"
}

new_window_in() {
    activate new-window-command 1 as 1 "--working-directory=$1" 0
}

# PID of the running daemon, if any. Doesn't start it.
daemon_pid() {
    busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus \
        GetConnectionUnixProcessID s "$APP_ID" 2>/dev/null | cut -d' ' -f2 || true
}

focused_window="$(niri msg -j focused-window 2>/dev/null || true)"

# Nothing focused (or niri unavailable): use default.
if [[ -z "$focused_window" || "$focused_window" == "null" ]]; then
    new_window_in "$DEFAULT_DIR"
    exit 0
fi

pid="$(jq -r '.pid // empty' <<<"$focused_window")"
app_id="$(jq -r '.app_id // empty' <<<"$focused_window")"

# No PID for the focused window: use default.
if [[ -z "$pid" ]]; then
    new_window_in "$DEFAULT_DIR"
    exit 0
fi

# A window of the daemon: it knows the cwd. Other Ghostty processes (ie
# `ghostty -e`) fall through to the /proc lookup below.
if [[ "$app_id" == "$APP_ID" && "$pid" == "$(daemon_pid)" ]]; then
    activate new-window 0 0
    exit 0
fi

if [[ "$app_id" == "sublime_text" ]]; then
    # Sublime's own process holds the project cwd.
    target_pid="$pid"
else
    # Terminals (and most apps): the focused window's process is the parent of
    # the running shell; its newest child has the live cwd.
    target_pid="$(pgrep --newest --parent "$pid" || true)"
fi

dir=""
if [[ -n "$target_pid" ]]; then
    dir="$(readlink "/proc/${target_pid}/cwd" 2>/dev/null || true)"
fi

if [[ -n "$dir" && -d "$dir" ]]; then
    new_window_in "$dir"
else
    new_window_in "$DEFAULT_DIR"
fi
