
watchhist() {
    tail -n 1 -f ~/.zsh_history | sed -E 's/.*;(.*)/\1/'
}
