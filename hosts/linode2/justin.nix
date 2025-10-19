{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ../../home/programs/git.nix
    ../../home/programs/starship.nix
    ../../home/programs/zsh.nix
    ../../home/programs/vim.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".tigrc".source = ../../home/.tigrc;
    ".bashrc".source = ../../home/.bashrc;
    ".tmux.conf".source = ../../home/.tmux.conf;
    ".profile.d".source = ../../home/.profile.d;
    ".config/nixpkgs/config.nix".source = ../../home/.config/nixpkgs/config.nix;
  };

  home.packages = with pkgs; [
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ssh.enableDefaultConfig = true;

  stylix = {
    enable = true;
    autoEnable = false;
    targets.xresources.enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
    };
  };

  home.stateVersion = "24.05";
}
