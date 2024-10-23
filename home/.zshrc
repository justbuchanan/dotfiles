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

# To customize prompt, run `p10k configure` or edit .p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
