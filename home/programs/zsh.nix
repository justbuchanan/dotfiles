{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "git"
    #     "z"
    #   ];
    #   theme = "robbyrussell";
    #   custom = "$HOME/.oh-my-zsh-custom";
    #   extraConfig = ''
    #     # Show direnv icon in prompt
    #     precmd() {
    #       if [[ -n "$DIRENV_DIR" ]]; then
    #         RPROMPT="%F{yellow}📁%f"
    #       else
    #         RPROMPT=""
    #       fi
    #     }
    #   '';
    # };

    initContent = ''
      # # disable home-manager-generated system prompt since we're using starship instead
      # if typeset -f prompt > /dev/null; then
      #   prompt off
      # fi

      # Allow VIM-like shortcuts at the command line
      bindkey -v
      bindkey jj vi-cmd-mode

      # source all files in .profile.d
      for i in ~/.profile.d/*.sh ; do
          if [[ -r "$i" ]]; then
              . $i
          fi
      done

      # the nix-provided ghostty isn't compatible with Arch opengl install, so use pacman-installed ghostty
      if [[ "$(cat /etc/os-release)" == *"Arch Linux"* ]]; then
          export PATH="$HOME/.local/bin/ghostty-bin-dir/:$PATH"
          mkdir -p ~/.local/bin/ghostty-bin-dir || true
          ln -s /usr/bin/ghostty ~/.local/bin/ghostty-bin-dir/ghostty 2>/dev/null || true
      fi
    '';
  };
}
