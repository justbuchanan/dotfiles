
# Sets current window to "urgent" and posts a notification
# Useful for notifying that a long-running task is done
# Example: ./long-task; n
n() {
    CMD=$(fc -ln -1)
    echo -e "\a" # bell to set "urgent" flag on current window

    if [ "$#" -eq 0 ]; then
        # print last command if no args are given
        notify-send "Done: $CMD"
    else
        # print the arguments as a string
        notify-send "$@"
    fi
}
