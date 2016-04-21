local ret_status=''
if [[ $? -eq 0 ]]; then
    ret_status="%{$fg_bold[green]%}➜"
else
    ret_status="%{$fg_bold[red]%}➜"
fi

host_info=""
if ! [[ -z $SSH_CLIENT ]]; then
    host_info="%m: ";
fi

PROMPT='${ret_status} %{$fg[blue]%}$host_info%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
