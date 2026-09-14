{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # TODO: needed? this is already in hosts/shared/base.nix
  nixpkgs.config.allowUnfree = true;
  news.display = "silent";

  programs.ssh.enableDefaultConfig = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file = {
    ".tigrc".source = ./.tigrc;
    ".bashrc".source = ./.bashrc;
    ".tmux.conf".source = ./.tmux.conf;
    ".profile.d".source = ./.profile.d;
    ".config/nixpkgs/config.nix".source = ./.config/nixpkgs/config.nix;
  };

  home.packages = with pkgs; [
    age
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
