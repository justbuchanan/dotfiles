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
    ../../home/programs/zsh.nix
    ../../home/programs/starship.nix
    ../../home/programs/vim.nix
    ../../home/base.nix
  ];

  home.stateVersion = "24.05";
}
