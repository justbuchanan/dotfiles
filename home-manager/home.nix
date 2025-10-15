{ config, pkgs, ... }:

{
  imports = [
    ./niri.nix
    ./hyprland.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.ssh.enableDefaultConfig = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.gnome-keyring.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.05";
}
