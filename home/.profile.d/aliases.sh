# open sublime projects
alias subp='subl --project *.sublime-project'

# shortcuts
alias q='exit'
alias please='sudo'

# some cd shortcuts
alias ..='cd ..'
alias cD='cd ~/src/justin/dotfiles'
alias cS='cd ~/src/'

alias s='stylize -i -g master'

alias c='wl-copy'
alias v='wl-paste'

alias netscan='nmap  -sn  192.168.0.0/24 | grep -v "Host is up" | sed "s/Nmap scan report for //g"'

alias open="xdg-open $@"

alias say="echo '$*' | espeak"
