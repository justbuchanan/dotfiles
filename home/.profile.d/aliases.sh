# open sublime projects
alias subp='subl --project *.sublime-project'

alias g='git'

# shortcuts
alias q='exit'
alias please='sudo'

# some cd shortcuts
alias ..='cd ..'
alias cD='cd ~/src/justin/dotfiles'
alias cS='cd ~/src/'

alias s='stylize -i -g main'

alias c='wl-copy'
alias v='wl-paste'

alias open="xdg-open $@"

alias say="echo '$*' | espeak"

export HM_DIR=/home/justin/src/justin/dotfiles
alias hms='home-manager switch --flake $HM_DIR'
# hms "fast" - disables network lookups
alias hmsf='home-manager switch --option substitute false --flake $HM_DIR'
