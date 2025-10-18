{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # disable home-manager-generated system prompt since we're using starship instead
      if typeset -f prompt > /dev/null; then
        prompt off
      fi

      # Allow VIM-like shortcuts at the command line
      bindkey -v
      bindkey jj vi-cmd-mode

      # source all files in .profile.d
      for i in ~/.profile.d/*.sh ; do
          if [[ -r "$i" ]]; then
              . $i
          fi
      done
    '';
  };
}
