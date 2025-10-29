#!/usr/bin/env bash

# open sublime projects
alias subp='subl --project *.sublime-project'

alias g='git'

alias q='exit'

alias please='sudo'

# cd shortcuts
alias ..='cd ..'
alias cD='cd ~/src/justin/dotfiles'
alias cS='cd ~/src/'

take() {
    mkdir -p "$1" && cd "$1"
}

alias s='stylize -i -g main'

alias c='wl-copy'
alias v='wl-paste'

alias open=xdg-open

say() {
    echo "$@" | espeak
}

export HM_DIR=/home/justin/src/justin/dotfiles
alias hms='home-manager switch --flake $HM_DIR'
# hms "fast" - disables network lookups
alias hmsf='home-manager switch --option substitute false --flake $HM_DIR'
