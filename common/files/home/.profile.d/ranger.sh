
# use rg to open ranger or hop back into ranger if you're already inside it
rg() {
    if [ -z "$RANGER_LEVEL" ]
    then
        ranger
    else
        exit
    fi
}

