#!/usr/bin/env bash

# install dependencies required to run the actual install script
echo 'Bootstrapping...'
if ! [[ $(pacman -Q python) ]]; then
    sudo pacman -Sy python
fi
sudo pip install colorama > /dev/null

echo
echo "Prerequisites installed; Now run python install script"
