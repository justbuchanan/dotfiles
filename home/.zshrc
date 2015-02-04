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


# echo the number of files in the current directory with the given file extension (include the dot in the parameter)
count_ext() {
	echo "$(print -l *$1(N) 2> /dev/null | wc -w | tr -d ' ')"
}

# Quickly open Xcode workspaces or projects or sublime projects in the current directory
x() {
	if [ "$(count_ext '.xcworkspace')" != "0" ]; then
		open *.xcworkspace
	elif [ "$(count_ext '.xcodeproj')" != "0" ]; then
		open *.xcodeproj
	elif [ "$(count_ext '.sublime-project')" != "0" ]; then
		subl --project *.sublime-project
	else
		echo "No xcode workspaces/projects or sublime projects found here"
	fi
}


############################################################
# Other
############################################################

# source all files in .profile.d
for i in ~/.profile.d/*.sh ; do
    if [ -r "$i" ]; then
        . $i
    fi
done

# vim as default editor
export EDITOR='vim'

# RVM
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# added by travis gem
[ -f /home/justbuchanan/.travis/travis.sh ] && source /home/justbuchanan/.travis/travis.sh
