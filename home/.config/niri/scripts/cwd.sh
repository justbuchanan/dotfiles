#!/usr/bin/env bash

# Prints the working directory of the currently-focused window, for opening a
# new terminal there. Ghostty runs one process per window (single-instance is
# disabled, see home.nix), so niri reports a unique PID per window and we can
# read that window's shell cwd from /proc.

set -euo pipefail

DEFAULT_DIR="$HOME"

focused_window="$(niri msg -j focused-window 2>/dev/null || true)"

# Nothing focused (or niri unavailable): use default.
if [[ -z "$focused_window" || "$focused_window" == "null" ]]; then
    echo "$DEFAULT_DIR"
    exit 0
fi

pid="$(jq -r '.pid // empty' <<<"$focused_window")"
app_id="$(jq -r '.app_id // empty' <<<"$focused_window")"

# No PID for the focused window: use default.
if [[ -z "$pid" ]]; then
    echo "$DEFAULT_DIR"
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
    printf '%s\n' "$dir"
else
    echo "$DEFAULT_DIR"
fi
