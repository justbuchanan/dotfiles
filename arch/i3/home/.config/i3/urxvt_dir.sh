#!/usr/bin/bash

DIR=$(xcwd)

if [[ -z $DIR ]]; then
    echo -n '~'
else
    echo -n $DIR
fi
