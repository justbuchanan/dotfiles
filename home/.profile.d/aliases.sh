# rails
alias b='bundle exec'

# show all objc method prototypes in all files in the current directory
alias show_methods="sed -n '/^[-+]/{s/^.[[:blank:]]*(\([^)]*\))?[[:blank:]]*//s/[[:blank:]]*[;{][[:blank:]]*$//s/:[^:]*([[:blank:]]|$)/:/gp}' *.m"

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

alias c='xclip -selection clipboard'
alias v='xclip -selection clipboard -o'



alias netscan='nmap  -sn  192.168.0.0/24 | grep -v "Host is up" | sed "s/Nmap scan report for //g"'


alias open="xdg-open $@"

alias say="echo '$*' | espeak"

