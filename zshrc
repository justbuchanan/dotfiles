# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/Users/justbuchanan/.rvm/gems/ruby-2.0.0-p0/bin:/Users/justbuchanan/.rvm/gems/ruby-2.0.0-p0@global/bin:/Users/justbuchanan/.rvm/rubies/ruby-2.0.0-p0/bin:/Users/justbuchanan/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin



# import local zsh customizations, if present
zrcl="$HOME/.zshrc.local"
[[ ! -a $zrcl ]] || source $zrcl


# some cd shortcuts
alias cd.='cd .'
alias ..='cd ..'
alias cD='cd ~/Desktop/'
alias cS='cd ~/src/'

# Allow VIM-like shortcuts at the command line
bindkey -v


############################################################
# OS X
############################################################

alias ki='killall iTunes'
alias mac_model='sysctl hw.model'

# Quickly open Xcode workspaces or projects in the current directory
x() {
	local workspace_count="$(print -l *.xcworkspace(N) 2> /dev/null | wc -w | tr -d ' ')"
	local project_count="$(print -l *.xcodepro(N) 2> /dev/null | wc -w | tr -d ' ')"
	if [ "$workspace_count" != "0" ]; then
		open *.xcworkspace
	elif [ "$project_count" != "0" ]; then
		open *.xcodeproj
	else
		echo "No Xcode workspaces/projects here"
	fi
}


# volume-level
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
alias mid="osascript -e 'set volume output volume 45'"


############################################################
# Other
############################################################

# show all method prototypes in all files in the current directory
alias show_methods="sed -n '/^[-+]/{s/^.[[:blank:]]*(\([^)]*\))?[[:blank:]]*//s/[[:blank:]]*[;{][[:blank:]]*$//s/:[^:]*([[:blank:]]|$)/:/gp}' *.m"

# open sublime projects
alias subp='subl --project *.sublime-project'
