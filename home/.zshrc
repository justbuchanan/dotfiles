# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# setup antigen for zsh "package management"
source ~/.config/zsh/antigen.zsh
antigen use oh-my-zsh

export DEFAULT_USER=justin

# theme
antigen theme romkatv/powerlevel10k

# packages
antigen bundle git
antigen bundle mercurial
antigen bundle pip
antigen bundle python
#antigen bundle rupa/z

if [[ `uname` == 'Linux' ]]; then
    antigen bundle systemd
else
    # TODO: check for OS X
    antigen bundle brew
fi

# load completions
antigen apply

# import local zsh customizations, if present
zrcl="$HOME/.zshrc.local"
[[ ! -a $zrcl ]] || source $zrcl

# Allow VIM-like shortcuts at the command line
bindkey -v
bindkey jj vi-cmd-mode

# source all files in .profile.d
for i in ~/.profile.d/*.sh ; do
    if [[ -r "$i" ]]; then
        . $i
    fi
done

# vim as default editor
export EDITOR='vim'

# Ruby gems
#if which ruby > /dev/null && which gem > /dev/null; then
#    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
#fi
export PATH="/home/justin/.local/share/gem/ruby/3.0.0/bin:$PATH"

# RVM
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"



export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"


export TERRARIUM_ADDR=glassbox
alias tcli="$HOME/src/justin/terrarium/code/client.py"

#export PATH="/opt/anaconda/bin:$PATH"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

export PATH="$HOME/.nix-profile/bin:$PATH"

# To customize prompt, run `p10k configure` or edit .p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
