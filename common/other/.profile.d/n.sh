
# Sets current window to "urgent" and posts a notification
# Useful for notifying that a long-running task is done
# Example: ./long-task; n
n() {
    CMD=$(fc -ln -1)
    echo -e "\a" # bell to set "urgent" flag on current window
    notify-send "Done: $CMD"
}
