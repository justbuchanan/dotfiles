#!/bin/bash

DIR=~/screenshots

mkdir -p $DIR
cd $DIR
scrot
notify-send "Screenshot saved to $DIR"

