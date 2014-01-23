#!/usr/bin/env bash

# use homebrew to install all formulae listed in tools.txt
brew install $(sed 's/#.*//;/^$/d' tools.txt)

