
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# run monitor setup script if it exists.
# This is a script exported by arandr.
#MONITOR_CFG=$HOME/.screenlayout/default.sh
#if [[ -e "$MONITOR_CFG" ]]; then
#    $MONITOR_CFG
#fi
