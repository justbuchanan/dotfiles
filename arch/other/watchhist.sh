#!/usr/bin/env bash
#
# Print out commands as they are run by watching the history file. Useful for
# demos.

tail -n 1 -f ~/.zsh_history | sed -E 's/.*;(.*)/\1/'
